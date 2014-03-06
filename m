Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaCFTvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:51:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaCFTvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:51:17 -0500
Date: Thu, 6 Mar 2014 14:51:06 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Bad page map during process exit. (ext4_file_mmap)
Message-ID: <20140306195106.GA9470@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hit this while building a kernel on 3.14rc5

[60602.562954] BUG: Bad page map in process systemd-udevd  pte:ffff88005d47e270 pmd:148048067
[60602.563792] addr:00007fcf338e8000 vm_flags:08000070 anon_vma:          (null) mapping:ffff88009f2622f0 index:12c
[60602.564613] vma->vm_ops->fault: filemap_fault+0x0/0x420
[60602.565426] vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x70
[60602.566245] CPU: 1 PID: 7946 Comm: systemd-udevd Not tainted 3.14.0-rc5+ #130 
[60602.567939]  ffff8801a5915200 0000000001ae188a ffff880199503c78 ffffffffa672edd8
[60602.568783]  00007fcf338e8000 ffff880199503cc0 ffffffffa617cfb4 ffff88005d47e270
[60602.569626]  000000000000012c ffff880148048740 00007fcf33800000 ffff880199503df0
[60602.570486] Call Trace:
[60602.571358]  [<ffffffffa672edd8>] dump_stack+0x4e/0x7a
[60602.572244]  [<ffffffffa617cfb4>] print_bad_pte+0x184/0x230
[60602.573116]  [<ffffffffa617ea58>] unmap_single_vma+0x738/0x8a0
[60602.573974]  [<ffffffffa617fce9>] unmap_vmas+0x49/0x90
[60602.574815]  [<ffffffffa6189095>] exit_mmap+0xe5/0x1a0
[60602.575655]  [<ffffffffa6068d13>] mmput+0x73/0x110
[60602.576495]  [<ffffffffa606d022>] do_exit+0x2a2/0xb50
[60602.577340]  [<ffffffffa60aa0a1>] ? vtime_account_user+0x91/0xa0
[60602.578193]  [<ffffffffa615213b>] ? context_tracking_user_exit+0x9b/0x100
[60602.579067]  [<ffffffffa606e8cc>] do_group_exit+0x4c/0xc0
[60602.579939]  [<ffffffffa606e954>] SyS_exit_group+0x14/0x20
[60602.580818]  [<ffffffffa67429ea>] tracesys+0xd4/0xd9

It's possible that the damage had been done by an earlier fuzzing run, and we never
touched that memory until the kernel install caused us to trip over it.
Only seen this one once so far.

	Dave

