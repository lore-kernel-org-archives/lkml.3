Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3LHNB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 08:01:27 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:48268 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab3LHNBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 08:01:25 -0500
Message-ID: <52A46D9D.4020008@gmail.com>
Date: Sun, 08 Dec 2013 15:01:17 +0200
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Steven Luo <steven@steven676.net>,
        ?????? ???????? <ivo.g.dimitrov.75@gmail.com>
CC: gregkh@linuxfoundation.org, nico@ngolde.de, fabs@goesec.de,
        omar.ramirez@copitl.com, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        tony@atomide.com, felipe.contreras@gmail.com,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Use vm_iomap_memory for mmap-ing
 instead of remap_pfn_range
References: <1386014416-4556-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <20131207234912.GA1245@steven676.net>
In-Reply-To: <20131207234912.GA1245@steven676.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08.12.2013 01:49, Steven Luo wrote:
> This patch causes problems with DSP codecs on OMAP3 devices running
> Android -- specifically, when the decoder is cleaning up after itself,
> munmap() of the mapped area fails, leading to a memory leak which
> eventually crashes the system.
>
> As far as I can tell, the code with this patch applied reduces to
> (ignoring checks and such)
>
> remap_pfn_range(vma, vma->vm_start,
> 	(pdata->phys_mempool_base >> PAGE_SHIFT) + vma->vm_pgoff,
> 	vma->vm_end - vma->vm_start,
> 	vma->vm_page_prot);
>
> whereas the original was
>
>> -	status = remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>> -				 vma->vm_end - vma->vm_start,
>> -				 vma->vm_page_prot);
> We're subtracting (pdata->phys_mempool_base >> PAGE_SHIFT) from
> vma->vm_pgoff before calling vm_iomap_memory() to address the issue --
> if that's satisfactory to everyone involved, I can submit the following
> patch.
>
> -Steven Luo
>
> (please cc, not subscribed)
>
> From: Steven Luo <steven@steven676.net>
> Date: Sat, 7 Dec 2013 02:11:20 -0800
> Subject: [PATCH] tidspbridge: fix last patch to map same region of physical
>   memory as before
>
> Commit 559c71fe5dc3 ("Staging: TIDSPBRIDGE: Use vm_iomap_memory for
> mmap-ing instead of remap_pfn_range") had the effect of inadvertently
> shifting the start of the physical memory area mapped by
> pdata->phys_mempool_base.  Correct this by subtracting that shift before
> calling vm_iomap_memory() and adding it back afterwards.
>
> Reported-by: Dheeraj CVR <cvr.dheeraj@gmail.com>
> Signed-off-by: Steven Luo <steven@steven676.net>
> ---
>   drivers/staging/tidspbridge/rmgr/drv_interface.c |   29 +++++++++++++++++++---
>   1 file changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
> index 83cc3a5..d7f7d04 100644
> --- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
> +++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
> @@ -258,6 +258,9 @@ err:
>   /* This function maps kernel space memory to user space memory. */
>   static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
>   {
> +	unsigned long base_pgoff;
> +	int status;
> +
>   	struct omap_dsp_platform_data *pdata =
>   	    omap_dspbridge_dev->dev.platform_data;
>   	
> @@ -269,9 +272,29 @@ static int bridge_mmap(struct file *filp, struct vm_area_struct *vma)
>   		vma->vm_start, vma->vm_end, vma->vm_page_prot,
>   		vma->vm_flags);
>   
> -	return vm_iomap_memory(vma,
> -			       pdata->phys_mempool_base,
> -			       pdata->phys_mempool_size);
> +	/*
> +	 * vm_iomap_memory() expects vma->vm_pgoff to be expressed as an offset
> +	 * from the start of the physical memory pool, but we're called with
> +	 * a pfn (physical page number) stored there instead.
> +	 *
> +	 * To avoid duplicating lots of tricky overflow checking logic,
> +	 * temporarily convert vma->vm_pgoff to the offset vm_iomap_memory()
> +	 * expects, but restore the original value once the mapping has been
> +	 * created.
> +	 */
> +	base_pgoff = pdata->phys_mempool_base >> PAGE_SHIFT;
> +	if (vma->vm_pgoff < base_pgoff)
> +		return -EINVAL;
> +	vma->vm_pgoff -= base_pgoff;
> +
> +	status = vm_iomap_memory(vma,
> +				 pdata->phys_mempool_base,
> +				 pdata->phys_mempool_size);
> +
> +	/* Restore the original value of vma->vm_pgoff */
> +	vma->vm_pgoff += base_pgoff;
> +
> +	return status;
>   }
>   
>   static const struct file_operations bridge_fops = {
Tested on Nokia N900 with Maemo 5 and Harmattan codec nodes
