Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaIHX1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:27:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbaIHX12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:27:28 -0400
Date: Mon, 8 Sep 2014 16:27:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>, Jiri Slaby <jslaby@suse.cz>,
        kernel@stlinux.com, linux-serial@vger.kernel.org
Subject: Re: [PATCH 3.17-rc3] serial: asc: Adopt readl_/writel_relaxed()
Message-ID: <20140908232727.GA8970@kroah.com>
References: <1409745651-3247-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409745651-3247-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 01:00:51PM +0100, Daniel Thompson wrote:
> The architectures where this peripheral exists (ARM and SH) have expensive
> implementations of writel(), reliant on spin locks and explicit L2 cache
> management. These architectures provide a cheaper writel_relaxed() which
> is much better suited to peripherals that do not perform DMA. The
> situation with readl()/readl_relaxed()is similar although less acute.
> 
> This driver does not use DMA and will be more power efficient and more
> robust (due to absense of spin locks during console I/O) if it uses the
> relaxed variants.
> 
> This change means the driver is no longer portable and therefore no
> longer suitable for compile testing.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
> Cc: Patrice Chotard <patrice.chotard@st.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: kernel@stlinux.com
> Cc: linux-serial@vger.kernel.org
> Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
> Acked-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/tty/serial/Kconfig  | 2 +-
>  drivers/tty/serial/st-asc.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 26cec64d..e9b1735 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1527,7 +1527,7 @@ config SERIAL_FSL_LPUART_CONSOLE
>  config SERIAL_ST_ASC
>  	tristate "ST ASC serial port support"
>  	select SERIAL_CORE
> -	depends on ARM || COMPILE_TEST
> +	depends on ARM

I really don't like stuff that does this, sorry.  I want to test build
as many drivers as I can.  COMPILE_TEST does not mean that the driver is
"portable", only that it builds properly on all platforms.

>  	help
>  	  This driver is for the on-chip Asychronous Serial Controller on
>  	  STMicroelectronics STi SoCs.
> diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
> index 8b2d735..adadbc1 100644
> --- a/drivers/tty/serial/st-asc.c
> +++ b/drivers/tty/serial/st-asc.c
> @@ -151,12 +151,12 @@ static inline struct asc_port *to_asc_port(struct uart_port *port)
> 
>  static inline u32 asc_in(struct uart_port *port, u32 offset)
>  {
> -	return readl(port->membase + offset);
> +	return readl_relaxed(port->membase + offset);

What plaforms do not provide readl_relaxed()?

thanks,

greg k-h
