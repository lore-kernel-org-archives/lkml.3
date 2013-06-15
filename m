Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3FOBEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 21:04:40 -0400
Received: from trent.utfs.org ([94.185.90.103]:46666 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab3FOBEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:04:39 -0400
Date: Fri, 14 Jun 2013 18:04:34 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
cc: nico-linuxsetlocalversion@schottelius.org
Subject: [PATCH] scripts/setlocalversion on write-protected source tree
Message-ID: <alpine.DEB.2.10.1306141756510.13746@trent.utfs.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-ID: <alpine.DEB.2.10.1306141756512.13746@trent.utfs.org>
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since no one objected[0] and Nico kinda approved of my suggestion to 
remove "git update-index", I propose the 2nd version of this patch
for 3.11 (Linux, that is)

[0] https://lkml.org/lkml/2013/6/9/185

---

  Signed-off-by: Christian Kujau <lists@nerdbynature.de>
  Cc: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>

I just stumbled across another[0] issue when scripts/setlocalversion 
operates on a write-protected source tree. Back then[0] the source tree 
was on an read-only NFS share, so "test -w" was introduced before "git 
update-index" was run.

This time, the source tree is on read/write NFS share, but the permissions 
are world-readable and only a specific user (or root) can write. 
Thus, "test -w ." returns "0" and then runs "git update-index", 
producing the following message (on a dirty tree):

  fatal: Unable to create '/usr/local/src/linux-git/.git/index.lock': Permission denied

While it says "fatal", compilation continues just fine.

However, I don't think a kernel compilation should alter the source 
tree (or the .git directory) in any way and I don't see how removing 
"git update-index" could do any harm. The Mercurial and SVN routines in 
scripts/setlocalversion don't have any tree-modifying commands, AFAICS. 
So, maybe the patch below would be acceptable.

[0] https://patchwork.kernel.org/patch/29718/

---

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 84b88f1..d105a44 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -71,9 +71,6 @@ scm_version()
 			printf -- '-svn%s' "`git svn find-rev $head`"
 		fi
 
-		# Update index only on r/w media
-		[ -w . ] && git update-index --refresh --unmerged > /dev/null
-
 		# Check for uncommitted changes
 		if git diff-index --name-only HEAD | grep -qv "^scripts/package"; then
 			printf '%s' -dirty




-- 
BOFH excuse #359:

YOU HAVE AN I/O ERROR -> Incompetent Operator error
