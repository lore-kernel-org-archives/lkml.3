Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaLPWtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:49:47 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44215 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaLPWtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:49:46 -0500
Date: Tue, 16 Dec 2014 14:49:42 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH v4 11/11] mtd: nand: stm_nand_bch: provide ST's
 implementation of Bad Block Table
Message-ID: <20141216224942.GH9759@ld-irv-0074>
References: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
 <1415206793-25670-12-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415206793-25670-12-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:59:53PM +0000, Lee Jones wrote:
> This is the BBT format ST use internally.  It has to be used on boards
> which were flashed with or actively use ST's tooling and boards which
> are booted using ST's bootloaders.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mtd/nand/Kconfig        |   8 +
>  drivers/mtd/nand/Makefile       |   4 +-
>  drivers/mtd/nand/stm_nand_bbt.c | 619 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 630 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/mtd/nand/stm_nand_bbt.c
> 
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 2738eec..040374d 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -520,4 +520,12 @@ config MTD_NAND_STM_BCH
>  	help
>  	  Adds support for the STMicroelectronics NANDi BCH Controller.
>  
> +config MTD_NAND_STM_BCH_BBT
> +	bool "STMicroelectronics: NANDi BCH Controller Bad Block Table support"
> +	default y if MTD_NAND_STM_BCH=y || MTD_NAND_STM_BCH=m

This line could be simplified. But it's also weird now that you can
select CONFIG_MTD_NAND_STM_BCH_BBT, but that won't build the BBT code if
MTD_NAND_STM_BCH=n. So I'd suggest the following instead:

	depends on MTD_NAND_STM_BCH
	default y

Or maybe this could be more explicit about the default:

	depends on MTD_NAND_STM_BCH
	default MTD_NAND_STM_BCH

> +	help
> +	  Adds support for the STMicroelectronics Bad Block Table support.
> +	  If you are using a device which has has already been initialised
> +	  by ST or using their tooling/bootloaders, leave this enabled.
> +
>  endif # MTD_NAND
> diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
> index 6044e0a..e342c91 100644
> --- a/drivers/mtd/nand/Makefile
> +++ b/drivers/mtd/nand/Makefile
> @@ -41,7 +41,9 @@ obj-$(CONFIG_MTD_NAND_MLC_LPC32XX)      += lpc32xx_mlc.o
>  obj-$(CONFIG_MTD_NAND_SH_FLCTL)		+= sh_flctl.o
>  obj-$(CONFIG_MTD_NAND_MXC)		+= mxc_nand.o
>  obj-$(CONFIG_MTD_NAND_SOCRATES)		+= socrates_nand.o
> -obj-$(CONFIG_MTD_NAND_STM_BCH)		+= stm_nand_bch.o
> +obj-$(CONFIG_MTD_NAND_STM_BCH)		+= stm-nand.o
> +stm-nand-y				+= stm_nand_bch.o
> +stm-nand-$(CONFIG_MTD_NAND_STM_BCH_BBT)	+= stm_nand_bbt.o
>  obj-$(CONFIG_MTD_NAND_TXX9NDFMC)	+= txx9ndfmc.o
>  obj-$(CONFIG_MTD_NAND_NUC900)		+= nuc900_nand.o
>  obj-$(CONFIG_MTD_NAND_MPC5121_NFC)	+= mpc5121_nfc.o

[...]

Brian
