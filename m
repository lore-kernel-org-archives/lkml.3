Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3LWOi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:38:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3LWOiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:38:24 -0500
Date: Mon, 23 Dec 2013 20:08:15 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Jan Beulich <JBeulich@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Broken initrd compression settings in 3.13
In-Reply-To: <CA+55aFzYZEmNEHQVgWS6usVnDVi-8ar7ZzP+eUGrqoO2OP66kA@mail.gmail.com>
Message-ID: <alpine.LFD.2.10.1312231805580.6405@wniryva.cad.erqung.pbz>
References: <CA+55aFzYZEmNEHQVgWS6usVnDVi-8ar7ZzP+eUGrqoO2OP66kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hi,

+-- On Fri, 20 Dec 2013, Linus Torvalds wrote --+
| So commit 1bf49dd4be0b ("./Makefile: export initial ramdisk
| compression config option") seems to be totally broken.
| 
| And I'm not saying that because Jan fixed a make-3.80 incompatibility
| in commit 7ac181568342 ("fix build with make 3.80")
| 
| I'm saying that because it sets and exports the INITRD_COMPRESS
| environment variable completely incorrectly, as far as I can tell.
| 
| And it looks like nobody noticed, because apparently dracut didn't use
| to care about that INITRD_COMPRESS environment variable at all. But as
| of a F20 update yesterday, apparently dracut actually does care, and
| as a result nothing actually works.

  This issue was indeed noticed earlier and is fixed in commit '9ba4bcb645' 
which defaults to '.gz' compression when all CONFIG_RD_* options are set.

  -> https://lkml.org/lkml/2013/10/30/535

The issue occurs due the order in which variables are examined in 
usr/Makefile.

| That setting is f*cking moronic. It sets INITRD_COMPRESS to 'lz4' if
| RD_LZ4 is set. But RD_LZ4 is *always* set (unless you go into some
| expert settings), so basically what that commit does is to always set
| INITRD_COMPRESS to lz4.

  No, it does not! It would set INITRD_COMPRESS=lz4 when *only* CONFIG_RD_LZ4 
option is set and none other. That would be moronic thing to do. But that is 
almost impossible to happen via a distro kernel config because even if you 
could build a kernel with only CONFIG_RD_LZ4, it would not boot because the 
de-compressor in 'lib/decompress_unlz4.c' is broken since they changed the LZ4 
file format

 -> http://fastcompression.blogspot.fr/2013/04/lz4-streaming-format-final.html

|  (b) there's no way to select the compression level (unlike the
| INITRAMFS_COMPRESSION thing that actually has a choice)

   Ummn...?

|  (c) even if you *do* have lz4, it doesn't actually work, because
| while that causes the new F20 dracut to compress the initramfs with
| lz4, the end result is completely broken, because the F20 "lsinitrd"
| scripts don't understand the end result, so now the whole kernel
| install fails.

   Strange! I'm running kernel-3.12.0 which seems to have commit 
'1bf49dd4be0b' which exports INITRD_COMPRESS, but not commit '9ba4bcb645' 
which fixes the usr/Makefile. For the test I enabled all CONFIG_RD_ options

===
...
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y

...
# make install
/usr/src/kernels/linux-3.12/arch/x86/boot/install.sh: INITRD_COMPRESS: bzip2
/sbin/dracut: compress: bzip2 -9 (bzip2)
# 
# file /boot/initramfs-3.12.0.img 
/boot/initramfs-3.12.0.img: bzip2 compressed data, block size = 900k
# 
===

So, the final initramfs-3.12.0 is still .bzip2 compressed, which lsinitrd(1) 
does understand. Yet, it won't boot because the lz4 de-compressor is broken. I 
tried to look into it briefly to create a fix, but then got occupied with 
other work and am yet to get back to it. :(

| I'm going to remove that export of INITRD_COMPRESS, since right now
| that value is broken and useless. No way does it make sense to
| mindlessly default to a compressor that most people don't have, and
| that doesn't work with most tools.

  Or include the patch '9ba4bcb645' which fixes this issue. I see it already 
merged actually.

--
Prasad J Pandit / Red Hat Security Response Team
