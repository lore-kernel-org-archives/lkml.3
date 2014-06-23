Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbaFWNhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:37:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36691 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaFWNDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 09/93] perf: Limit perf_event_attr::sample_period to 63 bits
Date: Mon, 23 Jun 2014 14:01:48 +0100
Message-Id: <1403528592-2163-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9c511b4296db..fe0c665c54d2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6816,6 +6816,9 @@ SYSCALL_DEFINE5(perf_event_open,
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

