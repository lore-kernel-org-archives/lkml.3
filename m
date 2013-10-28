Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3J1IPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:15:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15452 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3J1IPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:15:20 -0400
X-AuditID: cbfee6a3-b7ff36d000001162-ef-526e1d151a71
Date: Mon, 28 Oct 2013 08:15:17 +0000 (GMT)
From: Shifei Ge <shifei10.ge@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs:fix truncate_partial_nodes bug
To: jaegeuk.kim@samsung.com
Cc: =?windows-1252?Q?=3F=3F?= <shu.tan@samsung.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Reply-to: shifei10.ge@samsung.com
MIME-version: 1.0
X-MTR: 20131028080143133@shifei10.ge
Msgkey: 20131028080143133@shifei10.ge
X-EPLocale: zh_CN.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131028080143133@shifei10.ge
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <27929860.72301382948116848.JavaMail.weblogic@epml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t/tmbqisnlBBh3zVSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGzqvr2AsuSVTMnB7WwPhHvIuRk0NIQE2ia/4iVhBbQsBEYtvE
	RmYIW0ziwr31bF2MXEA18xklDq/5zgaSYBFQlZjQspQJxGYT0JKYtvsnWLOwgL1E74VmsBoR
	AQWJyW2bmUGamQXWM0pcWT2HBWKbosSPi21gNq+AoMTJmU9YILapSCxeNJEdIq4q0Tetkwki
	LifxfM4pKJtXYkb7UxaY+LSva6AulZY4P2sDI8zVi78/horzSxy7vQOolwOs98n9YJgxuzd/
	YYOwBSSmnjkI1aop8eoZzEg+iTUL37LAjNl1ajkzTO/9LXPBzmEGemVK90N2CNtA4siiOazo
	3uIVcJRYNnMV6wRGuVlIUrOQtM9C0o6sZgEjyypG0dSC5ILipPQKY73ixNzi0rx0veT83E2M
	4Dh/tngH4//z1ocYBTgYlXh4N6zNDRJiTSwrrsw9xCjBwawkwtt3CyjEm5JYWZValB9fVJqT
	WnyIUZqDRUmcN/5WUpCQQHpiSWp2ampBahFMlomDU6qBsWbWZLN493ztkB37i64kvmNbkbSu
	yiL7wsm9E7P3xIV8cpH/vTfv8+L//mZKRhlzZTjiVm7x+K/5xJvxduDcoEan5GyXO24r5mmW
	HpqXWbpm2dfbrWFpaemP3/+aqyecfnDRsnmBEpZJC3jnhmRmdN1faNQl0p9f8atn5lGZPzEs
	iwM2vgwMUGIpzkg01GIuKk4EAAVeYPDvAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9S8FSmx003144

truncate_partial_nodes puts pages incorrectly in two cases.note that the value for argc 'depth' can only be 2 or 3(see truncate_inode_blocks --->truncate_partial_nodes ).
first case:err happened in the first 'for' loop
	assume depth is 2,when err happened,pages[0] is invalid,so this page don't need to be put when func return,there is no problem.
	but when depth is 3 ,pages isn't put correctly when pages[0] is valid and pages[1] is invalid.in this case,depth is set to 2(ref to statemnt depth = i + 1) ,and then 'goto fail'.
	in label 'fail', for (i = depth - 3; i >= 0; i--) cann't meet the condition because i=-1,so pages[0] cann't be put when func return.
second case:err happened in the second 'for' loop
	now,we've got pages[0] with argc 'depth' is 2 ,or we've got pages[0] and pages[1] with depth is 3.when err happend,we need 'goto fail' to put pages we've got.
	when depth is 2,in label 'fail',for (i = depth - 3; i >= 0; i--) cann't meet the condition because i=-1,so pages[0] cann't be put.
	when depth is 3,in label 'fail',for (i = depth - 3; i >= 0; i--) can only put pages[0],pages[1] also cann't be put.
notes 'depth' has been changed before first 'goto fail'(ref to statemnt depth = i + 1),so pass this modified 'depth' to trace_f2fs_truncate_partial_nodes is also incorrectly.

>From 9de8efa31759ce86a032f5ad092d337b686ede06 Mon Sep 17 00:00:00 2001
Signed-off-by: Shifei Ge <shifei10.ge@samsung.com>
---
 fs/f2fs/node.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 304d5ce..9986930 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -625,6 +625,7 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 	int err = 0;
 	int i;
 	int idx = depth - 2;
+	int dep = depth;
 
 	nid[0] = le32_to_cpu(ri->i_nid[offset[0] - NODE_DIR1_BLOCK]);
 	if (!nid[0])
@@ -663,11 +664,12 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 	}
 	offset[idx]++;
 	offset[depth - 1] = 0;
+	depth--;
 fail:
-	for (i = depth - 3; i >= 0; i--)
+	for (i = depth - 2; i >= 0; i--)
 		f2fs_put_page(pages[i], 1);
 
-	trace_f2fs_truncate_partial_nodes(dn->inode, nid, depth, err);
+	trace_f2fs_truncate_partial_nodes(dn->inode, nid, dep, err);
 
 	return err;
 }
-- 
1.7.9.5ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
