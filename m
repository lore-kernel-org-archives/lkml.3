Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbbAXLdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 06:33:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:47521 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751923AbbAXLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 06:33:03 -0500
Date: Sat, 24 Jan 2015 06:33:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5 v2] tracing: Automatically mount tracefs on
 debugfs/tracing
Message-ID: <20150124063330.2c986ea2@grimm.local.home>
In-Reply-To: <20150124030041.GB5009@kroah.com>
References: <20150123155525.795129339@goodmis.org>
	<20150123162414.580817092@goodmis.org>
	<20150124030041.GB5009@kroah.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2015 11:00:41 +0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> > +		if (traced->d_op) {
> > +			/*
> > +			 * FIXME:
> > +			 * Currently debugfs sets the d_op by a
> > side-effect
> > +			 * of calling simple_lookup(). Normally,
> > we should
> > +			 * never change d_op of a dentry, but as
> > this is
> > +			 * happening at boot up and shouldn't be
> > racing with
> > +			 * any other users, this should be OK. But
> > it is still
> > +			 * a hack, and needs to be properly done.
> > +			 */
> > +			trace_ops = *traced->d_op;
> > +			trace_ops.d_automount = trace_automount;
> > +			traced->d_flags |= DCACHE_NEED_AUTOMOUNT;
> > +			traced->d_op = &trace_ops;
> > +		} else {
> > +			/* Ideally, this is what should happen */
> > +			trace_ops = simple_dentry_operations;
> > +			trace_ops.d_automount = trace_automount;
> > +			d_set_d_op(traced, &trace_ops);
> 
> How will this else block run if debugfs is setting d_op in the
> debugfs_create_dir() call?

It wont; I put the else block there to show what we would like to do.
And would hopefully work if debugfs ever changed.


> 
> What really do you want to do here, just automount a filesystem on
> debugfs?  If so, can't we just add a new debugfs call to do that?

We could add a call to debugfs to do that. Would you prefer that? From
talking with Al, it sounds to me that changing d_ops on the fly is very
racy. Adding a call in debugfs sounds like it would be open for other
users to do the same and do so while the system is running. Would that
be wise?

Doing the automount here is guaranteed not to happen after system boot
up, or when there might be users of debugfs while the ops changes.

-- Steve


-- Steve
