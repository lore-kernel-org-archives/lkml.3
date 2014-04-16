Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaDPSEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:04:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbaDPSEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:04:32 -0400
Date: Wed, 16 Apr 2014 14:04:22 -0400
From: Dave Jones <davej@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: rw_copy_check_uvector() - free iov on error
Message-ID: <20140416180422.GA20907@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20140415145749.GF10187@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415145749.GF10187@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 04:57:49PM +0200, Miklos Szeredi wrote:

 > Some callers (aio_run_iocb, vmsplice_to_user) forget to free the iov on
 > error.  This seems to be a recurring problem, with most callers being buggy
 > initially.

Your patch looks a lot more complete than the quick hack I did a few
days ago when coverity first started nagging about this, but in testing
I've found that something really ugly starts showing up when you patch this

The symptoms vary, but always are some kind of slab corruption.
Here's the last example:

=============================================================================
BUG kmalloc-256 (Not tainted): Invalid object pointer 0xffff8802407adc60
-----------------------------------------------------------------------------

Disabling lock debugging due to kernel taint
INFO: Slab 0xffffea000901eb00 objects=28 used=22 fp=0xffff8802407ad6d0 flags=0x20000000004081
CPU: 1 PID: 1185 Comm: trinity-c1 Tainted: G    B         3.15.0-rc1+ #191
 ffff880243c073c0 00000000f952f249 ffff8800a1a2bc10 ffffffffbd74686d
 ffffea000901eb00 ffff8800a1a2bce8 ffffffffbd1b0cd4 ffffffff00000020
 ffff8800a1a2bcf8 ffff8800a1a2bca8 61766e4943c00a18 656a626f2064696c
Call Trace:
 [<ffffffffbd74686d>] dump_stack+0x4e/0x7a
 [<ffffffffbd1b0cd4>] slab_err+0xb4/0xe0
 [<ffffffffbd0bf3ae>] ? put_lock_stats.isra.23+0xe/0x30
 [<ffffffffbd1b0da6>] ? slab_pad_check.part.44+0xa6/0x170
 [<ffffffffbd744e7f>] free_debug_processing+0x88/0x22a
 [<ffffffffbd1c7041>] ? compat_do_readv_writev+0xe1/0x250
 [<ffffffffbd74506d>] __slab_free+0x4c/0x2c3
 [<ffffffffbd1c6679>] ? do_sync_readv_writev+0x59/0xa0
 [<ffffffffbd1b2614>] kfree+0x214/0x220
 [<ffffffffbd1c7041>] ? compat_do_readv_writev+0xe1/0x250
 [<ffffffffbd1c7041>] compat_do_readv_writev+0xe1/0x250
 [<ffffffffbd0bf716>] ? lock_release_holdtime.part.24+0xe6/0x160
 [<ffffffffbd0a3ccd>] ? get_parent_ip+0xd/0x50
 [<ffffffffbd75642b>] ? preempt_count_sub+0x6b/0xf0
 [<ffffffffbd751a01>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffffbd349883>] ? __this_cpu_preempt_check+0x13/0x20
 [<ffffffffbd1c730a>] compat_writev+0x3a/0x80
 [<ffffffffbd1c85d8>] compat_SyS_writev+0x58/0xd0
 [<ffffffffbd75c6a9>] ia32_do_call+0x13/0x13
FIX kmalloc-256: Object at 0xffff8802407adc60 not freed


I also had an incomplete trace that showed vmsplice causing a bug in mm/slub.c:3396
on an earlier run.

The crash happens very quickly (within a few seconds of running trinity) for me.

	Dave

