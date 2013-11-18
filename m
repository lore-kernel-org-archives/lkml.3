Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3KRTCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:02:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3KRSkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 04/25] virtio-net: correctly handle cpu hotplug notifier during resuming
Date: Mon, 18 Nov 2013 10:40:33 -0800
Message-Id: <20131118184033.368797849@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184032.248465920@linuxfoundation.org>
References: <20131118184032.248465920@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit ec9debbd9a88d8ea86c488d6ffcac419ee7d46d9 ]

commit 3ab098df35f8b98b6553edc2e40234af512ba877 (virtio-net: don't respond to
cpu hotplug notifier if we're not ready) tries to bypass the cpu hotplug
notifier by checking the config_enable and does nothing is it was false. So it
need to try to hold the config_lock mutex which may happen in atomic
environment which leads the following warnings:

[  622.944441] CPU0 attaching NULL sched-domain.
[  622.944446] CPU1 attaching NULL sched-domain.
[  622.944485] CPU0 attaching NULL sched-domain.
[  622.950795] BUG: sleeping function called from invalid context at kernel/mutex.c:616
[  622.950796] in_atomic(): 1, irqs_disabled(): 1, pid: 10, name: migration/1
[  622.950796] no locks held by migration/1/10.
[  622.950798] CPU: 1 PID: 10 Comm: migration/1 Not tainted 3.12.0-rc5-wl-01249-gb91e82d #317
[  622.950799] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  622.950802]  0000000000000000 ffff88001d42dba0 ffffffff81a32f22 ffff88001bfb9c70
[  622.950803]  ffff88001d42dbb0 ffffffff810edb02 ffff88001d42dc38 ffffffff81a396ed
[  622.950805]  0000000000000046 ffff88001d42dbe8 ffffffff810e861d 0000000000000000
[  622.950805] Call Trace:
[  622.950810]  [<ffffffff81a32f22>] dump_stack+0x54/0x74
[  622.950815]  [<ffffffff810edb02>] __might_sleep+0x112/0x114
[  622.950817]  [<ffffffff81a396ed>] mutex_lock_nested+0x3c/0x3c6
[  622.950818]  [<ffffffff810e861d>] ? up+0x39/0x3e
[  622.950821]  [<ffffffff8153ea7c>] ? acpi_os_signal_semaphore+0x21/0x2d
[  622.950824]  [<ffffffff81565ed1>] ? acpi_ut_release_mutex+0x5e/0x62
[  622.950828]  [<ffffffff816d04ec>] virtnet_cpu_callback+0x33/0x87
[  622.950830]  [<ffffffff81a42576>] notifier_call_chain+0x3c/0x5e
[  622.950832]  [<ffffffff810e86a8>] __raw_notifier_call_chain+0xe/0x10
[  622.950835]  [<ffffffff810c5556>] __cpu_notify+0x20/0x37
[  622.950836]  [<ffffffff810c5580>] cpu_notify+0x13/0x15
[  622.950838]  [<ffffffff81a237cd>] take_cpu_down+0x27/0x3a
[  622.950841]  [<ffffffff81136289>] stop_machine_cpu_stop+0x93/0xf1
[  622.950842]  [<ffffffff81136167>] cpu_stopper_thread+0xa0/0x12f
[  622.950844]  [<ffffffff811361f6>] ? cpu_stopper_thread+0x12f/0x12f
[  622.950847]  [<ffffffff81119710>] ? lock_release_holdtime.part.7+0xa3/0xa8
[  622.950848]  [<ffffffff81135e4b>] ? cpu_stop_should_run+0x3f/0x47
[  622.950850]  [<ffffffff810ea9b0>] smpboot_thread_fn+0x1c5/0x1e3
[  622.950852]  [<ffffffff810ea7eb>] ? lg_global_unlock+0x67/0x67
[  622.950854]  [<ffffffff810e36b7>] kthread+0xd8/0xe0
[  622.950857]  [<ffffffff81a3bfad>] ? wait_for_common+0x12f/0x164
[  622.950859]  [<ffffffff810e35df>] ? kthread_create_on_node+0x124/0x124
[  622.950861]  [<ffffffff81a45ffc>] ret_from_fork+0x7c/0xb0
[  622.950862]  [<ffffffff810e35df>] ? kthread_create_on_node+0x124/0x124
[  622.950876] smpboot: CPU 1 is now offline
[  623.194556] SMP alternatives: lockdep: fixing up alternatives
[  623.194559] smpboot: Booting Node 0 Processor 1 APIC 0x1
...

A correct fix is to unregister the hotcpu notifier during restore and register a
new one in resume.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1096,11 +1096,6 @@ static int virtnet_cpu_callback(struct n
 {
 	struct virtnet_info *vi = container_of(nfb, struct virtnet_info, nb);
 
-	mutex_lock(&vi->config_lock);
-
-	if (!vi->config_enable)
-		goto done;
-
 	switch(action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
@@ -1114,8 +1109,6 @@ static int virtnet_cpu_callback(struct n
 		break;
 	}
 
-done:
-	mutex_unlock(&vi->config_lock);
 	return NOTIFY_OK;
 }
 
@@ -1672,6 +1665,8 @@ static int virtnet_freeze(struct virtio_
 	struct virtnet_info *vi = vdev->priv;
 	int i;
 
+	unregister_hotcpu_notifier(&vi->nb);
+
 	/* Prevent config work handler from accessing the device */
 	mutex_lock(&vi->config_lock);
 	vi->config_enable = false;
@@ -1720,6 +1715,10 @@ static int virtnet_restore(struct virtio
 	virtnet_set_queues(vi, vi->curr_queue_pairs);
 	rtnl_unlock();
 
+	err = register_hotcpu_notifier(&vi->nb);
+	if (err)
+		return err;
+
 	return 0;
 }
 #endif


