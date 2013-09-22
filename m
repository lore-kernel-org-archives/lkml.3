Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3IVW6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:58:17 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:55636 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab3IVW6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:58:16 -0400
Date: Sun, 22 Sep 2013 18:58:09 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Felipe Pena <felipensp@gmail.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, Kautuk Consul <consul.kautuk@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 1/1] arch/parisc: mm: fix uninitialized variable usage
Message-ID: <20130922225809.GL856@cmpxchg.org>
References: <1379873866-29219-1-git-send-email-felipensp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379873866-29219-1-git-send-email-felipensp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe,

On Sun, Sep 22, 2013 at 03:17:46PM -0300, Felipe Pena wrote:
> The FAULT_FLAG_WRITE flag has been set based on uninitialized variable

Oops, you are right.

> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>  arch/parisc/mm/fault.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
> index d10d27a..6b38026 100644
> --- a/arch/parisc/mm/fault.c
> +++ b/arch/parisc/mm/fault.c
> @@ -182,8 +182,6 @@ void do_page_fault(struct pt_regs *regs, unsigned long code,
>  
>  	if (user_mode(regs))
>  		flags |= FAULT_FLAG_USER;
> -	if (acc_type & VM_WRITE)
> -		flags |= FAULT_FLAG_WRITE;
>  retry:
>  	down_read(&mm->mmap_sem);
>  	vma = find_vma_prev(mm, address, &prev_vma);
> @@ -201,6 +199,9 @@ good_area:
>  	if ((vma->vm_flags & acc_type) != acc_type)
>  		goto bad_area;
>  
> +	if (acc_type & VM_WRITE)
> +		flags |= FAULT_FLAG_WRITE;

Can acc_type actually change between between the first round and a
retry?  Otherwise, it might make sense to pull this up and place it
next to the flag initialization instead of pulling one flag down.
