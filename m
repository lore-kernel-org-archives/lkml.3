Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbaJIVFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:05:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59008 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512AbaJIVFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:05:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 136/163] md/raid1: fix_read_error should act on all non-faulty devices.
Date: Thu,  9 Oct 2014 14:02:41 -0700
Message-Id: <1412888588-26755-137-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit b8cb6b4c121e1bf1963c16ed69e7adcb1bc301cd upstream.

If a devices is being recovered it is not InSync and is not Faulty.

If a read error is experienced on that device, fix_read_error()
will be called, but it ignores non-InSync devices.  So it will
neither fix the error nor fail the device.

It is incorrect that fix_read_error() ignores non-InSync devices.
It should only ignore Faulty devices.  So fix it.

This became a bug when we allowed reading from a device that was being
recovered.  It is suitable for any subsequent -stable kernel.

Fixes: da8840a747c0dbf49506ec906757a6b87b9741e9
Reported-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Tested-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2cf4f69..e4885c0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2154,7 +2154,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			d--;
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
-			    test_bit(In_sync, &rdev->flags))
+			    !test_bit(Faulty, &rdev->flags))
 				r1_sync_page_io(rdev, sect, s,
 						conf->tmppage, WRITE);
 		}
@@ -2166,7 +2166,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			d--;
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
-			    test_bit(In_sync, &rdev->flags)) {
+			    !test_bit(Faulty, &rdev->flags)) {
 				if (r1_sync_page_io(rdev, sect, s,
 						    conf->tmppage, READ)) {
 					atomic_add(s, &rdev->corrected_errors);
-- 
1.9.1

