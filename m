Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3IKE6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3IKE44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:56 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5Av21j2b-x0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Z0ji_k5uTiEA:10 a=tHz9FfFoAAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=38eI-UBrmworDQ2UwVoA:9 a=6O0IECtVFhoA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042928.688592044@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [219/251] xen/events: initialize local per-cpu mask for all possible events
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0219-xen-events-initialize-local-per-cpu-mask-for-all-pos.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

[ Upstream commit 84ca7a8e45dafb49cd5ca90a343ba033e2885c17 ]

The sizeof() argument in init_evtchn_cpu_bindings() is incorrect
resulting in only the first 64 (or 32 in 32-bit guests) ports having
their bindings being initialized to VCPU 0.

In most cases this does not cause a problem as request_irq() will set
the irq affinity which will set the correct local per-cpu mask.
However, if the request_irq() is called on a VCPU other than 0, there
is a window between the unmasking of the event and the affinity being
set were an event may be lost because it is not locally unmasked on
any VCPU. If request_irq() is called on VCPU 0 then local irqs are
disabled during the window and the race does not occur.

Fix this by initializing all NR_EVENT_CHANNEL bits in the local
per-cpu masks.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/xen/events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 99c5345..3987f6f 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -324,7 +324,7 @@ static void init_evtchn_cpu_bindings(void)
 
 	for_each_possible_cpu(i)
 		memset(per_cpu(cpu_evtchn_mask, i),
-		       (i == 0) ? ~0 : 0, sizeof(*per_cpu(cpu_evtchn_mask, i)));
+		       (i == 0) ? ~0 : 0, NR_EVENT_CHANNELS/8);
 }
 
 static inline void clear_evtchn(int port)
-- 
1.7.10.4


