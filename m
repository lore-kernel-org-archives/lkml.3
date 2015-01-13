Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbbAMLdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:33:03 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:63420 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbAMLdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:33:00 -0500
From: Kaixu Xia <xiakaixu@huawei.com>
To: <mathieu.poirier@linaro.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <xiakaixu@huawei.com>,
        <kaixu.xia@linaro.org>
Subject: [PATCH] coresight: fix the link between orphan connection and newly added device
Date: Tue, 13 Jan 2015 19:23:16 +0800
Message-ID: <1421148196-17928-1-git-send-email-xiakaixu@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.54B5016E.00F6,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 23451ed194d2ca5f16abcf344acf6c73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When found a component that has one orphan connection, we should
validate if it match the newly added device. If it does not match,
this component still has an orphan connection(still_orphan = true).
The process should be like this. The original logic maybe cause
path building failed.

The tested result as follows. 
pre:
/sys/bus/coresight/devices # echo 1 > e3c42000.etb/enable_sink
/sys/bus/coresight/devices # echo 1 > e3c7c000.ptm/enable_source
[   15.527692] Unable to handle kernel NULL pointer dereference at virtual address 00000124
[   15.555142] pgd = c2294000
[   15.564226] [00000124] *pgd=3d393831, *pte=00000000, *ppte=00000000
[   15.585391] Internal error: Oops: 817 [#1] PREEMPT SMP ARM
[   15.603807] CPU: 0 PID: 144 Comm: sh Not tainted 3.17.0-rc1-12634-g1222fe0-dirty #3
[   15.629490] task: ed3803c0 ti: c213a000 task.ti: c213a000
[   15.647627] PC is at coresight_build_paths+0x1c/0x314
[   15.664579] LR is at coresight_build_paths+0x6c/0x314
[   15.681526] pc : [<c02da20c>]    lr : [<c02da25c>]    psr: 20000013
[   15.681526] sp : c213be88  ip : c02da800  fp : 00000000
[   15.720023] r10: 00000002  r9 : ed13250c  r8 : 00000001
[   15.737549] r7 : c213bee8  r6 : ffffffea  r5 : 00000000  r4 : 00000124
[   15.759446] r3 : ed216f24  r2 : 00000001  r1 : c213bee8  r0 : 00000000
[   15.781346] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user

post:
/sys/bus/coresight/devices # echo 1 > e3c42000.etb/enable_sink
/sys/bus/coresight/devices # echo 1 > e3c7c000.ptm/enable_source
[   59.934255] coresight-etb10 e3c42000.etb: ETB enabled
[   59.951317] coresight-replicator replicator0: REPLICATOR enabled
[   59.971581] coresight-funnel e3c41000.funnel: FUNNEL inport 0 enabled
[   59.993334] coresight-etm3x e3c7c000.ptm: ETM tracing enabled

Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
---
 drivers/coresight/coresight.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/coresight/coresight.c b/drivers/coresight/coresight.c
index 6e0181f..11968b7 100644
--- a/drivers/coresight/coresight.c
+++ b/drivers/coresight/coresight.c
@@ -504,11 +504,12 @@ static int coresight_orphan_match(struct device *dev, void *data)
 		/* We have found at least one orphan connection */
 		if (conn->child_dev == NULL) {
 			/* Does it match this newly added device? */
-			if (!strcmp(dev_name(&csdev->dev), conn->child_name))
+			if (!strcmp(dev_name(&csdev->dev), conn->child_name)) {
 				conn->child_dev = csdev;
-		} else {
-			/* Too bad, this component still has an orphan */
-			still_orphan = true;
+			} else {
+				/* Too bad, this component still has an orphan */
+				still_orphan = true;
+			}
 		}
 	}
 
-- 
1.8.5.5

