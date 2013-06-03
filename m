Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab3FCQIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:08:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:11871 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab3FCQIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:08:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,794,1363158000"; 
   d="scan'208";a="344094051"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <51ACBBEA.2040804@sr71.net>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1368321816-17719-24-git-send-email-kirill.shutemov@linux.intel.com>
 <519BEFAE.1080800@sr71.net>
 <20130603150214.54C34E0090@blue.fi.intel.com>
 <51ACBBEA.2040804@sr71.net>
Subject: Re: [PATCHv4 23/39] thp: wait_split_huge_page(): serialize over
 i_mmap_mutex too
Content-Transfer-Encoding: 7bit
Message-Id: <20130603160920.737A1E0090@blue.fi.intel.com>
Date: Mon,  3 Jun 2013 19:09:20 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> 
> On 06/03/2013 08:02 AM, Kirill A. Shutemov wrote:
> > Dave Hansen wrote:
> >> On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
> >>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com
> >>> -#define wait_split_huge_page(__anon_vma, __pmd)				\
> >>> +#define wait_split_huge_page(__vma, __pmd)				\
> >>>  	do {								\
> >>>  		pmd_t *____pmd = (__pmd);				\
> >>> -		anon_vma_lock_write(__anon_vma);			\
> >>> -		anon_vma_unlock_write(__anon_vma);			\
> >>> +		struct address_space *__mapping =			\
> >>> +					vma->vm_file->f_mapping;	\
> >>> +		struct anon_vma *__anon_vma = (__vma)->anon_vma;	\
> >>> +		if (__mapping)						\
> >>> +			mutex_lock(&__mapping->i_mmap_mutex);		\
> >>> +		if (__anon_vma) {					\
> >>> +			anon_vma_lock_write(__anon_vma);		\
> >>> +			anon_vma_unlock_write(__anon_vma);		\
> >>> +		}							\
> >>> +		if (__mapping)						\
> >>> +			mutex_unlock(&__mapping->i_mmap_mutex);		\
> >>>  		BUG_ON(pmd_trans_splitting(*____pmd) ||			\
> >>>  		       pmd_trans_huge(*____pmd));			\
> >>>  	} while (0)
> ...
> >> Could you also describe the lengths to which you've gone to try and keep
> >> this macro from growing in to any larger of an abomination.  Is it truly
> >> _impossible_ to turn this in to a normal function?  Or will it simply be
> >> a larger amount of work that you can do right now?  What would it take?
> > 
> > Okay, I've tried once again. The patch is below. It looks too invasive for
> > me. What do you think?
> 
> That patch looks great to me, actually.  It really looks to just be
> superficially moving code around.  The diffstat is even too:

One of blocker I see is new dependency <linux/mm.h> -> <linux/fs.h>.
It makes header files nightmare worse.

-- 
 Kirill A. Shutemov
