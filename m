Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3LUBiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 20:38:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3LUBip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 20:38:45 -0500
Date: Fri, 20 Dec 2013 17:39:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: P J P <ppandit@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Broken initrd compression settings in 3.13
Message-Id: <20131220173935.0812cc4e.akpm@linux-foundation.org>
In-Reply-To: <CA+55aFzYZEmNEHQVgWS6usVnDVi-8ar7ZzP+eUGrqoO2OP66kA@mail.gmail.com>
References: <CA+55aFzYZEmNEHQVgWS6usVnDVi-8ar7ZzP+eUGrqoO2OP66kA@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013 16:41:43 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So commit 1bf49dd4be0b ("./Makefile: export initial ramdisk
> compression config option") seems to be totally broken.
> 
> And I'm not saying that because Jan fixed a make-3.80 incompatibility
> in commit 7ac181568342 ("fix build with make 3.80")
> 
> I'm saying that because it sets and exports the INITRD_COMPRESS
> environment variable completely incorrectly, as far as I can tell.
> 
> And it looks like nobody noticed, because apparently dracut didn't use
> to care about that INITRD_COMPRESS environment variable at all. But as
> of a F20 update yesterday, apparently dracut actually does care, and
> as a result nothing actually works.
> 
> That setting is f*cking moronic. It sets INITRD_COMPRESS to 'lz4' if
> RD_LZ4 is set. But RD_LZ4 is *always* set (unless you go into some
> expert settings), so basically what that commit does is to always set
> INITRD_COMPRESS to lz4.
> 
> Why is that wrong?
> 
> It's wrong because
> 
>  (a) most sane people don't even have lz4 _installed_, so dracut won't
> actually succeed
> 
>  (b) there's no way to select the compression level (unlike the
> INITRAMFS_COMPRESSION thing that actually has a choice)
> 
>  (c) even if you *do* have lz4, it doesn't actually work, because
> while that causes the new F20 dracut to compress the initramfs with
> lz4, the end result is completely broken, because the F20 "lsinitrd"
> scripts don't understand the end result, so now the whole kernel
> install fails.
> 
> Now, it could be argued that this is a F20 bug, and the fact that F20
> has a dracut that can generate a lz4 initrd, but has other tools that
> then cannot handle it is arguably indeed a buglet in F20. So the (c)
> part is arguably a F20 problem.
> 
> HOWEVER.
> 
> (a) and (b) are very much kernel bugs.
> 
> I'm going to remove that export of INITRD_COMPRESS, since right now
> that value is broken and useless. No way does it make sense to
> mindlessly default to a compressor that most people don't have, and
> that doesn't work with most tools.

Jeff sent the below this morning.  Will that fix (a)?


From: Jeff Layton <jlayton@redhat.com>
Subject: Makefile: fix order of INITRD_COMPRESS-y assignments

Commit 7ac181568342ec ("fix build with make 3.80") changed how the
Makefile handles the INITRD_COMPRESS-y assignment in order to make it work
properly with older versions of make.  Unfortunately, it also changes the
behavior of how that assignment works when multiple CONFIG_RD_* options
are set, such that they are now preferred in the reverse order of the way
they were before.

Reverse the order of assignments to try and preserve the earlier
precedence in this situation.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Jan Beulich <jbeulich@suse.com>
Cc: P J P <ppandit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Makefile~makefile-fix-order-of-initrd_compress-y-assignments Makefile
--- a/Makefile~makefile-fix-order-of-initrd_compress-y-assignments
+++ a/Makefile
@@ -733,11 +733,11 @@ export mod_strip_cmd
 # This shall be used by the dracut(8) tool while creating an initramfs image.
 #
 INITRD_COMPRESS-y                  := gzip
-INITRD_COMPRESS-$(CONFIG_RD_BZIP2) := bzip2
-INITRD_COMPRESS-$(CONFIG_RD_LZMA)  := lzma
-INITRD_COMPRESS-$(CONFIG_RD_XZ)    := xz
-INITRD_COMPRESS-$(CONFIG_RD_LZO)   := lzo
 INITRD_COMPRESS-$(CONFIG_RD_LZ4)   := lz4
+INITRD_COMPRESS-$(CONFIG_RD_LZO)   := lzo
+INITRD_COMPRESS-$(CONFIG_RD_XZ)    := xz
+INITRD_COMPRESS-$(CONFIG_RD_LZMA)  := lzma
+INITRD_COMPRESS-$(CONFIG_RD_BZIP2) := bzip2
 export INITRD_COMPRESS := $(INITRD_COMPRESS-y)
 
 ifdef CONFIG_MODULE_SIG_ALL
_

