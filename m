Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab3FCPxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:53:20 -0400
Received: from www.sr71.net ([198.145.64.142]:58268 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758624Ab3FCPxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:53:17 -0400
Message-ID: <51ACBBEA.2040804@sr71.net>
Date: Mon, 03 Jun 2013 08:53:14 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
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
Subject: Re: [PATCHv4 23/39] thp: wait_split_huge_page(): serialize over i_mmap_mutex
 too
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-24-git-send-email-kirill.shutemov@linux.intel.com> <519BEFAE.1080800@sr71.net> <20130603150214.54C34E0090@blue.fi.intel.com>
In-Reply-To: <20130603150214.54C34E0090@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/03/2013 08:02 AM, Kirill A. Shutemov wrote:
> Dave Hansen wrote:
>> On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
>>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com
>>> -#define wait_split_huge_page(__anon_vma, __pmd)				\
>>> +#define wait_split_huge_page(__vma, __pmd)				\
>>>  	do {								\
>>>  		pmd_t *____pmd = (__pmd);				\
>>> -		anon_vma_lock_write(__anon_vma);			\
>>> -		anon_vma_unlock_write(__anon_vma);			\
>>> +		struct address_space *__mapping =			\
>>> +					vma->vm_file->f_mapping;	\
>>> +		struct anon_vma *__anon_vma = (__vma)->anon_vma;	\
>>> +		if (__mapping)						\
>>> +			mutex_lock(&__mapping->i_mmap_mutex);		\
>>> +		if (__anon_vma) {					\
>>> +			anon_vma_lock_write(__anon_vma);		\
>>> +			anon_vma_unlock_write(__anon_vma);		\
>>> +		}							\
>>> +		if (__mapping)						\
>>> +			mutex_unlock(&__mapping->i_mmap_mutex);		\
>>>  		BUG_ON(pmd_trans_splitting(*____pmd) ||			\
>>>  		       pmd_trans_huge(*____pmd));			\
>>>  	} while (0)
...
>> Could you also describe the lengths to which you've gone to try and keep
>> this macro from growing in to any larger of an abomination.  Is it truly
>> _impossible_ to turn this in to a normal function?  Or will it simply be
>> a larger amount of work that you can do right now?  What would it take?
> 
> Okay, I've tried once again. The patch is below. It looks too invasive for
> me. What do you think?

That patch looks great to me, actually.  It really looks to just be
superficially moving code around.  The diffstat is even too:

>  include/linux/huge_mm.h  |   35 ++++++++++++++--------------
>  include/linux/mm.h       |   24 +++++++++++++++++--
>  include/linux/mm_types.h |   37 +++++++++++++++++++++++++++++
>  include/linux/rmap.h     |   58 -----------------------------------------------
>  mm/memory.c              |    8 +++---
>  5 files changed, 81 insertions(+), 81 deletions(-)

