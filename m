Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab3CLWdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab3CLWcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 005/100] USB: EHCI: revert "remove ASS/PSS polling timeout"
Date: Tue, 12 Mar 2013 15:30:50 -0700
Message-Id: <20130312223123.482987282@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 221f8dfca89276d8aec54c6d07fbe20c281668f0 upstream.

This patch (as1649) reverts commit
55bcdce8a8228223ec4d17d8ded8134ed265d2c5 (USB: EHCI: remove ASS/PSS
polling timeout).  That commit was written under the assumption that
some controllers may take a very long time to turn off their async and
periodic schedules.  It now appears that in fact the schedules do get
turned off reasonably quickly, but some controllers occasionally leave
the schedules' status bits turned on and consequently ehci-hcd can't
tell that the schedules are off.

VIA controllers in particular have this problem.  ehci-hcd tells the
hardware to turn off the async schedule, the schedule does get turned
off, but the status bit remains on.  Since the EHCI spec requires that
the schedules not be re-enabled until the previous disable has taken
effect, with an unlimited timeout the async schedule never gets turned
back on.  The resulting symptom is that the system is unable to
communicate with USB devices.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Ronald <ronald645@gmail.com>
Reported-and-tested-by: Paul Hartman <paul.hartman@gmail.com>
Reported-and-tested-by: Dieter Nützel <dieter@nuetzel-hh.de>
Reported-and-tested-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-timer.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/drivers/usb/host/ehci-timer.c
+++ b/drivers/usb/host/ehci-timer.c
@@ -113,15 +113,14 @@ static void ehci_poll_ASS(struct ehci_hc
 
 	if (want != actual) {
 
-		/* Poll again later */
-		ehci_enable_event(ehci, EHCI_HRTIMER_POLL_ASS, true);
-		++ehci->ASS_poll_count;
-		return;
+		/* Poll again later, but give up after about 20 ms */
+		if (ehci->ASS_poll_count++ < 20) {
+			ehci_enable_event(ehci, EHCI_HRTIMER_POLL_ASS, true);
+			return;
+		}
+		ehci_dbg(ehci, "Waited too long for the async schedule status (%x/%x), giving up\n",
+				want, actual);
 	}
-
-	if (ehci->ASS_poll_count > 20)
-		ehci_dbg(ehci, "ASS poll count reached %d\n",
-				ehci->ASS_poll_count);
 	ehci->ASS_poll_count = 0;
 
 	/* The status is up-to-date; restart or stop the schedule as needed */
@@ -160,14 +159,14 @@ static void ehci_poll_PSS(struct ehci_hc
 
 	if (want != actual) {
 
-		/* Poll again later */
-		ehci_enable_event(ehci, EHCI_HRTIMER_POLL_PSS, true);
-		return;
+		/* Poll again later, but give up after about 20 ms */
+		if (ehci->PSS_poll_count++ < 20) {
+			ehci_enable_event(ehci, EHCI_HRTIMER_POLL_PSS, true);
+			return;
+		}
+		ehci_dbg(ehci, "Waited too long for the periodic schedule status (%x/%x), giving up\n",
+				want, actual);
 	}
-
-	if (ehci->PSS_poll_count > 20)
-		ehci_dbg(ehci, "PSS poll count reached %d\n",
-				ehci->PSS_poll_count);
 	ehci->PSS_poll_count = 0;
 
 	/* The status is up-to-date; restart or stop the schedule as needed */


