Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbaEFPwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:52:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757840AbaEFPwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:52:30 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bruce Rogers <brogers@suse.com>
Subject: [PATCH] pvpanic: Set high notifier priority
Date: Tue,  6 May 2014 17:52:26 +0200
Message-Id: <1399391546-32101-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've observed the missing pvpanic call at panic, and it turned out
that this was blocked by the broken notifier of drm_fb_helper, where
scheduling may be called during switching to the fb console.
It's fairly difficult to fix the drm_fb problem and a quick fix isn't
foreseen, a simpler solution for the missing pvpanic call would be
just to call this earlier.

In order to assure that, this patch sets a higher priority to pvpanic
notifier_block.  Once when the issue of drm_fb is resolved, we can
remove this priority again.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/platform/x86/pvpanic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/pvpanic.c b/drivers/platform/x86/pvpanic.c
index c9f6e511daa6..073a90a63dbc 100644
--- a/drivers/platform/x86/pvpanic.c
+++ b/drivers/platform/x86/pvpanic.c
@@ -70,6 +70,7 @@ pvpanic_panic_notify(struct notifier_block *nb, unsigned long code,
 
 static struct notifier_block pvpanic_panic_nb = {
 	.notifier_call = pvpanic_panic_notify,
+	.priority = 1, /* let this called before broken drm_fb_helper */
 };
 
 
-- 
1.9.2

