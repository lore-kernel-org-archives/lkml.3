Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbaKYL7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:59:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58135 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaKYKkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 035/254] USB: cdc-acm: only raise DTR on transitions from B0
Date: Tue, 25 Nov 2014 10:36:25 +0000
Message-Id: <1416912004-5928-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 4473d054ceb572557954f9536731d39b20937b0c upstream.

Make sure to only raise DTR on transitions from B0 in set_termios.

Also allow set_termios to be called from open with a termios_old of
NULL. Note that DTR will not be raised prematurely in this case.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 959343b891c7..c14814fb1e75 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -980,11 +980,12 @@ static void acm_tty_set_termios(struct tty_struct *tty,
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
2.1.0

