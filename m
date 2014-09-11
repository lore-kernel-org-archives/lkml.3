Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaIKHnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 03:43:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50222 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaIKHnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 03:43:08 -0400
Date: Thu, 11 Sep 2014 10:42:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, lee.jones@linaro.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        rogerable@realtek.com, devel@linuxdriverproject.org
Subject: Re: [PATCH 1/2] mfd: rtsx: fix PM suspend for 5227
Message-ID: <20140911074249.GW6600@mwanda>
References: <cover.1410330111.git.micky_ching@realsil.com.cn>
 <c13c93e9f5fca1a46df2b141899d50c13b28aaa0.1410330111.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c13c93e9f5fca1a46df2b141899d50c13b28aaa0.1410330111.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 03:17:52PM +0800, micky_ching@realsil.com.cn wrote:
> +	/* reset PM_CTRL3 before send buffer cmd */
> +	err = rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x00);
> +	if (err < 0)
> +		return err;
> +
> +	return err;

Just do:
	return rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x00);

> +}
> +
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
> index 74346d5..037fbc5 100644
> --- a/include/linux/mfd/rtsx_pci.h
> +++ b/include/linux/mfd/rtsx_pci.h
> @@ -967,4 +967,17 @@ static inline u8 *rtsx_pci_get_cmd_data(struct rtsx_pcr *pcr)
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
> +	if (err)
> +		return err;

Some of these check for "if (err) " and some check for "if (err < 0) ".
What is the significance of that?  I'm a newbie here.  Did you mean for
them to be different?


> +	err = pci_write_config_byte(pcr->pci, addr, (val & mask) | append);
> +	return err;

	return pci_write_config_byte(pcr->pci, addr, (val & mask) | append);

regards,
dan carpenter

