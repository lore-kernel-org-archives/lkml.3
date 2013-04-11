Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934797Ab3DKX3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:29:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45664 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3DKX3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:29:18 -0400
Date: Fri, 12 Apr 2013 00:29:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [RFC] revoke(2) and generic handling of things like
 remove_proc_entry()
Message-ID: <20130411232913.GC4068@ZenIV.linux.org.uk>
References: <20130405042932.GB4068@ZenIV.linux.org.uk>
 <20130406050049.GI4068@ZenIV.linux.org.uk>
 <877gk8vlnp.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gk8vlnp.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 01:48:26PM -0700, Eric W. Biederman wrote:

> Last time I was looking at this I was noticing that there is a lock
> (mmap_sem?) that is held over every ->vm_op->foo() call.  If that is
> true today it should be possible to just grab that lock and change
> vm_ops.  That makes for a very cheap and easy implementation, except for
> the covolutions needed for taking the lock.

3-rd party down_write(&mm->mmap_sem) is a Bloody Bad Idea(tm).  VM locking is
complicated enough as it is and making it cope with such things would make it
even more convoluted.

> If we can do add useful support at the fs and mm layers without
> affecting performance I am all for it.  I remember that tends to make
> things easier.  As an alternative let me suggest what I had intended to
> do if/when I ever got back to working on revoke.
> 
> Make a library like libfs that can be used for files that want to
> implement revoke support.
> 
> In that library implement what can be implemented reliably and correctly
> and error on the sophisticated cases we can't support.
> 
> With the semantics and the basic users figured out move what bits we can
> into the vfs or the mm subsystem to make things easier.
> 
> With a library at the very least we have one implementation that we can
> debug and work with instead of a different implementation of revoke for
> each different kind of file.

Yecchh...  revoke() as a syscall or revoke as something that happens when
kernel decides that file has gone away?  The latter includes
procfs/debugfs/sysfs at the very least.  Do we want to require all of those
to use that library?  I would rather try to avoid a need for wrappers, TBH...

You have a very good point re ->close() - the locking conditions for it are
such that making revoke do it is extremely inconvenient.  IMO it means that
mmap should check for attempts to set ->vm_op on vma with non-NULL
->vm_file->f_revoke and fail if it runs into such.
