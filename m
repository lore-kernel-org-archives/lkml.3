Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbaIQQjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:39:16 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36267 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbaIQQjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:39:11 -0400
Date: Wed, 17 Sep 2014 09:39:02 -0700
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH v2 1/2] mfd: rtsx: fix PM suspend for 5227
Message-ID: <20140917163902.GN30918@lee--X1>
References: <cover.1410484754.git.micky_ching@realsil.com.cn>
 <62adefd6958b52490289cec7c29a064447ed6de8.1410484754.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62adefd6958b52490289cec7c29a064447ed6de8.1410484754.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> Fix rts5227 failed send buffer cmd after suspend,
> PM_CTRL3 should reset before send any buffer cmd after suspend.
> Otherwise, buffer cmd will failed, this will lead resume fail.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/rts5227.c        |   19 +++++++++++++++++++
>  include/linux/mfd/rtsx_pci.h |   12 ++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
> index 9c8eec8..197f5c1 100644
> --- a/drivers/mfd/rts5227.c
> +++ b/drivers/mfd/rts5227.c
> @@ -128,8 +128,27 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
>  	return rtsx_pci_send_cmd(pcr, 100);
>  }
>  
> +static int rts5227_pm_reset(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	/* init aspm */
> +	err = rtsx_pci_update_cfg_byte(pcr, LCTLR, 0xFC, 0);
> +	if (err < 0)
> +		return err;
> +
> +	/* reset PM_CTRL3 before send buffer cmd */
> +	return rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x00);
> +}
> +

This is exactly the same function as in the other patch.  Please place
it somewhere it can be referenced by both drivers.

>  static int rts5227_optimize_phy(struct rtsx_pcr *pcr)
>  {
> +	int err;
> +
> +	err = rts5227_pm_reset(pcr);
> +	if (err < 0)
> +		return err;
> +
>  	/* Optimize RX sensitivity */
>  	return rtsx_pci_write_phy_register(pcr, 0x00, 0xBA42);
>  }
> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
> index 74346d5..b34fec8 100644
> --- a/include/linux/mfd/rtsx_pci.h
> +++ b/include/linux/mfd/rtsx_pci.h
> @@ -967,4 +967,16 @@ static inline u8 *rtsx_pci_get_cmd_data(struct rtsx_pcr *pcr)
>  	return (u8 *)(pcr->host_cmds_ptr);
>  }
>  
> +static inline int rtsx_pci_update_cfg_byte(struct rtsx_pcr *pcr, int addr,
> +		u8 mask, u8 append)
> +{
> +	int err;
> +	u8 val;
> +
> +	err = pci_read_config_byte(pcr->pci, addr, &val);
> +	if (err < 0)
> +		return err;
> +	return pci_write_config_byte(pcr->pci, addr, (val & mask) | append);
> +}
> +
>  #endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
