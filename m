Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaABMLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:11:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59128 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaABMIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH, RFC 11/30] staging: panel: fix interruptible_sleep_on race
Date: Thu,  2 Jan 2014 13:07:35 +0100
Message-Id: <1388664474-1710039-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/6jFTI3qZ1X94akqZOZQAwYAEZxoyBri0TreDHDmu6j
 Ey4r4Bw37djf272lEtIbSHX7zAK2FaxQmBgkCUGxZCz2h5Rpdz
 cZCSeZ0B9WUDWAS2Zyu6Tp/oNBurzGqTSKBCgXuwq38LbHudcd
 z61o8nRWTticC1LYlJZT3xVWUwOYX9IsXZrKvbApkYrnztIeVI
 5uI0hq1LXeOh3xnE0cA+aLLcz7rEmOzQDXuE2C2132TIg4kmTv
 /POYs+Ml4diFKKWkmCjQgCRHqM6VLIra4LAk1xRBKcdf/MGJ1W
 W7/z9tr/tYIanC+j9Mn+qz7H6FQpvDnxiLa9r5VEfhxEIzMR3f
 MiT3KF9yTtU7Parylf5RlJS4/ZV+O5x4VsE1NoyIg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interruptible_sleep_on is racy and going away. This replaces the one
caller in the panel driver with the appropriate wait_event_interruptible
variant.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: devel@driverdev.osuosl.org
Cc: Willy Tarreau <willy@meta-x.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/panel/panel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index cbc15c1..ec4b1fd 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1590,8 +1590,8 @@ static ssize_t keypad_read(struct file *file,
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
-		interruptible_sleep_on(&keypad_read_wait);
-		if (signal_pending(current))
+		if (wait_event_interruptible(keypad_read_wait,
+					     keypad_buflen != 0))
 			return -EINTR;
 	}
 
-- 
1.8.3.2

