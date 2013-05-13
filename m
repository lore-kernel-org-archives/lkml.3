Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3EMPBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:01:34 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:62771 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3EMPBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:01:32 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] HID: input: return ENODATA if reading battery attrs fails
Date: Mon, 13 May 2013 17:01:30 +0200
Message-Id: <1368457290-1734-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
Hi

I really dislike the way power_supply core calls into the drivers during the
"add" uevent. If a driver holds an I/O mutex (or anything else), it might
even deadlock in a very non-obvious way. Is there a reason why we need to
pass _all_ battery properties along "add" and "remove" uevents? Isn't it
enough to pass them with "change" uevents? This would guarantee that the
power_supply callbacks are only called from user-context and "change" events.

Anyway, I'd still like to see this patch applied so we have this annoying
bug fixed. I'd be willing to change the power_supply core, too, if one of the
maintainers agrees on the design (David? Anton?).

And, @Daniel, can you check whether this actually fixes the bug? I don't own
a device that reports battery-information, but it at least fixes the same bug
for the hid-wiimote driver (tested by me).

Cheers
David

 drivers/hid/hid-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 945b815..c526a3c 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -354,10 +354,10 @@ static int hidinput_get_battery_property(struct power_supply *psy,
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
1.8.2.3

