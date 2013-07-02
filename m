Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab3GBLKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:10:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36354 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab3GBLIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 43/50] dlci: validate the net device in dlci_del()
Date: Tue,  2 Jul 2013 12:07:31 +0100
Message-Id: <1372763258-20664-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wan/dlci.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 1f6e053..6a8a382 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -384,6 +384,7 @@ static int dlci_del(struct dlci_add *dlci)
 	struct frad_local	*flp;
 	struct net_device	*master, *slave;
 	int			err;
+	bool			found = false;
 
 	rtnl_lock();
 
@@ -394,6 +395,17 @@ static int dlci_del(struct dlci_add *dlci)
 		goto out;
 	}
 
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
+
 	if (netif_running(master)) {
 		err = -EBUSY;
 		goto out;
-- 
1.8.1.2

