Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab3KIHMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:12:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749Ab3KIGwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Natrio <natrio@list.ru>, Jeff Pohlmeyer <yetanothergeek@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.11 39/94] Revert "epoll: use freezable blocking call"
Date: Fri,  8 Nov 2013 22:51:45 -0800
Message-Id: <20131109065206.990675079@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit c511851de162e8ec03d62e7d7feecbdf590d881d upstream.

This reverts commit 1c441e921201 (epoll: use freezable blocking call)
which is reported to cause user space memory corruption to happen
after suspend to RAM.

Since it appears to be extremely difficult to root cause this
problem, it is best to revert the offending commit and try to address
the original issue in a better way later.

References: https://bugzilla.kernel.org/show_bug.cgi?id=61781
Reported-by: Natrio <natrio@list.ru>
Reported-by: Jeff Pohlmeyer <yetanothergeek@gmail.com>
Bisected-by: Leo Wolf <jclw@ymail.com>
Fixes: 1c441e921201 (epoll: use freezable blocking call)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -34,7 +34,6 @@
 #include <linux/mutex.h>
 #include <linux/anon_inodes.h>
 #include <linux/device.h>
-#include <linux/freezer.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/mman.h>
@@ -1603,8 +1602,7 @@ fetch_events:
 			}
 
 			spin_unlock_irqrestore(&ep->lock, flags);
-			if (!freezable_schedule_hrtimeout_range(to, slack,
-								HRTIMER_MODE_ABS))
+			if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
 				timed_out = 1;
 
 			spin_lock_irqsave(&ep->lock, flags);


