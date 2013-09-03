Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab3ICQfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:35:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46505 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415Ab3ICQ1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:27:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 49/58] xen/events: initialize local per-cpu mask for all possible events
Date: Tue,  3 Sep 2013 09:23:53 -0700
Message-Id: <1378225442-20654-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/xen/events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 7ae3821..6f788a8 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -333,7 +333,7 @@ static void init_evtchn_cpu_bindings(void)
 
 	for_each_possible_cpu(i)
 		memset(per_cpu(cpu_evtchn_mask, i),
-		       (i == 0) ? ~0 : 0, sizeof(*per_cpu(cpu_evtchn_mask, i)));
+		       (i == 0) ? ~0 : 0, NR_EVENT_CHANNELS/8);
 }
 
 static inline void clear_evtchn(int port)
-- 
1.8.1.2

