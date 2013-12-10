Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab3LJTbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:31:03 -0500
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:37903
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707Ab3LJTa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:30:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=lfq9myo/eLzz5DH33+tkkZymPrrhluEb+HfRpHMKPPBu+boZO5Am7r9+GGwcpQ9e;
  h=Received:From:To:Cc:References:In-Reply-To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:Thread-Index:Content-Language:X-ELNK-Trace:X-Originating-IP;
From: "Frank Filz" <ffilzlnx@mindspring.com>
To: "'Jeff Layton'" <jlayton@redhat.com>, <linux-fsdevel@vger.kernel.org>
Cc: <nfs-ganesha-devel@lists.sourceforge.net>,
        <samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
In-Reply-To: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
Subject: RE: [Nfs-ganesha-devel] [PATCH v3 0/6] locks: implement "filp-private"	(aka UNPOSIX) locks
Date: Tue, 10 Dec 2013 11:30:54 -0800
Message-ID: <029701cef5de$58d19c80$0a74d580$@mindspring.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFMmfS/maBCm6lZHt2iMnVsKdamJ5tSh/Cw
Content-Language: en-us
X-ELNK-Trace: 136157f01908a8929c7f779228e2f6aeda0071232e20db4d0e50412c68a490247dc07ead635e85bb350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.236.153.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patchset is the third posting of this set. Behavior between this set
and
> the last should be more or less the same. Here is a summary of
> changes:
> 
> v3:
> - more consolidation of common code between flock_to_posix_lock and
>   flock_to_posix_lock64
> - better bisectability by reordering changes, such that partial
>   implementation won't be exposed
> - s/filp/file/ s/FILP/FILE/ in symbol names
> 
> v2:
> - inheritance semantics have been change to be more BSD-lock like
> - patchset size has been reduced by changing how lock ownership
>   is handled
> - new F_UNLCKP l_type value has been added
> 
> Note too that I've gone ahead and opened a request for the POSIX folks to
> consider adding this to the POSIX spec once we have something mergeable.
> They seem amenable to the idea but don't want to enshrine it into the
> standard until there's a real implementation of it:
> 
>     http://austingroupbugs.net/view.php?id=768
> 
> I also owe them a better writeup of the semantics for these new locks, but
> have been holding off on doing that until they're a little more settled.
> 
> As a side note, I've also had a few other userland developers reach out to
me
> as to the status of this work. There seems to be a lot of interest since
classic
> POSIX locks are such a pain to work with in threaded programs. Hopefully
> some will chime in on this posting...

This is looking really good to me. I will  be excited to utilize this
capability in Ganesha.

Thanks

Frank

> Original cover letter from v1 posting follows. Comments and suggestions
> welcome.
> 
> -------------------------------[snip]------------------------------
> 
> At LSF this year, there was a discussion about the "wishlist" for userland
file
> servers. One of the things brought up was the goofy and problematic
> behavior of POSIX locks when a file is closed. Boaz started a thread on it
here:
> 
>     http://permalink.gmane.org/gmane.linux.file-systems/73364
> 
> Userland fileservers often need to maintain more than one open file
> descriptor on a file. The POSIX spec says:
> 
> "All locks associated with a file for a given process shall be removed
when a
> file descriptor for that file is closed by that process or the  process
holding
> that file descriptor terminates."
> 
> This is problematic since you can't close any file descriptor without
dropping
> all your POSIX locks. Most userland file servers therefore end up opening
the
> file with more access than is really necessary, and keeping fd's open for
> longer than is necessary to work around this.
> 
> This patchset is a first stab at an approach to address this problem by
adding
> two new l_type values -- F_RDLCKP and F_WRLCKP (the 'P' is short for
> "private" -- I'm open to changing that if you have a better mnemonic).
> 
> For all intents and purposes these lock types act just like their "non-P"
> counterpart. The difference is that they are only implicitly released when
the
> fd against which they were acquired is closed. As a side effect, these
locks
> cannot be merged with "non-P" locks since they have different semantics on
> close.
> 
> I've given this patchset some very basic smoke testing and it seems to do
the
> right thing, but it is still pretty rough. If this looks reasonable I'll
plan to do
> some documentation updates and will take a stab at trying to get these new
> lock types added to the POSIX spec (as HCH recommended).
> 
> At this point, my main questions are:
> 
> 1) does this look useful, particularly for fileserver implementors?
> 
> 2) does this look OK API-wise? We could consider different "cmd" values
>    or even different syscalls, but I figured this makes it clearer that
>    "P" and "non-P" locks will still conflict with one another.
> 
> Jeff Layton (6):
>   locks: consolidate common code in the flock_to_posix_lock routines
>   locks: consolidate checks for compatible filp->f_mode values in setlk
>     handlers
>   locks: rename locks_remove_flock to locks_remove_file
>   locks: show private lock types in /proc/locks
>   locks: report l_pid as -1 for FL_FILE_PVT locks
>   locks: add new "private" lock type that is owned by the filp
> 
>  fs/file_table.c                  |   2 +-
>  fs/locks.c                       | 122
+++++++++++++++++++++------------------
>  include/linux/fs.h               |   5 +-
>  include/uapi/asm-generic/fcntl.h |  16 +++++
>  4 files changed, 85 insertions(+), 60 deletions(-)
> 
> --
> 1.8.4.2
> 
> 
>
----------------------------------------------------------------------------
--
> Rapidly troubleshoot problems before they affect your business. Most IT
> organizations don't have a clear picture of how application performance
> affects their revenue. With AppDynamics, you get 100% visibility into your
> Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics
> Pro!
> http://pubads.g.doubleclick.net/gampad/clk?id=84349831&iu=/4140/ostg.clk
> trk
> _______________________________________________
> Nfs-ganesha-devel mailing list
> Nfs-ganesha-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/nfs-ganesha-devel

