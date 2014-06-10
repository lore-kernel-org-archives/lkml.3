Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaFJWiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:38:04 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:33243 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFJWiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:38:01 -0400
MIME-Version: 1.0
Date: Tue, 10 Jun 2014 15:38:00 -0700
X-Google-Sender-Auth: olax74zQSogzggnyChxgP0nlLDc
Message-ID: <CAD=FV=VX6QqL+jdEwk8Mp53FHBqj2v=w65zqBcbYWTtPZPmMVQ@mail.gmail.com>
Subject: CONFIG_PREMPT vs. linux-next causes slub_debug=FZPUA errors
From: Doug Anderson <dianders@chromium.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently, both Andrew Bresticker (CCed) and I have noticed errors
reported by slub_debug when using linuxnext.  I'm still seeing them on
20140606.


NOTES:
* errors only seem to be present when you've got CONFIG_PREMPT enabled.

* errors seem to happen most often when rebooting, but I've seen them
during other times as well.

* a quick guesstimate is that ~50% of my reboots show this problem.

* I'm testing on an exynos5250-based board and Andrew on an ARM board
with a different SoC.

* I don't see issues on a current fetch of "linux", AKA (5b174fd Merge
branch 'for-3.16' of git://linux-nfs.org/~bfields/linux)


I didn't do a full bisect, but I don't seem to see issues on 20140528.
On 20140530 I see almost constant slub errors (seems much worse than
20140606)

An example error is below:


[   13.521842] =============================================================================
[   13.528566] BUG bio-1 (Not tainted): Poison overwritten
[   13.533765] -----------------------------------------------------------------------------
[   13.533765]
[   13.543394] Disabling lock debugging due to kernel taint
[   13.548685] INFO: 0xec495848-0xec49584f. First byte 0x80 instead of 0x6b
[   13.555378] INFO: Allocated in mempool_alloc_slab+0x24/0x28 age=28
cpu=5 pid=220
[   13.562741]  kmem_cache_alloc+0x90/0x1d0
[   13.566640]  mempool_alloc_slab+0x24/0x28
[   13.570631]  mempool_alloc+0x4c/0x144
[   13.574279]  bio_alloc_bioset+0xa4/0x1b0
[   13.578182]  __split_and_process_bio+0x33c/0x3f0
[   13.582778]  dm_request+0x1f0/0x204
[   13.586248]  generic_make_request+0xa4/0xdc
[   13.590411]  submit_bio+0x114/0x144
[   13.593882]  _submit_bh+0x22c/0x250
[   13.597351]  submit_bh+0x1c/0x20
[   13.600566]  jbd2_journal_commit_transaction+0xb24/0x1778
[   13.605940]  kjournald2+0xc0/0x264
[   13.609325]  kthread+0xf8/0x10c
[   13.612447]  ret_from_fork+0x14/0x20
[   13.616006] INFO: Freed in mempool_free_slab+0x24/0x28 age=40 cpu=1 pid=196
[   13.622944]  kmem_cache_free+0x1a4/0x234
[   13.626845]  mempool_free_slab+0x24/0x28
[   13.630748]  mempool_free+0x98/0x9c
[   13.634220]  bio_put+0x8c/0x98
[   13.637259]  clone_endio+0xd0/0xec
[   13.640640]  bio_endio+0xc0/0xcc
[   13.643852]  crypt_end_io+0x50/0x54
[   13.647320]  crypt_endio+0xb8/0xc0
[   13.650703]  bio_endio+0xc0/0xcc
[   13.653914]  loop_thread+0x61c/0x660
[   13.657470]  kthread+0xf8/0x10c
[   13.660592]  ret_from_fork+0x14/0x20
[   13.664150] INFO: Slab 0xef57c200 objects=39 used=0 fp=0xec490000
flags=0x4080
[   13.671347] INFO: Object 0xec4957c0 @offset=22464 fp=0x  (null)
[   13.671347]
[   13.678726] Bytes b4 ec4957b0: c4 00 00 00 eb 1e ff ff 5a 5a 5a 5a
5a 5a 5a 5a  ........ZZZZZZZZ
[   13.687484] Object ec4957c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.696072] Object ec4957d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.704660] Object ec4957e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.713249] Object ec4957f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.721837] Object ec495800: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.730425] Object ec495810: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.739013] Object ec495820: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.747601] Object ec495830: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.756190] Object ec495840: 6b 6b 6b 6b 6b 6b 6b 6b 80 15 00 00 00
00 00 00  kkkkkkkk........
[   13.764778] Object ec495850: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.773366] Object ec495860: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.781954] Object ec495870: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.790543] Object ec495880: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.799131] Object ec495890: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.807719] Object ec4958a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.816307] Object ec4958b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.824896] Object ec4958c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.833484] Object ec4958d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.842072] Object ec4958e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.850660] Object ec4958f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.859248] Object ec495900: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.867837] Object ec495910: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.876425] Object ec495920: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.885014] Object ec495930: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.893602] Object ec495940: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.902190] Object ec495950: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.910778] Object ec495960: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.919366] Object ec495970: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.927954] Object ec495980: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.936543] Object ec495990: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.945131] Object ec4959a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.953719] Object ec4959b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.962308] Object ec4959c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.970896] Object ec4959d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.979484] Object ec4959e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.988072] Object ec4959f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   13.996661] Object ec495a00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   14.005249] Object ec495a10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   14.013837] Object ec495a20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   14.022425] Object ec495a30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   14.031014] Object ec495a40: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b a5  kkkkkkkkkkkkkkk.
[   14.039602] Redzone ec495a50: bb bb bb bb
           ....
