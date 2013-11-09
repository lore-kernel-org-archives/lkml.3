Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3KIOWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 09:22:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58907 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3KIOWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 09:22:17 -0500
Date: Sat, 9 Nov 2013 15:22:16 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 50/74] uio: provide vm access to UIO_MEM_PHYS maps
Message-ID: <20131109142216.GB14892@pengutronix.de>
References: <20131109065113.502217951@linuxfoundation.org>
 <20131109065117.016923315@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131109065117.016923315@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 10:51:55PM -0800, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> commit 7294151d0592e0ff48c61fca9fd7c93d613134da upstream.
> 
> This makes it possible to let gdb access mappings of the process that is
> being debugged.
> 
> uio_mmap_logical was moved and uio_vm_ops renamed to group related code
> and differentiate to new stuff.
I wonder why you picked that one for stable?!

Best regards
Uwe
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/uio/uio.c |   26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -630,12 +630,26 @@ static int uio_vma_fault(struct vm_area_
>  	return 0;
>  }
>  
> -static const struct vm_operations_struct uio_vm_ops = {
> +static const struct vm_operations_struct uio_logical_vm_ops = {
>  	.open = uio_vma_open,
>  	.close = uio_vma_close,
>  	.fault = uio_vma_fault,
>  };
>  
> +static int uio_mmap_logical(struct vm_area_struct *vma)
> +{
> +	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
> +	vma->vm_ops = &uio_logical_vm_ops;
> +	uio_vma_open(vma);
> +	return 0;
> +}
> +
> +static const struct vm_operations_struct uio_physical_vm_ops = {
> +#ifdef CONFIG_HAVE_IOREMAP_PROT
> +	.access = generic_access_phys,
> +#endif
> +};
> +
>  static int uio_mmap_physical(struct vm_area_struct *vma)
>  {
>  	struct uio_device *idev = vma->vm_private_data;
> @@ -643,6 +657,8 @@ static int uio_mmap_physical(struct vm_a
>  	if (mi < 0)
>  		return -EINVAL;
>  
> +	vma->vm_ops = &uio_physical_vm_ops;
> +
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>  
>  	return remap_pfn_range(vma,
> @@ -652,14 +668,6 @@ static int uio_mmap_physical(struct vm_a
>  			       vma->vm_page_prot);
>  }
>  
> -static int uio_mmap_logical(struct vm_area_struct *vma)
> -{
> -	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
> -	vma->vm_ops = &uio_vm_ops;
> -	uio_vma_open(vma);
> -	return 0;
> -}
> -
>  static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
>  {
>  	struct uio_listener *listener = filep->private_data;
> 
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
