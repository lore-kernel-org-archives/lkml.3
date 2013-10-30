Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab3J3QGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:06:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39044 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab3J3QGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:06:44 -0400
Date: Wed, 30 Oct 2013 17:06:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: x86-ml <x86@kernel.org>
Subject: Kbuild: Ignore GREP_OPTIONS env variable
Message-ID: <20131030160635.GE13290@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is just a general poll of what people think about the issue here,
just so that at least we've talked about it.

So I had defined GREP_OPTIONS=--color=always on one of my boxes and had
forgotten about it and the kernel build started failing because we use
grep quite a while in the tree and it started issuing shell color markup
which generated garbage files, like the syscall headers on x86, for
example.

I have a fix below which seems to take care of it but what is the
general opinion: Do we want to be more robust against the environment we
find on a machine before building the kernel or let the user figure it
out himself that he should be using

GREP_OPTIONS=--color=auto

in the first place and it is his own moronic fault if he does 'always'?

Opinions, comments?

Thanks.

--
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] Kbuild: Ignore GREP_OPTIONS env variable
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When building the kernel in a shell which defines GREP_OPTIONS so that
grep behavior is modified, we can break the generation of the syscalls
table like so:

__SYSCALL_COMMON([01;31m[K0[m[K, sys_read, sys_read)
__SYSCALL_COMMON([01;31m[K1[m[K, sys_write, sys_write)
__SYSCALL_COMMON([01;31m[K1[m[K0, sys_mprotect, sys_mprotect) ...

This is just the initial breakage, later we barf when generating
modules.

In this case, GREP_OPTIONS contains "--color=always" which adds the shell
colors markup and completely fudges the headers under ...generated/asm/.

Fix that by ignoring the GREP_OPTIONS variable for the whole kernel
build as we tend to use grep at a bunch of places.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 868c0eb67b08..7a2acd9a5d1c 100644
--- a/Makefile
+++ b/Makefile
@@ -16,6 +16,9 @@ NAME = One Giant Leap for Frogkind
 # o  print "Entering directory ...";
 MAKEFLAGS += -rR --no-print-directory
 
+GREP_OPTIONS=
+export GREP_OPTIONS
+
 # Avoid funny character set dependencies
 unexport LC_ALL
 LC_COLLATE=C
-- 
1.8.4

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
