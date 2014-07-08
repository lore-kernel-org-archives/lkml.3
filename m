Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaGHT3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:29:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54174 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755705AbaGHTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Szymon Janc" <szymon.janc@tieto.com>,
        "Marcel Holtmann" <marcel@holtmann.org>,
        "Johan Hedberg" <johan.hedberg@intel.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.817580951@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 089/125] Bluetooth: Fix SSP acceptor just-works
 confirmation without MITM
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit ba15a58b179ed76a7e887177f2b06de12c58ec8f upstream.

=46romthe Bluetooth Core Specification 4.1 page 1958:

"if both devices have set the Authentication_Requirements parameter to
one of the MITM Protection Not Required options, authentication stage 1
shall function as if both devices set their IO capabilities to
DisplayOnly (e.g., Numeric comparison with automatic confirmation on
both devices)"

So far our implementation has done user confirmation for all just-works
cases regardless of the MITM requirements, however following the
specification to the word means that we should not be doing confirmation
when neither side has the MITM flag set.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Tested-by: Szymon Janc <szymon.janc@tieto.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
[bwh: Backported to 3.2: s/conn->flags/conn->pend/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/hci_event.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2690,8 +2690,11 @@ static inline void hci_user_confirm_requ
 
 		/* If we're not the initiators request authorization to
 		 * proceed from user space (mgmt_user_confirm with
-		 * confirm_hint set to 1). */
-		if (!test_bit(HCI_CONN_AUTH_PEND, &conn->pend)) {
+		 * confirm_hint set to 1). The exception is if neither
+		 * side had MITM in which case we do auto-accept.
+		 */
+		if (!test_bit(HCI_CONN_AUTH_PEND, &conn->pend) &&
+		    (loc_mitm || rem_mitm)) {
 			BT_DBG("Confirming auto-accept as acceptor");
 			confirm_hint = 1;
 			goto confirm;

