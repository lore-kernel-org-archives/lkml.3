Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaHKHtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:49:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaHKHtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:49:45 -0400
Date: Mon, 11 Aug 2014 09:49:18 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Naresh Kumar Inna <naresh@chelsio.com>,
        Arvind Bhushan <arvindb@chelsio.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 06/23] csiostor: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Message-ID: <20140811074916.GD16504@dhcp-27-160.brq.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <66f5bda4546f61484a27570f9971fdb6683210da.1405533479.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66f5bda4546f61484a27570f9971fdb6683210da.1405533479.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:10PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Christoph,

This driver does not have maintainers in Chelsio anymore.

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Naresh Kumar Inna <naresh@chelsio.com>
> Cc: Arvind Bhushan <arvindb@chelsio.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/csiostor/csio_hw.h  |    2 +-
>  drivers/scsi/csiostor/csio_isr.c |   22 +++++++++-------------
>  2 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
> index 49b1daa..5db2d85 100644
> --- a/drivers/scsi/csiostor/csio_hw.h
> +++ b/drivers/scsi/csiostor/csio_hw.h
> @@ -94,7 +94,7 @@ enum {
>  };
>  
>  struct csio_msix_entries {
> -	unsigned short	vector;		/* Vector assigned by pci_enable_msix */
> +	unsigned short	vector;		/* Assigned MSI-X vector */
>  	void		*dev_id;	/* Priv object associated w/ this msix*/
>  	char		desc[24];	/* Description of this vector */
>  };
> diff --git a/drivers/scsi/csiostor/csio_isr.c b/drivers/scsi/csiostor/csio_isr.c
> index 91ba91d..a8c748a 100644
> --- a/drivers/scsi/csiostor/csio_isr.c
> +++ b/drivers/scsi/csiostor/csio_isr.c
> @@ -499,7 +499,7 @@ csio_reduce_sqsets(struct csio_hw *hw, int cnt)
>  static int
>  csio_enable_msix(struct csio_hw *hw)
>  {
> -	int rv, i, j, k, n, min, cnt;
> +	int i, j, k, n, min, cnt;
>  	struct csio_msix_entries *entryp;
>  	struct msix_entry *entries;
>  	int extra = CSIO_EXTRA_VECS;
> @@ -521,19 +521,15 @@ csio_enable_msix(struct csio_hw *hw)
>  
>  	csio_dbg(hw, "FW supp #niq:%d, trying %d msix's\n", hw->cfg_niq, cnt);
>  
> -	while ((rv = pci_enable_msix(hw->pdev, entries, cnt)) >= min)
> -		cnt = rv;
> -	if (!rv) {
> -		if (cnt < (hw->num_sqsets + extra)) {
> -			csio_dbg(hw, "Reducing sqsets to %d\n", cnt - extra);
> -			csio_reduce_sqsets(hw, cnt - extra);
> -		}
> -	} else {
> -		if (rv > 0)
> -			csio_info(hw, "Not using MSI-X, remainder:%d\n", rv);
> -
> +	cnt = pci_enable_msix_range(hw->pdev, entries, min, cnt);
> +	if (cnt < 0) {
>  		kfree(entries);
> -		return -ENOMEM;
> +		return cnt;
> +	}
> +
> +	if (cnt < (hw->num_sqsets + extra)) {
> +		csio_dbg(hw, "Reducing sqsets to %d\n", cnt - extra);
> +		csio_reduce_sqsets(hw, cnt - extra);
>  	}
>  
>  	/* Save off vectors */
> -- 
> 1.7.7.6
> 
