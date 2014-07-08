Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaGHKgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:36:09 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:39589 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaGHKgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:36:06 -0400
Subject: [PATCH] scripts/checkstack.pl: automatically handle 32-bit and
 64-bit mode for ARCH=x86
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org
Date: Tue, 08 Jul 2014 14:35:57 +0400
Message-ID: <20140708103557.4408.87822.stgit@zurg>
In-Reply-To: <CALYGNiOkiBWfT1+SeAkx1qEZKFm2y9G1gXhVEyNC0OrewB2ktA@mail.gmail.com>
References: <CALYGNiOkiBWfT1+SeAkx1qEZKFm2y9G1gXhVEyNC0OrewB2ktA@mail.gmail.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for ARCH=x86 into checkstack.

commit ffee0de ("x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT")
had merged ARCH=i386 and ARCH=x86_64 into one ARCH=x86. checkstack.pl searches
patterns of machine instructions which are usually used for allocating stack
frames. checkstalk.pl needs either i386 or x86_64, x86 isn't enough:

$ make checkstack
objdump -d vmlinux $(find . -name '*.ko') | \
perl linux/scripts/checkstack.pl x86
wrong or unknown architecture "x86"

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 scripts/checkstack.pl |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/scripts/checkstack.pl b/scripts/checkstack.pl
index c05d586..899b423 100755
--- a/scripts/checkstack.pl
+++ b/scripts/checkstack.pl
@@ -52,14 +52,12 @@ my (@stack, $re, $dre, $x, $xs, $funcre);
 		#8000008a:       20 1d           sub sp,4
 		#80000ca8:       fa cd 05 b0     sub sp,sp,1456
 		$re = qr/^.*sub.*sp.*,([0-9]{1,8})/o;
-	} elsif ($arch =~ /^i[3456]86$/) {
+	} elsif ($arch =~ /^x86(_64)?$/ || $arch =~ /^i[3456]86$/) {
 		#c0105234:       81 ec ac 05 00 00       sub    $0x5ac,%esp
-		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%esp$/o;
-		$dre = qr/^.*[as][du][db]    (%.*),\%esp$/o;
-	} elsif ($arch eq 'x86_64') {
-		#    2f60:	48 81 ec e8 05 00 00 	sub    $0x5e8,%rsp
-		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%rsp$/o;
-		$dre = qr/^.*[as][du][db]    (\%.*),\%rsp$/o;
+		# or
+		#    2f60:    48 81 ec e8 05 00 00       sub    $0x5e8,%rsp
+		$re = qr/^.*[as][du][db]    \$(0x$x{1,8}),\%(e|r)sp$/o;
+		$dre = qr/^.*[as][du][db]    (%.*),\%(e|r)sp$/o;
 	} elsif ($arch eq 'ia64') {
 		#e0000000044011fc:       01 0f fc 8c     adds r12=-384,r12
 		$re = qr/.*adds.*r12=-(([0-9]{2}|[3-9])[0-9]{2}),r12/o;

