Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbbA0ATw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:19:52 -0500
Received: from smtprelay0252.hostedemail.com ([216.40.44.252]:50656 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753759AbbA0ATs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:19:48 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4385:5007:6119:6261:7875:7903:8660:9389:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12740:13069:13148:13230:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: color59_73c0c875a541e
X-Filterd-Recvd-Size: 2724
Date: Mon, 26 Jan 2015 18:43:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150126184314.24f2583c@gandalf.local.home>
In-Reply-To: <20150126214658.GQ29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
	<20150126193049.GN29656@ZenIV.linux.org.uk>
	<20150126154259.5e650d32@gandalf.local.home>
	<20150126214658.GQ29656@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 21:46:58 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Jan 26, 2015 at 03:42:59PM -0500, Steven Rostedt wrote:
> > On Mon, 26 Jan 2015 19:30:49 +0000
> > Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > You are still fighting an inconvenient API, but now it's not debugfs one -
> > > it's your copy thereof.  Why not give your instances/ an inode_operations
> > > of its own?  One with ->mkdir() and ->rmdir(), leaving all other directories
> > > as-is.  That way you don't need the secondary methods at all.  And sure,
> > > debugfs_create_dir() grabs ->i_mutex on parent, making you drop that in
> > > your ->mkdir() if you want to call it.  But now you are not talking to it -
> > > just to your own code, where you are free to change the calling conventions,
> > > making it caller's responsibility to get that ->i_mutex.  The same goes for
> > > the rmdir side...
> > 
> > The vfs layer grabs the i_mutex, which needs to be dropped.
> 
> What for?  Just keep it through your instance_mkdir/instance_rmdir and be
> done with that.  Sure, it means that you need variants of file/directory
> creation/removal primitives that would assume that parent is already locked
> by caller (and would leave unlocking to the caller as well).  So add them...

I originally had this, but the issue isn't with i_mutex only. The
instance_mkdir and instance_rmdir need to grab trace_types_lock. This
is also held when calling into tracefs.

That is, we can not hold i_mutex and take trace_types_lock.

trace_types_lock needs to be held with the creation or destruction of
events, which is what mkdir an rmdir do.


-- Steve
