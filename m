Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965517AbaCSP2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:28:38 -0400
Received: from hygieia.santi-shop.eu ([78.46.175.2]:42976 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965001AbaCSP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:28:37 -0400
Date: Wed, 19 Mar 2014 16:28:32 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Nicolas Pitre <nico@fluxnic.net>, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: mvsdio: unhandled interrupt, mmc writes queuing up
Message-ID: <20140319162832.1f5caae0@neptune.home>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since upgrading my Sheevaplug from 3.7.2 to 3.13.6 (FDT) I'm seeing
  mvsdio f1090000.mvsdio: unhandled interrupt status=0x8810 en=0x0000 pio=0
at varied timings.


In addition to that, kernel seems excessively busy doing writeback via
workqueue (without success?):
[14909.275124] kworker/u2:2    R running      0  2001      2 0x00000000
[14909.275137] Workqueue: writeback bdi_writeback_workfn (flush-179:0)
[14909.275157] [<c0351df8>] (__schedule+0x180/0x38c) from [<c0034a24>] (__cond_resched+0x24/0x34)
[14909.275172] [<c0034a24>] (__cond_resched+0x24/0x34) from [<c0034a70>] (__cond_resched_lock+0x3c/0x44)
[14909.275187] [<c0034a70>] (__cond_resched_lock+0x3c/0x44) from [<c00b8a2c>] (writeback_sb_inodes+0x2b0/0x348)
[14909.275201] [<c00b8a2c>] (writeback_sb_inodes+0x2b0/0x348) from [<c00b8b34>] (__writeback_inodes_wb+0x70/0xac)
[14909.275214] [<c00b8b34>] (__writeback_inodes_wb+0x70/0xac) from [<c00b8cf0>] (wb_writeback+0x180/0x190)
[14909.275228] [<c00b8cf0>] (wb_writeback+0x180/0x190) from [<c00b91c0>] (bdi_writeback_workfn+0x144/0x324)
[14909.275243] [<c00b91c0>] (bdi_writeback_workfn+0x144/0x324) from [<c00286b8>] (process_one_work+0x104/0x358)
[14909.275258] [<c00286b8>] (process_one_work+0x104/0x358) from [<c0028ce8>] (worker_thread+0x134/0x38c)
[14909.275273] [<c0028ce8>] (worker_thread+0x134/0x38c) from [<c002dec4>] (kthread+0xb0/0xcc)
[14909.275287] [<c002dec4>] (kthread+0xb0/0xcc) from [<c0009490>] (ret_from_fork+0x14/0x24)
(eating about 50% CPU time with variations between 10% and 90%)

Dirty pages accumulate and calls to `sync` do not write those back
to storage.


Any idea what it could be and how to fix it?

I get same results with 3.14-rc7.

Bruno
