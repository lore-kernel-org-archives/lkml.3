Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbbAYQQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:16:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbbAYQQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:16:07 -0500
Date: Sun, 25 Jan 2015 21:22:07 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5 v2] tracing: Automatically mount tracefs on
 debugfs/tracing
Message-ID: <20150125132206.GA16249@kroah.com>
References: <20150123155525.795129339@goodmis.org>
 <20150123162414.580817092@goodmis.org>
 <20150124030041.GB5009@kroah.com>
 <20150124063330.2c986ea2@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150124063330.2c986ea2@grimm.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 06:33:30AM -0500, Steven Rostedt wrote:
> On Sat, 24 Jan 2015 11:00:41 +0800
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > > +		if (traced->d_op) {
> > > +			/*
> > > +			 * FIXME:
> > > +			 * Currently debugfs sets the d_op by a
> > > side-effect
> > > +			 * of calling simple_lookup(). Normally,
> > > we should
> > > +			 * never change d_op of a dentry, but as
> > > this is
> > > +			 * happening at boot up and shouldn't be
> > > racing with
> > > +			 * any other users, this should be OK. But
> > > it is still
> > > +			 * a hack, and needs to be properly done.
> > > +			 */
> > > +			trace_ops = *traced->d_op;
> > > +			trace_ops.d_automount = trace_automount;
> > > +			traced->d_flags |= DCACHE_NEED_AUTOMOUNT;
> > > +			traced->d_op = &trace_ops;
> > > +		} else {
> > > +			/* Ideally, this is what should happen */
> > > +			trace_ops = simple_dentry_operations;
> > > +			trace_ops.d_automount = trace_automount;
> > > +			d_set_d_op(traced, &trace_ops);
> > 
> > How will this else block run if debugfs is setting d_op in the
> > debugfs_create_dir() call?
> 
> It wont; I put the else block there to show what we would like to do.
> And would hopefully work if debugfs ever changed.
> 
> 
> > 
> > What really do you want to do here, just automount a filesystem on
> > debugfs?  If so, can't we just add a new debugfs call to do that?
> 
> We could add a call to debugfs to do that. Would you prefer that? From
> talking with Al, it sounds to me that changing d_ops on the fly is very
> racy. Adding a call in debugfs sounds like it would be open for other
> users to do the same and do so while the system is running. Would that
> be wise?

If we could do it in a non-racy way, that would be good, otherwise I
don't see us being able to even take this patch :(

thanks,

greg k-h
