Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab3HTClJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:41:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28285 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3HTClI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:41:08 -0400
X-Spam-Score: -101.1
Message-ID: <5212D703.5080405@asianux.com>
Date: Tue, 20 Aug 2013 10:40:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: bsingharora@gmail.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/delayacct.c: check NULL for member variable 'delays'
 in all extern functions.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The member variable 'delays' may be NULL, so need check NULL before use
it for all extern functions, just like __delayacct_tsk_init() and
__delayacct_add_tsk() have already done.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/delayacct.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index d473988..10cddce 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -81,11 +81,15 @@ static void delayacct_end(struct timespec *start, struct timespec *end,
 
 void __delayacct_blkio_start(void)
 {
+	if (!current->delays)
+		return;
 	delayacct_start(&current->delays->blkio_start);
 }
 
 void __delayacct_blkio_end(void)
 {
+	if (!current->delays)
+		return;
 	if (current->delays->flags & DELAYACCT_PF_SWAPIN)
 		/* Swapin block I/O */
 		delayacct_end(&current->delays->blkio_start,
@@ -167,6 +171,8 @@ __u64 __delayacct_blkio_ticks(struct task_struct *tsk)
 	__u64 ret;
 	unsigned long flags;
 
+	if (!tsk->delays)
+		return 0;
 	spin_lock_irqsave(&tsk->delays->lock, flags);
 	ret = nsec_to_clock_t(tsk->delays->blkio_delay +
 				tsk->delays->swapin_delay);
@@ -176,11 +182,15 @@ __u64 __delayacct_blkio_ticks(struct task_struct *tsk)
 
 void __delayacct_freepages_start(void)
 {
+	if (!current->delays)
+		return;
 	delayacct_start(&current->delays->freepages_start);
 }
 
 void __delayacct_freepages_end(void)
 {
+	if (!current->delays)
+		return;
 	delayacct_end(&current->delays->freepages_start,
 			&current->delays->freepages_end,
 			&current->delays->freepages_delay,
-- 
1.7.7.6
