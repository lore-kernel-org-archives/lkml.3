Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965256AbaLLGmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:42:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51851 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759023AbaLLGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:55 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Hans de Goede" <hdegoede@redhat.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "=?UTF-8?q?Pali=20Roh=C3=A1r?=" <pali.rohar@gmail.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.567526836@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 121/164] Input: alps - allow up to 2 invalid packets
 without resetting device
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali.rohar@gmail.com>

commit 9d720b34c0a432639252f63012e18b0507f5b432 upstream.

On some Dell Latitude laptops ALPS device or Dell EC send one invalid byte
in 6 bytes ALPS packet. In this case psmouse driver enter out of sync
state. It looks like that all other bytes in packets are valid and also
device working properly. So there is no need to do full device reset, just
need to wait for byte which match condition for first byte (start of
packet). Because ALPS packets are bigger (6 or 8 bytes) default limit is
small.

This patch increase number of invalid bytes to size of 2 ALPS packets which
psmouse driver can drop before do full reset.

Resetting ALPS devices take some time and when doing reset on some Dell
laptops touchpad, trackstick and also keyboard do not respond. So it is
better to do it only if really necessary.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/alps.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -751,6 +751,9 @@ int alps_init(struct psmouse *psmouse)
 	/* We are having trouble resyncing ALPS touchpads so disable it for now */
 	psmouse->resync_time = 0;
 
+	/* Allow 2 invalid packets without resetting device */
+	psmouse->resetafter = psmouse->pktsize * 2;
+
 	return 0;
 
 init_fail:

