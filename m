Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967617Ab3DRQUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:20:54 -0400
Received: from www.sr71.net ([198.145.64.142]:51847 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965490Ab3DRQUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:20:52 -0400
Message-ID: <51701D5E.80802@sr71.net>
Date: Thu, 18 Apr 2013 09:20:46 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
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
Subject: Re: [PATCHv3, RFC 31/34] thp: initial implementation of do_huge_linear_fault()
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com> <1365163198-29726-32-git-send-email-kirill.shutemov@linux.intel.com> <51631206.3060605@sr71.net> <20130417143842.1A76CE0085@blue.fi.intel.com> <516F1D3C.1060804@sr71.net> <20130418160920.4A00DE0085@blue.fi.intel.com>
In-Reply-To: <20130418160920.4A00DE0085@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 09:09 AM, Kirill A. Shutemov wrote:
> Dave Hansen wrote:
>> On 04/17/2013 07:38 AM, Kirill A. Shutemov wrote:
>> Are you still sure you can't do _any_ better than a verbatim copy of 129
>> lines?
> 
> It seems I was too lazy. Shame on me. :(
> Here's consolidated version. Only build tested. Does it look better?

Yeah, it's definitely a step in the right direction.  There rae
definitely some bugs in there like:

+	unsigned long haddr = address & PAGE_MASK;

I do think some of this refactoring stuff

> -				unlock_page(page);
> -				vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
> -				tmp = vma->vm_ops->page_mkwrite(vma, &vmf);
> -				if (unlikely(tmp &
> -					  (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
> -					ret = tmp;
> +			unlock_page(page);
> +			vmf.flags = FAULT_FLAG_WRITE | FAULT_FLAG_MKWRITE;
> +			tmp = vma->vm_ops->page_mkwrite(vma, &vmf);
> +			if (unlikely(tmp &
> +					(VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
> +				ret = tmp;
> +				goto unwritable_page;
> +			}

could probably be a separate patch and would make what's going on more
clear, but it's passable the way it is.  When it is done this way it's
hard sometimes reading the diff to realize if you are adding code or
just moving it around.

This stuff:

>  		if (set_page_dirty(dirty_page))
> -			dirtied = 1;
> +			dirtied = true;

needs to go in another patch for sure.

One thing I *REALLY* like about doing patches this way is that things
like this start to pop out:

> -	ret = vma->vm_ops->fault(vma, &vmf);
> +	if (try_huge_pages) {
> +		pgtable = pte_alloc_one(mm, haddr);
> +		if (unlikely(!pgtable)) {
> +			ret = VM_FAULT_OOM;
> +			goto uncharge_out;
> +		}
> +		ret = vma->vm_ops->huge_fault(vma, &vmf);
> +	} else
> +		ret = vma->vm_ops->fault(vma, &vmf);

The ->fault is (or can be) essentially per filesystem, and we're going
to be adding support per-filesystem.  any reason we can't just handle
this inside the ->fault code and avoid adding huge_fault altogether?
