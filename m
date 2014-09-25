Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaIYH3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:29:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55206 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaIYH3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:29:18 -0400
X-AuditID: cbfee61a-f79c06d000004e71-88-5423c44c0b3b
From: Chao Yu <chao2.yu@samsung.com>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] md: avoid potential long delay under pers_lock
Date: Thu, 25 Sep 2014 15:28:34 +0800
Message-id: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/Yjg7yxSdseIg7Ti2xgbm7gW8TXQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jAV2fI8ohBtc/61hc3jWHzaJ9/i5G
	i73zG1gcmD02n672+LxJLoApissmJTUnsyy1SN8ugStj1fn7bAUHOSqanhxhbmBsZO9i5OSQ
	EDCRWP1mEiOELSZx4d56ti5GLg4hgUWMEg/evIRyfgA5x86xglSxCahILO/4zwRiiwgISix9
	/JUZxGYWsJG482AaSxcjB4ewgL3Ejus6IGEWAVWJp38usoDYvAKWEgsnT2CHsAUlfky+xwLR
	qiWxfudxJghbXmLzmrfMEAcpSOw4+5oRYpWeRN/OO1A14hIbj9ximcAoMAvJqFlIRs1CMmoW
	kpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKD9pnUDsaVDRaHGAU4GJV4eD38lUOE
	WBPLiitzDzFKcDArifBu2woU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1
	ILUIJsvEwSnVwLjDWq0u2cfj6YdZN5TWiulv1Z7w8qh1vZntDCXz7Ftle1sO7nsSsL5r1Yyc
	e99TvLc8WTxjYbTDnBMtaq8Ksl80dgde8b9QuORVvI2jcN/9stQV0y+wTPptMG/++dqT1ldM
	k/yjIrn3GlcuYeiOCVF60ZC34Xi9v5xE9sLJDI97NmW732xa3KnEUpyRaKjFXFScCAA5KeeU
	VgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk may cause long time lapse if value of printk_delay in sysctl is
configured large by user. If register_md_personality takes long time to print in
spinlock pers_lock, we may encounter high CPU usage rate when there are other
pers_lock competitors who may be blocked to spin.
We can avoid this condition by moving printk out of coverage of pers_lock
spinlock.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e02de05..5fcf215 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7200,9 +7200,10 @@ static const struct file_operations md_seq_fops = {
 
 int register_md_personality(struct md_personality *p)
 {
+	printk(KERN_INFO "md: %s personality registered for level %d\n",
+						p->name, p->level);
 	spin_lock(&pers_lock);
 	list_add_tail(&p->list, &pers_list);
-	printk(KERN_INFO "md: %s personality registered for level %d\n", p->name, p->level);
 	spin_unlock(&pers_lock);
 	return 0;
 }
-- 
2.0.1.474.g72c7794


