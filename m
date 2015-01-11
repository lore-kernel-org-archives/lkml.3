Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbbAKPFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 10:05:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbbAKPFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 10:05:06 -0500
Message-ID: <54B2911D.4050904@suse.cz>
Date: Sun, 11 Jan 2015 16:05:01 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
CC: Rik van Riel <riel@redhat.com>, "Elifaz, Dana" <Dana.Elifaz@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Chris Clayton <chris2553@googlemail.com>,
        Oded Gabbay <oded.gabbay@amd.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: fix corner case in anon_vma endless growing prevention
References: <20150111135406.13266.42007.stgit@zurg>
In-Reply-To: <20150111135406.13266.42007.stgit@zurg>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2015 02:54 PM, Konstantin Khlebnikov wrote:
> Fix for BUG_ON(anon_vma->degree) splashes in unlink_anon_vmas()
> ("kernel BUG at mm/rmap.c:399!").
> 
> Anon_vma_clone() is usually called for a copy of source vma in destination
> argument. If source vma has anon_vma it should be already in dst->anon_vma.
> NULL in dst->anon_vma is used as a sign that it's called from anon_vma_fork().
> In this case anon_vma_clone() finds anon_vma for reusing.
> 
> Vma_adjust() calls it differently and this breaks anon_vma reusing logic:
> anon_vma_clone() links vma to old anon_vma and updates degree counters but
> vma_adjust() overrides vma->anon_vma right after that. As a result final
> unlink_anon_vmas() decrements degree for wrong anon_vma.
> 
> This patch assigns ->anon_vma before calling anon_vma_clone().
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> Fixes: 7a3ef208e662 ("mm: prevent endless growth of anon_vma hierarchy")
> Tested-by: Chris Clayton <chris2553@googlemail.com>
> Tested-by: Oded Gabbay <oded.gabbay@amd.com>
> Cc: Daniel Forrest <dan.forrest@ssec.wisc.edu>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Rik van Riel <riel@redhat.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/mmap.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7b36aa7..12616c5 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -778,10 +778,12 @@ again:			remove_next = 1 + (end > next->vm_end);
>  		if (exporter && exporter->anon_vma && !importer->anon_vma) {
>  			int error;
>  
> +			importer->anon_vma = exporter->anon_vma;
>  			error = anon_vma_clone(importer, exporter);
> -			if (error)
> +			if (error) {
> +				importer->anon_vma = NULL;
>  				return error;
> -			importer->anon_vma = exporter->anon_vma;
> +			}
>  		}
>  	}
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

