Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab3IGF7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 01:59:44 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46746 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3IGF7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 01:59:43 -0400
Date: Fri, 6 Sep 2013 22:59:16 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] vmpressure: fix divide-by-0 in vmpressure_work_fn
Message-ID: <alpine.LNX.2.00.1309062254470.11420@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hit divide-by-0 in vmpressure_work_fn(): checking vmpr->scanned before
taking the lock is not enough, we must check scanned afterwards too.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org
---

 mm/vmpressure.c |    3 +++
 1 file changed, 3 insertions(+)

--- 3.11/mm/vmpressure.c	2013-09-02 13:46:10.000000000 -0700
+++ linux/mm/vmpressure.c	2013-09-06 22:43:03.596003080 -0700
@@ -187,6 +187,9 @@ static void vmpressure_work_fn(struct wo
 	vmpr->reclaimed = 0;
 	spin_unlock(&vmpr->sr_lock);
 
+	if (!scanned)
+		return;
+
 	do {
 		if (vmpressure_event(vmpr, scanned, reclaimed))
 			break;
