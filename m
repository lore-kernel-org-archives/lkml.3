Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161372Ab3LFNA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:00:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43799 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161244Ab3LFNAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 059/272] HID: uhid: fix leak for 64/32 UHID_CREATE
Date: Fri,  6 Dec 2013 12:55:48 +0000
Message-Id: <1386334761-25517-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Herrmann <dh.herrmann@gmail.com>

commit 80897aa787ecd58eabb29deab7cbec9249c9b7e6 upstream.

UHID allows short writes so user-space can omit unused fields. We
automatically set them to 0 in the kernel. However, the 64/32 bit
compat-handler didn't do that in the UHID_CREATE fallback. This will
reveal random kernel heap data (of random size, even) to user-space.

Fixes: befde0226a59 ('HID: uhid: make creating devices work on 64/32 systems')

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/uhid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 145a4cb..0bb3bb8 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -312,7 +312,7 @@ static int uhid_event_from_user(const char __user *buffer, size_t len,
 			 */
 			struct uhid_create_req_compat *compat;
 
-			compat = kmalloc(sizeof(*compat), GFP_KERNEL);
+			compat = kzalloc(sizeof(*compat), GFP_KERNEL);
 			if (!compat)
 				return -ENOMEM;
 
-- 
1.8.3.2

