Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742AbaKLCB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:01:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161153AbaKLB4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:56:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 086/123] USB: cdc-acm: only raise DTR on transitions from B0
Date: Wed, 12 Nov 2014 10:17:32 +0900
Message-Id: <20141112011722.909399891@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 4473d054ceb572557954f9536731d39b20937b0c upstream.

Make sure to only raise DTR on transitions from B0 in set_termios.

Also allow set_termios to be called from open with a termios_old of
NULL. Note that DTR will not be raised prematurely in this case.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -883,11 +883,12 @@ static void acm_tty_set_termios(struct t
 	/* FIXME: Needs to clear unsupported bits in the termios */
 	acm->clocal = ((termios->c_cflag & CLOCAL) != 0);
 
-	if (!newline.dwDTERate) {
+	if (C_BAUD(tty) == B0) {
 		newline.dwDTERate = acm->line.dwDTERate;
 		newctrl &= ~ACM_CTRL_DTR;
-	} else
+	} else if (termios_old && (termios_old->c_cflag & CBAUD) == B0) {
 		newctrl |=  ACM_CTRL_DTR;
+	}
 
 	if (newctrl != acm->ctrlout)
 		acm_set_control(acm, acm->ctrlout = newctrl);


