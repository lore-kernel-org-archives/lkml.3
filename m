Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbaFLKnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:43:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57092 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916AbaFLKnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:43:17 -0400
Date: Thu, 12 Jun 2014 11:43:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] debugfs: Fix corrupted loop in
 debugfs_remove_recursive
Message-ID: <20140612104314.GB18016@ZenIV.linux.org.uk>
References: <20140609140607.3e3aae39@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609140607.3e3aae39@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 02:06:07PM -0400, Steven Rostedt wrote:

> When these are called, the d_entry and inode locks need to be released
> to call the instance creation and deletion code. That code has its own
> accounting and locking to serialize everything to prevent multiple
> users from causing harm. As the parent "instance" directory can not
> be modified this simplifies things.

Yecchhh...   Looking at debugfs:

static inline int debugfs_positive(struct dentry *dentry)
{
        return dentry->d_inode && !d_unhashed(dentry);
}

...
        if (debugfs_positive(dentry)) {
                if (dentry->d_inode) {
What the hell?

        parent = dentry->d_parent;
        if (!parent || !parent->d_inode)
                return;
Huh?  First of all, ->d_parent is *never* NULL.  Moreover, it can't be a
negative dentry.

What's more, if debugfs_rename() is ever used for cross-directory renames,
this tree-walker is buggered - it'll happily walk up "back" into a directory
it has never visited...
