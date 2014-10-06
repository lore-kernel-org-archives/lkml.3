Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaJFVFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 17:05:43 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:37592 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJFVFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 17:05:42 -0400
Date: Mon, 6 Oct 2014 22:05:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH] mfd: rtsx: fix PM suspend for 5227 & 5249
Message-ID: <20141006210536.GD18035@lee--X1>
References: <1411023333-1816-1-git-send-email-micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411023333-1816-1-git-send-email-micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> Fix rts5227&5249 failed send buffer cmd after suspend,
> PM_CTRL3 should reset before send any buffer cmd after suspend.
> Otherwise, buffer cmd will failed, this will lead resume fail.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/Makefile         |    2 +-
>  drivers/mfd/rts5227.c        |    6 ++++++
>  drivers/mfd/rts5249.c        |    4 ++++
>  drivers/mfd/rtsx_gops.c      |   36 ++++++++++++++++++++++++++++++++++++
>  drivers/mfd/rtsx_pcr.h       |    3 +++
>  include/linux/mfd/rtsx_pci.h |   12 ++++++++++++
>  6 files changed, 62 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/mfd/rtsx_gops.c

[...]

> diff --git a/drivers/mfd/rtsx_gops.c b/drivers/mfd/rtsx_gops.c
> new file mode 100644
> index 0000000..3cf596f
> --- /dev/null
> +++ b/drivers/mfd/rtsx_gops.c
> @@ -0,0 +1,36 @@
> +/* Driver for Realtek PCI-Express card reader
> + *
> + * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2, or (at your option) any
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + *
> + * Author:
> + *   Micky Ching <micky_ching@realsil.com.cn>
> + */
> +
> +#include <linux/mfd/rtsx_pci.h>
> +#include "rtsx_pcr.h"
> +
> +int rtsx_gops_pm_reset(struct rtsx_pcr *pcr)
> +{
> +	int err;
> +
> +	/* init aspm */
> +	err = rtsx_pci_update_cfg_byte(pcr, LCTLR, 0xFC, 0);

I'm not keen on the magic numbers here.  Can you #define them?

> +	if (err < 0)
> +		return err;
> +
> +	/* reset PM_CTRL3 before send buffer cmd */
> +	return rtsx_pci_write_register(pcr, PM_CTRL3, 0x10, 0x00);

Same.

> +}
> diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
> index 07e4c2e..fe2bbb6 100644
> --- a/drivers/mfd/rtsx_pcr.h
> +++ b/drivers/mfd/rtsx_pcr.h
> @@ -72,4 +72,7 @@ do {									\
>  	pcr->ms_pull_ctl_disable_tbl = __device##_ms_pull_ctl_disable_tbl; \
>  } while (0)
>  
> +/* generic operations */
> +int rtsx_gops_pm_reset(struct rtsx_pcr *pcr);
> +
>  #endif
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
