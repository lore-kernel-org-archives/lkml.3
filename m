Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3I2StX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 14:49:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52024 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3I2StT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 14:49:19 -0400
Date: Sun, 29 Sep 2013 19:49:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [rfc][possible solution] RCU vfsmounts
Message-ID: <20130929184917.GN13318@ZenIV.linux.org.uk>
References: <20130928202728.GK13318@ZenIV.linux.org.uk>
 <CA+55aFzrjiM6bgqNgdckJGAZks2fR8ZD+R_5AqxvrnS64DD3ow@mail.gmail.com>
 <20130929060601.GL13318@ZenIV.linux.org.uk>
 <CA+55aFyGY7hZTDhWiyWBe+oSkxd2GzoYWGhvXtGTyZKL-3PZ1w@mail.gmail.com>
 <20130929181047.GM13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929181047.GM13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 07:10:47PM +0100, Al Viro wrote:
> FWIW, right now I'm reviewing the subset of fs code that can be hit in
> RCU mode.  Not a pretty sight, that... ;-/  First catch: in
> fuse_dentry_revalidate() we have a case (reachable with LOOKUP_RCU) where
> we do this:
>         } else if (inode) {
>                 fc = get_fuse_conn(inode);
>                 if (fc->readdirplus_auto) {
>                         parent = dget_parent(entry);
>                         fuse_advise_use_readdirplus(parent->d_inode);
>                         dput(parent);
>                 }
>         }
> First of all, that'll lead to obvious nastiness if we get here when
> ->s_fs_info has already been freed in process of fs shutdown; fc will
> be pointing to kfreed object and no, freeing it isn't RCU-delayed.
> That's not a problem with the current tree, of course, but this
> dput(parent) very much is - doing that under rcu_read_lock() is
> a Bloody Bad Idea(tm).

Another one: 
int ll_revalidate_nd(struct dentry *dentry, unsigned int flags)
{
        struct inode *parent = dentry->d_parent->d_inode;
        int unplug = 0;

        CDEBUG(D_VFSTRACE, "VFS Op:name=%s,flags=%u\n",  
               dentry->d_name.name, flags);

        if (!(flags & (LOOKUP_PARENT|LOOKUP_OPEN|LOOKUP_CREATE)) &&
            ll_need_statahead(parent, dentry) > 0) {
                if (flags & LOOKUP_RCU)
                        return -ECHILD;

... and ll_need_statahead(NULL, ...) will oops.  Doesn't even need
LOOKUP_RCU to barf - ->d_revalidate() can be called without ->i_mutex
on parent, so we can race with e.g. rename() followed by rmdir() of
old parent.
