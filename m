Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaJFFf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:35:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42260 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJFFf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:35:26 -0400
Date: Mon, 6 Oct 2014 06:35:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, bfields@redhat.com,
        mszeredi@suse.cz, "Eric W. Biederman" <ebiederm@xmission.com>,
        hch@lst.de, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: dcache: NULL ptr deref in dentry_kill
Message-ID: <20141006053523.GD7996@ZenIV.linux.org.uk>
References: <5431E203.9070501@oracle.com>
 <20141006031355.GA7996@ZenIV.linux.org.uk>
 <54320FB0.7060403@oracle.com>
 <20141006042517.GB7996@ZenIV.linux.org.uk>
 <54321CF4.9070101@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54321CF4.9070101@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 12:39:16AM -0400, Sasha Levin wrote:
>         if (!IS_ROOT(dentry)) {
>                 parent = dentry->d_parent;
>                 if (unlikely(!spin_trylock(&parent->d_lock))) { <=== here
>                         if (inode)
>                                 spin_unlock(&inode->i_lock);
>                         goto failed;
> 
> We're trying to deref a NULL 'parent'.
 
->d_parent is *never* NULL.  There are very few places where it's modified,
all of them in fs/dcache.c:
fs/dcache.c:1416:       dentry->d_parent = dentry;
fs/dcache.c:1453:       dentry->d_parent = parent;
fs/dcache.c:2478:               dentry->d_parent = target->d_parent;
fs/dcache.c:2479:               target->d_parent = target;
fs/dcache.c:2484:               swap(dentry->d_parent, target->d_parent);

The fifth one exchanges two something->d_parent.  Can't introduce NULL.
Neither can the third one (again, foo->d_parent = bar->d_parent).  The
first and the fourth are also obvious - p->d_parent = p will oops with
p == NULL and store a non-NULL otherwise.  Which leaves the second -
d_alloc().  And there the lines immediately after that assignment are
        list_add(&dentry->d_u.d_child, &parent->d_subdirs);
        spin_unlock(&parent->d_lock);
which would oops with parent == NULL.

Dentries are allocated by __d_alloc().  By the time somebody might
observe them, they already have non-NULL ->d_parent.  And they never
get it set to NULL afterwards.  I don't see any variables (auto or not)
of type struct dentry and I don't see anything that would contain
struct dentry as a field.  It doesn't guarantee that nobody manages
to allocate one somehow or hide a conversion of some strange pointer to
struct dentry *, but any such place would be very likely to trigger tons
of oopsen - it would have to manage to hide initialization of ->d_subdirs,
->d_lru, ->d_alias, etc. and it's hard to do accidentally.

Another possibility is that this pointer either never went to struct dentry
or used to point to one in times long past, and memory had been zeroed
since then.  Or that something has shat some zeroes into a real struct
dentry, corrupting ->d_parent in process.

But any struct dentry with NULL ->d_parent is a serious bug.  That really
should never, ever happen.
