Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaKFEQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:16:58 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:63903 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaKFEQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:16:55 -0500
Date: Wed, 5 Nov 2014 21:16:48 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next] xen: pcifront: Process failure for
 pcifront_(re)scan_root()
Message-ID: <20141106041648.GM6168@google.com>
References: <543206CD.1040505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543206CD.1040505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 11:04:45AM +0800, Chen Gang wrote:
> When pcifront_rescan_root() or pcifront_scan_root() fails, need return
> error code, neither set XenbusStateConnected state, just like the other
> areas have done.
> 
> For pcifront_rescan_root(), it will return error code ("num_roots = 0;",
> skip xenbus_switch_state return value).
> 
> For pcifront_scan_root(), it will return 0 ("num_roots = 0;", set 0 by
> the return value of xenbus_switch_state, which always return 0, at
> present).
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Applied to pci/virtualization for v3.19, with Konrad's ack and my changelog
rework.  Thanks!

> ---
>  drivers/pci/xen-pcifront.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
> index 53df39a..d78d884 100644
> --- a/drivers/pci/xen-pcifront.c
> +++ b/drivers/pci/xen-pcifront.c
> @@ -866,6 +866,11 @@ static int pcifront_try_connect(struct pcifront_device *pdev)
>  		xenbus_dev_error(pdev->xdev, err,
>  				 "No PCI Roots found, trying 0000:00");
>  		err = pcifront_scan_root(pdev, 0, 0);
> +		if (err) {
> +			xenbus_dev_fatal(pdev->xdev, err,
> +					 "Error scanning PCI root 0000:00");
> +			goto out;
> +		}
>  		num_roots = 0;
>  	} else if (err != 1) {
>  		if (err == 0)
> @@ -947,6 +952,11 @@ static int pcifront_attach_devices(struct pcifront_device *pdev)
>  		xenbus_dev_error(pdev->xdev, err,
>  				 "No PCI Roots found, trying 0000:00");
>  		err = pcifront_rescan_root(pdev, 0, 0);
> +		if (err) {
> +			xenbus_dev_fatal(pdev->xdev, err,
> +					 "Error scanning PCI root 0000:00");
> +			goto out;
> +		}
>  		num_roots = 0;
>  	} else if (err != 1) {
>  		if (err == 0)
> -- 
> 1.9.3
