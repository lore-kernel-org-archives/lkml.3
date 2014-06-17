Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967307AbaFQVxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:53:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55043 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967264AbaFQVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:53:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 148/212] perf: Limit perf_event_attr::sample_period to 63 bits
Date: Tue, 17 Jun 2014 14:44:02 -0700
Message-Id: <1403041506-13646-149-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 0819b2e30ccb93edf04876237b6205eef84ec8d2 upstream.

Vince reported that using a large sample_period (one with bit 63 set)
results in wreckage since while the sample_period is fundamentally
unsigned (negative periods don't make sense) the way we implement
things very much rely on signed logic.

So limit sample_period to 63 bits to avoid tripping over this.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-p25fhunibl4y3qi0zuqmyf4b@git.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6ed1163..ad33a96 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6997,6 +6997,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (attr.freq) {
 		if (attr.sample_freq > sysctl_perf_event_sample_rate)
 			return -EINVAL;
+	} else {
+		if (attr.sample_period & (1ULL << 63))
+			return -EINVAL;
 	}
 
 	/*
-- 
1.9.1

