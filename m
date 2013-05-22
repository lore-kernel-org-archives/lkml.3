Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3EVWKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:10:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab3EVWKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Mason <jon.mason@intel.com>
Subject: [ 18/21] NTB: memcpy lockup workaround
Date: Wed, 22 May 2013 15:10:36 -0700
Message-Id: <20130522205234.722975333@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Mason <jon.mason@intel.com>

commit c336acd3331dcc191a97dbc66a557d47741657c7 upstream.

The system will appear to lockup for long periods of time due to the NTB
driver spending too much time in memcpy.  Avoid this by reducing the
number of packets that can be serviced on a given interrupt.

Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ntb/ntb_transport.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1034,11 +1034,16 @@ out:
 static void ntb_transport_rx(unsigned long data)
 {
 	struct ntb_transport_qp *qp = (struct ntb_transport_qp *)data;
-	int rc;
+	int rc, i;
 
-	do {
+	/* Limit the number of packets processed in a single interrupt to
+	 * provide fairness to others
+	 */
+	for (i = 0; i < qp->rx_max_entry; i++) {
 		rc = ntb_process_rxc(qp);
-	} while (!rc);
+		if (rc)
+			break;
+	}
 }
 
 static void ntb_transport_rxc_db(void *data, int db_num)


