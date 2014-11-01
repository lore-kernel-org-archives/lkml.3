Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaKAX0J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:26:09 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:44468 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaKAX0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 19:26:04 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v3 2/4] input: alps: Allow 2 invalid packets without resetting device
Date: Sun,  2 Nov 2014 00:25:08 +0100
Message-Id: <1414884310-19842-3-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414884310-19842-1-git-send-email-pali.rohar@gmail.com>
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
 <1414884310-19842-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some Dell Latitude laptops ALPS device or Dell EC send one invalid byte in
6 bytes ALPS packet. In this case psmouse driver enter out of sync state. It
looks like that all other bytes in packets are valid and also device working
properly. So there is no need to do full device reset, just need to wait
for byte which match condition for first byte (start of packet). Because ALPS
packets are bigger (6 or 8 bytes) default limit is small.

This patch increase number of invalid bytes to size of 2 ALPS packets which
psmouse driver can drop before do full reset.

Resetting ALPS devices take some time and when doing reset on some Dell laptops
touchpad, trackstick and also keyboard do not respond. So it is better to do it
only if really necessary.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/input/mouse/alps.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index a772745..7c47e97 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2391,6 +2391,9 @@ int alps_init(struct psmouse *psmouse)
 	/* We are having trouble resyncing ALPS touchpads so disable it for now */
 	psmouse->resync_time = 0;
 
+	/* Allow 2 invalid packets without resetting device */
+	psmouse->resetafter = psmouse->pktsize * 2;
+
 	return 0;
 
 init_fail:
-- 
1.7.9.5

