Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbaD1UVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:21:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbaD1UVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:21:23 -0400
Date: Mon, 28 Apr 2014 21:30:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hughd@google.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Refuse to insert a probe into MAP_SHARED vma
Message-ID: <20140428193029.GA9773@redhat.com>
References: <20140428191622.GA9234@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428191622.GA9234@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And of course, I forgot to add Hugh ;) Fix that.

On 04/28, Oleg Nesterov wrote:
>
> valid_vma() rejects the VM_SHARED vmas, but this still allows to insert
> a probe into the MAP_SHARED but not VM_MAYWRITE vma.
> 
> Currently this is fine, such a mapping doesn't really differ from the
> private read-only mmap except mprotect(PROT_WRITE) won't work. However,
> get_user_pages(FOLL_WRITE | FOLL_FORCE) doesn't allow to COW in this
> case, and it would be safer to follow the same conventions as mm even
> if currently this happens to work.
> 
> After the recent cda540ace6a1 "mm: get_user_pages(write,force) refuse
> to COW in shared areas" only uprobes can insert an anon page into the
> shared file-backed area, lets stop this and change valid_vma() to check
> VM_MAYSHARE instead.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index d1edc5e..7716c40 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -127,7 +127,7 @@ struct xol_area {
>   */
>  static bool valid_vma(struct vm_area_struct *vma, bool is_register)
>  {
> -	vm_flags_t flags = VM_HUGETLB | VM_MAYEXEC | VM_SHARED;
> +	vm_flags_t flags = VM_HUGETLB | VM_MAYEXEC | VM_MAYSHARE;
>  
>  	if (is_register)
>  		flags |= VM_WRITE;
> -- 
> 1.5.5.1
> 

