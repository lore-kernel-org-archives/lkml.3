Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab3B1Osl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:48:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42205 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3B1Osg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Liu <wei.liu2@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 068/139] xen: close evtchn port if binding to irq fails
Date: Thu, 28 Feb 2013 14:43:38 +0000
Message-Id: <1362062689-2567-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit e7e44e444876478d50630f57b0c31d29f6725020 upstream.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/evtchn.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index b1f60a0..b2db77e 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -269,6 +269,14 @@ static int evtchn_bind_to_user(struct per_user_data *u, int port)
 				       u->name, (void *)(unsigned long)port);
 	if (rc >= 0)
 		rc = evtchn_make_refcounted(port);
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
@@ -277,6 +285,8 @@ static void evtchn_unbind_from_user(struct per_user_data *u, int port)
 {
 	int irq = irq_from_evtchn(port);
 
+	BUG_ON(irq < 0);
+
 	unbind_from_irqhandler(irq, (void *)(unsigned long)port);
 
 	set_port_user(port, NULL);
-- 
1.8.1.2

