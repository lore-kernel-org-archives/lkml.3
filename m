Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab3JKUH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:07:59 -0400
Received: from fieldses.org ([174.143.236.118]:38914 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758810Ab3JKUH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:07:57 -0400
Date: Fri, 11 Oct 2013 16:07:56 -0400
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: Re: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX)
 locks
Message-ID: <20131011200756.GB22160@fieldses.org>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 08:25:17AM -0400, Jeff Layton wrote:
> At LSF this year, there was a discussion about the "wishlist" for
> userland file servers. One of the things brought up was the goofy and
> problematic behavior of POSIX locks when a file is closed. Boaz started
> a thread on it here:
> 
>     http://permalink.gmane.org/gmane.linux.file-systems/73364
> 
> Userland fileservers often need to maintain more than one open file
> descriptor on a file. The POSIX spec says:
> 
> "All locks associated with a file for a given process shall be removed
>  when a file descriptor for that file is closed by that process or the
>  process holding that file descriptor terminates."
> 
> This is problematic since you can't close any file descriptor without
> dropping all your POSIX locks. Most userland file servers therefore
> end up opening the file with more access than is really necessary, and
> keeping fd's open for longer than is necessary to work around this.
> 
> This patchset is a first stab at an approach to address this problem by
> adding two new l_type values -- F_RDLCKP and F_WRLCKP (the 'P' is short
> for "private" -- I'm open to changing that if you have a better
> mnemonic).
> 
> For all intents and purposes these lock types act just like their
> "non-P" counterpart. The difference is that they are only implicitly
> released when the fd against which they were acquired is closed. As a
> side effect, these locks cannot be merged with "non-P" locks since they
> have different semantics on close.

They also can't be merged with "private" locks belonging to other file
descriptors.  (If you merge lock A, then lock B into a single lock C,
what do you do when B's owner goes away?)

But based on other discussion in the thread it sounds like we'll
actually want to go farther and make them conflict, so, fine.

Seems like a good thing to have, anyway.

--b.

> I've given this patchset some very basic smoke testing and it seems to
> do the right thing, but it is still pretty rough.  If this looks
> reasonable I'll plan to do some documentation updates and will take a
> stab at trying to get these new lock types added to the POSIX spec (as
> HCH recommended).
> 
> At this point, my main questions are:
> 
> 1) does this look useful, particularly for fileserver implementors?
> 
> 2) does this look OK API-wise? We could consider different "cmd" values
>    or even different syscalls, but I figured this makes it clearer that
>    "P" and "non-P" locks will still conflict with one another.
> 
> Jeff Layton (5):
>   locks: consolidate checks for compatible filp->f_mode values in setlk
>     handlers
>   locks: add definitions for F_RDLCKP and F_WRLCKP
>   locks: skip FL_FILP_PRIVATE locks on close unless we're closing the
>     correct filp
>   locks: handle merging of locks when FL_FILP_PRIVATE is set
>   locks: show private lock types in /proc/locks
> 
>  fs/locks.c                       | 121 ++++++++++++++++++++++++++-------------
>  include/linux/fs.h               |   1 +
>  include/uapi/asm-generic/fcntl.h |   9 +++
>  3 files changed, 91 insertions(+), 40 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
