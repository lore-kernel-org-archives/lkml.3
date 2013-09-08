Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab3IHDtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:49:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56071 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756915Ab3IHDTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "David Vrabel" <david.vrabel@citrix.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.194950544@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [080/121] xen/events: initialize local per-cpu mask for all
 possible events
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 84ca7a8e45dafb49cd5ca90a343ba033e2885c17 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/xen/events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -316,7 +316,7 @@ static void init_evtchn_cpu_bindings(voi
 
 	for_each_possible_cpu(i)
 		memset(per_cpu(cpu_evtchn_mask, i),
-		       (i == 0) ? ~0 : 0, sizeof(*per_cpu(cpu_evtchn_mask, i)));
+		       (i == 0) ? ~0 : 0, NR_EVENT_CHANNELS/8);
 }
 
 static inline void clear_evtchn(int port)

