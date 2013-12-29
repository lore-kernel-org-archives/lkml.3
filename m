Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab3L2DET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:04:19 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58803 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3L2DER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 22:04:17 -0500
Date: Sun, 29 Dec 2013 11:03:18 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, airlied@redhat.com, akpm@linux-foundation.org,
        kilobyte@angband.pl, linux-kernel@vger.kernel.org
Subject: [PATCH] vt: fix potential dual con_driver register for conswitchp
Message-ID: <20131229030318.GA31264@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, airlied@redhat.com,
	akpm@linux-foundation.org, kilobyte@angband.pl,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should check whether conswitchp is registered before
add it to registered_con_driver in con_init, or it will
cause dual con_driver register for conswitchp.

Although I haven't met it in reality, but I think it could
happen for Embeded devices, who register platform con_driver
earlier than call con_init.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/vt/vt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index edcd6b8..3de4504 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2876,6 +2876,8 @@ static int __init con_init(void)
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
 		struct con_driver *con_driver = &registered_con_driver[i];
 
+		if (con_driver->con == conswitchp)
+			break;
 		if (con_driver->con == NULL) {
 			con_driver->con = conswitchp;
 			con_driver->desc = display_desc;
-- 
1.8.3.4.8.g69490f3.dirty
