Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab3LWReq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:34:46 -0500
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:35724 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618Ab3LWReo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:34:44 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: netdev@vger.kernel.org
Cc: dm@chelsio.com, linux-kernel@vger.kernel.org, davem@davemloft.net,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] cxgb4: allow large buffer size to have page size
Date: Mon, 23 Dec 2013 15:34:29 -0200
Message-Id: <1387820069-13623-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122317-1798-0000-0000-0000011E2F70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 52367a763d8046190754ab43743e42638564a2d1
("cxgb4/cxgb4vf: Code cleanup to enable T4 Configuration File support"),
we have failures like this during cxgb4 probe:

cxgb4 0000:01:00.4: bad SGE FL page buffer sizes [65536, 65536]
cxgb4: probe of 0000:01:00.4 failed with error -22

This happens whenever software parameters are used, without a
configuration file. That happens when the hardware was already
initialized (after kexec, or after csiostor is loaded).

It happens that these values are acceptable, rendering fl_pg_order equal
to 0, which is the case of a hard init when the page size is equal or
larger than 65536.

Accepting fl_large_pg equal to fl_small_pg solves the issue, and
shouldn't cause any trouble besides a possible performance reduction
when smaller pages are used. And that can be fixed by a configuration
file.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index cc380c3..cc3511a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2581,7 +2581,7 @@ static int t4_sge_init_soft(struct adapter *adap)
 	#undef READ_FL_BUF
 
 	if (fl_small_pg != PAGE_SIZE ||
-	    (fl_large_pg != 0 && (fl_large_pg <= fl_small_pg ||
+	    (fl_large_pg != 0 && (fl_large_pg < fl_small_pg ||
 				  (fl_large_pg & (fl_large_pg-1)) != 0))) {
 		dev_err(adap->pdev_dev, "bad SGE FL page buffer sizes [%d, %d]\n",
 			fl_small_pg, fl_large_pg);
-- 
1.7.1

