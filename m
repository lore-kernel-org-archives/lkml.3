Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422893Ab3CVSNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:13:45 -0400
Received: from www.sr71.net ([198.145.64.142]:34230 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422861Ab3CVSNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:13:44 -0400
Message-ID: <514CA182.7050906@sr71.net>
Date: Fri, 22 Mar 2013 11:22:58 -0700
From: Dave <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 17/30] thp: wait_split_huge_page(): serialize over
 i_mmap_mutex too
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-18-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1363283435-7666-18-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -113,11 +113,20 @@ extern void __split_huge_page_pmd(struct vm_area_struct *vma,
>  			__split_huge_page_pmd(__vma, __address,		\
>  					____pmd);			\
>  	}  while (0)
> -#define wait_split_huge_page(__anon_vma, __pmd)				\
> +#define wait_split_huge_page(__vma, __pmd)				\
>  	do {								\
>  		pmd_t *____pmd = (__pmd);				\
> -		anon_vma_lock_write(__anon_vma);			\
> -		anon_vma_unlock_write(__anon_vma);			\
> +		struct address_space *__mapping =			\
> +					vma->vm_file->f_mapping;	\
> +		struct anon_vma *__anon_vma = (__vma)->anon_vma;	\
> +		if (__mapping)						\
> +			mutex_lock(&__mapping->i_mmap_mutex);		\
> +		if (__anon_vma) {					\
> +			anon_vma_lock_write(__anon_vma);		\
> +			anon_vma_unlock_write(__anon_vma);		\
> +		}							\
> +		if (__mapping)						\
> +			mutex_unlock(&__mapping->i_mmap_mutex);		\
>  		BUG_ON(pmd_trans_splitting(*____pmd) ||			\
>  		       pmd_trans_huge(*____pmd));			\
>  	} while (0)

That thing was pretty ugly _before_. :)  Any chance this can get turned
in to a function?

What's the deal with the i_mmap_mutex operation getting split up?  I'm
blanking on what kind of pages would have both anon_vmas and a valid
mapping.
