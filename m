Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaJGAVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:21:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48432 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaJGAVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:21:49 -0400
Message-Id: <3f071b0ef6be54f114b21dbaa160782b05dd2a5e.1412640584.git.geoff@infradead.org>
In-Reply-To: <cover.1412640584.git.geoff@infradead.org>
References: <cover.1412640584.git.geoff@infradead.org>
From: Geoff Levand <geoff@infradead.org>
Patch-Date: Wed, 20 Aug 2014 14:44:41 -0700
Subject: [PATCH V22/5] kexec: Simplify conditional
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Oct 2014 00:21:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the code around one of the conditionals in the kexec_load
syscall routine.

The original code was confusing with a redundant check on KEXEC_ON_CRASH
and comments outside of the conditional block.  This change switches the
order of the conditional check, and cleans up the comments for the
conditional.  There is no functional change to the code.

Signed-off-by: Geoff Levand <geoff@infradead.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/kexec.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2bee072..4b8356b 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1288,19 +1288,22 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 	if (nr_segments > 0) {
 		unsigned long i;
 
-		/* Loading another kernel to reboot into */
-		if ((flags & KEXEC_ON_CRASH) == 0)
-			result = kimage_alloc_init(&image, entry, nr_segments,
-						   segments, flags);
-		/* Loading another kernel to switch to if this one crashes */
-		else if (flags & KEXEC_ON_CRASH) {
-			/* Free any current crash dump kernel before
+		if (flags & KEXEC_ON_CRASH) {
+			/*
+			 * Loading another kernel to switch to if this one
+			 * crashes.  Free any current crash dump kernel before
 			 * we corrupt it.
 			 */
+
 			kimage_free(xchg(&kexec_crash_image, NULL));
 			result = kimage_alloc_init(&image, entry, nr_segments,
 						   segments, flags);
 			crash_map_reserved_pages();
+		} else {
+			/* Loading another kernel to reboot into. */
+
+			result = kimage_alloc_init(&image, entry, nr_segments,
+						   segments, flags);
 		}
 		if (result)
 			goto out;
-- 
1.9.1


