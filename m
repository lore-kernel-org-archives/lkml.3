Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaHROub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:50:31 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:54821 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaHROu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:50:29 -0400
Date: Mon, 18 Aug 2014 17:50:19 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] input: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140818145019.GA14053@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/input/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 1c4c0db..f9db5ea 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -539,7 +539,7 @@ static void __input_release_device(struct input_handle *handle)
 	grabber = rcu_dereference_protected(dev->grab,
 					    lockdep_is_held(&dev->mutex));
 	if (grabber == handle) {
-		rcu_assign_pointer(dev->grab, NULL);
+		RCU_INIT_POINTER(dev->grab, NULL);
 		/* Make sure input_pass_event() notices that grab is gone */
 		synchronize_rcu();
 
-- 
1.9.1

