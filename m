Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3I3KVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:21:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43714 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab3I3KNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Kosina <jkosina@suse.cz>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 073/104] HID: input: return ENODATA if reading battery attrs fails
Date: Mon, 30 Sep 2013 11:10:50 +0100
Message-Id: <1380535881-9239-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Herrmann <dh.herrmann@gmail.com>

commit d0a934b764c67b4bf626f5b7cf725a6e3066afd2 upstream.

power_supply core has the bad habit of calling our battery callbacks
from within power_supply_register(). Furthermore, if the callbacks
fail with an unhandled error code, it will skip any uevent that it
might currently process.
So if HID-core registers battery devices, an "add" uevent is generated
and the battery callbacks are called. These will gracefully fail due
to timeouts as they might still hold locks on event processing. One
could argue that this should be fixed in power_supply core, but the
least we can do is to signal ENODATA so power_supply core will just
skip the property and continue with the uevent.

This fixes a bug where "add" and "remove" uevents are skipped for
battery devices. upower is unable to track these devices and currently
needs to ignore them.

This patch also overwrites any other error code. I cannot see any reason
why we should forward protocol- or I/O-errors to the power_supply core.
We handle these errors in hid_ll_driver later, anyway, so just skip
them. power_supply core cannot do anything useful with them, anyway,
and we avoid skipping important uevents and confusing user-space.

Thanks a lot to Daniel Nicoletti for pushing and investigating
on this.

Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Reported-by: Daniel Nicoletti <dantti12@gmail.com>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[ luis: 3.5.y-prereq for:
  6c2794a HID: battery: don't do DMA from stack ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 5301006..73f2f7c 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -339,10 +339,10 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 					      dev->battery_report_type);
 
 		if (ret != 2) {
-			if (ret >= 0)
-				ret = -EINVAL;
+			ret = -ENODATA;
 			break;
 		}
+		ret = 0;
 
 		if (dev->battery_min < dev->battery_max &&
 		    buf[1] >= dev->battery_min &&
-- 
1.8.3.2

