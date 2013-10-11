Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab3JKItc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:49:32 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:50332 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3JKIt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:49:29 -0400
Message-ID: <5257BA10.2010607@onera.fr>
Date: Fri, 11 Oct 2013 10:42:56 +0200
From: Paul Chavent <Paul.Chavent@onera.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pps : add non blocking option to PPS_FETCH ioctl.
References: <1378282838-2292-1-git-send-email-paul.chavent@onera.fr> <20130906065509.GA6627@enneenne.com>
In-Reply-To: <20130906065509.GA6627@enneenne.com>
Content-Type: multipart/mixed;
 boundary="------------010405030409000407010501"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Fri, 11 Oct 2013 10:49:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010405030409000407010501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

I haven't had any feedback for weeks. I join a patch with more details 
in the commit message if needed.

Do you know someone responsible to apply PPS patches ?

Regards.

Paul.

On 09/06/2013 08:55 AM, Rodolfo Giometti wrote:
> On Wed, Sep 04, 2013 at 10:20:38AM +0200, Paul Chavent wrote:
>> Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
>
> Acked: Rodolfo Giometti <giometti@enneenne.com>
>

--------------010405030409000407010501
Content-Type: text/x-patch;
 name="0001-pps-add-non-blocking-option-to-PPS_FETCH-ioctl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-pps-add-non-blocking-option-to-PPS_FETCH-ioctl.patch"

>From 370fca528140f879957a1b717fe9c13855d5c7f7 Mon Sep 17 00:00:00 2001
From: Paul Chavent <paul.chavent@onera.fr>
Date: Wed, 4 Sep 2013 10:09:43 +0200
Subject: [PATCH] pps : add non blocking option to PPS_FETCH ioctl (v2).

This new version add a commit message with more details.

The PPS_FETCH ioctl is blocking still the reception of a pps
event. But, in some case, one may need the last event date
immediately. This patch allow to get the result of PPS_FETCH if the
device has the O_NONBLOCK flag set.

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
---
 drivers/pps/pps.c | 57 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 2f07cd6..983f50c 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -152,35 +152,38 @@ static long pps_cdev_ioctl(struct file *file,
 		if (err)
 			return -EFAULT;
 
-		ev = pps->last_ev;
-
-		/* Manage the timeout */
-		if (fdata.timeout.flags & PPS_TIME_INVALID)
-			err = wait_event_interruptible(pps->queue,
-					ev != pps->last_ev);
-		else {
-			unsigned long ticks;
-
-			dev_dbg(pps->dev, "timeout %lld.%09d\n",
-					(long long) fdata.timeout.sec,
-					fdata.timeout.nsec);
-			ticks = fdata.timeout.sec * HZ;
-			ticks += fdata.timeout.nsec / (NSEC_PER_SEC / HZ);
-
-			if (ticks != 0) {
-				err = wait_event_interruptible_timeout(
-						pps->queue,
-						ev != pps->last_ev,
-						ticks);
-				if (err == 0)
-					return -ETIMEDOUT;
+		if (!(file->f_flags & O_NONBLOCK)) {
+			ev = pps->last_ev;
+
+			/* Manage the timeout */
+			if (fdata.timeout.flags & PPS_TIME_INVALID)
+				err = wait_event_interruptible(pps->queue,
+						ev != pps->last_ev);
+			else {
+				unsigned long ticks;
+
+				dev_dbg(pps->dev, "timeout %lld.%09d\n",
+						(long long) fdata.timeout.sec,
+						fdata.timeout.nsec);
+				ticks = fdata.timeout.sec * HZ;
+				ticks += fdata.timeout.nsec /
+					(NSEC_PER_SEC / HZ);
+
+				if (ticks != 0) {
+					err = wait_event_interruptible_timeout(
+							pps->queue,
+							ev != pps->last_ev,
+							ticks);
+					if (err == 0)
+						return -ETIMEDOUT;
+				}
 			}
-		}
 
-		/* Check for pending signals */
-		if (err == -ERESTARTSYS) {
-			dev_dbg(pps->dev, "pending signal caught\n");
-			return -EINTR;
+			/* Check for pending signals */
+			if (err == -ERESTARTSYS) {
+				dev_dbg(pps->dev, "pending signal caught\n");
+				return -EINTR;
+			}
 		}
 
 		/* Return the fetched timestamp */
-- 
1.7.12.1


--------------010405030409000407010501--
