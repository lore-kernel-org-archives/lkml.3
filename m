Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaABMJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:09:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60069 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaABMIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Cliff Whickman <cpw@sgi.com>,
        Robin Holt <robinmholt@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH, RFC 28/30] sgi-xp: open-code interruptible_sleep_on_timeout
Date: Thu,  2 Jan 2014 13:07:52 +0100
Message-Id: <1388664474-1710039-29-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ryemAYtrdJcG/weiwzvh7YC+jxNeK+M+DG73/q11KiZ
 9jenxJXnyi+P0IIvXACyMDBVCA1iX9vqfS8R1Ls2G2GWrzvZ0z
 juZDkue3Ct1ANr20LvBPhPO8XTKIxfR3nHmYRYkcf8KsCy7SvU
 iaXdLYXqz+70BUKxfJEyf2yOkOFUaQbUQF24RxhSK1Y/wmfpIY
 PVnWB9IK61MRYbcsLQa7ylG8nJ1KybSGQ3AWtHagMUw1oUoyHt
 eDcJxRn2YzEdwlfcR+7xXtcczlFrk2V/jysE0I5HmVZZAu2XPh
 6xVazP/uXENMIJnEMOzx58JyBD0zFYwDEGr9gqBrK1wg7oAc+g
 3jvrOBhxGEDi8XmPoWPrwsBwMXcGbwlCSooGwSunD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interruptible_sleep_on_timeout is deprecated and going away soon.
The use in the sgi-xp driver leaves me puzzled, so I'd prefer not
to touch it. This patch replaces it with an open-coded prepare_to_wait
and finish_wait pair, which should be completely equivalent, so it
doesn't fix an existing race, but lets us get away with removing
the function so we can not get any new users.

In order to remove the typical sleep_on race, one would have to
replace the call with wait_event_interruptible_timeout and add
a condition to wait for. The fact that there is a one-jiffy timeout
suggests that we don't actually expect to get woken up properly
and the caller just uses this as a short sleeping function
if it doesn't wake up properly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Cliff Whickman <cpw@sgi.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/sgi-xp/xpc_channel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/sgi-xp/xpc_channel.c b/drivers/misc/sgi-xp/xpc_channel.c
index 652593f..128d561 100644
--- a/drivers/misc/sgi-xp/xpc_channel.c
+++ b/drivers/misc/sgi-xp/xpc_channel.c
@@ -828,6 +828,7 @@ enum xp_retval
 xpc_allocate_msg_wait(struct xpc_channel *ch)
 {
 	enum xp_retval ret;
+	DEFINE_WAIT(wait);
 
 	if (ch->flags & XPC_C_DISCONNECTING) {
 		DBUG_ON(ch->reason == xpInterrupted);
@@ -835,7 +836,9 @@ xpc_allocate_msg_wait(struct xpc_channel *ch)
 	}
 
 	atomic_inc(&ch->n_on_msg_allocate_wq);
-	ret = interruptible_sleep_on_timeout(&ch->msg_allocate_wq, 1);
+	prepare_to_wait(&ch->msg_allocate_wq, &wait, TASK_INTERRUPTIBLE);
+	ret = schedule_timeout(1);
+	finish_wait(&ch->msg_allocate_wq, &wait);
 	atomic_dec(&ch->n_on_msg_allocate_wq);
 
 	if (ch->flags & XPC_C_DISCONNECTING) {
-- 
1.8.3.2

