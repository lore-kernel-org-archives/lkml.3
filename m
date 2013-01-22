Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3AVGVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 01:21:30 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:52966 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3AVGV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 01:21:28 -0500
Message-ID: <1358835638.6336.1.camel@nexus.lab.ntt.co.jp>
Subject: HID: clean up quirk for Sony RF receivers
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antonio Ospite <ospite@studenti.unina.it>
Date: Tue, 22 Jan 2013 15:20:38 +0900
In-Reply-To: <50FE2A34.3050607@lab.ntt.co.jp>
References: <1358221428.9926.1.camel@nexus.lab.ntt.co.jp>
	  <20130115103638.be566e39f0f5ad7186362dd8@studenti.unina.it>
	  <50F52986.2080002@lab.ntt.co.jp>
	  <1358246448.4897.3.camel@nexus.lab.ntt.co.jp>
	  <alpine.LNX.2.00.1301151702150.7734@pobox.suse.cz>
	  <50F637D1.8070302@lab.ntt.co.jp>
	  <alpine.LNX.2.00.1301161141250.14768@pobox.suse.cz>
	 <50FE2A34.3050607@lab.ntt.co.jp>
Organization: NTT Open Source Software Center
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document what the fix-up is does and make it more robust by ensuring
that it is only applied to the USB interface that corresponds to the
mouse (sony_report_fixup() is called once per interface during probing).

Cc: linux-input@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

diff -urNp linux-3.8-rc4-orig/drivers/hid/hid-sony.c linux-3.8-rc4/drivers/hid/hid-sony.c
--- linux-3.8-rc4-orig/drivers/hid/hid-sony.c	2013-01-22 14:21:13.380552283 +0900
+++ linux-3.8-rc4/drivers/hid/hid-sony.c	2013-01-22 14:41:56.316934002 +0900
@@ -43,9 +43,19 @@ static __u8 *sony_report_fixup(struct hi
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
 


