Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaEWSRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:17:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36486 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaEWSQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:58 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 16/16] sched: Disable wake_affine to broaden the scope of wakeup target cpus
Date: Fri, 23 May 2014 19:16:43 +0100
Message-Id: <1400869003-27769-17-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:57.0026 (UTC) FILETIME=[2E9C6A20:01CF76B3]
X-MC-Unique: 114052319165700501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIHCTW005149

SD_WAKE_AFFINE is currently set by default on all levels which means
that wakeups are always handled inside the lowest level sched_domain.
That means a tiny periodic task is very likely to stay on the cpu it was
forked on forever. To save energy we need to revisit the task placement
decision every now and again to ensure that we don't keep waking the
same cpu if there are cheaper alternatives.

One way is to simply disable wake_affine and rely on the fork/exec
balancing mechanism (find_idlest_{group, cpu}). This is what this patch
does.

An alternative is to let the platform remove the SD_WAKE_AFFINE flag
from lower levels to increase the search space for
select_idle_sibling().

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 49b895a..eeb0508 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6069,8 +6069,13 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 					| 1*SD_BALANCE_NEWIDLE
 					| 1*SD_BALANCE_EXEC
 					| 1*SD_BALANCE_FORK
+#ifdef CONFIG_SCHED_ENERGY
+					| 1*SD_BALANCE_WAKE
+					| 0*SD_WAKE_AFFINE
+#else
 					| 0*SD_BALANCE_WAKE
 					| 1*SD_WAKE_AFFINE
+#endif
 					| 0*SD_SHARE_CPUPOWER
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 0*SD_SERIALIZE
-- 
1.7.9.5


