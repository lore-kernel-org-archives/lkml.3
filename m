Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaAXDBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 22:01:07 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:2603 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbaAXDBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 22:01:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugJAL/W4VJ5LGaB/2dsb2JhbABagwyDOrQ6hVCBCxd0giUBAQEEJxMcIxAIAw4KCSUPBSUDIROIBMdLFo5qB4Q4BJQ9g2WSGYNBKA
Date: Fri, 24 Jan 2014 14:01:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@redhat.com>,
        xfs@oss.sgi.com,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: XFS lockdep spew with v3.13-4156-g90804ed
Message-ID: <20140124030100.GM27606@dastard>
References: <20140124015855.GM16455@hansolo.jdub.homelinux.org>
 <20140124022903.GK27606@dastard>
 <CA+5PVA4i0xp7jqcR=yMG3BjucXfkbM+yXP7YoDHWZgbLtdej-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4i0xp7jqcR=yMG3BjucXfkbM+yXP7YoDHWZgbLtdej-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 09:51:05PM -0500, Josh Boyer wrote:
> On Thu, Jan 23, 2014 at 9:29 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jan 23, 2014 at 08:58:56PM -0500, Josh Boyer wrote:
> >> the existing dependency chain (in reverse order) is:
> >> [  132.638078]
> >> -> #1 (&(&ip->i_lock)->mr_lock){++++..}:
> >> [  132.638080]        [<ffffffff810deaa2>] lock_acquire+0xa2/0x1d0
> >> [  132.638083]        [<ffffffff8178312e>] _raw_spin_lock+0x3e/0x80
> >> [  132.638085]        [<ffffffff8123c579>] __mark_inode_dirty+0x119/0x440
> >> [  132.638088]        [<ffffffff812447fc>] __set_page_dirty+0x6c/0xc0
> >> [  132.638090]        [<ffffffff812477e1>] mark_buffer_dirty+0x61/0x180
> >> [  132.638092]        [<ffffffff81247a31>] __block_commit_write.isra.21+0x81/0xb0
> >> [  132.638094]        [<ffffffff81247be6>] block_write_end+0x36/0x70
> >> [  132.638096]        [<ffffffff81247c48>] generic_write_end+0x28/0x90
> >> [  132.638097]        [<ffffffffa0554cab>] xfs_vm_write_end+0x2b/0x70 [xfs]
> >> [  132.638104]        [<ffffffff8118c4f6>] generic_file_buffered_write+0x156/0x260
> >> [  132.638107]        [<ffffffffa05651d7>] xfs_file_buffered_aio_write+0x107/0x250 [xfs]
> >> [  132.638115]        [<ffffffffa05653eb>] xfs_file_aio_write+0xcb/0x130 [xfs]
> >> [  132.638122]        [<ffffffff8120af8a>] do_sync_write+0x5a/0x90
> >> [  132.638125]        [<ffffffff8120b74d>] vfs_write+0xbd/0x1f0
> >> [  132.638126]        [<ffffffff8120c15c>] SyS_write+0x4c/0xa0
> >> [  132.638128]        [<ffffffff8178db69>] system_call_fastpath+0x16/0x1b
> >
> > Sorry, what? That trace is taking the ip->i_vnode->i_lock
> > *spinlock*, not the ip->i_lock *rwsem*. And it's most definitely not
> > currently holding the ip->i_lock rwsem here. I think lockdep has
> > dumped the wrong stack trace here, because it most certainly doesn't
> > match the unsafe locking scenario that has been detected.
> 
> I rebooted again with the same kernel and lockdep spit out a different
> stacktrace for this part.  See below.  The rest looks mostly the same,
> and it spews when I log into gnome, so at least it's recreatable.

Right, it spat out the correct one this time - block mapping in the
IO path run from a page fault.
> 
> > You can't mmap directories, and so the page fault lock order being
> > shown for CPU1 can't happen on a directory. False positive.
> >
> > *sigh*
> >
> > More complexity in setting up inode lock order instances is required
> > so that lockdep doesn't confuse the lock ordering semantics of
> > directories with regular files. As if that code to make lockdep
> > happy wasn't complex enough already....
> 
> So the summary is basically: false positive with additional annotations needed?

Precisely.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
