Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaKYLeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:34:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58482 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaKYKlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 100/254] s390/topology: call set_sched_topology early
Date: Tue, 25 Nov 2014 10:37:30 +0000
Message-Id: <1416912004-5928-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 48e9a6c1f54695609b709bf674aac133794ada00 upstream.

The call to topology_init is too late for the set_sched_topology call.
The initial scheduling domain structure has already been established
with default topology array. Use the smp_cpus_done() call to get the
s390 specific topology array registered early enough.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/kernel/topology.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 355a16c55702..b93bed76ea94 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -464,15 +464,17 @@ static struct sched_domain_topology_level s390_topology[] = {
 
 static int __init topology_init(void)
 {
-	if (!MACHINE_HAS_TOPOLOGY) {
+	if (MACHINE_HAS_TOPOLOGY)
+		set_topology_timer();
+	else
 		topology_update_polarization_simple();
-		goto out;
-	}
-	set_topology_timer();
-out:
-
-	set_sched_topology(s390_topology);
-
 	return device_create_file(cpu_subsys.dev_root, &dev_attr_dispatching);
 }
 device_initcall(topology_init);
+
+static int __init early_topology_init(void)
+{
+	set_sched_topology(s390_topology);
+	return 0;
+}
+early_initcall(early_topology_init);
-- 
2.1.0

