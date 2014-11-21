Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbaKUQ6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:58:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbaKUQ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:57:58 -0500
Date: Fri, 21 Nov 2014 08:56:38 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
        ebiederm@xmission.com,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
Subject: Re: kdbus: add node and filesystem implementation
Message-ID: <20141121165638.GA24866@kroah.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
 <1416546149-24799-7-git-send-email-gregkh@linuxfoundation.org>
 <546F606D.40407@oracle.com>
 <CANq1E4QkXv9Ak6eT+NZPsy+5nTGKE8oypLvdr97cFcvmtigS_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4QkXv9Ak6eT+NZPsy+5nTGKE8oypLvdr97cFcvmtigS_A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 05:13:26PM +0100, David Herrmann wrote:
> Hi
> 
> On Fri, Nov 21, 2014 at 4:55 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> > On 11/21/2014 12:02 AM, Greg Kroah-Hartman wrote:
> >> +static struct dentry *fs_dir_iop_lookup(struct inode *dir,
> >> +                                     struct dentry *dentry,
> >> +                                     unsigned int flags)
> >> +{
> >> +     struct dentry *dnew = NULL;
> >> +     struct kdbus_node *parent;
> >> +     struct kdbus_node *node;
> >> +     struct inode *inode;
> >> +
> >> +     parent = kdbus_node_from_dentry(dentry->d_parent);
> >> +     if (!kdbus_node_acquire(parent))
> >> +             return NULL;
> >> +
> >> +     /* returns reference to _acquired_ child node */
> >> +     node = kdbus_node_find_child(parent, dentry->d_name.name);
> >> +     if (node) {
> >> +             dentry->d_fsdata = node;
> >> +             inode = fs_inode_get(dir->i_sb, node);
> >> +             if (IS_ERR(inode))
> >> +                     dnew = ERR_CAST(inode);
> >> +             else
> >> +                     dnew = d_materialise_unique(dentry, inode);
> >
> > d_materialise_unique() is gone in Al's fs tree:
> >
> > [mandatory]
> >         d_materialise_unique() is gone; d_splice_alias() does everything you
> >         need now.  Remember that they have opposite orders of arguments ;-/
> 
> That was actually pushed after we prepared v2, so I haven't seen it
> yet. I now rebased on top of vfs.git#for-next, with
> d_materialise_unique() -> d_splice_alias(). Thanks for the hint!
> 
> > Maybe it's worth basing your git tree on top of Al's rather than a random
> > -rc, since it's now a filesystem?
> 
> Sure, sounds good.

No, I'll keep it as is, we can handle the merge issues later when it
hits Linus's tree, this makes it easier for me and others to test it
out properly.

thanks,

greg k-h
