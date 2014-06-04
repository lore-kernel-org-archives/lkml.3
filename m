Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaFDXVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaFDXVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.14 095/228] Bluetooth: Fix triggering BR/EDR L2CAP Connect too early
Date: Wed,  4 Jun 2014 16:22:04 -0700
Message-Id: <20140604232351.100843025@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 9eb1fbfa0a737fd4d3a6d12d71c5ea9af622b887 upstream.

Commit 1c2e004183178 introduced an event handler for the encryption key
refresh complete event with the intent of fixing some LE/SMP cases.
However, this event is shared with BR/EDR and there we actually want to
act only on the auth_complete event (which comes after the key refresh).

If we do not do this we may trigger an L2CAP Connect Request too early
and cause the remote side to return a security block error.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3006,6 +3006,12 @@ static void hci_key_refresh_complete_evt
 	if (!conn)
 		goto unlock;
 
+	/* For BR/EDR the necessary steps are taken through the
+	 * auth_complete event.
+	 */
+	if (conn->type != LE_LINK)
+		goto unlock;
+
 	if (!ev->status)
 		conn->sec_level = conn->pending_sec_level;
 


