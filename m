Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaHTRSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:18:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaHTRSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:18:02 -0400
Date: Wed, 20 Aug 2014 13:17:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Glanzmann <thomas@glanzmann.de>
Subject: [PATCH] x86/purgatory: Use approprate -m64/-32 build flag for
 arch/x86/purgatory
Message-ID: <20140820171752.GC21518@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas reported that build of x86_64 kernel was failing for him. He is
using 32bit tool chain.

Problem is that while compiling purgatory, I have not specified -m64
flag. And 32bit tool chain must be assuming -m32 by default.

Following is error message.

(mini) [~/work/linux-2.6] make
scripts/kconfig/conf --silentoldconfig Kconfig
  CHK     include/config/kernel.release
  UPD     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      arch/x86/purgatory/purgatory.o
arch/x86/purgatory/purgatory.c:1:0: error: code model 'large' not supported in
the 32 bit mode
make[1]: *** [arch/x86/purgatory/purgatory.o] Error 1
make: *** [archprepare] Error 2

Fix it by explicitly passing appropriate -m64/-m32 build flag for purgatory.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Tested-by: Thomas Glanzmann <thomas@glanzmann.de>
Suggested-by: H. Peter Anvin <hpa@zytor.com> 
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/purgatory/Makefile |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/arch/x86/purgatory/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/purgatory/Makefile	2014-08-20 11:32:21.723559119 -0400
+++ linux-2.6/arch/x86/purgatory/Makefile	2014-08-20 11:32:23.654570231 -0400
@@ -11,6 +11,7 @@ targets += purgatory.ro
 # sure how to relocate those. Like kexec-tools, use custom flags.
 
 KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -MD -Os -mcmodel=large
+KBUILD_CFLAGS += -m$(BITS)
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
