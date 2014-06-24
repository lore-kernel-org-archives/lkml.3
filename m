Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaFXTnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:43:41 -0400
Received: from orange.myspectrum.nl ([149.210.134.247]:49306 "EHLO
	orange.myspectrum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFXTnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:43:40 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2014 15:43:40 EDT
Message-ID: <53A9D326.9060409@myspectrum.nl>
Date: Tue, 24 Jun 2014 21:36:06 +0200
From: Jeroen Hofstee <jeroen@myspectrum.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
CC: u-boot@lists.denx.de, linux-kernel@vger.kernel.org
Subject: Re: [U-Boot] [RFC] kbuild.h: workaround for llvm IAS
References: <1402609254-14078-1-git-send-email-jeroen@myspectrum.nl> <20140624215349.3E89.AA925319@jp.panasonic.com>
In-Reply-To: <20140624215349.3E89.AA925319@jp.panasonic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masahiro,

On 24-06-14 14:53, Masahiro Yamada wrote:
> On Thu, 12 Jun 2014 23:40:54 +0200
> Jeroen Hofstee <jeroen@myspectrum.nl> wrote:
>
>> KBuild (ab)uses the asm statement to write to a file and
>> llvm integrated as chokes about these invalid asm statements.
>> Workaround it by making it look like valid asm code.
>>
>> Signed-off-by: Jeroen Hofstee <jeroen@myspectrum.nl>
> I think Linux has the same problem.
>
> Are you willing to this patch to linux-kbuild ML?
> Or fixing U-Boot only?
I don't mind in general, but it is just noise for them (cc-ing them to
create some).  For u-boot (ARM) you actually get a valid binary with
this patch after clang support has landed, for linux you just get other
errors as far as I tried (native only), patch below.

However in linux there seem more spots relying on the format, e.g.
     arch/ia64/kvm/Makefile
     arch/ia64/kernel/Makefile
     arch/um/Makefile

So if anything, I think this should be made a general rules first
in the makefiles. It seems stupid to potentially break something
while it gains nothing.

So yes, u-boot only afaic, or does that make your syncing more difficult?

Regards,
Jeroen


--- a/Kbuild
+++ b/Kbuild
@@ -52,7 +52,8 @@ targets += arch/$(SRCARCH)/kernel/asm-offsets.s

  # Default sed regexp - multiline due to syntax constraints
  define sed-y
-       "/^->/{s:->#\(.*\):/* \1 */:; \
+       "s:[[:space:]]*\.ascii[[:space:]]*\"\(.*\)\":\1:; \
+       /^->/{s:->#\(.*\):/* \1 */:; \
         s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
         s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
         s:->::; p;}"
diff --git a/include/linux/kbuild.h b/include/linux/kbuild.h
index 22a7219..4e80f3a 100644
--- a/include/linux/kbuild.h
+++ b/include/linux/kbuild.h
@@ -2,14 +2,14 @@
  #define __LINUX_KBUILD_H

  #define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+       asm volatile("\n.ascii \"->" #sym " %0 " #val "\"" : : "i" (val))

-#define BLANK() asm volatile("\n->" : : )
+#define BLANK() asm volatile("\n.ascii \"->\"" : : )

  #define OFFSET(sym, str, mem) \
         DEFINE(sym, offsetof(struct str, mem))

  #define COMMENT(x) \
-       asm volatile("\n->#" x)
+       asm volatile("\n.ascii \"->#" x "\"")

  #endif
diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index c11212f..0698af3 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -6,7 +6,8 @@ modpost-objs    := modpost.o file2alias.o sumversion.o
  devicetable-offsets-file := devicetable-offsets.h

  define sed-y
-       "/^->/{s:->#\(.*\):/* \1 */:; \
+       "s:[[:space:]]*\.ascii[[:space:]]*\"\(.*\)\":\1:; \
+       /^->/{s:->#\(.*\):/* \1 */:; \
         s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
         s:^->\([^ ]*\) [\$$#]*\([^ ]*\) \(.*\):#define \1 \2 /* \3 */:; \
         s:->::; p;}"
