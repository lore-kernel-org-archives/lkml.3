Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3H0W6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 18:58:47 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:35334 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab3H0W6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 18:58:45 -0400
Message-ID: <521D2F1F.1070103@gmail.com>
Date: Wed, 28 Aug 2013 00:58:39 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-tegra@vger.kernel.org, kernel@stlinux.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 01/16] ARM: call clk_of_init from time_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-2-git-send-email-sebastian.hesselbarth@gmail.com> <3837b119-baad-4e68-8805-2bc52c0135f9@DB9EHSMHS031.ehs.local>
In-Reply-To: <3837b119-baad-4e68-8805-2bc52c0135f9@DB9EHSMHS031.ehs.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/13 00:19, Sören Brinkmann wrote:
> On Tue, Aug 27, 2013 at 11:27:55PM +0200, Sebastian Hesselbarth wrote:
>> Most DT ARM machs require common clock providers initialized before timers.
>> Currently, arch/arm machs use .init_time to call clk_of_init right before
>> clocksource_of_init. This prevents to remove that hook and use the default
>> hook instead. clk_of_init is safe to call for non-DT platforms, so add
>> the call to ARM arch time_init by default. While at it, also reorder includes
>> alphabetically.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Changelog:
>> v1->v2:
>> - reorder includes alphabetically
>>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: linux-tegra@vger.kernel.org
>> Cc: kernel@stlinux.com
>> Cc: linux-samsung-soc@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   arch/arm/kernel/time.c |   24 ++++++++++++++----------
>>   1 files changed, 14 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
>> index 98aee32..dd1028e 100644
>> --- a/arch/arm/kernel/time.c
>> +++ b/arch/arm/kernel/time.c
>> @@ -11,25 +11,26 @@
> [ ... ]
>>   void __init time_init(void)
>>   {
>> +	/* initalize common clocks before timers */
>> +	of_clk_init(NULL);
>> +
>>   	if (machine_desc->init_time)
>>   		machine_desc->init_time();
>>   	else
>
> This forces zynq to move some initialization our clock code relies on to
> init_irq(). Also, the current code already takes an approach of
> doing either common init or machine specific init.

Soeren,

you know that patch 16/16 takes care of zynq's clock init?

It's your own patch you provided from the last RFC. Looking at it, it
moves  zynq_sclr_init() to .init_irq and removes the call to
of_clk_init() from zynq_clock_init() which is called by
zynq_sclr_init().

Isn't that solving the above issues for mach-zynq?

> I think it might be better to move the call to of_clk_init() down into
> the else branch of the if-else.

Possibly, yes. But we could also unconditionally call of_clk_init() at
the beginning of time_init() and call clocksource_of_init() at the end.
That will make .init_time() to some fixup hook between initialization of 
clocks and timers.

> Though, this probably contradicts the purpose of the whole series.

Hmm, the purpose was to allow most platforms to remove a custom
.init_time hook only calling of_clk_init() and clocksource_of_init().

If we move of_clk_init() above also in the else-branch the purpose
is still met.

Sebastian

