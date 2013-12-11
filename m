Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab3LKALq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:11:46 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:46761 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab3LKALo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:11:44 -0500
Date: Tue, 10 Dec 2013 16:11:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, page_alloc: make __GFP_NOFAIL really not fail
In-Reply-To: <20131210153909.8b4bfa1d643e5f8582eff7c9@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1312101559590.22701@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312091355360.11026@chino.kir.corp.google.com> <20131209152202.df3d4051d7dc61ada7c420a9@linux-foundation.org> <alpine.DEB.2.02.1312101504120.22701@chino.kir.corp.google.com>
 <20131210153909.8b4bfa1d643e5f8582eff7c9@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Andrew Morton wrote:

> > Heh, it's difficult to remove __GFP_NOFAIL when new users get added: 
> > 84235de394d9 ("fs: buffer: move allocation failure loop into the 
> > allocator") added a new user
> 
> That wasn't reeeeealy a new user - it was "convert an existing
> open-coded retry-for-ever loop".  Which is what __GFP_NOFAIL is for.
> 

No, it just looks like that's what it did.  find_or_create_page() in that 
function does an order-0 allocation which always implicitly __GFP_NOFAIL 
because of the should_alloc_retry() behavior.  So why does it need to add 
__GFP_NOFAIL there now?  Because it is now allowed to bypass memcg limits 
to the root memcg, which is new behavior with the patch.  It adds 
additional memcg powers that can't be duplicated in the caller, so now 
it's really become __GFP_BYPASS_MEMCG_LIMIT_ON_OOM for everything that was 
doing order-3 or smaller allocations, which should be all existing 
__GFP_NOFAIL users.
