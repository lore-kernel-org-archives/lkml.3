Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3H0B2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:28:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3H0BGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:06:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 04/13] xen/events: initialize local per-cpu mask for all possible events
Date: Mon, 26 Aug 2013 18:08:36 -0700
Message-Id: <20130827010310.187001988@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010309.850395966@linuxfoundation.org>
References: <20130827010309.850395966@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -324,7 +324,7 @@ static void init_evtchn_cpu_bindings(voi
 
 	for_each_possible_cpu(i)
 		memset(per_cpu(cpu_evtchn_mask, i),
-		       (i == 0) ? ~0 : 0, sizeof(*per_cpu(cpu_evtchn_mask, i)));
+		       (i == 0) ? ~0 : 0, NR_EVENT_CHANNELS/8);
 }
 
 static inline void clear_evtchn(int port)


