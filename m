Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3FEPzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:55:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38267 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab3FEPzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:55:13 -0400
MIME-Version: 1.0
Message-ID: <1370447678-22367-9-git-send-email-konrad.wilk@oracle.com>
Date: Wed, 5 Jun 2013 08:54:37 -0700 (PDT)
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/9] xen/time: Check that the per_cpu data structure has data
 before freeing.
References: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't check whether the per_cpu data structure has actually
been freed in the past. This checks it and if it has been freed
in the past then just continues on without double-freeing.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/time.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 011f1bf..6a56ae0 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -434,10 +434,13 @@ void xen_teardown_timer(int cpu)
 	struct clock_event_device *evt;
 	BUG_ON(cpu == 0);
 	evt = &per_cpu(xen_clock_events, cpu).evt;
-	unbind_from_irqhandler(evt->irq, NULL);
-	evt->irq = -1;
-	kfree(per_cpu(xen_clock_events, cpu).name);
-	per_cpu(xen_clock_events, cpu).name = NULL;
+
+	if (evt->irq >= 0) {
+		unbind_from_irqhandler(evt->irq, NULL);
+		evt->irq = -1;
+		kfree(per_cpu(xen_clock_events, cpu).name);
+		per_cpu(xen_clock_events, cpu).name = NULL;
+	}
 }
 
 void xen_setup_cpu_clockevents(void)
-- 
1.8.1.4

