Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab3HMP6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:58:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788Ab3HMP6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:42 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Klv2xkZ8g1gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=mQJOYmf6k0wA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=IuRubmz5vkYhvLOw4SwA:9 a=hPjdaMEvmhQA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155830.821507623@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Jinyue <lijinyue@huawei.com>, Li Zefan <lizefan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [46/88] dlci: validate the net device in dlci_del()
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0046-dlci-validate-the-net-device-in-dlci_del.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Zefan Li <lizefan@huawei.com>

[ Upstream commit 578a1310f2592ba90c5674bca21c1dbd1adf3f0a ]

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
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wan/dlci.c |   12 ++++++++++++
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
1.7.10.4


