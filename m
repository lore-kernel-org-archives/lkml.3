Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaDVGDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:03:22 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:52611 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDVGDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:03:20 -0400
Message-ID: <53560613.7030801@synopsys.com>
Date: Tue, 22 Apr 2014 11:32:59 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Davidlohr Bueso <davidlohr@hp.com>, <akpm@linux-foundation.org>
CC: <zeus@gnu.org>, <aswin@hp.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] arc: call find_vma with the mmap_sem held
References: <1397960791-16320-1-git-send-email-davidlohr@hp.com> <1397960791-16320-5-git-send-email-davidlohr@hp.com>
In-Reply-To: <1397960791-16320-5-git-send-email-davidlohr@hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 20 April 2014 07:56 AM, Davidlohr Bueso wrote:
> Performing vma lookups without taking the mm->mmap_sem is asking
> for trouble. While doing the search, the vma in question can be
> modified or even removed before returning to the caller. Take the
> lock (shared) in order to avoid races while iterating through
> the vmacache and/or rbtree.
> 
> This patch is completely *untested*.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> ---
>  arch/arc/kernel/troubleshoot.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
> index 73a7450..3a5a5c1 100644
> --- a/arch/arc/kernel/troubleshoot.c
> +++ b/arch/arc/kernel/troubleshoot.c
> @@ -90,7 +90,7 @@ static void show_faulting_vma(unsigned long address, char *buf)
>  	/* can't use print_vma_addr() yet as it doesn't check for
>  	 * non-inclusive vma
>  	 */
> -
> +	down_read(&current->active_mm->mmap_sem);

Actually avoiding the lock here was intentional - atleast in the past, in case of
a crash from mmap_region() - due to our custom mmap syscall handler (not in
mainline) it would cause a double lockup.

However given that this code is now only called for user contexts [if
user_mode(regs)] above becomes moot point anyways and it would be safe to do that.

So, yes this looks good.

A minor suggestion though - can you please use a tmp for current->active_mm as
there are 3 users now in the function.

Acked-by: Vineet Gupta <vgupta@synopsys.com>

Thx
-Vineet



>  	vma = find_vma(current->active_mm, address);
>  
>  	/* check against the find_vma( ) behaviour which returns the next VMA
> @@ -110,9 +110,10 @@ static void show_faulting_vma(unsigned long address, char *buf)
>  			vma->vm_start < TASK_UNMAPPED_BASE ?
>  				address : address - vma->vm_start,
>  			nm, vma->vm_start, vma->vm_end);
> -	} else {
> +	} else
>  		pr_info("    @No matching VMA found\n");
> -	}
> +
> +	up_read(&current->active_mm->mmap_sem);
>  }
>  
>  static void show_ecr_verbose(struct pt_regs *regs)
> 

