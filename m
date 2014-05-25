Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaEYN0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 09:26:55 -0400
Received: from mout.gmx.net ([212.227.17.21]:51398 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaEYN0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 09:26:53 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: infinipath@intel.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] ipath: use time_before()/_after()
Date: Sun, 25 May 2014 15:26:41 +0200
Message-Id: <1401024401-1992-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:WbI664NiiZ6D4pTHmSawDq5pEeXM65+VGQDOUSvr7uxDgwZJfL0
 6+UDEp8c/hiueLFlHEsaPdUxRDZob/SINDY/PIuZ//WeSuOcWBR8s9hLMLgjdDSW0C0GEMK
 ItWgHOOzaPr7ITnR9nR7R/gfcMk0po9iWV55pJnMvq2/DcDBIAtnGaxBtOKMpxF9H3ZoP2q
 dCto0hUBads/g1P+kcXqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are
modified to use time_before/_after() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/infiniband/hw/ipath/ipath_intr.c |    4 ++--
 drivers/infiniband/hw/ipath/ipath_sdma.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
index 26dfbc8..01ba792 100644
--- a/drivers/infiniband/hw/ipath/ipath_intr.c
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c
@@ -70,7 +70,7 @@ void ipath_disarm_senderrbufs(struct ipath_devdata *dd)
 	if (sbuf[0] || sbuf[1] || (piobcnt > 128 && (sbuf[2] || sbuf[3]))) {
 		int i;
 		if (ipath_debug & (__IPATH_PKTDBG|__IPATH_DBG) &&
-			dd->ipath_lastcancel > jiffies) {
+			time_after(dd->ipath_lastcancel, jiffies)) {
 			__IPATH_DBG_WHICH(__IPATH_PKTDBG|__IPATH_DBG,
 					  "SendbufErrs %lx %lx", sbuf[0],
 					  sbuf[1]);
@@ -755,7 +755,7 @@ static int handle_errors(struct ipath_devdata *dd, ipath_err_t errs)
 
 	/* likely due to cancel; so suppress message unless verbose */
 	if ((errs & (INFINIPATH_E_SPKTLEN | INFINIPATH_E_SPIOARMLAUNCH)) &&
-		dd->ipath_lastcancel > jiffies) {
+		time_after(dd->ipath_lastcancel, jiffies)) {
 		/* armlaunch takes precedence; it often causes both. */
 		ipath_cdbg(VERBOSE,
 			"Suppressed %s error (%llx) after sendbuf cancel\n",
diff --git a/drivers/infiniband/hw/ipath/ipath_sdma.c b/drivers/infiniband/hw/ipath/ipath_sdma.c
index 98ac18e..17a5177 100644
--- a/drivers/infiniband/hw/ipath/ipath_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_sdma.c
@@ -247,7 +247,7 @@ static void sdma_abort_task(unsigned long opaque)
 
 	/* ipath_sdma_abort() is done, waiting for interrupt */
 	if (status == IPATH_SDMA_ABORT_DISARMED) {
-		if (jiffies < dd->ipath_sdma_abort_intr_timeout)
+		if (time_before(jiffies, dd->ipath_sdma_abort_intr_timeout))
 			goto resched_noprint;
 		/* give up, intr got lost somewhere */
 		ipath_dbg("give up waiting for SDMADISABLED intr\n");
@@ -341,7 +341,7 @@ resched:
 	 * JAG - this is bad to just have default be a loop without
 	 * state change
 	 */
-	if (jiffies > dd->ipath_sdma_abort_jiffies) {
+	if (time_after(jiffies, dd->ipath_sdma_abort_jiffies)) {
 		ipath_dbg("looping with status 0x%08lx\n",
 			  dd->ipath_sdma_status);
 		dd->ipath_sdma_abort_jiffies = jiffies + 5 * HZ;
-- 
1.7.10.4

