Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaFLQEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:04:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbaFLQEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:04:36 -0400
Date: Thu, 12 Jun 2014 09:08:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] debugfs: Fix corrupted loop in
 debugfs_remove_recursive
Message-ID: <20140612160827.GA12378@kroah.com>
References: <20140609140607.3e3aae39@gandalf.local.home>
 <20140612104314.GB18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612104314.GB18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 11:43:14AM +0100, Al Viro wrote:
> On Mon, Jun 09, 2014 at 02:06:07PM -0400, Steven Rostedt wrote:
> 
> > When these are called, the d_entry and inode locks need to be released
> > to call the instance creation and deletion code. That code has its own
> > accounting and locking to serialize everything to prevent multiple
> > users from causing harm. As the parent "instance" directory can not
> > be modified this simplifies things.
> 
> Yecchhh...   Looking at debugfs:
> 
> static inline int debugfs_positive(struct dentry *dentry)
> {
>         return dentry->d_inode && !d_unhashed(dentry);
> }
> 
> ...
>         if (debugfs_positive(dentry)) {
>                 if (dentry->d_inode) {
> What the hell?
> 
>         parent = dentry->d_parent;
>         if (!parent || !parent->d_inode)
>                 return;
> Huh?  First of all, ->d_parent is *never* NULL.  Moreover, it can't be a
> negative dentry.
> 
> What's more, if debugfs_rename() is ever used for cross-directory renames,
> this tree-walker is buggered - it'll happily walk up "back" into a directory
> it has never visited...

All of that code has been there since before 2.11, I really don't
remember how I came up with it at all, sorry.

I'm working on converting debugfs to use kernfs, so all of the debugfs
mess and problems should go away soon.

thanks,

greg k-h
