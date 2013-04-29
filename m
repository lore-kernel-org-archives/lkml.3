Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3D2HfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 03:35:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42397 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab3D2HfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 03:35:22 -0400
Date: Mon, 29 Apr 2013 09:35:18 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Inki Dae <inki.dae@samsung.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] module: fix mutiple defined issue
Message-ID: <20130429073518.GZ15233@pengutronix.de>
References: <1367213521-26795-1-git-send-email-inki.dae@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367213521-26795-1-git-send-email-inki.dae@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 02:32:01PM +0900, Inki Dae wrote:
> This patch fixes mutiple defined issue to MODULE_DEVICE_TABLE
s/mutiple/multiple/, still this sentence doesn't sound right. What is
the error message you see?
 
> The issue could be induced when some framework which includes two
> more sub drivers, is built as one moudle because those sub drivers
s/moudle/module/

> could have their own MODULE_DEVICE_TABLE.
> 
> And 'struct of_device_id' isn't needed to be determined by type
> argument because the definition of 'of_device_id' should be fixed.
> So this patch makes 'of_devce_id' definition to be fixed and
> only its instance name to be defined by type.
include/linux/isapnp.h uses:
#define ISAPNP_CARD_TABLE(name) \
		MODULE_GENERIC_TABLE(isapnp_card, name)

and you changed the table's type with your patch. Ditto for all users of

	MODULE_DEVICE_TABLE(i2c, ...);
	MODULE_DEVICE_TABLE(acpi, ...);
	MODULE_DEVICE_TABLE(platform, ...);
	MODULE_DEVICE_TABLE(pci, ...);
	MODULE_DEVICE_TABLE(sdio, ...);

So I'm pretty sure your patch is wrong and I expect it makes most
defconfigs fail to compile.

Best regards
Uwe

> 
> Signed-off-by: Inki Dae <inki.dae@samsung.com>
> ---
>  include/linux/module.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 46f1ea0..ac5d79f 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -84,7 +84,7 @@ void trim_init_extable(struct module *m);
>  
>  #ifdef MODULE
>  #define MODULE_GENERIC_TABLE(gtype,name)			\
> -extern const struct gtype##_id __mod_##gtype##_table		\
> +extern const struct of_device_id __mod_##gtype##_table		\
>    __attribute__ ((unused, alias(__stringify(name))))
>  
>  #else  /* !MODULE */
> -- 
> 1.7.5.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
