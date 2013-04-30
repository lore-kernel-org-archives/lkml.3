Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476Ab3D3Ldu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:33:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10027 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760421Ab3D3Ldf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:33:35 -0400
X-IronPort-AV: E=Sophos;i="4.87,581,1363104000"; 
   d="scan'208,223";a="7159410"
Message-ID: <517FAB9B.6010005@cn.fujitsu.com>
Date: Tue, 30 Apr 2013 19:31:39 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        "'Lin Feng'" <linfeng@cn.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, guz.fnst@cn.fujitsu.com
Subject: [PATCH v2 4/4] PCI: Check if the pci device get removed from pci
 tree already in remove_callback()
References: <516FB647.5030203@cn.fujitsu.com> <CAErSpo65ARR_fZwsGCZDJqbPWktHYUkufgPt-2mWwur=nPR1Qg@mail.gmail.com>
In-Reply-To: <CAErSpo65ARR_fZwsGCZDJqbPWktHYUkufgPt-2mWwur=nPR1Qg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 19:31:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 19:31:51,
	Serialize complete at 2013/04/30 19:31:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a870da3615988f53a8949e5f8c907b079162067b Mon Sep 17 00:00:00 2001
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Tue, 30 Apr 2013 18:45:12 +0800
Subject: [PATCH v2 4/4] PCI: Check if the pci device get removed from pci tree already in remove_callback 
We found nested removing through:
	echo -n 1 > /sys/bus/pci/devices/0000\:10\:00.0/remove ; echo -n 1 >
/sys/bus/pci/devices/0000\:1a\:01.0/remove

will cause kernel crash as bus get freed.

[  418.946462] CPU 4
[  418.968377] Pid: 512, comm: kworker/u:2 Tainted: G        W    3.8.0 #2
FUJITSU-SV PRIMEQUEST 1800E/SB
[  419.081763] RIP: 0010:[<ffffffff8137972e>]  [<ffffffff8137972e>]
pci_bus_read_config_word+0x5e/0x90
[  420.494137] Call Trace:
[  420.523326]  [<ffffffff813851ef>] ? remove_callback+0x1f/0x40
[  420.591984]  [<ffffffff8138044b>] pci_pme_active+0x4b/0x1c0
[  420.658545]  [<ffffffff8137d8e7>] pci_stop_bus_device+0x57/0xb0
[  420.729259]  [<ffffffff8137dab6>] pci_stop_and_remove_bus_device+0x16/0x30
[  420.811392]  [<ffffffff813851fb>] remove_callback+0x2b/0x40
[  420.877955]  [<ffffffff81257a56>] sysfs_schedule_callback_work+0x26/0x70

https://bugzilla.kernel.org/show_bug.cgi?id=54411

We have one patch that will let device hold bus ref to prevent it from
being freed, but that will still generate warning.

------------[ cut here ]------------
WARNING: at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()
Hardware name: PRIMEQUEST 1800E
list_del corruption, ffff8807d1b6c000->next is LIST_POISON1 (dead000000100100)
Call Trace:
 [<ffffffff81056d4f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81056e46>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81280b13>] __list_del_entry+0x63/0xd0
 [<ffffffff81280b91>] list_del+0x11/0x40
 [<ffffffff81298331>] pci_destroy_dev+0x31/0xc0
 [<ffffffff812985bb>] pci_remove_bus_device+0x5b/0x70
 [<ffffffff812985ee>] pci_stop_and_remove_bus_device+0x1e/0x30
 [<ffffffff8129fc89>] remove_callback+0x29/0x40
 [<ffffffff811f3b84>] sysfs_schedule_callback_work+0x24/0x70

We can just check if the device get removed from pci tree
already in the protection under pci_remove_rescan_mutex.


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5b4a9d9..18590c1 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -328,10 +328,17 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
 
 static void remove_callback(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-
+	struct pci_dev *pdev = to_pci_dev(dev), *tmp;
+	bool found = false;
+	struct pci_bus *bus = pdev->bus;
 	mutex_lock(&pci_remove_rescan_mutex);
-	pci_stop_and_remove_bus_device(pdev);
+	list_for_each_entry(tmp, &bus->devices, bus_list)
+		if (tmp == pdev) {
+			found = true;
+			break;
+		}
+	if (found)
+		pci_stop_and_remove_bus_device(pdev);
 	mutex_unlock(&pci_remove_rescan_mutex);
 }
 
-- 
1.7.7

