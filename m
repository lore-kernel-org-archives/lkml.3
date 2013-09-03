Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336Ab3ICQe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:34:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46533 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab3ICQ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:27:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Peschke <mpeschke@linux.vnet.ibm.com>,
        Steffen Maier <maier@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 55/58] [SCSI] zfcp: fix schedule-inside-lock in scsi_device list loops
Date: Tue,  3 Sep 2013 09:23:59 -0700
Message-Id: <1378225442-20654-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

commit 924dd584b198a58aa7cb3efefd8a03326550ce8f upstream.

BUG: sleeping function called from invalid context at kernel/workqueue.c:2752
in_atomic(): 1, irqs_disabled(): 1, pid: 360, name: zfcperp0.0.1700
CPU: 1 Not tainted 3.9.3+ #69
Process zfcperp0.0.1700 (pid: 360, task: 0000000075b7e080, ksp: 000000007476bc30)
<snip>
Call Trace:
([<00000000001165de>] show_trace+0x106/0x154)
 [<00000000001166a0>] show_stack+0x74/0xf4
 [<00000000006ff646>] dump_stack+0xc6/0xd4
 [<000000000017f3a0>] __might_sleep+0x128/0x148
 [<000000000015ece8>] flush_work+0x54/0x1f8
 [<00000000001630de>] __cancel_work_timer+0xc6/0x128
 [<00000000005067ac>] scsi_device_dev_release_usercontext+0x164/0x23c
 [<0000000000161816>] execute_in_process_context+0x96/0xa8
 [<00000000004d33d8>] device_release+0x60/0xc0
 [<000000000048af48>] kobject_release+0xa8/0x1c4
 [<00000000004f4bf2>] __scsi_iterate_devices+0xfa/0x130
 [<000003ff801b307a>] zfcp_erp_strategy+0x4da/0x1014 [zfcp]
 [<000003ff801b3caa>] zfcp_erp_thread+0xf6/0x2b0 [zfcp]
 [<000000000016b75a>] kthread+0xf2/0xfc
 [<000000000070c9de>] kernel_thread_starter+0x6/0xc
 [<000000000070c9d8>] kernel_thread_starter+0x0/0xc

Apparently, the ref_count for some scsi_device drops down to zero,
triggering device removal through execute_in_process_context(), while
the lldd error recovery thread iterates through a scsi device list.
Unfortunately, execute_in_process_context() decides to immediately
execute that device removal function, instead of scheduling asynchronous
execution, since it detects process context and thinks it is safe to do
so. But almost all calls to shost_for_each_device() in our lldd are
inside spin_lock_irq, even in thread context. Obviously, schedule()
inside spin_lock_irq sections is a bad idea.

Change the lldd to use the proper iterator function,
__shost_for_each_device(), in combination with required locking.

Occurences that need to be changed include all calls in zfcp_erp.c,
since those might be executed in zfcp error recovery thread context
with a lock held.

Other occurences of shost_for_each_device() in zfcp_fsf.c do not
need to be changed (no process context, no surrounding locking).

The problem was introduced in Linux 2.6.37 by commit
b62a8d9b45b971a67a0f8413338c230e3117dff5
"[SCSI] zfcp: Use SCSI device data zfcp_scsi_dev instead of zfcp_unit".

Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/s390/scsi/zfcp_erp.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 4133ab6..8e8f353 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -102,10 +102,13 @@ static void zfcp_erp_action_dismiss_port(struct zfcp_port *port)
 
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
 		zfcp_erp_action_dismiss(&port->erp_action);
-	else
-		shost_for_each_device(sdev, port->adapter->scsi_host)
+	else {
+		spin_lock(port->adapter->scsi_host->host_lock);
+		__shost_for_each_device(sdev, port->adapter->scsi_host)
 			if (sdev_to_zfcp(sdev)->port == port)
 				zfcp_erp_action_dismiss_lun(sdev);
+		spin_unlock(port->adapter->scsi_host->host_lock);
+	}
 }
 
 static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
@@ -592,9 +595,11 @@ static void _zfcp_erp_lun_reopen_all(struct zfcp_port *port, int clear,
 {
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock(port->adapter->scsi_host->host_lock);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
 			_zfcp_erp_lun_reopen(sdev, clear, id, 0);
+	spin_unlock(port->adapter->scsi_host->host_lock);
 }
 
 static void zfcp_erp_strategy_followup_failed(struct zfcp_erp_action *act)
@@ -1435,8 +1440,10 @@ void zfcp_erp_set_adapter_status(struct zfcp_adapter *adapter, u32 mask)
 		atomic_set_mask(common_mask, &port->status);
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	shost_for_each_device(sdev, adapter->scsi_host)
+	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, adapter->scsi_host)
 		atomic_set_mask(common_mask, &sdev_to_zfcp(sdev)->status);
+	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1470,11 +1477,13 @@ void zfcp_erp_clear_adapter_status(struct zfcp_adapter *adapter, u32 mask)
 	}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	shost_for_each_device(sdev, adapter->scsi_host) {
+	spin_lock_irqsave(adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, adapter->scsi_host) {
 		atomic_clear_mask(common_mask, &sdev_to_zfcp(sdev)->status);
 		if (clear_counter)
 			atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
 	}
+	spin_unlock_irqrestore(adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1488,16 +1497,19 @@ void zfcp_erp_set_port_status(struct zfcp_port *port, u32 mask)
 {
 	struct scsi_device *sdev;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
+	unsigned long flags;
 
 	atomic_set_mask(mask, &port->status);
 
 	if (!common_mask)
 		return;
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
 			atomic_set_mask(common_mask,
 					&sdev_to_zfcp(sdev)->status);
+	spin_unlock_irqrestore(port->adapter->scsi_host->host_lock, flags);
 }
 
 /**
@@ -1512,6 +1524,7 @@ void zfcp_erp_clear_port_status(struct zfcp_port *port, u32 mask)
 	struct scsi_device *sdev;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 	u32 clear_counter = mask & ZFCP_STATUS_COMMON_ERP_FAILED;
+	unsigned long flags;
 
 	atomic_clear_mask(mask, &port->status);
 
@@ -1521,13 +1534,15 @@ void zfcp_erp_clear_port_status(struct zfcp_port *port, u32 mask)
 	if (clear_counter)
 		atomic_set(&port->erp_counter, 0);
 
-	shost_for_each_device(sdev, port->adapter->scsi_host)
+	spin_lock_irqsave(port->adapter->scsi_host->host_lock, flags);
+	__shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port) {
 			atomic_clear_mask(common_mask,
 					  &sdev_to_zfcp(sdev)->status);
 			if (clear_counter)
 				atomic_set(&sdev_to_zfcp(sdev)->erp_counter, 0);
 		}
+	spin_unlock_irqrestore(port->adapter->scsi_host->host_lock, flags);
 }
 
 /**
-- 
1.8.1.2

