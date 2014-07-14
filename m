Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbaGNTTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:19:32 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:32876 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597AbaGNTTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:19:09 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
        lxc-devel@lists.linuxcontainers.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@WittsEnd.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 1/3] fuse/dev: Fix unbalanced calls to kunmap_atomic() during splice I/O
Date: Mon, 14 Jul 2014 14:18:14 -0500
Message-Id: <1405365496-58404-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fuse_copy_finish() assumes that mapaddr in fuse_copy_state refers
to a valid mapping if currbuf is non-NULL, but this isn't always
true when moving pages for splice I/O. This results in an
unbalanced call to kunmap_atomic() and thus an unbalanced
decrement of the preempt count. Avoid this by checking that
mapaddr is non-NULL before calling kunmap_atomic().

This can be reproduced easily with fusexmp_fh:

  $ mkdir data mount
  $ dd if=/dev/urandom of=data/rand.bin bs=1M count=1
  $ fusexmp_fh -omodules=subdir,subdir=$PWD/data,splice_write,splice_move mount
  $ cat mount/rand.bin >/dev/null

The bug has existed in its current form since 58bda1da4
"fuse/dev: use atomic maps" and fbb32750a "pipe: kill ->map()
and ->unmap()" converted all unmaps to kunmap_atomic() in 3.15.
The fundamental problem of unmapping a page which hasn't been
mapped goes back farther, probably to ce534fb05 "fuse: allow
splice to move pages," but likely with a different impact.

Cc: <stable@vger.kernel.org>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/fuse/dev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 098f97bdcf1b..219d1e685183 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -666,12 +666,10 @@ static void fuse_copy_finish(struct fuse_copy_state *cs)
 	if (cs->currbuf) {
 		struct pipe_buffer *buf = cs->currbuf;
 
-		if (!cs->write) {
-			kunmap_atomic(cs->mapaddr);
-		} else {
+		if (cs->mapaddr)
 			kunmap_atomic(cs->mapaddr);
+		if (cs->write)
 			buf->len = PAGE_SIZE - cs->len;
-		}
 		cs->currbuf = NULL;
 		cs->mapaddr = NULL;
 	} else if (cs->mapaddr) {
-- 
1.9.1

