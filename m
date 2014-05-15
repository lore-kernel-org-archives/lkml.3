Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaEOLxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:53:44 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43369 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaEOLxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:53:42 -0400
Date: Thu, 15 May 2014 13:53:37 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        acme@ghostprotocols.net, jolsa@redhat.com, jmario@redhat.com,
        dzickus@redhat.com
Subject: [PATCH] perf/x86: fix Haswell precise store data source encoding
Message-ID: <20140515115337.GA2855@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patches fixes a bug in  precise_store_data_hsw() whereby
it would set the data source memory level to the wrong value.

As per the the SDM Vol 3b Table 18-41 (Layout of Data Linear
Address Information in PEBS Record), when status bit 0 is set
this is a L1 hit, otherwise this is a L1 miss. 

This patch encodes the memory level according to the specification.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ae96cfa..81424f6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -114,9 +114,13 @@ static u64 precise_store_data_hsw(u64 status)
 
 	dse.val = 0;
 	dse.mem_op = PERF_MEM_OP_STORE;
-	dse.mem_lvl = PERF_MEM_LVL_NA;
+	dse.mem_lvl = PERF_MEM_LVL_L1;
+
 	if (status & 1)
-		dse.mem_lvl = PERF_MEM_LVL_L1;
+		dse.mem_lvl |= PERF_MEM_LVL_HIT;
+	else
+		dse.mem_lvl |= PERF_MEM_LVL_MISS;
+
 	/* Nothing else supported. Sorry. */
 	return dse.val;
 }
