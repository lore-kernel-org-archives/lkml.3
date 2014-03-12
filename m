Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaCLSTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:19:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45320 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbaCLSTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:19:30 -0400
Date: Wed, 12 Mar 2014 18:19:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        stable <stable@vger.kernel.org>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] fs: fix i_writecount on shmem and friends
Message-ID: <20140312181925.GK18016@ZenIV.linux.org.uk>
References: <1393859798-1407-1-git-send-email-dh.herrmann@gmail.com>
 <CA+55aFwzBoTc+09jZTGjfTQTfkgZwrN5m09snb+F9inLaDn0OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwzBoTc+09jZTGjfTQTfkgZwrN5m09snb+F9inLaDn0OA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 12:05:09PM -0700, Linus Torvalds wrote:
> 
> which returns ETXTBSY (most easily seen by just stracing it).
> 
> The patch would also seem to make sense, with the i_readcount_inc()
> being immediately below for the FMODE_READ case.

I think it's trying to fix the problem in the wrong place.  The bug is real,
all right, but it's not that alloc_file() for non-regulars doesn't grab
writecount; it's that drop_file_write_access() drops it for those.

What the hell would we want to play with that counter for, anyway?  It's not
as if they could be mmapped, so all it does is making pipe(2) and socket(2)
more costly, for no visible reason.

I would prefer to flip
        put_write_access(inode);

        if (special_file(inode->i_mode))
                return;
in drop_file_write_access() instead.

<goes to looks at i_writecount users>
Oh, shit...

drivers/md/md.c:
/* similar to deny_write_access, but accounts for our holding a reference
 * to the file ourselves */
static int deny_bitmap_write_access(struct file * file)
{
        struct inode *inode = file->f_mapping->host;

        spin_lock(&inode->i_lock);
        if (atomic_read(&inode->i_writecount) > 1) {
                spin_unlock(&inode->i_lock);
                return -ETXTBSY;
        }
        atomic_set(&inode->i_writecount, -1);
        spin_unlock(&inode->i_lock);

        return 0;
}

Broken.  get_write_access() will happily increment i_writecount e.g. from
1 to 2, without even looking at i_lock.  Moreover, it's paired with
void restore_bitmap_write_access(struct file *file)
{
        struct inode *inode = file->f_mapping->host;

        spin_lock(&inode->i_lock);
        atomic_set(&inode->i_writecount, 1);
        spin_unlock(&inode->i_lock);
}
Just what will happen if we do denywrite mmap() of that file in between?
Even worse, the caller take file straight from fget(), with no sanity
checks whatsoever.  Just what will happen if I give it e.g. a directory?
Or a procfs/sysfs/whatnot file, for that matter?  Neil?  I realize that
it's root-only, but still...
