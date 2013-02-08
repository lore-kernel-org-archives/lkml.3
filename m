Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab3BHBR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:17:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759170Ab3BHA5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [ 23/34] USB: EHCI: remove ASS/PSS polling timeout
Date: Thu,  7 Feb 2013 16:57:19 -0800
Message-Id: <20130208004631.149937738@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 55bcdce8a8228223ec4d17d8ded8134ed265d2c5 upstream.

This patch (as1647) attempts to work around a problem that seems to
affect some nVidia EHCI controllers.  They sometimes take a very long
time to turn off their async or periodic schedules.  I don't know if
this is a result of other problems, but in any case it seems wise not
to depend on schedule enables or disables taking effect in any
specific length of time.

The patch removes the existing 20-ms timeout for enabling and
disabling the schedules.  The driver will now continue to poll the
schedule state at 1-ms intervals until the controller finally decides
to obey the most recent command issued by the driver.  Just in case
this hides a problem, a debugging message will be logged if the
controller takes longer than 20 polls.

I don't know if this will actually fix anything, but it can't hurt.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-timer.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/usb/host/ehci-timer.c
+++ b/drivers/usb/host/ehci-timer.c
@@ -113,14 +113,15 @@ static void ehci_poll_ASS(struct ehci_hc
 
 	if (want != actual) {
 
-		/* Poll again later, but give up after about 20 ms */
-		if (ehci->ASS_poll_count++ < 20) {
-			ehci_enable_event(ehci, EHCI_HRTIMER_POLL_ASS, true);
-			return;
-		}
-		ehci_dbg(ehci, "Waited too long for the async schedule status (%x/%x), giving up\n",
-				want, actual);
+		/* Poll again later */
+		ehci_enable_event(ehci, EHCI_HRTIMER_POLL_ASS, true);
+		++ehci->ASS_poll_count;
+		return;
 	}
+
+	if (ehci->ASS_poll_count > 20)
+		ehci_dbg(ehci, "ASS poll count reached %d\n",
+				ehci->ASS_poll_count);
 	ehci->ASS_poll_count = 0;
 
 	/* The status is up-to-date; restart or stop the schedule as needed */
@@ -159,14 +160,14 @@ static void ehci_poll_PSS(struct ehci_hc
 
 	if (want != actual) {
 
-		/* Poll again later, but give up after about 20 ms */
-		if (ehci->PSS_poll_count++ < 20) {
-			ehci_enable_event(ehci, EHCI_HRTIMER_POLL_PSS, true);
-			return;
-		}
-		ehci_dbg(ehci, "Waited too long for the periodic schedule status (%x/%x), giving up\n",
-				want, actual);
+		/* Poll again later */
+		ehci_enable_event(ehci, EHCI_HRTIMER_POLL_PSS, true);
+		return;
 	}
+
+	if (ehci->PSS_poll_count > 20)
+		ehci_dbg(ehci, "PSS poll count reached %d\n",
+				ehci->PSS_poll_count);
 	ehci->PSS_poll_count = 0;
 
 	/* The status is up-to-date; restart or stop the schedule as needed */


