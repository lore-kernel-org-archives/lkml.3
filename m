Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3CREiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:38:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33664 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222Ab3CREbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:07 -0400
Message-Id: <20130318042147.339105936@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:15 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 31/82] HID: clean up quirk for Sony RF receivers
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Luis Vázquez Cao <fernando_b1@lab.ntt.co.jp>

commit 99d249021abd4341771523ed8dd7946276103432 upstream.

Document what the fix-up is does and make it more robust by ensuring
that it is only applied to the USB interface that corresponds to the
mouse (sony_report_fixup() is called once per interface during probing).

Cc: linux-input@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-sony.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -44,9 +44,19 @@ static __u8 *sony_report_fixup(struct hi
 {
 	struct sony_sc *sc = hid_get_drvdata(hdev);
 
-	if ((sc->quirks & VAIO_RDESC_CONSTANT) &&
-			*rsize >= 56 && rdesc[54] == 0x81 && rdesc[55] == 0x07) {
+	/*
+	 * Some Sony RF receivers wrongly declare the mouse pointer as a
+	 * a constant non-data variable.
+	 */
+	if ((sc->quirks & VAIO_RDESC_CONSTANT) && *rsize >= 56 &&
+	    /* usage page: generic desktop controls */
+	    /* rdesc[0] == 0x05 && rdesc[1] == 0x01 && */
+	    /* usage: mouse */
+	    rdesc[2] == 0x09 && rdesc[3] == 0x02 &&
+	    /* input (usage page for x,y axes): constant, variable, relative */
+	    rdesc[54] == 0x81 && rdesc[55] == 0x07) {
 		hid_info(hdev, "Fixing up Sony RF Receiver report descriptor\n");
+		/* input: data, variable, relative */
 		rdesc[55] = 0x06;
 	}
 


