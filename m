Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaE0PcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:32:05 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:47550 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbaE0PcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:32:01 -0400
Date: Tue, 27 May 2014 10:31:58 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations
In-Reply-To: <20140527145352.GB3765@amt.cnet>
Message-ID: <alpine.DEB.2.10.1405271027430.14466@gentwo.org>
References: <20140523193706.GA22854@amt.cnet> <alpine.DEB.2.10.1405270917510.13999@gentwo.org> <20140527145352.GB3765@amt.cnet>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Marcelo Tosatti wrote:

> >
> > Memory policies are only applied to a specific zone so this is not
> > unprecedented. However, if a user wants to limit allocation to a specific
> > node and there is no DMA memory there then may be that is a operator
> > error? After all the application will be using memory from a node that the
> > operator explicitly wanted not to be used.
>
> Ok here is the use-case:
>
> - machine contains driver which requires zone specific memory (such as
> KVM, which requires root pagetable at paddr < 4GB).

GFP_KERNEL is used for page tables.

>
>  * The second pass through get_page_from_freelist() doesn't even call
>  * here for GFP_ATOMIC calls.  For those calls, the __alloc_pages()
>  * variable 'wait' is not set, and the bit ALLOC_CPUSET is not set
>  * in alloc_flags.  That logic and the checks below have the combined
>  * affect that:
>  *      in_interrupt - any node ok (current task context irrelevant)
>  *      GFP_ATOMIC   - any node ok
>  *      TIF_MEMDIE   - any node ok
>  *      GFP_KERNEL   - any node in enclosing hardwalled cpuset ok

Page table allocations are GFP_KERNEL allocations. So the above use case
is ok if you switch off the hardwall flag in the cpuset.

