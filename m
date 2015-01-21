Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbbAUUrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:47:48 -0500
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:47700 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750914AbbAUUrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:47:39 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3872:3874:4605:5007:6261:7576:7875:7903:9121:10004:10400:10848:10967:11026:11232:11233:11658:11914:12043:12517:12519:12740:13069:13311:13357:13618:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trees94_2582e5bddd402
X-Filterd-Recvd-Size: 2914
Date: Wed, 21 Jan 2015 15:47:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 4/5] tracing: Have mkdir and rmdir be part of
 tracefs
Message-ID: <20150121154736.4d32e2a0@gandalf.local.home>
In-Reply-To: <20150121172101.953700301@goodmis.org>
References: <20150121171953.823177070@goodmis.org>
	<20150121172101.953700301@goodmis.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 12:19:57 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The tracing "instances" directory can create sub tracing buffers
> with mkdir, and remove them with rmdir. As a mkdir will also create
> all the files and directories that control the sub buffer the locks
> needed to be released before doing so to avoid deadlock. This method
> was not very robust, and could potentially have a race somewhere due
> to the lock releasing within the removing of the directory. But this
> was needed because debugfs did not provide a mkdir or rmdir method
> from syscalls.
> 
> Now that tracing has been converted over to tracefs, the tracefs file
> system can be modified to accommodate this feature. Instead of needing
> to release the locks, keep them locked but add a way to flag that they
> are locked and do not need to be locked again.
> 
> A struct trace_dir_ops is created that holds the methods to be called
> for both mkdir and rmdir, as well as a pointer to let the tracefs subsystem
> know that the current inode's lock is already held by the calling process.
> 
> The pointer holds the current owner of the lock, and this is checked when
> creating new files or removing old ones, and if the pointer matches current,
> then the lock is not taken to avoid the deadlock.

Grumble, my tests triggered this bug with lockdep on:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sb->s_type->i_mutex_key#6);
                               lock(trace_types_lock);
                               lock(&sb->s_type->i_mutex_key#6);
  lock(trace_types_lock);

 *** DEADLOCK ***


I need to take that trace_types_lock here, but it's true that that lock
is held when these mutexes are taken. I'll have to spend a bit more
time figuring out how to solve this :-/

-- Steve
