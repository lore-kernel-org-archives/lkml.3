Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab3BYW3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:29:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab3BYWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Liu <wei.liu2@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 26/58] xen: close evtchn port if binding to irq fails
Date: Mon, 25 Feb 2013 14:19:22 -0800
Message-Id: <20130225221641.757249508@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit e7e44e444876478d50630f57b0c31d29f6725020 upstream.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/evtchn.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -269,6 +269,14 @@ static int evtchn_bind_to_user(struct pe
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
@@ -277,6 +285,8 @@ static void evtchn_unbind_from_user(stru
 {
 	int irq = irq_from_evtchn(port);
 
+	BUG_ON(irq < 0);
+
 	unbind_from_irqhandler(irq, (void *)(unsigned long)port);
 
 	set_port_user(port, NULL);


