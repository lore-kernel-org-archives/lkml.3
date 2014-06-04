Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaFDJdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:33:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42827 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaFDJdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:33:20 -0400
Date: Wed, 4 Jun 2014 11:32:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 03/13] kexec: Move segment verification code in a
 separate function
Message-ID: <20140604093254.GB4105@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-4-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401800822-27425-4-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:06:52AM -0400, Vivek Goyal wrote:
> Previously do_kimage_alloc() will allocate a kimage structure, copy
> segment list from user space and then do the segment list sanity verification.
> 
> Break down this function in 3 parts. do_kimage_alloc_init() to do actual
> allocation and basic initialization of kimage structure.
> copy_user_segment_list() to copy segment list from user space and
> sanity_check_segment_list() to verify the sanity of segment list as passed
> by user space.
> 
> In later patches, I need to only allocate kimage and not copy segment
> list from user space. So breaking down in smaller functions enables
> re-use of code at other places.

I haven't seen what's going on further in the patchset but from looking at
kimage_normal_alloc() and kimage_crash_alloc()'s guts, they look very
similar and could probably share a common __kimage_alloc which does
do_kimage_alloc_init, copy_user_segment_list, sanity_check_segment_list
and kimage_alloc_control_pages...

One probably would have to actually write it down to see whether it
makes sense though and is not too ugly :-)

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---

In any case, it looks ok, just two nitpicks below:

Acked-by: Borislav Petkov <bp@suse.de>

>  kernel/kexec.c | 182 ++++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 101 insertions(+), 81 deletions(-)

...

> +static struct kimage *do_kimage_alloc_init(void)
> +{
> +	struct kimage *image;
> +
> +	/* Allocate a controlling structure */
> +	image = kzalloc(sizeof(*image), GFP_KERNEL);
> +	if (!image)
> +		return NULL;
> +
> +	image->head = 0;
> +	image->entry = &image->head;
> +	image->last_entry = &image->head;
> +	image->control_page = ~0; /* By default this does not apply */
> +	image->type = KEXEC_TYPE_DEFAULT;
> +
> +	/* Initialize the list of control pages */
> +	INIT_LIST_HEAD(&image->control_pages);
> +
> +	/* Initialize the list of destination pages */
> +	INIT_LIST_HEAD(&image->dest_pages);
> +
> +	/* Initialize the list of unusable pages */
> +	INIT_LIST_HEAD(&image->unuseable_pages);

If the "e" in "unuseable" bugs you too, like me, you could add this one
to your patchset :-)

http://lkml.kernel.org/r/1392819695-24116-1-git-send-email-bp@alien8.de

...

> @@ -258,22 +292,23 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
>  					   get_order(KEXEC_CONTROL_PAGE_SIZE));
>  	if (!image->control_code_page) {
>  		printk(KERN_ERR "Could not allocate control_code_buffer\n");
> -		goto out_free;
> +		goto out_free_image;
>  	}
>  
>  	image->swap_page = kimage_alloc_control_pages(image, 0);
>  	if (!image->swap_page) {
>  		printk(KERN_ERR "Could not allocate swap buffer\n");
> -		goto out_free;
> +		goto out_free_control_pages;
>  	}
>  
>  	*rimage = image;
>  	return 0;
>  
> -out_free:
> +

Superfluous newline.

> +out_free_control_pages:
>  	kimage_free_page_list(&image->control_pages);
> +out_free_image:
>  	kfree(image);
> -out:
>  	return result;
>  }
>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
