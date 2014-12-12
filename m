Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966031AbaLLGsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:48:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760938AbaLLGsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:19 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Al Viro" <viro@zeniv.linux.org.uk>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.410045683@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 052/164] fix misuses of f_count() in ppp and netlink
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

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
[bwh: Backported to 3.2: drop changes to netlink_mmap_sendmsg()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -588,7 +588,7 @@ static long ppp_ioctl(struct file *file,
 			if (file == ppp->owner)
 				ppp_shutdown_interface(ppp);
 		}
-		if (atomic_long_read(&file->f_count) <= 2) {
+		if (atomic_long_read(&file->f_count) < 2) {
 			ppp_release(NULL, file);
 			err = 0;
 		} else

