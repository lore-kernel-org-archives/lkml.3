Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737AbaLLGhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:37:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51887 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759297AbaLLGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.641056798@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 115/164] USB: cdc-acm: only raise DTR on transitions
 from B0
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 4473d054ceb572557954f9536731d39b20937b0c upstream.

Make sure to only raise DTR on transitions from B0 in set_termios.

Also allow set_termios to be called from open with a termios_old of
NULL. Note that DTR will not be raised prematurely in this case.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -819,11 +819,12 @@ static void acm_tty_set_termios(struct t
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

