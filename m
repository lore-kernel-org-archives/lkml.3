Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3KOUis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 15:38:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51809 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3KOUij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 15:38:39 -0500
Date: Fri, 15 Nov 2013 20:38:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Wu <lekensteyn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] coredumps truncated after "new helper: dump_align()"
Message-ID: <20131115203838.GJ13318@ZenIV.linux.org.uk>
References: <11835033.kIc1RH0rS1@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11835033.kIc1RH0rS1@al>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 03:26:10PM +0100, Peter Wu wrote:
> Hi Al,
> 
> Somewhere in the merge window of 3.13, coredumps appear truncated.
> Instead of 319488 bytes, I get 868 bytes (tested with x86_64 only).
> 
> The latest Linus' master (v3.12-9579-g049ffa8) is still affected.
> Bisection leads to:
> 
> commit 22a8cb8248ba5d340307ba72432253b1dbdb5cf7
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Tue Oct 8 11:05:01 2013 -0400
> 
>     new helper: dump_align()
>     
>     dump_skip to given alignment...

Argh...  Really dumb braino when getting rid of long long division in
dump_align().  Please, see if this gets rid of the entire problem on your
setup - it definitely fixes a bug in there and it seems to restore the
normal behaviour on the reproducer I've got here, but...

I'm going to send that to Linus, along with another coredump fix
(dump_emit() ought to use __kernel_write() instead of vfs_write())
shortly anyway, but if you spot anything still broken...

diff --git a/fs/coredump.c b/fs/coredump.c
index 62406b6..a2856f7 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
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
