Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3CLAEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:04:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54714 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754188Ab3CLAES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:04:18 -0400
Message-ID: <1363046657.3724.11.camel@joe-AO722>
Subject: Re: [PATCH v2 3/3] drivers: android: binder: Remove excessive
 indentation
From: Joe Perches <joe@perches.com>
To: Mirsal Ennaime <mirsal@mirsal.fr>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 11 Mar 2013 17:04:17 -0700
In-Reply-To: <1363044388-11409-4-git-send-email-mirsal@mirsal.fr>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
	 <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
	 <1363044388-11409-4-git-send-email-mirsal@mirsal.fr>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 00:26 +0100, Mirsal Ennaime wrote:
> Remove one level of indentation from the binder proc page release code
> by using slightly different control semantics.
> 
> This is a cosmetic patch which removes checkpatch "80-columns" warnings

More trivia:

> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
[]
> @@ -3001,17 +3001,20 @@ static void binder_deferred_release(struct binder_proc *proc)
>  		int i;
>  
>  		for (i = 0; i < proc->buffer_size / PAGE_SIZE; i++) {
> -			if (proc->pages[i]) {
> -				void *page_addr = proc->buffer + i * PAGE_SIZE;
> -				binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
> -					"binder_release: %d: page %d at %p not freed\n",
> -					proc->pid, i,
> -					page_addr);
> -				unmap_kernel_range((unsigned long)page_addr,
> -					PAGE_SIZE);
> -				__free_page(proc->pages[i]);
> -				page_count++;
> -			}
> +			void *page_addr;
> +
> +			if (!proc->pages[i])
> +				continue;
> +
> +			page_addr = proc->buffer + i * PAGE_SIZE;
> +			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
> +				"binder_release: %d: page %d at %p not freed\n",
> +				proc->pid, i,
> +				page_addr);
> +			unmap_kernel_range((unsigned long)page_addr,
> +				PAGE_SIZE);

Please align single function call args to open parenthesis.
Please fill to 80 chars where appropriate.
I think using %s, __func__ is better than embedded function names.

like:
			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
				     "%s: %d: page %d at %p not freed\n",
				     __func__, proc->pid, i, page_addr);
			unmap_kernel_range((unsigned long)page_addr, PAGE_SIZE);

Also for the binder folk:

I think it's odd to use pr_info in binder_debug.
Why not use KERN_DEBUG or pr_debug/dynamic_debugging?

#define binder_debug(mask, x...) \
	do { \
		if (binder_debug_mask & mask) \
			pr_info(x); \
	} while (0)


