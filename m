Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3CDEI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:08:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32777 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756122Ab3CDDnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:15 -0500
Message-Id: <20130304033718.612508615@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:59 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 112/153] firewire: add minor number range check to fw_device_init()
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 3bec60d511179853138836ae6e1b61fe34d9235f upstream.

fw_device_init() didn't check whether the allocated minor number isn't
too large.  Fail if it goes overflows MINORBITS.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firewire/core-device.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -995,6 +995,10 @@ static void fw_device_init(struct work_s
 	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
 	      idr_get_new(&fw_device_idr, device, &minor) :
 	      -ENOMEM;
+	if (minor >= 1 << MINORBITS) {
+		idr_remove(&fw_device_idr, minor);
+		minor = -ENOSPC;
+	}
 	up_write(&fw_device_rwsem);
 
 	if (ret < 0)


