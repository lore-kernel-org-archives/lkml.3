Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaJCJnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:43:49 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44469 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaJCJnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:43:46 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 3/3] input: alps: Reset mouse and ALPS driver immediately after first invalid packet
Date: Fri,  3 Oct 2014 11:43:12 +0200
Message-Id: <1412329392-5580-4-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For unknown reasons linux psmouse alps driver sometimes receive totally invalid
packet sequences on Dell Latitude laptops. According to ALPS HW engineers these
invalid packets do not come from ALPS devices. So it looks like bug in BIOS and
EC incorrectly split keyboard and touchpad PS/2 data when laptops are under
heavy loads (big I/O together with powersave governor, running on battery).

There are sequences of invalid packets (which are dropeed) and some sequences
which look like valid. But these valid packets cause random trackstick button
pressing, random cursor moving/jumping and in these condition it is not possible
to use ALPS device (trackstick+touchpad).

To prevent random button press and random cursor jumps immediately reset ALPS
device after first invalid packet. This will cause that touchpad and trackstick
will not respond for one or two seconds and it better then random cursor jumps.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/input/mouse/alps.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index b1f44d4..d2b144f 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2399,6 +2399,10 @@ int alps_init(struct psmouse *psmouse)
 	/* We are having trouble resyncing ALPS touchpads so disable it for now */
 	psmouse->resync_time = 0;
 
+	/* Reset immediately after bad packet. When bad packet arrives then
+	   cursor pointer jumps and trackstick buttons are randomly pressed. */
+	psmouse->resetafter = 1;
+
 	return 0;
 
 init_fail:
-- 
1.7.9.5

