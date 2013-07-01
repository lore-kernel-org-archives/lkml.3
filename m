Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab3GAUMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:12:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab3GAUKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Jinyue <lijinyue@huawei.com>, Li Zefan <lizefan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 4/8] dlci: validate the net device in dlci_del()
Date: Mon,  1 Jul 2013 13:10:36 -0700
Message-Id: <20130701200233.932306855@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200232.909858308@linuxfoundation.org>
References: <20130701200232.909858308@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zefan Li <lizefan@huawei.com>

commit 578a1310f2592ba90c5674bca21c1dbd1adf3f0a upstream.

We triggered an oops while running trinity with 3.4 kernel:

BUG: unable to handle kernel paging request at 0000000100000d07
IP: [<ffffffffa0109738>] dlci_ioctl+0xd8/0x2d4 [dlci]
PGD 640c0d067 PUD 0
Oops: 0000 [#1] PREEMPT SMP
CPU 3
...
Pid: 7302, comm: trinity-child3 Not tainted 3.4.24.09+ 40 Huawei Technologies Co., Ltd. Tecal RH2285          /BC11BTSA
RIP: 0010:[<ffffffffa0109738>]  [<ffffffffa0109738>] dlci_ioctl+0xd8/0x2d4 [dlci]
...
Call Trace:
  [<ffffffff8137c5c3>] sock_ioctl+0x153/0x280
  [<ffffffff81195494>] do_vfs_ioctl+0xa4/0x5e0
  [<ffffffff8118354a>] ? fget_light+0x3ea/0x490
  [<ffffffff81195a1f>] sys_ioctl+0x4f/0x80
  [<ffffffff81478b69>] system_call_fastpath+0x16/0x1b
...

It's because the net device is not a dlci device.

Reported-by: Li Jinyue <lijinyue@huawei.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wan/dlci.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -377,6 +377,7 @@ static int dlci_del(struct dlci_add *dlc
 	struct frad_local	*flp;
 	struct net_device	*master, *slave;
 	int			err;
+	bool			found = false;
 
 	rtnl_lock();
 
@@ -386,6 +387,17 @@ static int dlci_del(struct dlci_add *dlc
 		err = -ENODEV;
 		goto out;
 	}
+
+	list_for_each_entry(dlp, &dlci_devs, list) {
+		if (dlp->master == master) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		err = -ENODEV;
+		goto out;
+	}
 
 	if (netif_running(master)) {
 		err = -EBUSY;