[   14.047244] Padding ec495af8: 5a 5a 5a 5a 5a 5a 5a 5a
           ZZZZZZZZ
[   14.055222] CPU: 4 PID: 1072 Comm: dmsetup Tainted: G    B
3.15.0-rc8-next-20140606-00004-g73d55cf #113
[   14.065300] [<80015c2c>] (unwind_backtrace) from [<80012378>]
(show_stack+0x20/0x24)
[   14.073015] [<80012378>] (show_stack) from [<804f3ca4>]
(dump_stack+0x78/0xc4)
[   14.080213] [<804f3ca4>] (dump_stack) from [<80109b6c>]
(print_trailer+0x11c/0x13c)
[   14.087849] [<80109b6c>] (print_trailer) from [<80109c2c>]
(check_bytes_and_report+0xa0/0x100)
[   14.096436] [<80109c2c>] (check_bytes_and_report) from [<80109dc0>]
(check_object+0x134/0x234)
[   14.105024] [<80109dc0>] (check_object) from [<80109fd0>]
(__free_slab+0x110/0x124)
[   14.112658] [<80109fd0>] (__free_slab) from [<8010a060>]
(discard_slab+0x7c/0x84)
[   14.120120] [<8010a060>] (discard_slab) from [<8010d308>]
(free_partial+0x94/0x24c)
[   14.127754] [<8010d308>] (free_partial) from [<8010d4ec>]
(__kmem_cache_shutdown+0x2c/0x68)
[   14.136084] [<8010d4ec>] (__kmem_cache_shutdown) from [<800edec4>]
(kmem_cache_destroy+0x40/0xc0)
[   14.144931] [<800edec4>] (kmem_cache_destroy) from [<80224d58>]
(bioset_free+0xd4/0xfc)
[   14.152912] [<80224d58>] (bioset_free) from [<80386a24>]
(__dm_destroy+0x144/0x1c4)
[   14.160545] [<80386a24>] (__dm_destroy) from [<8038797c>]
(dm_destroy+0x1c/0x20)
[   14.167917] [<8038797c>] (dm_destroy) from [<8038d318>]
(dev_remove+0x104/0x110)
[   14.175289] [<8038d318>] (dev_remove) from [<8038c030>]
(ctl_ioctl+0x3ec/0x4a4)
[   14.182575] [<8038c030>] (ctl_ioctl) from [<8038c108>]
(dm_ctl_ioctl+0x20/0x24)
[   14.189865] [<8038c108>] (dm_ctl_ioctl) from [<801209ec>]
(do_vfs_ioctl+0x4e4/0x5a0)
[   14.197585] [<801209ec>] (do_vfs_ioctl) from [<80120b04>]
(SyS_ioctl+0x5c/0x84)
[   14.204873] [<80120b04>] (SyS_ioctl) from [<8000e500>]
(ret_fast_syscall+0x0/0x30)
[   14.212411] FIX bio-1: Restoring 0xec495848-0xec49584f=0x6b
[   14.212411]
[   14.975183] reboot: Res
