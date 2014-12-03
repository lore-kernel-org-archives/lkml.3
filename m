Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaLCLbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:31:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbaLCL1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:45 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 088/101] pvpanic: Set high notifier priority
Date: Wed,  3 Dec 2014 12:26:50 +0100
Message-Id: <037e69291b28bb3c7ac303c8d743fca393a5532e.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7939831eacd81fccbd7a956b30c7bb3abb9079db upstream.

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
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/platform/x86/pvpanic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/pvpanic.c b/drivers/platform/x86/pvpanic.c
index 47ae0c47d4b5..469e182c5461 100644
--- a/drivers/platform/x86/pvpanic.c
+++ b/drivers/platform/x86/pvpanic.c
@@ -71,6 +71,7 @@ pvpanic_panic_notify(struct notifier_block *nb, unsigned long code,
 
 static struct notifier_block pvpanic_panic_nb = {
 	.notifier_call = pvpanic_panic_notify,
+	.priority = 1, /* let this called before broken drm_fb_helper */
 };
 
 
-- 
2.1.3

