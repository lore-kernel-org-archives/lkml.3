Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaKLBYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:24:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbaKLBYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:24:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.17 071/319] s390/topology: call set_sched_topology early
Date: Wed, 12 Nov 2014 10:13:29 +0900
Message-Id: <20141112011004.326675737@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 48e9a6c1f54695609b709bf674aac133794ada00 upstream.

The call to topology_init is too late for the set_sched_topology call.
The initial scheduling domain structure has already been established
with default topology array. Use the smp_cpus_done() call to get the
s390 specific topology array registered early enough.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/topology.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -464,15 +464,17 @@ static struct sched_domain_topology_leve
 
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


