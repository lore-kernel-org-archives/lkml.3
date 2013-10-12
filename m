Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3JLJUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 05:20:49 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:21534 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3JLJUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 05:20:47 -0400
X-RZG-AUTH: :IWkQb0WIdvqIIwNfJfyiKBgoQwjwJ7eL6yL6M6h2IziqwDGkR4xBppouhChxc2pJbWJcUZM4igo495BgM1cfZ6Op
X-RZG-CLASS-ID: mo05
Message-ID: <52591461.7070605@samba.org>
Date: Sat, 12 Oct 2013 11:20:33 +0200
From: "Stefan (metze) Metzmacher" <metze@samba.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org
CC: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] locks: implement "filp-private" (aka UNPOSIX)
 locks
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
In-Reply-To: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
X-Enigmail-Version: 1.5.2
OpenPGP: id=0E53083F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

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
> 
> I've given this patchset some very basic smoke testing and it seems to
> do the right thing, but it is still pretty rough. If this looks
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

I haven't looked at the patches, but it would be very good to have locks
per "open" and not per "fd".

What happens in this example?

fd1 = open("/somefile", ...);
fd2 = open("/somefile", ...);
fd3 = dup(fd1);

lock(fd1, range1)
lock(fd2, range2)
lock(fd3, range3)

lock(fd2, range1) // => error already locked?

lock(fd3, range1) // stacked lock?

close(fd1)

lock(fd2, range1) // is range1 still locked by fd3 ?

What about fd-passing, will the locks be transferred/shared with the
other process?

metze
