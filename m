Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaIIJip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:38:45 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34999 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbaIIJim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:38:42 -0400
Message-ID: <540ECAA4.70801@linaro.org>
Date: Tue, 09 Sep 2014 10:38:44 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, patches@linaro.org,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>, Jiri Slaby <jslaby@suse.cz>,
        kernel@stlinux.com, linux-serial@vger.kernel.org,
        Maxime COQUELIN <maxime.coquelin@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
Subject: Re: [PATCH 3.17-rc3] serial: asc: Adopt readl_/writel_relaxed()
References: <1409745651-3247-1-git-send-email-daniel.thompson@linaro.org> <20140908232727.GA8970@kroah.com>
In-Reply-To: <20140908232727.GA8970@kroah.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 00:27, Greg Kroah-Hartman wrote:
> On Wed, Sep 03, 2014 at 01:00:51PM +0100, Daniel Thompson wrote:
>> The architectures where this peripheral exists (ARM and SH) have expensive
>> implementations of writel(), reliant on spin locks and explicit L2 cache
>> management. These architectures provide a cheaper writel_relaxed() which
>> is much better suited to peripherals that do not perform DMA. The
>> situation with readl()/readl_relaxed()is similar although less acute.
>>
>> This driver does not use DMA and will be more power efficient and more
>> robust (due to absense of spin locks during console I/O) if it uses the
>> relaxed variants.
>>
>> This change means the driver is no longer portable and therefore no
>> longer suitable for compile testing.
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> Cc: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
>> Cc: Patrice Chotard <patrice.chotard@st.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Jiri Slaby <jslaby@suse.cz>
>> Cc: kernel@stlinux.com
>> Cc: linux-serial@vger.kernel.org
>> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
>> Acked-by: Peter Griffin <peter.griffin@linaro.org>
>> ---
>>  drivers/tty/serial/Kconfig  | 2 +-
>>  drivers/tty/serial/st-asc.c | 4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
>> index 26cec64d..e9b1735 100644
>> --- a/drivers/tty/serial/Kconfig
>> +++ b/drivers/tty/serial/Kconfig
>> @@ -1527,7 +1527,7 @@ config SERIAL_FSL_LPUART_CONSOLE
>>  config SERIAL_ST_ASC
>>  	tristate "ST ASC serial port support"
>>  	select SERIAL_CORE
>> -	depends on ARM || COMPILE_TEST
>> +	depends on ARM
> 
> I really don't like stuff that does this, sorry.  I want to test build
> as many drivers as I can.  COMPILE_TEST does not mean that the driver is
> "portable", only that it builds properly on all platforms.

I originally made this change compilable (and portable) but was asked to
change it during review:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/331027/focus=333911

It sounds like I gave in too quickly. I'll re-post the original version
shortly.


>>  	help
>>  	  This driver is for the on-chip Asychronous Serial Controller on
>>  	  STMicroelectronics STi SoCs.
>> diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
>> index 8b2d735..adadbc1 100644
>> --- a/drivers/tty/serial/st-asc.c
>> +++ b/drivers/tty/serial/st-asc.c
>> @@ -151,12 +151,12 @@ static inline struct asc_port *to_asc_port(struct uart_port *port)
>>
>>  static inline u32 asc_in(struct uart_port *port, u32 offset)
>>  {
>> -	return readl(port->membase + offset);
>> +	return readl_relaxed(port->membase + offset);
> 
> What plaforms do not provide readl_relaxed()?

I'd never thought to ask that. However I think the answer is "only those
that use asm-generic/io.h" meaning: blackfin, m68k, metag, openrisc,
score and sparc. I'll look into a patch to fix that...

The reason I never thought much about readl_relaxed() is that the
compilability concerns centre around writel_relaxed() instead. This is
much less widely implemented. It appears mostly on architectures where
writel() is both expensive and (sometimes) overkill. It is currently
found only on: alpha, arm, arm64, avr32, hexagon, microblaze, mips and sh.

My original code to conceal the difference between the two looked like
this (and the change is to a single accessor function, not littered
though the code):
--- cut here ---
 static inline void asc_out(struct uart_port *port, u32 offset,
 			    u32 value)
{
+#ifdef writel_relaxed
+	writel_relaxed(value, port->membase + offset);
+	barrier();
+#else
 	writel(value, port->membase + offset);
+#endif
 }
--- cut here ---

Note that barrier() is not needed if our only goal is for the driver to
pass the COMPILE_TEST but was included because different architectures
have different rules about inclusion of barrier() within the _relaxed()
macros making explicit barriers useful if this code were consumed by a
copy 'n paste operation...

