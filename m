Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaK0PY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:24:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49280 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaK0PY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:24:26 -0500
Date: Thu, 27 Nov 2014 18:23:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, lee.jones@linaro.org, chris@printf.net,
        ulf.hansson@linaro.org, gregkh@linuxfoundation.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, rogerable@realtek.com,
        devel@linuxdriverproject.org
Subject: Re: [PATCH 1/2] mfd: rtsx: add func to split u32 into register
Message-ID: <20141127152342.GA4860@mwanda>
References: <cover.1417056337.git.micky_ching@realsil.com.cn>
 <51dde5250305623c420e78fa555800ef8fef0a09.1417056337.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51dde5250305623c420e78fa555800ef8fef0a09.1417056337.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 10:53:58AM +0800, micky_ching@realsil.com.cn wrote:
> +static inline void rtsx_pci_write_be32(struct rtsx_pcr *pcr, u16 reg, u32 val)
> +{
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg,     0xFF, val >> 24);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 1, 0xFF, val >> 16);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 2, 0xFF, val >> 8);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, val);

This assumes the cpu is little endian.  First convert to big endian
using cpu_to_be32() and then write it out.

	__be32 be_val = cpu_to_be32()

	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg,     0xFF, be_val);
	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 1, 0xFF, be_val >> 8);
	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 2, 0xFF, be_val >> 16);
	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, be_val >> 24);

(Written hurredly in my mail client.  May be wrong).

> +}
> +
> +static inline void rtsx_pci_write_le32(struct rtsx_pcr *pcr, u16 reg, u32 val)
> +{
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg,     0xFF, val);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 1, 0xFF, val >> 8);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 2, 0xFF, val >> 16);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, val >> 24);
> +}

We don't have a user for rtsx_pci_write_le32() so don't add it.

regards,
dan carpenter
