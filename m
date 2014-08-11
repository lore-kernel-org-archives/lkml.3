Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaHKI5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:57:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaHKI5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:57:15 -0400
Date: Mon, 11 Aug 2014 10:57:10 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: qla2xxx-upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 21/23] qla2xxx: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Message-ID: <20140811085709.GM16504@dhcp-27-160.brq.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <cf38d1596543fd61c099bc0b834c2ea7a11f8b28.1405533479.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf38d1596543fd61c099bc0b834c2ea7a11f8b28.1405533479.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:25PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Log message code 0x00c6 preserved, although it is reported
> after successful call to pci_enable_msix_range(), not before
> possibly unsuccessful call to pci_enable_msix(). Consumers
> of the error code should not notice the difference.

Hello,

Please, anyone (from QLogic especially) review this patch.

Thanks!

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: qla2xxx-upstream@qlogic.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/qla2xxx/qla_isr.c |   27 +++++++++++----------------
>  1 files changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index a56825c..52d420f 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2923,27 +2923,22 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
>  	for (i = 0; i < ha->msix_count; i++)
>  		entries[i].entry = i;
>  
> -	ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
> -	if (ret) {
> -		if (ret < MIN_MSIX_COUNT)
> -			goto msix_failed;
> -
> +	ret = pci_enable_msix_range(ha->pdev,
> +				    entries, MIN_MSIX_COUNT, ha->msix_count);
> +	if (ret < 0) {
> +		ql_log(ql_log_fatal, vha, 0x00c7,
> +		    "MSI-X: Failed to enable support, "
> +		    "giving   up -- %d/%d.\n",
> +		    ha->msix_count, ret);
> +		goto msix_out;
> +	} else if (ret < ha->msix_count) {
>  		ql_log(ql_log_warn, vha, 0x00c6,
>  		    "MSI-X: Failed to enable support "
>  		    "-- %d/%d\n Retry with %d vectors.\n",
>  		    ha->msix_count, ret, ret);
> -		ha->msix_count = ret;
> -		ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
> -		if (ret) {
> -msix_failed:
> -			ql_log(ql_log_fatal, vha, 0x00c7,
> -			    "MSI-X: Failed to enable support, "
> -			    "giving   up -- %d/%d.\n",
> -			    ha->msix_count, ret);
> -			goto msix_out;
> -		}
> -		ha->max_rsp_queues = ha->msix_count - 1;
>  	}
> +	ha->msix_count = ret;
> +	ha->max_rsp_queues = ha->msix_count - 1;
>  	ha->msix_entries = kzalloc(sizeof(struct qla_msix_entry) *
>  				ha->msix_count, GFP_KERNEL);
>  	if (!ha->msix_entries) {
> -- 
> 1.7.7.6
> 
