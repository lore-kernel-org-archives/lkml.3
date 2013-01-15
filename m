Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab3AOKKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:10:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:46162 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756277Ab3AOKKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:10:40 -0500
X-IronPort-AV: E=Sophos;i="4.84,473,1355068800"; 
   d="scan'208";a="6591099"
Message-ID: <50F52677.80100@cn.fujitsu.com>
Date: Tue, 15 Jan 2013 17:50:47 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: virtualization@lists.linux-foundation.org
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, hutao@cn.fujitsu.com, linux-scsi@vger.kernel.org,
        mst@redhat.com, rusty@rustcorp.com.au, asias@redhat.com,
        stefanha@redhat.com, nab@linux-iscsi.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 2/2] virtio-scsi: reset virtqueue affinity when doing cpu
 hotplug
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com> <50F525E3.1000100@cn.fujitsu.com>
In-Reply-To: <50F525E3.1000100@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 17:49:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 17:49:51,
	Serialize complete at 2013/01/15 17:49:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add hot cpu notifier to reset the request virtqueue affinity
when doing cpu hotplug.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 16b0ef2..a3b5f12 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -20,6 +20,7 @@
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 #include <linux/virtio_scsi.h>
+#include <linux/cpu.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
@@ -109,6 +110,9 @@ struct virtio_scsi {
 	/* Does the affinity hint is set for virtqueues? */
 	bool affinity_hint_set;
 
+	/* CPU hotplug notifier */
+	struct notifier_block nb;
+
 	struct virtio_scsi_vq ctrl_vq;
 	struct virtio_scsi_vq event_vq;
 	struct virtio_scsi_vq req_vqs[];
@@ -738,6 +742,23 @@ static void virtscsi_set_affinity(struct virtio_scsi *vscsi, bool affinity)
 	}
 }
 
+static int virtscsi_cpu_callback(struct notifier_block *nfb,
+				 unsigned long action, void *hcpu)
+{
+	struct virtio_scsi *vscsi = container_of(nfb, struct virtio_scsi, nb);
+	switch(action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		virtscsi_set_affinity(vscsi, true);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
 static void virtscsi_init_vq(struct virtio_scsi_vq *virtscsi_vq,
 			     struct virtqueue *vq)
 {
@@ -888,6 +909,13 @@ static int __devinit virtscsi_probe(struct virtio_device *vdev)
 	if (err)
 		goto virtscsi_init_failed;
 
+	vscsi->nb.notifier_call = &virtscsi_cpu_callback;
+	err = register_hotcpu_notifier(&vscsi->nb);
+	if (err) {
+		pr_err("virtio_scsi: registering cpu notifier failed\n");
+		goto scsi_add_host_failed;
+	}
+
 	cmd_per_lun = virtscsi_config_get(vdev, cmd_per_lun) ?: 1;
 	shost->cmd_per_lun = min_t(u32, cmd_per_lun, shost->can_queue);
 	shost->max_sectors = virtscsi_config_get(vdev, max_sectors) ?: 0xFFFF;
@@ -925,6 +953,8 @@ static void __devexit virtscsi_remove(struct virtio_device *vdev)
 
 	scsi_remove_host(shost);
 
+	unregister_hotcpu_notifier(&vscsi->nb);
+
 	virtscsi_remove_vqs(vdev);
 	scsi_host_put(shost);
 }
-- 
1.8.1
