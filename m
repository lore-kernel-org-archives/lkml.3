Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422637Ab3BANX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:23:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:44912 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459Ab3BANK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:10:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Piotr Haber <phaber@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 29/89] brcmsmac: increase timer reference count for new timers only
Date: Fri,  1 Feb 2013 14:07:44 +0100
Message-Id: <20130201130209.600957370@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1401,9 +1401,10 @@ void brcms_add_timer(struct brcms_timer
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


