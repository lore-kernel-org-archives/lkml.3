Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3CATpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:45:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3CATpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 58/77] HID: clean up quirk for Sony RF receivers
Date: Fri,  1 Mar 2013 11:44:43 -0800
Message-Id: <20130301194358.088642415@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Luis Vázquez Cao <fernando_b1@lab.ntt.co.jp>

commit 99d249021abd4341771523ed8dd7946276103432 upstream.

Document what the fix-up is does and make it more robust by ensuring
that it is only applied to the USB interface that corresponds to the
mouse (sony_report_fixup() is called once per interface during probing).

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-sony.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
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
 


