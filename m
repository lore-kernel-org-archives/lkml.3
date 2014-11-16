Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaKPWCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:02:17 -0500
Received: from 1wt.eu ([62.212.114.60]:48011 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaKPWCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:02:13 -0500
Message-Id: <20141116215330.019965111@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:54:01 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 33/48] fix misuses of f_count() in ppp and netlink
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

we used to check for "nobody else could start doing anything with
that opened file" by checking that refcount was 2 or less - one
for descriptor table and one we'd acquired in fget() on the way to
wherever we are.  That was race-prone (somebody else might have
had a reference to descriptor table and do fget() just as we'd
been checking) and it had become flat-out incorrect back when
we switched to fget_light() on those codepaths - unlike fget(),
it doesn't grab an extra reference unless the descriptor table
is shared.  The same change allowed a race-free check, though -
we are safe exactly when refcount is less than 2.

It was a long time ago; pre-2.6.12 for ioctl() (the codepath leading
to ppp one) and 2.6.17 for sendmsg() (netlink one).  OTOH,
netlink hadn't grown that check until 3.9 and ppp used to live
in drivers/net, not drivers/net/ppp until 3.1.  The bug existed
well before that, though, and the same fix used to apply in old
location of file.

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
(cherry picked from commit 24dff96a37a2ca319e75a74d3929b2de22447ca6)
[wt: apply to drivers/net/ppp_generic.c only]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/ppp_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index 965adb6..5e9156a 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -590,7 +590,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			if (file == ppp->owner)
 				ppp_shutdown_interface(ppp);
 		}
-		if (atomic_long_read(&file->f_count) <= 2) {
+		if (atomic_long_read(&file->f_count) < 2) {
 			ppp_release(NULL, file);
 			err = 0;
 		} else
-- 
1.7.12.2.21.g234cd45.dirty



