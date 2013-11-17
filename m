Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab3KQGTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 01:19:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59382 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3KQGTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 01:19:10 -0500
Date: Sun, 17 Nov 2013 06:19:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Wu <lekensteyn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] coredumps truncated after "new helper: dump_align()"
Message-ID: <20131117061907.GL13318@ZenIV.linux.org.uk>
References: <11835033.kIc1RH0rS1@al>
 <20131115203838.GJ13318@ZenIV.linux.org.uk>
 <8708646.IsEyNQP0iB@al>
 <20131116000408.GK13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131116000408.GK13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 12:04:08AM +0000, Al Viro wrote:
> On Fri, Nov 15, 2013 at 10:34:43PM +0100, Peter Wu wrote:
> 
> > Unfortunately, this patch still does not fix the issue. I rm'd the output 
> > directory just to be sure, but the bug is still there. What does this commit 
> > do anyway? The commit message is quite vague.
> 
> Introduces a helper that used to be open-coded in a bunch of places -
> pads the coredump to given alignment.  And switches those places
> to that new helper...
> 
> FWIW, I haven't tried that on your config yet, but here (with the patch
> in my previous mail) I'm seeing a sane-looking coredump -
> -rw------- 1 root root 315392 Nov 15 17:48 core
> Different userland, presumably, since that static binary is 684349
> bytes long.
> 
> I'll try to reproduce with your config...

... and on your config I'm seeing
Inited
Segmentation fault (core dumped)
[    0.123351] Core size: 315392
in the log.  Same size, same apparently sane coredump.  Can you check what you
get on mainline + diff below (combination of dump_align() and locking fix)?

diff --git a/fs/coredump.c b/fs/coredump.c
index 62406b6..bc3fbcd 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -695,7 +695,7 @@ int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
 	while (nr) {
 		if (dump_interrupted())
 			return 0;
-		n = vfs_write(file, addr, nr, &pos);
+		n = __kernel_write(file, addr, nr, &pos);
 		if (n <= 0)
 			return 0;
 		file->f_pos = pos;
@@ -733,7 +733,7 @@ int dump_align(struct coredump_params *cprm, int align)
 {
 	unsigned mod = cprm->written & (align - 1);
 	if (align & (align - 1))
-		return -EINVAL;
-	return mod ? dump_skip(cprm, align - mod) : 0;
+		return 0;
+	return mod ? dump_skip(cprm, align - mod) : 1;
 }
 EXPORT_SYMBOL(dump_align);
