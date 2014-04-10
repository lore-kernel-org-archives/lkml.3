Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789AbaDJIM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:12:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36184 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934320AbaDJIMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:12:24 -0400
Date: Thu, 10 Apr 2014 10:12:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        jason.low2@hp.com, linux-kernel@vger.kernel.org
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
Message-ID: <20140410081212.GI10526@twins.programming.kicks-ass.net>
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409121940.GA12890@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 03:19:40PM +0300, Kirill A. Shutemov wrote:
> I have troble with the commit as well:

How so? As far as I can tell the below is a genuine bug and not related
to the mutex debug thing.

> [   26.745741] 
> [   26.747484] ======================================================
> [   26.748725] [ INFO: possible circular locking dependency detected ]
> [   26.748725] 3.13.0-11331-g6f008e72cd11 #1162 Not tainted
> [   26.748725] -------------------------------------------------------
> [   26.748725] trinity-c5/848 is trying to acquire lock:
> [   26.748725]  (&p->lock){+.+.+.}, at: [<ffffffff811774a8>] seq_read+0x38/0x3c0
> [   26.748725] 
> [   26.748725] but task is already holding lock:
> [   26.748725]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff811579db>] prepare_bprm_creds+0x2b/0x80
> [   26.748725] 
> [   26.748725] which lock already depends on the new lock.
> [   26.748725] 
> [   26.748725] 
> [   26.748725] the existing dependency chain (in reverse order) is:
> [   26.748725] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
> [   26.748725]        [<ffffffff810998d8>] __lock_acquire+0x3a8/0xc20
> [   26.748725]        [<ffffffff8109a1c6>] lock_acquire+0x76/0xc0
> [   26.748725]        [<ffffffff8173634d>] mutex_lock_killable_nested+0x6d/0x460
> [   26.748725]        [<ffffffff81049924>] mm_access+0x24/0xb0
> [   26.748725]        [<ffffffff811b6307>] m_start+0x67/0x1e0
> [   26.748725]        [<ffffffff811775a0>] seq_read+0x130/0x3c0
> [   26.748725]        [<ffffffff8114ffaa>] do_loop_readv_writev+0x5a/0x80
> [   26.748725]        [<ffffffff81150c4d>] compat_do_readv_writev+0x20d/0x220
> [   26.748725]        [<ffffffff81150c92>] compat_readv+0x32/0x70
> [   26.748725]        [<ffffffff81151c07>] compat_SyS_readv+0x47/0xa0
> [   26.748725]        [<ffffffff81742179>] ia32_sysret+0x0/0x5
> [   26.748725] -> #0 (&p->lock){+.+.+.}:
> [   26.780481]        [<ffffffff81097a4a>] validate_chain.isra.37+0x105a/0x10d0
> [   26.780481]        [<ffffffff810998d8>] __lock_acquire+0x3a8/0xc20
> [   26.780481]        [<ffffffff8109a1c6>] lock_acquire+0x76/0xc0
> [   26.780481]        [<ffffffff81735bad>] mutex_lock_nested+0x6d/0x3d0
> [   26.780481]        [<ffffffff811774a8>] seq_read+0x38/0x3c0
> [   26.780481]        [<ffffffff811b7af8>] proc_reg_read+0x38/0x70
> [   26.780481]        [<ffffffff81150799>] vfs_read+0x99/0x160
> [   26.780481]        [<ffffffff8115635c>] kernel_read+0x3c/0x50
> [   26.780481]        [<ffffffff811565e7>] prepare_binprm+0x137/0x1d0
> [   26.780481]        [<ffffffff81157f82>] do_execve_common.isra.34+0x4d2/0x730
> [   26.780481]        [<ffffffff81158461>] SyS_execve+0x31/0x50
> [   26.780481]        [<ffffffff81741099>] stub_execve+0x69/0xa0
> [   26.780481] 
> [   26.780481] other info that might help us debug this:
> [   26.780481] 
> [   26.780481]  Possible unsafe locking scenario:
> [   26.780481] 
> [   26.780481]        CPU0                    CPU1
> [   26.780481]        ----                    ----
> [   26.780481]   lock(&sig->cred_guard_mutex);
> [   26.780481]                                lock(&p->lock);
> [   26.780481]                                lock(&sig->cred_guard_mutex);
> [   26.780481]   lock(&p->lock);
> [   26.780481] 
> [   26.780481]  *** DEADLOCK ***
> [   26.780481] 
> [   26.780481] 1 lock held by trinity-c5/848:
> [   26.780481]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff811579db>] prepare_bprm_creds+0x2b/0x80
> [   26.780481] 
> [   26.780481] stack backtrace:
> [   26.780481] CPU: 5 PID: 848 Comm: trinity-c5 Not tainted 3.13.0-11331-g6f008e72cd11 #1162
> [   26.780481] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Bochs 01/01/2011
> [   26.780481]  ffffffff824f1130 ffff8803b6973b58 ffffffff8172fc76 ffffffff824f1130
> [   26.780481]  ffff8803b6973b98 ffffffff8172b6de ffff8803b6973bd0 ffff8803b72550e0
> [   26.780481]  ffff8803b72550e0 0000000000000000 ffff8803b72549d0 0000000000000001
> [   26.780481] Call Trace:
> [   26.780481]  [<ffffffff8172fc76>] dump_stack+0x4d/0x66
> [   26.780481]  [<ffffffff8172b6de>] print_circular_bug+0x201/0x20f
> [   26.780481]  [<ffffffff81097a4a>] validate_chain.isra.37+0x105a/0x10d0
> [   26.780481]  [<ffffffff810998d8>] __lock_acquire+0x3a8/0xc20
> [   26.780481]  [<ffffffff8109a1c6>] lock_acquire+0x76/0xc0
> [   26.780481]  [<ffffffff811774a8>] ? seq_read+0x38/0x3c0
> [   26.780481]  [<ffffffff81735bad>] mutex_lock_nested+0x6d/0x3d0
> [   26.780481]  [<ffffffff811774a8>] ? seq_read+0x38/0x3c0
> [   26.780481]  [<ffffffff811774a8>] ? seq_read+0x38/0x3c0
> [   26.780481]  [<ffffffff81082e18>] ? sched_clock_cpu+0xa8/0xd0
> [   26.780481]  [<ffffffff811774a8>] seq_read+0x38/0x3c0
> [   26.780481]  [<ffffffff811b7af8>] proc_reg_read+0x38/0x70
> [   26.780481]  [<ffffffff81167b9e>] ? dput+0x1e/0x110
> [   26.780481]  [<ffffffff81150799>] vfs_read+0x99/0x160
> [   26.780481]  [<ffffffff8115635c>] kernel_read+0x3c/0x50
> [   26.780481]  [<ffffffff811565e7>] prepare_binprm+0x137/0x1d0
> [   26.780481]  [<ffffffff81157f82>] do_execve_common.isra.34+0x4d2/0x730
> [   26.780481]  [<ffffffff81157ba9>] ? do_execve_common.isra.34+0xf9/0x730
> [   26.780481]  [<ffffffff8115c100>] ? mountpoint_last+0x1a0/0x1b0
> [   26.780481]  [<ffffffff81158461>] SyS_execve+0x31/0x50
> [   26.780481]  [<ffffffff81741099>] stub_execve+0x69/0xa0
