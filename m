Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaB1Ejv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:39:51 -0500
Received: from g2t2354.austin.hp.com ([15.217.128.53]:7625 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB1Eju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:39:50 -0500
Message-ID: <1393562387.2899.22.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v4] mm: per-thread vma caching
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, aswin@hp.com,
        scott.norton@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Feb 2014 20:39:47 -0800
In-Reply-To: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net>
References: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 13:48 -0800, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr@hp.com>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 8740213..95c2bd9 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -768,16 +768,23 @@ static void add_vma_to_mm(struct mm_struct *mm, struct vm_area_struct *vma)
>   */
>  static void delete_vma_from_mm(struct vm_area_struct *vma)
>  {
> +	int i;
>  	struct address_space *mapping;
>  	struct mm_struct *mm = vma->vm_mm;
> +	struct task_struct *curr = current;
>  
>  	kenter("%p", vma);
>  
>  	protect_vma(vma, 0);
>  
>  	mm->map_count--;
> -	if (mm->mmap_cache == vma)
> -		mm->mmap_cache = NULL;
> +	for (i = 0; i < VMACACHE_SIZE; i++) {
> +		/* if the vma is cached, invalidate the entire cache */
> +		if (curr->vmacache[i] == vma) {
> +			vmacache_invalidate(mm);

*sigh* this should be curr->mm. 

Andrew, if there is no more feedback, do you want me to send another
patch for this or prefer fixing yourself for -mm? Assuming you'll take
it, of course.

Thanks,
Davidlohr

