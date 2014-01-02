Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaABMMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:12:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49977 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaABMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH, RFC 10/30] staging: gdm72xx: fix interruptible_sleep_on race
Date: Thu,  2 Jan 2014 13:07:34 +0100
Message-Id: <1388664474-1710039-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:CmfCVCA7u9HA5X12dPtD+R1g5tsBdRhcYs6Vb/50fed
 Cw4d25CfyCW/f1+4pCpI5etnA53LTbPE20ULkrsfQ7yXu9PKy4
 pdxuORdBqVg+IEeBkOODwQ2cMSrFSuZ8yagjqgwzqWWpJU5dSd
 PVvOKyPB/J+Gamj/TXmnKCspa91KJsgubnE0irdd9f85Xw4F/u
 vm4qImIKH++4BgNxJFIgR+i2djdRMtj1gYOnnfuR4EKqxzHnVe
 5fTAo+5KOc4VoU/DXSC9FyyHrHcf8hquy3J8k2DRG209ySo0un
 1dIm+5IGHPgNYOtPvHI4gNfAmJM8VTkHdeFgoF8E7VT82WKWe3
 M6Q2mABbaIuIs/2ZJbmnxoED1DOz1MOJCDVy+O4pT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interruptible_sleep_on is racy and going away. This replaces the
use in the gdm72xx driver with the appropriate
wait_event_interruptible_lock_irq.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/gdm72xx/gdm_usb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index e0cb2ff..f8788bf 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -780,9 +780,10 @@ static int k_mode_thread(void *arg)
 
 			spin_lock_irqsave(&k_lock, flags2);
 		}
+		wait_event_interruptible_lock_irq(k_wait,
+						  !list_empty(&k_list) || k_mode_stop,
+						  k_lock);
 		spin_unlock_irqrestore(&k_lock, flags2);
-
-		interruptible_sleep_on(&k_wait);
 	}
 	return 0;
 }
-- 
1.8.3.2

