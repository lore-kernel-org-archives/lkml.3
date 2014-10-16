Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaJQHCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:02:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:60717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaJQHCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:02:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,737,1406617200"; 
   d="scan'208";a="620344502"
Date: Thu, 16 Oct 2014 18:33:31 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 07/21] dax,ext2: Replace XIP read and write with DAX
 I/O
Message-ID: <20141016223331.GA11169@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-8-git-send-email-matthew.r.wilcox@intel.com>
 <20141016095027.GE19075@thinkos.etherlink>
 <20141016195112.GE11522@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016195112.GE11522@wil.cx>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 03:51:12PM -0400, Matthew Wilcox wrote:
> On Thu, Oct 16, 2014 at 11:50:27AM +0200, Mathieu Desnoyers wrote:
> > > +			if (rw == WRITE) {
> > > +				if (!buffer_mapped(bh)) {
> > > +					retval = -EIO;
> > > +					/* FIXME: fall back to buffered I/O */
> > 
> > Fallback on buffered I/O would void guarantee about having data stored
> > into persistent memory after write returns. Not sure we actually want
> > that.
> 
> Yeah, I think that comment is just stale.  I can't see a way in which
> buffered I/O would succeed after DAX I/O falis.

On further consideration, I think the whole thing is just foolish.
I don't see how get_block(create == 1) can return success *and* a buffer
that is !mapped.

So I did this nice simplification:

-                       if (rw == WRITE) {
-                               if (!buffer_mapped(bh)) {
-                                       retval = -EIO;
-                                       /* FIXME: fall back to buffered I/O */
-                                       break;
-                               }
-                               hole = false;
-                       } else {
-                               hole = !buffer_written(bh);
-                       }
+                       hole = (rw != WRITE) && !buffer_written(bh);

(compile-tested only; I'm going to run all the changes through xfstests
next week when I'm back home before sending out a v12).
