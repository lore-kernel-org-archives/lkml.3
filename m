Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaCEOiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:38:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41750 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457AbaCEOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michele Baldessari <michele@acksyn.org>,
        Aaron Brown <aaron.f.brown@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 42/62] e100: Fix "disabling already-disabled device" warning
Date: Wed,  5 Mar 2014 14:36:46 +0000
Message-Id: <1394030226-26652-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michele Baldessari <michele@acksyn.org>

commit 2b6e0ca175fe4a20f21ba82b1e7ccc71029c4dd4 upstream.

In https://bugzilla.redhat.com/show_bug.cgi?id=994438 and
https://bugzilla.redhat.com/show_bug.cgi?id=970480  we
received different reports of e100 throwing the following
warning:

 [<c06a0ba5>] ? pci_disable_device+0x85/0x90
 [<c044a153>] warn_slowpath_fmt+0x33/0x40
 [<c06a0ba5>] pci_disable_device+0x85/0x90
 [<f7fdf7e0>] __e100_shutdown+0x80/0x120 [e100]
 [<c0476ca5>] ? check_preempt_curr+0x65/0x90
 [<f7fdf8d6>] e100_suspend+0x16/0x30 [e100]
 [<c06a1ebb>] pci_legacy_suspend+0x2b/0xb0
 [<c098fc0f>] ? wait_for_completion+0x1f/0xd0
 [<c06a2d50>] ? pci_pm_poweroff+0xb0/0xb0
 [<c06a2de4>] pci_pm_freeze+0x94/0xa0
 [<c0767bb7>] dpm_run_callback+0x37/0x80
 [<c076a204>] ? pm_wakeup_pending+0xc4/0x140
 [<c0767f12>] __device_suspend+0xb2/0x1f0
 [<c076806f>] async_suspend+0x1f/0x90
 [<c04706e5>] async_run_entry_fn+0x35/0x140
 [<c0478aef>] ? wake_up_process+0x1f/0x40
 [<c0464495>] process_one_work+0x115/0x370
 [<c0462645>] ? start_worker+0x25/0x30
 [<c0464dc5>] ? manage_workers.isra.27+0x1a5/0x250
 [<c0464f6e>] worker_thread+0xfe/0x330
 [<c0464e70>] ? manage_workers.isra.27+0x250/0x250
 [<c046a224>] kthread+0x94/0xa0
 [<c0997f37>] ret_from_kernel_thread+0x1b/0x28
 [<c046a190>] ? insert_kthread_work+0x30/0x30

This patch removes pci_disable_device() from __e100_shutdown().
pci_clear_master() is enough.

Signed-off-by: Michele Baldessari <michele@acksyn.org>
Tested-by: Mark Harig <idirectscm@aim.com>
Signed-off-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/intel/e100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index ada720b..5107b12 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -3005,7 +3005,7 @@ static void __e100_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		*enable_wake = false;
 	}
 
-	pci_disable_device(pdev);
+	pci_clear_master(pdev);
 }
 
 static int __e100_power_off(struct pci_dev *pdev, bool wake)
-- 
1.9.0

