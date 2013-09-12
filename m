Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab3ILNWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:22:25 -0400
Received: from sam.nabble.com ([216.139.236.26]:59387 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab3ILNWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:22:24 -0400
Date: Thu, 12 Sep 2013 06:22:24 -0700 (PDT)
From: johnflux <johnflux@gmail.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1378992144394-718779.post@n7.nabble.com>
In-Reply-To: <52308D47.409@hurleysoftware.com>
References: <CAHQ6N+pQpfmG-b_9iv0Ajg5EYPjfEK0=KYcQa0DLVmyN8VKZrQ@mail.gmail.com> <52308D47.409@hurleysoftware.com>
Subject: Re: Deadlock in fb and tty
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following seems to be better:

>From d93c1e9761ff66365d658da7d8d0d33823aa946f Mon Sep 17 00:00:00 2001
From: John Tapsell <johnflux@gmail.com>
Date: Thu, 12 Sep 2013 09:16:12 +0100
Subject: [PATCH] Fix deadlock between fb_info and console.  Do not lock
 fb_info when calling sending the FB_EVENT_CONBLANK

In fbmem.c, the semantics are that we acquire the lock_fb_info first,
and then console_lock.  However when fbcon.c fbcon_generic_blank() is
called, the console lock could already be held.  Locking fb_info can
thus cause a deadlock.

fbmem.c sends the FB_EVENT_BLANK without locking lock_fb_info first, so
this change introduces similar behaviour.
---
 drivers/video/console/fbcon.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 6b4fb5c..8546441 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -2333,13 +2333,9 @@ static void fbcon_generic_blank(struct vc_data *vc,
struct fb_info *info,
                vc->vc_video_erase_char = oldc;
        }
 
-
-       if (!lock_fb_info(info))
-               return;
        event.info = info;
        event.data = &blank;
        fb_notifier_call_chain(FB_EVENT_CONBLANK, &event);
-       unlock_fb_info(info);
 }
 
 static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
-- 
1.8.1.2


How can I get this reviewed/acked please?



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/Deadlock-in-fb-and-tty-tp717929p718779.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
