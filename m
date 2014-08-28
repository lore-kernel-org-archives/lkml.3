Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaH1PNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:13:21 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53379 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaH1PNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:13:19 -0400
Message-ID: <53FF4702.9020509@gmail.com>
Date: Thu, 28 Aug 2014 23:13:06 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/xen/evtchn.c: Check failure for evtchn_make_refcounted()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

evtchn_make_refcounted() may return failure, so need process the failure
case. In failure case, it need call unbind_from_irqhandler() just like
evtchn_unbind_from_user() has done.

irq_from_evtchn() must be OK when bind_evtchn_to_irqhandler() succeed,
so need not check it again.

Also still need remain the closing port code, because when the failure
occurs, unbind_from_irqhandler() will not close port internally.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/xen/evtchn.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index 00f40f0..8a629d6 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -311,6 +311,11 @@ static int evtchn_bind_to_user(struct per_user_data *u, int port)
 		goto err;
 
 	rc = evtchn_make_refcounted(port);
+	if (rc < 0) {
+		unbind_from_irqhandler(irq_from_evtchn(port), evtchn);
+		goto err;
+	}
+
 	return rc;
 
 err:
-- 
1.7.11.7
