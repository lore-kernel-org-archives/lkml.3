Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab3BEWKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:10:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47998 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab3BEWJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:58 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Piotr Haber <phaber@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 37/93] brcmsmac: increase timer reference count for new timers only
Date: Tue,  5 Feb 2013 20:06:26 -0200
Message-Id: <1360102042-10732-38-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Haber <phaber@broadcom.com>

commit a1fe52801a992e590cdaee2fb47a94bac9b5da90 upstream.

On hardware reintialization reference count of
already existing timers would be increased again.
This leads to problems on module unloading.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 50f92a0..24f35f6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1395,9 +1395,10 @@ void brcms_add_timer(struct brcms_timer *t, uint ms, int periodic)
 #endif
 	t->ms = ms;
 	t->periodic = (bool) periodic;
-	t->set = true;
-
-	atomic_inc(&t->wl->callbacks);
+	if (!t->set) {
+		t->set = true;
+		atomic_inc(&t->wl->callbacks);
+	}
 
 	ieee80211_queue_delayed_work(hw, &t->dly_wrk, msecs_to_jiffies(ms));
 }
-- 
1.7.9.5

