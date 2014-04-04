Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaDDOIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:08:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56047 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaDDOIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:08:01 -0400
Date: Fri, 4 Apr 2014 16:07:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Richard Hansen <rhansen@bbn.com>, Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Greg Troxel <gdt@ir.bbn.com>,
        bug-readline@gnu.org
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC [resend]
Message-ID: <20140404140732.GG10526@twins.programming.kicks-ass.net>
References: <533B04A9.6090405@bbn.com>
 <20140402111032.GA27551@infradead.org>
 <1396439119.2726.29.camel@menhir>
 <533CA0F6.2070100@bbn.com>
 <533E5B7A.7030309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533E5B7A.7030309@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 09:12:58AM +0200, Michael Kerrisk (man-pages) wrote:
> >   * Clearer intentions.  Looking at the existing code and the code
> >     history, the fact that flags=0 behaves like flags=MS_ASYNC appears
> >     to be a coincidence, not the result of an intentional choice.
> 
> Maybe. You earlier asserted that the semantics when flags==0 may have
> been different, prior to Peter Zijstra's patch,
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=204ec841fbea3e5138168edbc3a76d46747cc987
> .
> It's not clear to me that that is the case. But, it would be wise to
> CC the developer, in case he has an insight.

Right; so before that patch there appears to have been a difference.
The code looked like:

  if (flags & MS_ASYNC) {
  	balance_dirty_pages_ratelimited();
  } else if (flags & MS_SYNC) {
  	do_fsync()
  } else {
  	/* do nothing */
  }

Which would give the following semantics:

  msync(.flags = 0) -- scan PTEs and update dirty page accounting
  msync(.flags = MS_ASYNC) -- scan PTEs and dirty throttle
  msync(.flags = MS_SYNC) -- scan PTEs and flush dirty pages

However with the introduction of accurate dirty page accounting in
.19 we always had an accurate dirty page count and both .flags=0 and
.flags=MS_ASYNC turn into the same NO-OP.

Yielding todays state, where 0 and MS_ASYNC don't do anything much and
MS_SYNC issues the fsync() -- although I understand Willy recently
posted a patch to do a data-range-sync instead of the full fsync.


