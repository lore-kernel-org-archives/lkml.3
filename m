Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaKERqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:46:25 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:52305 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaKERqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:46:18 -0500
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Jim Paris <jim@jtan.com>,
        Oliver Neukum <oneukum@suse.de>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH Resend] USB: cdc-acm: only raise DTR on transitions from B0
Date: Wed,  5 Nov 2014 18:41:59 +0100
Message-Id: <1415209319-14076-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1414596640-28555-1-git-send-email-johan@kernel.org>
References: <1414596640-28555-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure to only raise DTR on transitions from B0 in set_termios.

Also allow set_termios to be called from open with a termios_old of
NULL. Note that DTR will not be raised prematurely in this case.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---

Greg,

I just noticed that this one did not make into usb-linus yet, although
24cb4502c97b ("cdc-acm: ensure that termios get set when the port is
activated"), which depend on this patch did.

Johan


 drivers/usb/class/cdc-acm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 6771f884cb82..9d6495424b06 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -985,11 +985,12 @@ static void acm_tty_set_termios(struct tty_struct *tty,
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
-- 
2.0.4

