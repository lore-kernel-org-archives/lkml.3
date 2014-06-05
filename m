Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaFEFF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:05:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaFEEU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.4 050/214] md: avoid possible spinning md thread at shutdown.
Date: Wed,  4 Jun 2014 21:16:53 -0700
Message-Id: <20140605041646.173014243@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 0f62fb220aa4ebabe8547d3a9ce4a16d3c045f21 upstream.

If an md array with externally managed metadata (e.g. DDF or IMSM)
is in use, then we should not set safemode==2 at shutdown because:

1/ this is ineffective: user-space need to be involved in any 'safemode' handling,
2/ The safemode management code doesn't cope with safemode==2 on external metadata
   and md_check_recover enters an infinite loop.

Even at shutdown, an infinite-looping process can be problematic, so this
could cause shutdown to hang.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8167,7 +8167,8 @@ static int md_notify_reboot(struct notif
 		if (mddev_trylock(mddev)) {
 			if (mddev->pers)
 				__md_stop_writes(mddev);
-			mddev->safemode = 2;
+			if (mddev->persistent)
+				mddev->safemode = 2;
 			mddev_unlock(mddev);
 		}
 		need_delay = 1;


