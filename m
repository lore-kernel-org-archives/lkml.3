Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936176Ab3DJAaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:30:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58097 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935194Ab3DJAar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:30:47 -0400
From: James M Leddy <james.leddy@canonical.com>
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Cc: haitao.zhang@canonical.com
Subject: [PATCH 1/1][RESUBMIT] input: fix weird issue of synaptics psmouse sync lost after resume
Date: Tue,  9 Apr 2013 20:30:43 -0400
Message-Id: <1365553843-11951-2-git-send-email-james.leddy@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365553843-11951-1-git-send-email-james.leddy@canonical.com>
References: <1365553843-11951-1-git-send-email-james.leddy@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@canonical.com>

In summary, the symptom is intermittent key events lost after resume
on some machines with synaptics touchpad (seems this is synaptics _only_),
and key events loss is due to serio port reconnect after psmouse sync lost.
Removing psmouse and inserting it back during the suspend/resume process
is able to work around the issue, so the difference between psmouse_connect()
and psmouse_reconnect() is the key to the root cause of this problem.

After comparing the two different paths, synaptics driver has its own
implementation of synaptics_reconnect(), and the missing psmouse_probe()
seems significant, the patch below added psmouse_probe() to the reconnect
process, and has been verified many times that the issue could not be reliably
reproduced.

There are two PS/2 commands in psmouse_probe():

  1. PSMOUSE_CMD_GETID
  2. PSMOUSE_CMD_RESET_DIS

Only the PSMOUSE_CMD_GETID seems to be significant. The
PSMOUSE_CMD_RESET_DIS is irrelevant to this issue after trying
several times.  So we have only implemented this patch to issue
the PSMOUSE_CMD_GETID so far.

Tested-by: Daniel Manrique <daniel.manrique@canonical.com>
Signed-off-by: James M Leddy <james.leddy@canonical.com>
---
 drivers/input/mouse/synaptics.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 12d12ca..3438a9d 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1355,6 +1355,7 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 {
 	struct synaptics_data *priv = psmouse->private;
 	struct synaptics_data old_priv = *priv;
+	unsigned char param[2];
 	int retry = 0;
 	int error;
 
@@ -1370,6 +1371,7 @@ static int synaptics_reconnect(struct psmouse *psmouse)
 			 */
 			ssleep(1);
 		}
+		ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETID);
 		error = synaptics_detect(psmouse, 0);
 	} while (error && ++retry < 3);
 
-- 
1.7.9.5

