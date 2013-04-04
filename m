Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763399Ab3DDQuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:50:50 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:45244 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762941Ab3DDQus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:50:48 -0400
Date: Thu, 4 Apr 2013 09:50:42 -0700
From: Tejun Heo <tj@kernel.org>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: flushing uninitialized work item in radeon init failure path
Message-ID: <20130404165042.GO9425@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following happens on my test machine which has an on-board VGA
which is not connected.  The failure is expected but, in the failure
path, it calls radeon_irq_kms_fini() which flushes @rdev->*_work when
@rdev seemingly hasn't gone through radeon_irq_kms_init(), ending up
trying to flush uninitialized work items triggering the following
lockdep warning.  Well, at least, that's what I think is happening.

 [drm] Initialized drm 1.1.0 20060810
 [drm] radeon kernel modesetting enabled.
 radeon 0000:00:0c.0: enabling device (0080 -> 0083)
 [drm] initializing kernel modesetting (RV100 0x1002:0x515E 0x1002:0x515E).
 [drm] register mmio base: 0xFEBE0000
 [drm] register mmio size: 65536
 radeon 0000:00:0c.0: Invalid ROM contents
 radeon 0000:00:0c.0: Invalid ROM contents
 [drm:radeon_get_bios] *ERROR* Unable to locate a BIOS ROM
 radeon 0000:00:0c.0: Card not posted and no BIOS - ignoring
 radeon 0000:00:0c.0: Fatal error during GPU init
 [drm] radeon: finishing device.
 [TTM] Memory type 2 has not been initialized
 [drm] radeon: cp finalized
 INFO: trying to register non-static key.
 the code is fine but needs lockdep annotation.
 turning off the locking correctness validator.
 Pid: 50, comm: kworker/0:1 Not tainted 3.9.0-rc5-work+ #1
 Call Trace:
  [<ffffffff810f9830>] __lock_acquire+0x1840/0x1c50
  [<ffffffff810faba6>] ? mark_held_locks+0x86/0x110
  [<ffffffff81c678a0>] ? retint_restore_args+0xe/0xe
  [<ffffffff810fad45>] ? trace_hardirqs_on_caller+0x115/0x1a0
  [<ffffffff8143635e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff810fa255>] lock_acquire+0x95/0x1e0
  [<ffffffff810b3315>] ? flush_work+0x5/0x270
  [<ffffffff810b335c>] flush_work+0x4c/0x270
  [<ffffffff810b3315>] ? flush_work+0x5/0x270
  [<ffffffff81c59b7b>] ? printk+0x4d/0x4f
  [<ffffffff8155677f>] radeon_irq_kms_fini+0x2f/0x70
  [<ffffffff815604bf>] r100_fini+0x4f/0x90
  [<ffffffff81529362>] radeon_device_fini+0x42/0x100
  [<ffffffff8152abdc>] radeon_driver_unload_kms+0x3c/0x60
  [<ffffffff8152acbd>] radeon_driver_load_kms+0xbd/0x160
  [<ffffffff8150320e>] drm_get_pci_dev+0x17e/0x2a0
  [<ffffffff81527dfb>] radeon_pci_probe+0xab/0xd0
  [<ffffffff8144c863>] local_pci_probe+0x23/0x40
  [<ffffffff810b07e8>] work_for_cpu_fn+0x18/0x30
  [<ffffffff810b44f6>] process_one_work+0x1f6/0x670
  [<ffffffff810b448a>] ? process_one_work+0x18a/0x670
  [<ffffffff810b499c>] process_scheduled_works+0x2c/0x40
  [<ffffffff810b4eb2>] worker_thread+0x2b2/0x380
  [<ffffffff810b4c00>] ? rescuer_thread+0x250/0x250
  [<ffffffff810ba7ea>] kthread+0xea/0xf0
  [<ffffffff810ba700>] ? __init_kthread_worker+0x70/0x70
  [<ffffffff81c682dc>] ret_from_fork+0x7c/0xb0
  [<ffffffff810ba700>] ? __init_kthread_worker+0x70/0x70
 radeon: probe of 0000:00:0c.0 failed with error -22

Thanks.

-- 
tejun
