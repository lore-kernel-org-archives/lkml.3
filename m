Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618Ab3DBLOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:14:44 -0400
Received: from plane.gmane.org ([80.91.229.3]:57220 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757451Ab3DBLOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:14:43 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Wladislav Wiebe <wladislav.kw@gmail.com>
Subject: Re: [PATCH V2] mips: function tracer: Fix broken function tracing
Date: Tue, 2 Apr 2013 11:12:16 +0000 (UTC)
Message-ID: <loom.20130402T131118-818@post.gmane.org>
References: <1358379808-16449-1-git-send-email-alcooperx@gmail.com>  <CAMuHMdUSRM6dauiRtSs20YVfHmNrROrc4RpZL+dKA_e2t82J6A@mail.gmail.com>  <CAOGqxeWNfknkq2Kad2sTWh9f9C8HpghdNBimsB9HFs8ze=LHHQ@mail.gmail.com> <1358436945.23211.10.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 194.251.119.198 (Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:19.0) Gecko/20100101 Firefox/19.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a bad experience with MIPS 64 Bit Architecture on Kernel 3.8.
The Kernel doesn't boot when enabling CONFIG_FUNCTION_TRACER,
it hangs at early startup directly after u-boot init:

..
## Loading Linux kernel with entry point: 0xffffffff805e23c0 ...
Bootloader: Done loading app on coremask: 0x3f
setting up named block for __uboot_log at 0xfcf4000
...

Basically, I temporary workaround it with 
diff --git a/linux/arch/mips/kernel/mcount.S b/linux/arch/mips/kernel/mcount.S
index 1658676..4438c74 100644
--- a/linux/arch/mips/kernel/mcount.S
+++ b/linux/arch/mips/kernel/mcount.S
@@ -46,9 +46,8 @@
        PTR_L   a5, PT_R9(sp)
        PTR_L   a6, PT_R10(sp)
        PTR_L   a7, PT_R11(sp)
-#else
-       PTR_ADDIU       sp, PT_SIZE
 #endif
+       PTR_ADDIU       sp, PT_SIZE
 .endm
 
        .macro RETURN_BACK
@@ -68,7 +67,11 @@ NESTED(ftrace_caller, PT_SIZE, ra)
        .globl _mcount
 _mcount:
        b       ftrace_stub
+#ifdef CONFIG_64BIT
+       nop
+#else
        addiu sp,sp,8
+#endif
 
        /* When tracing is activated, it calls ftrace_caller+8 (aka here) */
        lw      t1, function_trace_stop


Are you going to fix this for 3.9 release?

