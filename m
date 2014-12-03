Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaLCLxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:53:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbaLCL1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:15 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 050/101] Input: alps - allow up to 2 invalid packets without resetting device
Date: Wed,  3 Dec 2014 12:26:12 +0100
Message-Id: <335d898edb25d9a470b9c75f194b7c5f564338d4.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/alps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 071bd835594c..19e070f16e6b 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -1822,6 +1822,9 @@ int alps_init(struct psmouse *psmouse)
 	/* We are having trouble resyncing ALPS touchpads so disable it for now */
 	psmouse->resync_time = 0;
 
+	/* Allow 2 invalid packets without resetting device */
+	psmouse->resetafter = psmouse->pktsize * 2;
+
 	return 0;
 
 init_fail:
-- 
2.1.3

