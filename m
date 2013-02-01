Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3BAI3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:29:13 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:63006 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab3BAI3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:29:09 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Seth Forshee <seth.forshee@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chung-Yih Wang <cywang@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH] Input: synaptics - fix 1->3 contact transition reporting
Date: Fri,  1 Feb 2013 16:29:00 +0800
Message-Id: <1359707340-13033-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Investigating the following gesture highlighted two slight implementation
errors with choosing which slots to report in which slot when multiple
contacts are present:

Action                 SGM  AGM (MTB slot:Contact)
1. Touch contact 0    (0:0)
2. Touch contact 1    (0:0, 1:1)
3. Lift  contact 0    (1:1)
4. Touch contacts 2,3 (0:2, 1:3)

In step 4, slot 1 was not being cleared first, which means the same
tracking ID was being used for reporting both the old contact 1 and the
new contact 3.  This could result in "drumroll", where the old contact 1
would appear to suddenly jump to new finger 3 position.

Similarly, if contacts 2 & 3 are not detected at the same sample, step 4
is split into two:

Action                SGM  AGM  (MTB slot:contact)
1. Touch contact 0   (0:0)
2. Touch contact 1   (0:0, 1:1)
3. Lift  contact 0   (1:1)
4. Touch contact 2   (0:2, 1:1)
5. Touch contact 3   (0:2, 1:3)

In this case, there was also a bug.  In step 4, when contact 1 moves from
SGM to AGM and contact 2 is first reported in SGM, slot 0 was actually
empty.  So slot 0 can be used to report the new SGM (contact 0),
immediately.  Since it was empty, contact 2 in slot 0 will get a new
tracking ID.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index b6c6838..47159d8 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -722,11 +722,13 @@ static void synaptics_report_mt_data(struct psmouse *psmouse,
 	default:
 		/*
 		 * If the finger slot contained in SGM is valid, and either
-		 * hasn't changed, or is new, then report SGM in MTB slot 0.
+		 * hasn't changed, or is new, or the old SGM has now moved to
+		 * AGM, then report SGM in MTB slot 0.
 		 * Otherwise, empty MTB slot 0.
 		 */
 		if (mt_state->sgm != -1 &&
-		    (mt_state->sgm == old->sgm || old->sgm == -1))
+		    (mt_state->sgm == old->sgm ||
+		     old->sgm == -1 || mt_state->agm == old->sgm))
 			synaptics_report_slot(dev, 0, sgm);
 		else
 			synaptics_report_slot(dev, 0, NULL);
@@ -735,9 +737,31 @@ static void synaptics_report_mt_data(struct psmouse *psmouse,
 		 * If the finger slot contained in AGM is valid, and either
 		 * hasn't changed, or is new, then report AGM in MTB slot 1.
 		 * Otherwise, empty MTB slot 1.
+		 *
+		 * However, in the case where the AGM is new, make sure that
+		 * that it is either the same as the old SGM, or there was no
+		 * SGM.
+		 *
+		 * Otherwise, if the SGM was just 1, and the new AGM is 2, then
+		 * the new AGM will keep the old SGM's tracking ID, which can
+		 * cause apparent drumroll.  This happens if in the following
+		 * valid finger sequence:
+		 *
+		 *  Action                 SGM  AGM (MTB slot:Contact)
+		 *  1. Touch contact 0    (0:0)
+		 *  2. Touch contact 1    (0:0, 1:1)
+		 *  3. Lift  contact 0    (1:1)
+		 *  4. Touch contacts 2,3 (0:2, 1:3)
+		 *
+		 * In step 4, contact 3, in AGM must not be given the same
+		 * tracking ID as contact 1 had in step 3.  To avoid this,
+		 * the first agm with contact 3 is dropped and slot 1 is
+		 * invalidated (tracking ID = -1).
 		 */
 		if (mt_state->agm != -1 &&
-		    (mt_state->agm == old->agm || old->agm == -1))
+		    (mt_state->agm == old->agm ||
+		     (old->agm == -1 &&
+		      (old->sgm == -1 || mt_state->agm == old->sgm))))
 			synaptics_report_slot(dev, 1, agm);
 		else
 			synaptics_report_slot(dev, 1, NULL);
-- 
1.8.1

