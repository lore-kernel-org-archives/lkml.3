Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaKYLGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:06:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaKYKmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 183/254] Input: alps - allow up to 2 invalid packets without resetting device
Date: Tue, 25 Nov 2014 10:38:53 +0000
Message-Id: <1416912004-5928-184-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/mouse/alps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 873c0e024889..fdffac9f741d 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2154,6 +2154,9 @@ int alps_init(struct psmouse *psmouse)
 	/* We are having trouble resyncing ALPS touchpads so disable it for now */
 	psmouse->resync_time = 0;
 
+	/* Allow 2 invalid packets without resetting device */
+	psmouse->resetafter = psmouse->pktsize * 2;
+
 	return 0;
 
 init_fail:
-- 
2.1.0

