Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbaJCWF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:05:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbaJCWEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:04:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Lyakas <alex.bolshoy@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.16 335/357] md/raid1: fix_read_error should act on all non-faulty devices.
Date: Fri,  3 Oct 2014 14:32:01 -0700
Message-Id: <20141003212943.518670835@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2154,7 +2154,7 @@ static void fix_read_error(struct r1conf
 			d--;
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
-			    test_bit(In_sync, &rdev->flags))
+			    !test_bit(Faulty, &rdev->flags))
 				r1_sync_page_io(rdev, sect, s,
 						conf->tmppage, WRITE);
 		}
@@ -2166,7 +2166,7 @@ static void fix_read_error(struct r1conf
 			d--;
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
-			    test_bit(In_sync, &rdev->flags)) {
+			    !test_bit(Faulty, &rdev->flags)) {
 				if (r1_sync_page_io(rdev, sect, s,
 						    conf->tmppage, READ)) {
 					atomic_add(s, &rdev->corrected_errors);


