Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab3FDXQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:16:04 -0400
Received: from 1wt.eu ([62.212.114.60]:35410 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab3FDWmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:15 -0400
Message-Id: <20130604172132.918292146@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 063/184] PARISC: fix user-triggerable panic on parisc
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 441a179dafc0f99fc8b3a8268eef66958621082e upstream.

int sys32_rt_sigprocmask(int how, compat_sigset_t __user *set, compat_sigset_t __user *oset,
                                    unsigned int sigsetsize)
{
        sigset_t old_set, new_set;
        int ret;

        if (set && get_sigset32(set, &new_set, sigsetsize))

...
static int
get_sigset32(compat_sigset_t __user *up, sigset_t *set, size_t sz)
{
        compat_sigset_t s;
        int r;

        if (sz != sizeof *set) panic("put_sigset32()");

In other words, rt_sigprocmask(69, (void *)69, 69) done by 32bit process
will promptly panic the box.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/parisc/kernel/signal32.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/signal32.c b/arch/parisc/kernel/signal32.c
index fb59852..32d43e7 100644
--- a/arch/parisc/kernel/signal32.c
+++ b/arch/parisc/kernel/signal32.c
@@ -68,7 +68,8 @@ put_sigset32(compat_sigset_t __user *up, sigset_t *set, size_t sz)
 {
 	compat_sigset_t s;
 
-	if (sz != sizeof *set) panic("put_sigset32()");
+	if (sz != sizeof *set)
+		return -EINVAL;
 	sigset_64to32(&s, set);
 
 	return copy_to_user(up, &s, sizeof s);
@@ -80,7 +81,8 @@ get_sigset32(compat_sigset_t __user *up, sigset_t *set, size_t sz)
 	compat_sigset_t s;
 	int r;
 
-	if (sz != sizeof *set) panic("put_sigset32()");
+	if (sz != sizeof *set)
+		return -EINVAL;
 
 	if ((r = copy_from_user(&s, up, sz)) == 0) {
 		sigset_32to64(set, &s);
-- 
1.7.12.2.21.g234cd45.dirty



