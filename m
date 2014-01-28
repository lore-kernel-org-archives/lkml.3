Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaA1Aeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:34:37 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:34804 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaA1Aeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:34:36 -0500
From: Julien Grall <julien.grall@linaro.org>
To: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, patches@linaro.org,
        Julien Grall <julien.grall@linaro.org>
Subject: [PATCH] xen/events: xen_evtchn_fifo_init can be called very late
Date: Tue, 28 Jan 2014 00:34:29 +0000
Message-Id: <1390869269-12502-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM, xen_init_IRQ (which calls xen_evtchn_fifo_init) is called after
all CPUs are online. It would mean that the notifier will never be called.

Therefore, when a secondary CPU will receive an interrupt, Linux will segfault
because the event channel structure for this processor is not initialized.

This can be fixed by calling the init function on every online cpu when the
event channel fifo driver is initialized.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
---
 drivers/xen/events/events_fifo.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index 1de2a19..15498ab 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -410,12 +410,14 @@ static struct notifier_block evtchn_fifo_cpu_notifier = {
 
 int __init xen_evtchn_fifo_init(void)
 {
-	int cpu = get_cpu();
+	int cpu;
 	int ret;
 
-	ret = evtchn_fifo_init_control_block(cpu);
-	if (ret < 0)
-		goto out;
+	for_each_online_cpu(cpu) {
+		ret = evtchn_fifo_init_control_block(cpu);
+		if (ret < 0)
+			goto out;
+	}
 
 	pr_info("Using FIFO-based ABI\n");
 
@@ -423,6 +425,5 @@ int __init xen_evtchn_fifo_init(void)
 
 	register_cpu_notifier(&evtchn_fifo_cpu_notifier);
 out:
-	put_cpu();
 	return ret;
 }
-- 
1.7.10.4

