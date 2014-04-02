Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbaDBMbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:31:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbaDBMbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:31:49 -0400
Subject: Re: [PATCH 2/2] ttyprintk: Allow built as a module
From: Jean Delvare <jdelvare@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Struan Bartlett <struan.bartlett@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>, gnomes@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org
In-Reply-To: <1396434582-30799-2-git-send-email-tiwai@suse.de>
References: <1396434582-30799-1-git-send-email-tiwai@suse.de>
	 <1396434582-30799-2-git-send-email-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Wed, 02 Apr 2014 14:31:46 +0200
Message-ID: <1396441906.28124.3.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Le Wednesday 02 April 2014 à 12:29 +0200, Takashi Iwai a écrit :
> The driver is well written to be used as a module, just the exit call
> is missing.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/char/Kconfig     |  2 +-
>  drivers/char/ttyprintk.c | 13 ++++++++++++-
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 1386749b48ff..97816b133c7f 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -40,7 +40,7 @@ config SGI_MBCS
>  source "drivers/tty/serial/Kconfig"
>  
>  config TTY_PRINTK
> -	bool "TTY driver to output user messages via printk"
> +	tristate "TTY driver to output user messages via printk"
>  	depends on EXPERT && TTY
>  	default n
>  	---help---
> diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
> index 2a39c5790364..73606eaaba71 100644
> --- a/drivers/char/ttyprintk.c
> +++ b/drivers/char/ttyprintk.c
> @@ -17,7 +17,7 @@
>  #include <linux/device.h>
>  #include <linux/serial.h>
>  #include <linux/tty.h>
> -#include <linux/export.h>
> +#include <linux/module.h>
>  
>  struct ttyprintk_port {
>  	struct tty_port port;
> @@ -214,4 +214,15 @@ error:
>  	tty_port_destroy(&tpk_port.port);
>  	return ret;
>  }
> +
> +static void ttyprintk_exit(void)

Could be marked __exit.

> +{
> +	tty_unregister_driver(ttyprintk_driver);
> +	put_tty_driver(ttyprintk_driver);
> +	tty_port_destroy(&tpk_port.port);
> +}
> +
>  device_initcall(ttyprintk_init);
> +module_exit(ttyprintk_exit);
> +
> +MODULE_LICENSE("GPL");

Other than this, this looks good, thanks for doing that.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support

