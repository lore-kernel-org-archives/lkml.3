Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3LEQ7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:59:42 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:65053 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab3LEQ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:59:41 -0500
Date: Thu, 5 Dec 2013 11:59:36 -0500
From: Tejun Heo <tj@kernel.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 08/23] mm/memblock: Add memblock memory allocation apis
Message-ID: <20131205165936.GB24062@mtj.dyndns.org>
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
 <1386037658-3161-9-git-send-email-santosh.shilimkar@ti.com>
 <20131203232445.GX8277@htj.dyndns.org>
 <529F5047.50309@ti.com>
 <20131204160730.GQ3158@htj.dyndns.org>
 <529F5C55.1020707@ti.com>
 <52A07BBE.7060507@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A07BBE.7060507@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 05, 2013 at 03:12:30PM +0200, Grygorii Strashko wrote:
> I'll try to provide more technical details here.
> As Santosh mentioned in previous e-mails, it's not easy to simply
> get rid of using MAX_NUMNODES:
> 1) we introduce new interface memblock_allocX 
> 2) our interface uses memblock APIs __next_free_mem_range_rev()
>    and __next_free_mem_range()
> 3) __next_free_mem_range_rev() and __next_free_mem_range() use MAX_NUMNODES
> 4) _next_free_mem_range_rev() and __next_free_mem_range() are used standalone,
>    outside of our interface as part of *for_each_free_mem_range* or for_each_mem_pfn_range ..
> 
> The point [4] leads to necessity to find and correct all places where memmblock APIs
> are used and where it's expected to get MAX_NUMNODES as input parameter.
> The major problem is that simple "grep" will not work, because memmblock APIs calls
> are hidden inside other MM modules and it's not always clear
> what will be passed as input parameters to APIs of these MM modules
> (for example sparse_memory_present_with_active_regions() or sparse.c).

Isn't that kinda trivial to work around?  Make those functions accept
both MAX_NUMNODES and NUMA_NO_NODE but emit warning on MAX_NUMNODES
(preferably throttled reasonably).  Given the history of API, we'd
probably want to keep such warning for extended period of time but
that's what we'd need to do no matter what.

> As result, WIP patch, I did, and which was posted by Santosh illustrates
> the probable size and complexity of the change.

Again, I don't really mind the order things happen but I don't think
it's a good idea to spread misusage with a new API.  You gotta deal
with it one way or the other.

> Sorry, but question here is not "Do or not to do?", but rather 'how to do?",
> taking into account complexity and state of the current MM code.
> For example. would it be ok if I'll workaround the issue as in the attached patch?

Well, it's more of when.  It's not really a technically difficult
task and all I'm saying is it better be sooner than later.

Thanks.

-- 
tejun
