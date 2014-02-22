Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaBVPAF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 10:00:05 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:64424 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaBVPAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 10:00:03 -0500
Date: Sat, 22 Feb 2014 09:59:59 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v2 5/9] usb: don't use PREPARE_DELAYED_WORK
Message-ID: <20140222145959.GF12830@htj.dyndns.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
 <1392929071-16555-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392929071-16555-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

If this is actually safe, let's do it from the get-go.

Thanks!
------- 8< -------
PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
and a nasty surprise in terms of reentrancy guarantee as workqueue
considers work items to be different if they don't have the same work
function.

usb_hub->init_work is multiplexed with multiple work functions;
however, the work item is never queued while in-flight, so we can
simply use INIT_DELAYED_WORK() before each queueing.

It would probably be best to route this with other related updates
through the workqueue tree.

Lightly tested.

v2: Greg and Alan confirm that the work item is never queued while
    in-flight.  Simply use INIT_DELAYED_WORK().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/core/hub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1040,7 +1040,7 @@ static void hub_activate(struct usb_hub
 		 */
 		if (type == HUB_INIT) {
 			delay = hub_power_on(hub, false);
-			PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func2);
+			INIT_DELAYED_WORK(&hub->init_work, hub_init_func2);
 			schedule_delayed_work(&hub->init_work,
 					msecs_to_jiffies(delay));
 
@@ -1194,7 +1194,7 @@ static void hub_activate(struct usb_hub
 
 		/* Don't do a long sleep inside a workqueue routine */
 		if (type == HUB_INIT2) {
-			PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func3);
+			INIT_DELAYED_WORK(&hub->init_work, hub_init_func3);
 			schedule_delayed_work(&hub->init_work,
 					msecs_to_jiffies(delay));
 			return;		/* Continues at init3: below */
