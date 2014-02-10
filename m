Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaBJNcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:32:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbaBJNcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:32:42 -0500
Date: Mon, 10 Feb 2014 05:32:21 -0800
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-ba6a328f7dfc95b20df5e0eb33c698187e997190@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, rientjes@google.com,
        toshi.kani@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, toshi.kani@hp.com,
        rientjes@google.com
In-Reply-To: <1390770102-4007-1-git-send-email-yinghai@kernel.org>
References: <1390770102-4007-1-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Avoid duplicated pxm_to_node() calls
Git-Commit-ID: ba6a328f7dfc95b20df5e0eb33c698187e997190
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:32:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba6a328f7dfc95b20df5e0eb33c698187e997190
Gitweb:     http://git.kernel.org/tip/ba6a328f7dfc95b20df5e0eb33c698187e997190
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 26 Jan 2014 13:01:42 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 15:32:31 +0100

x86/mm: Avoid duplicated pxm_to_node() calls

In slit init code, too many pxm_to_node() function calls are done.

We can store from_node/to_node instead of keep calling
pxm_to_node().

  - Before this patch: pxm_to_node() is called n*(1+n*3) times.
  - After  this patch: pxm_to_node() is called n*(1+n) times.

for  8 sockets, it will be   72 instead of  200.
for 32 sockets, it will be 1056 instead of 3104.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/1390770102-4007-1-git-send-email-yinghai@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/srat.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 1953e9c..66338a6 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -52,12 +52,18 @@ void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 	int i, j;
 
 	for (i = 0; i < slit->locality_count; i++) {
-		if (pxm_to_node(i) == NUMA_NO_NODE)
+		const int from_node = pxm_to_node(i);
+
+		if (from_node == NUMA_NO_NODE)
 			continue;
+
 		for (j = 0; j < slit->locality_count; j++) {
-			if (pxm_to_node(j) == NUMA_NO_NODE)
+			const int to_node = pxm_to_node(j);
+
+			if (to_node == NUMA_NO_NODE)
 				continue;
-			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
+
+			numa_set_distance(from_node, to_node,
 				slit->entry[slit->locality_count * i + j]);
 		}
 	}
