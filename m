Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbbARMfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:35:18 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:41534 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbbARMfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:35:14 -0500
Date: Sun, 18 Jan 2015 12:35:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH 03/10] mfd: rtsx: add debug info when access register
 failed
Message-ID: <20150118123502.GP3574@x1>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <12574843e5abb5c02430c4f0cdf0c615c5eaebc3.1421320541.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12574843e5abb5c02430c4f0cdf0c615c5eaebc3.1421320541.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> Add debug info when access register failed, this is useful for
> debug.

Pull the creation of the macro into another patch.  I'm happy to apply
that, but I don't really want dbg prints scattered everywhere.  Feel
free to keep this patch on a branch and apply it when you need it, but
I'm not keen on having them in Mainline.

> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/rtsx_pcr.c       | 22 +++++++++++++++++-----
>  include/linux/mfd/rtsx_pci.h |  2 ++
>  2 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
> index 30f7ca8..92f5a41 100644
> --- a/drivers/mfd/rtsx_pcr.c
> +++ b/drivers/mfd/rtsx_pcr.c
> @@ -96,12 +96,16 @@ int rtsx_pci_write_register(struct rtsx_pcr *pcr, u16 addr, u8 mask, u8 data)
>  	for (i = 0; i < MAX_RW_REG_CNT; i++) {
>  		val = rtsx_pci_readl(pcr, RTSX_HAIMR);
>  		if ((val & HAIMR_TRANS_END) == 0) {
> -			if (data != (u8)val)
> +			if (data != (u8)val) {
> +				pcr_dbg(pcr, "write register 0x%02x failed\n",
> +					addr);
>  				return -EIO;
> +			}
>  			return 0;
>  		}
>  	}
>  
> +	pcr_dbg(pcr, "write register 0x%02x failed\n", addr);
>  	return -ETIMEDOUT;
>  }
>  EXPORT_SYMBOL_GPL(rtsx_pci_write_register);
> @@ -120,8 +124,10 @@ int rtsx_pci_read_register(struct rtsx_pcr *pcr, u16 addr, u8 *data)
>  			break;
>  	}
>  
> -	if (i >= MAX_RW_REG_CNT)
> +	if (i >= MAX_RW_REG_CNT) {
> +		pcr_dbg(pcr, "read register 0x%02x failed\n", addr);
>  		return -ETIMEDOUT;
> +	}
>  
>  	if (data)
>  		*data = (u8)(val & 0xFF);
> @@ -157,8 +163,10 @@ int rtsx_pci_write_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 val)
>  		}
>  	}
>  
> -	if (!finished)
> +	if (!finished) {
> +		pcr_dbg(pcr, "write phy 0x%x failed\n", addr);
>  		return -ETIMEDOUT;
> +	}
>  
>  	return 0;
>  }
> @@ -190,8 +198,10 @@ int rtsx_pci_read_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 *val)
>  		}
>  	}
>  
> -	if (!finished)
> +	if (!finished) {
> +		pcr_dbg(pcr, "read phy 0x%x failed\n", addr);
>  		return -ETIMEDOUT;
> +	}
>  
>  	rtsx_pci_init_cmd(pcr);
>  
> @@ -199,8 +209,10 @@ int rtsx_pci_read_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 *val)
>  	rtsx_pci_add_cmd(pcr, READ_REG_CMD, PHYDATA1, 0, 0);
>  
>  	err = rtsx_pci_send_cmd(pcr, 100);
> -	if (err < 0)
> +	if (err < 0) {
> +		pcr_dbg(pcr, "read phy 0x%x failed\n", addr);
>  		return err;
> +	}
>  
>  	ptr = rtsx_pci_get_cmd_data(pcr);
>  	data = ((u16)ptr[1] << 8) | ptr[0];
> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
> index e81f2bb..a680427 100644
> --- a/include/linux/mfd/rtsx_pci.h
> +++ b/include/linux/mfd/rtsx_pci.h
> @@ -838,6 +838,8 @@ struct rtsx_pcr {
>  #define PCI_VID(pcr)			((pcr)->pci->vendor)
>  #define PCI_PID(pcr)			((pcr)->pci->device)
>  
> +#define pcr_dbg(pcr, fmt, arg...)			\
> +	dev_dbg(&(pcr)->pci->dev, fmt, ##arg)
>  #define SDR104_PHASE(val)		((val) & 0xFF)
>  #define SDR50_PHASE(val)		(((val) >> 8) & 0xFF)
>  #define DDR50_PHASE(val)		(((val) >> 16) & 0xFF)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
