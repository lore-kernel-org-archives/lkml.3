Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750776Ab3LIXWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:22:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3LIXWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:22:03 -0500
Date: Mon, 9 Dec 2013 15:22:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, page_alloc: make __GFP_NOFAIL really not fail
Message-Id: <20131209152202.df3d4051d7dc61ada7c420a9@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1312091355360.11026@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312091355360.11026@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013 13:56:37 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> __GFP_NOFAIL specifies that the page allocator cannot fail to return
> memory.  Allocators that call it may not even check for NULL upon
> returning.
> 
> It turns out GFP_NOWAIT | __GFP_NOFAIL or GFP_ATOMIC | __GFP_NOFAIL can
> actually return NULL.  More interestingly, processes that are doing
> direct reclaim and have PF_MEMALLOC set may also return NULL for any
> __GFP_NOFAIL allocation.

__GFP_NOFAIL is a nasty thing and making it pretend to work even better
is heading in the wrong direction, surely?  It would be saner to just
disallow these even-sillier combinations.  Can we fix up the current
callers then stick a WARN_ON() in there?

> This patch fixes it so that the page allocator never actually returns
> NULL as expected for __GFP_NOFAIL.  It turns out that no code actually
> does anything as crazy as GFP_ATOMIC | __GFP_NOFAIL currently, so this
> is more for correctness than a bug fix for that issue.
