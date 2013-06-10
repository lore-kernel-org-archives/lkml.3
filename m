Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3FJBB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 21:01:56 -0400
Received: from trent.utfs.org ([94.185.90.103]:59845 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab3FJBBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 21:01:55 -0400
X-Greylist: delayed 662 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Jun 2013 21:01:55 EDT
Date: Sun, 9 Jun 2013 17:50:49 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: nico-linuxsetlocalversion@schottelius.org
Subject: [RFC] scripts/setlocalversion on write-protected source tree
Message-ID: <alpine.DEB.2.10.1306091640270.13746@trent.utfs.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1184995494-2012676215-1370825449=:13746"
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1184995494-2012676215-1370825449=:13746
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hi,

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

The patch below adds yet another (clumsy) check before "git 
update-index", but I'm not sure if this is the right way to go.

On a side note, I don't think a kernel compilation should alter the source 
tree (or the .git directory) in any way and I don't see how removing 
"git update-index" could do any harm. The Mercurial and SVN routines in 
scripts/setlocalversion don't have any tree-modifying commands, AFAICS. 
So, maybe the attached patch would be acceptable.

Thoughts?
Christian.

[0] https://patchwork.kernel.org/patch/29718/

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
old mode 100755
new mode 100644
index 84b88f1..2560718
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -72,7 +72,8 @@ scm_version()
 		fi
 
 		# Update index only on r/w media
-		[ -w . ] && git update-index --refresh --unmerged > /dev/null
+		[ -w . ] && touch .git/index.lock 2>/dev/null && rm -f .git/index.lock && \
+			git update-index --refresh --unmerged > /dev/null
 
 		# Check for uncommitted changes
 		if git diff-index --name-only HEAD | grep -qv "^scripts/package"; then


-- 
BOFH excuse #359:

YOU HAVE AN I/O ERROR -> Incompetent Operator error
---1184995494-2012676215-1370825449=:13746
Content-Type: TEXT/x-diff; name=setlocalversion_no-update-index.diff
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.10.1306091750490.13746@trent.utfs.org>
Content-Description: 
Content-Disposition: attachment; filename=setlocalversion_no-update-index.diff

ZGlmZiAtLWdpdCBhL3NjcmlwdHMvc2V0bG9jYWx2ZXJzaW9uIGIvc2NyaXB0
cy9zZXRsb2NhbHZlcnNpb24NCmluZGV4IDg0Yjg4ZjEuLmQxMDVhNDQgMTAw
NzU1DQotLS0gYS9zY3JpcHRzL3NldGxvY2FsdmVyc2lvbg0KKysrIGIvc2Ny
aXB0cy9zZXRsb2NhbHZlcnNpb24NCkBAIC03MSw5ICs3MSw2IEBAIHNjbV92
ZXJzaW9uKCkNCiAJCQlwcmludGYgLS0gJy1zdm4lcycgImBnaXQgc3ZuIGZp
bmQtcmV2ICRoZWFkYCINCiAJCWZpDQogDQotCQkjIFVwZGF0ZSBpbmRleCBv
bmx5IG9uIHIvdyBtZWRpYQ0KLQkJWyAtdyAuIF0gJiYgZ2l0IHVwZGF0ZS1p
bmRleCAtLXJlZnJlc2ggLS11bm1lcmdlZCA+IC9kZXYvbnVsbA0KLQ0KIAkJ
IyBDaGVjayBmb3IgdW5jb21taXR0ZWQgY2hhbmdlcw0KIAkJaWYgZ2l0IGRp
ZmYtaW5kZXggLS1uYW1lLW9ubHkgSEVBRCB8IGdyZXAgLXF2ICJec2NyaXB0
cy9wYWNrYWdlIjsgdGhlbg0KIAkJCXByaW50ZiAnJXMnIC1kaXJ0eQ0K

---1184995494-2012676215-1370825449=:13746--
