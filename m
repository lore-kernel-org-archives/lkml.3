Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3CDDns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32891 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756385Ab3CDDno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:44 -0500
Message-Id: <20130304033715.865807518@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:31 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Wei Liu <wei.liu2@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 084/153] xen: close evtchn port if binding to irq fails
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit e7e44e444876478d50630f57b0c31d29f6725020 upstream.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/xen/evtchn.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -269,6 +269,14 @@ static int evtchn_bind_to_user(struct pe
 				       u->name, (void *)(unsigned long)port);
 	if (rc >= 0)
 		rc = 0;
+	else {
+		/* bind failed, should close the port now */
+		struct evtchn_close close;
+		close.port = port;
+		if (HYPERVISOR_event_channel_op(EVTCHNOP_close, &close) != 0)
+			BUG();
+		set_port_user(port, NULL);
+	}
 
 	return rc;
 }
@@ -277,6 +285,8 @@ static void evtchn_unbind_from_user(stru
 {
 	int irq = irq_from_evtchn(port);
 
+	BUG_ON(irq < 0);
+
 	unbind_from_irqhandler(irq, (void *)(unsigned long)port);
 
 	set_port_user(port, NULL);


