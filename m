Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935353Ab3DHSqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:46:44 -0400
Received: from www.sr71.net ([198.145.64.142]:43066 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759936Ab3DHSqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:46:42 -0400
Message-ID: <51631092.5030708@sr71.net>
Date: Mon, 08 Apr 2013 11:46:42 -0700
From: Dave Hansen <dave@sr71.net>
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
Subject: Re: [PATCHv3, RFC 31/34] thp: initial implementation of do_huge_linear_fault()
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com> <1365163198-29726-32-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1365163198-29726-32-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 04:59 AM, Kirill A. Shutemov wrote:
> +	if (unlikely(khugepaged_enter(vma)))
> +		return VM_FAULT_OOM;
...
> +	ret = vma->vm_ops->huge_fault(vma, &vmf);
> +	if (unlikely(ret & VM_FAULT_OOM))
> +		goto uncharge_out_fallback;
> +	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
> +		goto uncharge_out;
> +
> +	if (unlikely(PageHWPoison(vmf.page))) {
> +		if (ret & VM_FAULT_LOCKED)
> +			unlock_page(vmf.page);
> +		ret = VM_FAULT_HWPOISON;
> +		goto uncharge_out;
> +	}

One note on all these patches, but especially this one is that I think
they're way too liberal with unlikely()s.  You really don't need to do
this for every single error case.  Please reserve them for places where
you _know_ there is a benefit, or that the compiler is doing things that
you _know_ are blatantly wrong.
