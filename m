Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab3FKVQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 17:16:09 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:47363 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab3FKVQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 17:16:08 -0400
Date: Tue, 11 Jun 2013 17:16:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] mm: Implement RLIMIT_RSS
Message-ID: <20130611211601.GA29426@cmpxchg.org>
References: <20130611182921.GB25941@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130611182921.GB25941@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 02:29:21PM -0400, Jörn Engel wrote:
> I've seen a couple of instances where people try to impose a vsize
> limit simply because there is no rss limit in Linux.  The vsize limit
> is a horrible approximation and even this patch seems to be an
> improvement.
> 
> Would there be strong opposition to actually supporting RLIMIT_RSS?
> 
> Jörn
> 
> --
> It's not whether you win or lose, it's how you place the blame.
> -- unknown
> 
> 
> Not quite perfect, but close enough for many purposes.  This checks rss
> limit inside may_expand_vm() and will fail if we are already over the
> limit.

This is trivial to exploit by creating the mappings first and
populating them later, so while it may cover some use cases, it does
not have the protection against malicious programs aspect that all the
other rlimits have.

The right place to enforce the limit is at the point of memory
allocation, which raises the question what to do when the limit is
exceeded in a page fault.  Reclaim from the process's memory?  Kill
it?

I guess the answer to these questions is "memory cgroups", so that's
why there is no real motivation to implement RLIMIT_RSS separately...
