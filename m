Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936745Ab3DJBSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 21:18:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58315 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab3DJBSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 21:18:35 -0400
Message-ID: <5164BDE9.3010706@canonical.com>
Date: Tue, 09 Apr 2013 21:18:33 -0400
From: James M Leddy <james.leddy@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 1/1][RESUBMIT] input: fix weird issue of synaptics psmouse
 sync lost after resume
References: <1365553843-11951-1-git-send-email-james.leddy@canonical.com>
In-Reply-To: <1365553843-11951-1-git-send-email-james.leddy@canonical.com>
Content-Type: multipart/mixed;
 boundary="------------000803050402050403040205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000803050402050403040205
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Eric Miao <eric.miao@canonical.com>

In summary, the symptom is intermittent key events lost after resume
on some machines with synaptics touchpad (seems this is synaptics _only_),
and key events loss is due to serio port reconnect after psmouse sync lost.
Removing psmouse and inserting it back during the suspend/resume process
is able to work around the issue, so the difference between
psmouse_connect()
and psmouse_reconnect() is the key to the root cause of this problem.

After comparing the two different paths, synaptics driver has its own
implementation of synaptics_reconnect(), and the missing psmouse_probe()
seems significant, the patch below added psmouse_probe() to the reconnect
process, and has been verified many times that the issue could not be
reliably
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

diff --git a/drivers/input/mouse/synaptics.c
b/drivers/input/mouse/synaptics.c
index 12d12ca..3438a9d 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1355,6 +1355,7 @@ static int synaptics_reconnect(struct psmouse
*psmouse)
 {
 	struct synaptics_data *priv = psmouse->private;
 	struct synaptics_data old_priv = *priv;
+	unsigned char param[2];
 	int retry = 0;
 	int error;
 @@ -1370,6 +1371,7 @@ static int synaptics_reconnect(struct psmouse
*psmouse)
 			 */
 			ssleep(1);
 		}
+		ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETID);
 		error = synaptics_detect(psmouse, 0);
 	} while (error && ++retry < 3);
 -- 1.7.9.5




--------------000803050402050403040205
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------000803050402050403040205--
