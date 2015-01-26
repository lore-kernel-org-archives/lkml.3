Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbbAZXZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:25:29 -0500
Received: from mail-yk0-f176.google.com ([209.85.160.176]:35220 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbbAZXZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:25:27 -0500
Date: Mon, 26 Jan 2015 18:25:23 -0500
From: Jeff Layton <jeff.layton@primarydata.com>
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, eparis@redhat.com,
        viro@ZenIV.linux.org.uk, linux-unionfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Overlayfs, *notify() and file locking...
Message-ID: <20150126182523.585c876e@tlielax.poochiereds.net>
In-Reply-To: <22064.1422309732@warthog.procyon.org.uk>
References: <22064.1422309732@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 22:02:12 +0000
David Howells <dhowells@redhat.com> wrote:

> Having looked briefly at *notify() and file locking with an eye to doing some
> changes there to provide support LSMs and procfs for overlayfs/unionmount type
> things, I'm wondering how we're going to manage these two facilities.
> 
> The problem with both of these (afaict) is that they attach things to the
> inode(s) to be watched.  Now, take overlayfs for an example:
> 
> Say you have a file that is pristine and on the lower layer.  You open it read
> only and lock it.  Someone else then opens it for writing.  Even if there's a
> mandatory lock on it, it will be copied up, and the copy will have no locks on
> it.  Now, we can get round that - sort of - by duplicating, sharing or moving
> the locking records between the inodes (though they may well exist on widely
> different media).
> 
> This is probably manageable, provided there isn't one or more servers involved
> (imagine if you've got one layer on NFS and another on CIFS, for example).
> Further more, if there are leases, we have to manage those trans-copyup also.
> 
> Note that moving the lock may not be possible if the R/O file is still open
> and still locked.  The R/O file still refers to the R/O copy, even after the
> copy up.
> 
> The situation is slightly complicated in the case of overlayfs in that there's
> a third inode - the overlay inode - around, though that's probably bypassed by
> file->f_inode pointing to one of the other layers.  Note that to get proc and
> LSMs working, I need to make file->f_path point to the overlay/union layer
> whilst file->f_inode points to the upper/lower layer inode.
> 
> The situation is more complicated in the case of unionmount if we go there as
> there *is* no top inode to hang things off until we try to write to the union
> layer.
> 
> Two further complications are that if a lock is placed on a lower inode, that
> lower inode may be shared with other overlays - and so must (a) be copied,
> moved or duplicated to the right overlay; and (b) must still interact
> correctly with any locks from other overlays.
> 
> Yet a further complication is how should locks interact between a file shared
> between namespaces?  F_GETLK can return information about a locker
> (eg. l_pid).
> 
> To summarise the problems:
> 
>  (1) Locks may need to migrate between layers on copy up.
> 
>  (2) Locks taken on source layers must still interact even after copy up.
> 
>  (3) The top layer may get in the way.
> 
>  (4) Layers may be remote and have remote locks (eg. NFS).
> 
>  (5) There are also leases.
> 
>  (6) There may be multiple overlays sharing files and locks must be copied up
>      to the right place.
> 
>  (7) Mandatory locks vs copyup.
> 
>  (8) f_path needs to point to the overlay layer while f_inode points to the
>      lower layer to fix proc and LSMs.
> 
> 

I think the first thing to do is to sort out how we expect this to work
from a user's standpoint. For instance:

Suppose I have a "shared" R/O layer on a NFS server with a "private" R/W
layer on some local storage. I then open the file O_RDWR and it gets
copied up. I then place a (POSIX) F_WRLCK on the file. Should that lock
be sent to the NFS server?

My expectation would be no. The file on the server isn't going to
change, so there's no need to send lock requests out to the server in
that use case. Doing so might be harmful -- other clients that are
using R/O layer could fail to get the lock.

That's just one case though. There are probably others where we *do*
want to send the locks to the server (e.g maybe the R/W layer is on
NFS). Perhaps if we outline more of these sorts of use cases, a pattern
will emerge that will help illustrate how it should all work. :)


> Now, the problem with file notifications is very similar.  These again hang
> off the inode, but the inode they need to be hung off may change:
> 
>  (1) Watches may need to migrate between layers.
> 
>  (2) Watches on the source layer need to be duplicated to all overlays on copy
>      up.
> 
>  (2b) Watches probably theoretically ought to remain watching the copied up
>       files even after a restart.  This is probably just too impractical,
>       though.
> 
>  (3) The top layer may get in the way and watches should probably go on the
>      appropriate lower layer.
> 
>  (4) The layers may be remote and have remote watches (eg. CIFS).
> 
>  (5) f_path needs to point to the overlay layer while f_inode points to the
>      lower layer to fix proc and LSMs.
> 
> 
> Note that for both overlayfs and unionmount, directories are 'real' on the top
> layer, so watches (and locks if that's possible) may be easier to handle
> there, though in another sense, they're harder since they're the union of
> several directories' worth of contents and *all* the contributory directories
> need to be watched as two unions need not be fabricated from the same set of
> directories in the same order.
> 
> David


-- 
Jeff Layton <jeff.layton@primarydata.com>
