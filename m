Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3JXFcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 01:32:35 -0400
Received: from intranet.asianux.com ([58.214.24.6]:56667 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3JXFce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 01:32:34 -0400
X-Spam-Score: -100.8
Message-ID: <5268B0B1.9050009@asianux.com>
Date: Thu, 24 Oct 2013 13:31:29 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joern Rennecke <joern.rennecke@embecosm.com>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Takashi Iwai <tiwai@suse.de>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Zissulescu <Claudiu.Zissulescu@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: [PATCH] kernel/modsign_certificate.S: use real contents instead of
 macro GLOBAL()
References: <523FD9E7.3050303@asianux.com> <523FDBD7.4040602@asianux.com> <C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com> <523FE578.5060801@asianux.com> <52672DAC.1030307@asianux.com> <CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com> <52673E41.6040606@asianux.com> <5267AF98.1010800@asianux.com>
In-Reply-To: <5267AF98.1010800@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some architectures, tool chain is not smart enough to recognize the
macro with multiple lines (e.g. arc tool chain), and for common ".S"
file, this kind of macro is also rarely used.

So expand the related contents of macro to let it pass compiling (can
use "arc-elf32-objdump -x" to know about it).

The related error (allmodconfig for arc):

    LD      init/built-in.o
  kernel/built-in.o: In function `load_module_signing_keys':
  kernel/modsign_pubkey.c:66: undefined reference to `modsign_certificate_list'
  kernel/modsign_pubkey.c:71: undefined reference to `modsign_certificate_list_end'
  kernel/modsign_pubkey.c:67: undefined reference to `modsign_certificate_list_end'

The related tool chain information:

  [root@gchenlinux linux-next]# arc-elf32-as -v
  GNU assembler version 2.23.2 (arc-elf32) using BFD version (GNU Binutils) 2.23.2
  [root@gchenlinux linux-next]# arc-elf32-ld -v
  GNU ld (GNU Binutils) 2.23.2
  [root@gchenlinux linux-next]# arc-elf32-gcc -v
  Using built-in specs.
  COLLECT_GCC=arc-elf32-gcc
  COLLECT_LTO_WRAPPER=/usr/local/libexec/gcc/arc-elf32/4.8.0/lto-wrapper
  Target: arc-elf32
  Configured with: ../gcc/configure --without-header --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes --target=arc-elf32 --with-cpu=arc700 : (reconfigured) ../gcc/configure --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes --target=arc-elf32 --with-cpu=arc700 : (reconfigured) ../gcc/configure --without-header --disable-nls --enable-language=c --disable-threads --disable-shared --enable-werror=no target_configargs=enable_vtable_verify=yes --target=arc-elf32 --with-cpu=arc700 --disable-multilib --with-headers=../newlib/newlib/libc/include
  Thread model: single
  gcc version 4.8.0 (GCC) 


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/modsign_certificate.S |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/modsign_certificate.S b/kernel/modsign_certificate.S
index 4a9a86d..1967dcd 100644
--- a/kernel/modsign_certificate.S
+++ b/kernel/modsign_certificate.S
@@ -1,12 +1,10 @@
 #include <linux/export.h>
 
-#define GLOBAL(name)	\
-	.globl VMLINUX_SYMBOL(name);	\
-	VMLINUX_SYMBOL(name):
-
 	.section ".init.data","aw"
 
-GLOBAL(modsign_certificate_list)
+	.globl VMLINUX_SYMBOL(modsign_certificate_list)
+VMLINUX_SYMBOL(modsign_certificate_list):
 	.incbin "signing_key.x509"
 	.incbin "extra_certificates"
-GLOBAL(modsign_certificate_list_end)
+	.globl VMLINUX_SYMBOL(modsign_certificate_list_end)
+VMLINUX_SYMBOL(modsign_certificate_list_end):
-- 
1.7.7.6
