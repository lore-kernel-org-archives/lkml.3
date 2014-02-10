Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaBJCV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:21:59 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39607 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaBJCUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:20:34 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 05/24] Bluetooth: Fix racy acquire of rfcomm_dev reference
Date: Sun,  9 Feb 2014 20:59:05 -0500
Message-Id: <1391997564-1805-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfcomm_dev_get() can return a rfcomm_dev reference for a
device for which destruction may be commencing. This can happen
on tty destruction, which calls rfcomm_tty_cleanup(), the last
port reference may have been released but RFCOMM_TTY_RELEASED
was not set. The following race is also possible:

CPU 0                            | CPU 1
                                 | rfcomm_release_dev
rfcomm_dev_get                   |   .
  spin_lock                      |   .
    dev  = __rfcomm_dev_get      |   .
    if dev                       |   .
      if test_bit(TTY_RELEASED)  |   .
                                 |   !test_and_set_bit(TTY_RELEASED)
                                 |     tty_port_put   <<<< last reference
      else                       |
        tty_port_get             |

The reference acquire is bogus because destruction will commence
with the release of the last reference.

Ignore the external state change of TTY_RELEASED and instead rely
on the reference acquire itself to determine if the reference is
valid.

Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index a535ef1..7cf193f 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -157,12 +157,8 @@ static struct rfcomm_dev *rfcomm_dev_get(int id)
 
 	dev = __rfcomm_dev_get(id);
 
-	if (dev) {
-		if (test_bit(RFCOMM_TTY_RELEASED, &dev->flags))
-			dev = NULL;
-		else
-			tty_port_get(&dev->port);
-	}
+	if (dev && !tty_port_get(&dev->port))
+		dev = NULL;
 
 	spin_unlock(&rfcomm_dev_lock);
 
-- 
1.8.1.2

