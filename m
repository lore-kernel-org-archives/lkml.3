Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3AOSlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:41:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab3AOSli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:41:38 -0500
Date: Tue, 15 Jan 2013 19:41:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Clayton <andrew@digital-domain.net>
Cc: Rik van Riel <riel@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: qemu-kvm hangs at start up under 3.8.0-rc3-00074-gb719f43 (works
 with CONFIG_LOCKDEP)
In-Reply-To: <20130115171756.36566374@zeus.pccl.info>
Message-ID: <alpine.LNX.2.00.1301151939400.14538@pobox.suse.cz>
References: <20130113222958.64840242@omega.digital-domain.net> <20130114132736.GA12489@redhat.com> <20130114182449.5a163101@omega.digital-domain.net> <50F58867.6010507@redhat.com> <20130115171756.36566374@zeus.pccl.info>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Andrew Clayton wrote:

> > > bash            S ffff88013b2b0d00     0  3203   3133 0x00000000
> > >   ffff880114dabe58 0000000000000082 8000000113558065
> > > ffff880114dabfd8 ffff880114dabfd8 0000000000004000 ffff88013b0c5b00
> > > ffff88013b2b0d00 ffff880114dabd88 ffffffff8109067d ffffea0004536670
> > > ffffea0004536640 Call Trace:
> > >   [<ffffffff8109067d>] ? default_wake_function+0xd/0x10
> > >   [<ffffffff8108a315>] ? atomic_notifier_call_chain+0x15/0x20
> > >   [<ffffffff8133d84f>] ? tty_get_pgrp+0x3f/0x50
> > >   [<ffffffff810819ac>] ? pid_vnr+0x2c/0x30
> > >   [<ffffffff8133fe54>] ? tty_ioctl+0x7b4/0xbd0
> > >   [<ffffffff8106bf62>] ? wait_consider_task+0x102/0xaf0
> > >   [<ffffffff815c00e4>] schedule+0x24/0x70
> > >   [<ffffffff8106cb24>] do_wait+0x1d4/0x200
> > >   [<ffffffff8106d9cb>] sys_wait4+0x9b/0xf0
> > >   [<ffffffff8106b9f0>] ? task_stopped_code+0x50/0x50
> > >   [<ffffffff815c1ad2>] system_call_fastpath+0x16/0x1b
> > >
> > > qemu-kvm        D ffff88011ab8c8b8     0  3345   3203 0x00000000
> > >   ffff880112129cd8 0000000000000082 ffff880112129c50
> > > ffff880112129fd8 ffff880112129fd8 0000000000004000 ffff88013b04ce00
> > > ffff880139da1a00 0000000000000000 00000000000280da ffff880112129d38
> > > ffffffff810d3300 Call Trace:
> > >   [<ffffffff810d3300>] ? __alloc_pages_nodemask+0xf0/0x7c0
> > >   [<ffffffff811273c6>] ? touch_atime+0x66/0x170
> > >   [<ffffffff810cdabf>] ? generic_file_aio_read+0x5bf/0x730
> > >   [<ffffffff815c00e4>] schedule+0x24/0x70
> > >   [<ffffffff815c0cdd>] rwsem_down_failed_common+0xbd/0x150
> > >   [<ffffffff815c0da3>] rwsem_down_write_failed+0x13/0x15
> > >   [<ffffffff812d1be3>] call_rwsem_down_write_failed+0x13/0x20
> > >   [<ffffffff815bf4dd>] ? down_write+0x2d/0x34
> > >   [<ffffffff810f0724>] vma_adjust+0xe4/0x610
> > >   [<ffffffff810f0fa4>] vma_merge+0x1b4/0x270
> > >   [<ffffffff810f1fa6>] do_brk+0x196/0x330
> > >   [<ffffffff810f2217>] sys_brk+0xd7/0x130
> > >   [<ffffffff815c1ad2>] system_call_fastpath+0x16/0x1b
> > 
> > This looks like qemu-kvm getting stuck trying to get the anon_vma
> > lock.
> > 
> > That leads to the obvious question: what is holding the lock, and/or
> > failed to release it?
> > 
> > Do you have any other (qemu-kvm?) processes on your system that have
> > any code in the VM (or strace/ptrace/...) in the backtrace, that might
> > be holding this lock?
> 
> I don't think so. The above was done having just logged into
> gnome-shell and opened up a couple of gnome-terminals.
>  
> > Do you have anything in your dmesg showing threads that had a BUG_ON
> > (and exited) while holding the lock?
> 
> I never noticed anything like that.
> 
> The interesting thing is that if I use basically the same kernel but
> with CONFIG_LOCKDEP enabled, it works fine.

Thorough and careful review and analysis revealed that the rootcause very 
likely is that I am a complete nitwit.

Could you please try the patch below and report backt? Thanks.



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] lockdep, rwsem: fix down_write_nest_lock() if !CONFIG_DEBUG_LOCK_ALLOC

Commit 1b963c81b1 ("lockdep, rwsem: provide down_write_nest_lock()") 
contains a bug in a codepath when CONFIG_DEBUG_LOCK_ALLOC is disabled, 
which causes down_read() to be called instead of down_write() by mistake 
on such configurations. Fix that.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 include/linux/rwsem.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 413cc11..8da67d6 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -135,7 +135,7 @@ do {								\
 
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
-# define down_write_nest_lock(sem, nest_lock)	down_read(sem)
+# define down_write_nest_lock(sem, nest_lock)	down_write(sem)
 # define down_write_nested(sem, subclass)	down_write(sem)
 #endif
 
-- 
Jiri Kosina
SUSE Labs
