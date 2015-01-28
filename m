Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbbA1ER4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:17:56 -0500
Received: from mail.kernel.org ([198.145.29.136]:38235 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761240AbbA1ERu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:17:50 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 047/177] fix misuses of f_count() in ppp and netlink
Date: Wed, 28 Jan 2015 12:07:40 +0800
Message-Id: <1422418236-12852-93-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 24dff96a37a2ca319e75a74d3929b2de22447ca6 upstream.

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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[lizf: Backported to 3.4: drop the change to netlink_mmap_sendmsg()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/ppp/ppp_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 21d7151..1207bb1 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -588,7 +588,7 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			if (file == ppp->owner)
 				ppp_shutdown_interface(ppp);
 		}
-		if (atomic_long_read(&file->f_count) <= 2) {
+		if (atomic_long_read(&file->f_count) < 2) {
 			ppp_release(NULL, file);
 			err = 0;
 		} else
-- 
1.9.1

