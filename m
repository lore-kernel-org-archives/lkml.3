Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab3GBLKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:10:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36385 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab3GBLIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Drake <dsd@laptop.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 44/50] Bluetooth: btmrvl: fix thread stopping race
Date: Tue,  2 Jul 2013 12:07:32 +0100
Message-Id: <1372763258-20664-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

commit ea05fea9042620ac3b8ab9a3e5e4d2ed80c89244 upstream.

There is currently a race condition in the btmrvl_remove_card() which
is causing hangs on suspend for OLPC. When the race occurs,
kthread_stop() never returns.

The problem is that btmrvl_service_main_thread() calls kthread_should_stop()
and then does a fair number of things before restarting the loop and
sleeping.

If the thread gets stopped after kthread_should_stop() is checked, but
before the sleep happens, the thread will go to sleep and won't necessarily
be woken up.

Move the kthread_should_stop() check into a race-free place.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/btmrvl_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index dc304de..2c63a21 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -496,6 +496,10 @@ static int btmrvl_service_main_thread(void *data)
 		add_wait_queue(&thread->wait_q, &wait);
 
 		set_current_state(TASK_INTERRUPTIBLE);
+		if (kthread_should_stop()) {
+			BT_DBG("main_thread: break from main thread");
+			break;
+		}
 
 		if (adapter->wakeup_tries ||
 				((!adapter->int_count) &&
@@ -511,11 +515,6 @@ static int btmrvl_service_main_thread(void *data)
 
 		BT_DBG("main_thread woke up");
 
-		if (kthread_should_stop()) {
-			BT_DBG("main_thread: break from main thread");
-			break;
-		}
-
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		if (adapter->int_count) {
 			adapter->int_count = 0;
-- 
1.8.1.2

