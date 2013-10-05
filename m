Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3JEGfD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 02:35:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50637 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3JEGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 02:35:01 -0400
Date: Sat, 5 Oct 2013 07:34:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chen Gang <gang.chen@asianux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/exit.c: call read_unlock() when failure occurs
 after already called read_lock() in do_wait().
Message-ID: <20131005063431.GU13318@ZenIV.linux.org.uk>
References: <524FA956.9080100@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524FA956.9080100@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 01:53:26PM +0800, Chen Gang wrote:
> If failure occurs after called read_lock(), need call read_unlock() too.
> 
> It can fail in multiple position, so add new tag 'fail_lock' for it
> (also can let 'if' only content one jump statement).

You know, this is getting too frequent...  You really need to do
something about it.  OK, you've formed a hypothesis (in this case,
that ptrace_do_wait() returns non-zero with tasklist_lock still held).
If that hypothesis was correct, you would've found a bug and yes,
this patch would probably be more or less a fix for that bug.

Do you see what's missing?  That's right, verifying that hypothesis.
Which isn't hard to do, either by slapping a printk into these
exits, or by trying to build a proof.  As it is, hypothesis is
incorrect and your patch introduces breakage.  The same would have
happened if _some_ exits from that function returned non-zero
values with tasklist_lock held and some returned non-zero values
with tasklist_lock released.

You really need to realize that pattern-matching is not enough - you
need to prove that your fix is correct and that requires an analysis
of what's there.

"I see something odd" is a good reason to ask or to try and figure out
what's going on.  It's not a good reason for blindly making changes
like that - not until you've done the analysis and can at least show
that it won't _break_ things.
