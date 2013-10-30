Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3J3WFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:05:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3J3WFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:05:22 -0400
Date: Wed, 30 Oct 2013 15:05:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: P J P <ppandit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Read CONFIG_RD_ variables for initramfs compression
Message-Id: <20131030150521.ff3fd577a6e506e4278db48c@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.03.1310301226260.12975@erqung.pbz>
References: <alpine.LFD.2.03.1310152002200.7552@erqung.pbz>
	<20131029151507.8f63dad8e7525e33431d9596@linux-foundation.org>
	<alpine.LFD.2.03.1310301226260.12975@erqung.pbz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013 15:57:20 +0530 (IST) P J P <ppandit@redhat.com> wrote:

> +-- On Tue, 29 Oct 2013, Andrew Morton wrote --+
> | On Tue, 15 Oct 2013 20:25:57 +0530 (IST) P J P <ppandit@redhat.com> wrote:
> | This patch breaks my x86_64 allmodconfig build, because I don't have
> | the lz4 executable installed:
> | 
> | /usr/src/25/scripts/gen_initramfs_list.sh: line 307: lz4: command not found
> | make[1]: *** [usr/initramfs_data.cpio.lz4] Error 1
> | 
> | This obviously isn't acceptable!
> 
>   Oops! '$ make allmodconfig' seems to enables all compression algorithms; So 
> the last one overrides the previous choices in usr/Makefile.
> 
> ===
> ...
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> CONFIG_RD_LZ4=y
> ===
> 
> Please see an updated patch herein. I've patched 'gen_initramfs_list.sh' 
> script to check if a selected compression command is accessible or not; And 
> fall-back to the default gzip(1) format when it is not. usr/Makefile also 
> defaults to '.gz' format when all are enabled.

Below is the delta.

Requiring that the executables exist in /bin is unpleasant.  Isn't
there some convenient way of testing for the presence of an executable
in $PATH?

The shell-builtin `which' seems to dtrt:

akpm3:/usr/src/25> if which gzip > /dev/null ; then echo foo ; fi 
foo
akpm3:/usr/src/25> if which lz4 > /dev/null ; then echo foo ; fi    
akpm3:/usr/src/25> 

/bin/which should do the same thing.

There's probably some kbuild-approved way of doing this, but I
don't know what it is off-hand.



From: P J P <ppandit@redhat.com>
Subject: initramfs-read-config_rd_-variables-for-initramfs-compression-fix

Oops!  '$ make allmodconfig' seems to enables all compression algorithms;
So the last one overrides the previous choices in usr/Makefile.

Please see an updated patch herein.  I've patched 'gen_initramfs_list.sh'
script to check if a selected compression command is accessible or not;
And fall-back to the default gzip(1) format when it is not.  usr/Makefile
also defaults to '.gz' format when all are enabled.

Signed-off-by: P J P <prasad@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |   19 ++++++++++++-------
 usr/Makefile                  |    6 +++---
 2 files changed, 15 insertions(+), 10 deletions(-)

diff -puN scripts/gen_initramfs_list.sh~initramfs-read-config_rd_-variables-for-initramfs-compression-fix scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~initramfs-read-config_rd_-variables-for-initramfs-compression-fix
+++ a/scripts/gen_initramfs_list.sh
@@ -240,13 +240,18 @@ case "$arg" in
 		output_file="$1"
 		cpio_list="$(mktemp ${TMPDIR:-/tmp}/cpiolist.XXXXXX)"
 		output=${cpio_list}
-		echo "$output_file" | grep -q "\.gz$" && compr="gzip -n -9 -f"
-		echo "$output_file" | grep -q "\.bz2$" && compr="bzip2 -9 -f"
-		echo "$output_file" | grep -q "\.lzma$" && compr="lzma -9 -f"
-		echo "$output_file" | grep -q "\.xz$" && \
-				compr="xz --check=crc32 --lzma2=dict=1MiB"
-		echo "$output_file" | grep -q "\.lzo$" && compr="lzop -9 -f"
-		echo "$output_file" | grep -q "\.lz4$" && compr="lz4 -9 -f"
+		echo "$output_file" | grep -q "\.gz$" && [ -x "/bin/gzip" ] \
+                && compr="gzip -n -9 -f"
+		echo "$output_file" | grep -q "\.bz2$" && [ -x "/bin/bzip2" ] \
+                && compr="bzip2 -9 -f"
+		echo "$output_file" | grep -q "\.lzma$" && [ -x "/bin/lzma" ] \
+                && compr="lzma -9 -f"
+		echo "$output_file" | grep -q "\.xz$" && [ -x "/bin/xz" ] \
+                && compr="xz --check=crc32 --lzma2=dict=1MiB"
+		echo "$output_file" | grep -q "\.lzo$" && [ -x "/bin/lzop" ] \
+                && compr="lzop -9 -f"
+		echo "$output_file" | grep -q "\.lz4$" && [ -x "/bin/lz4" ] \
+                && compr="lz4 -9 -f"
 		echo "$output_file" | grep -q "\.cpio$" && compr="cat"
 		shift
 		;;
diff -puN usr/Makefile~initramfs-read-config_rd_-variables-for-initramfs-compression-fix usr/Makefile
--- a/usr/Makefile~initramfs-read-config_rd_-variables-for-initramfs-compression-fix
+++ a/usr/Makefile
@@ -6,9 +6,6 @@ klibcdirs:;
 PHONY += klibcdirs
 
 
-# Gzip
-suffix_$(CONFIG_RD_GZIP)   = .gz
-
 # Bzip2
 suffix_$(CONFIG_RD_BZIP2)  = .bz2
 
@@ -24,6 +21,9 @@ suffix_$(CONFIG_RD_LZO)    = .lzo
 # Lz4
 suffix_$(CONFIG_RD_LZ4)    = .lz4
 
+# Gzip
+suffix_$(CONFIG_RD_GZIP)   = .gz
+
 AFLAGS_initramfs_data.o += -DINITRAMFS_IMAGE="usr/initramfs_data.cpio$(suffix_y)"
 
 # Generate builtin.o based on initramfs_data.o
_

