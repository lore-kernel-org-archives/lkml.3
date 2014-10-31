Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbaJaXbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 19:31:35 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:40090 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaJaXbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 19:31:34 -0400
MIME-Version: 1.0
In-Reply-To: <20141031205819.GA13262@www.outflux.net>
References: <20141031205819.GA13262@www.outflux.net>
Date: Fri, 31 Oct 2014 16:31:32 -0700
X-Google-Sender-Auth: 73DaoZRcnOwf5LYa5paLGaMpsNc
Message-ID: <CAE9FiQVYBwTifYXACeJRBOEtrN6o5kBpA6v0xLqUYS379pH-Mw@mail.gmail.com>
Subject: Re: [PATCH v2] x86, boot: add hex output for debugging
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Josh Triplett <josh@joshtriplett.org>,
        Junjie Mao <eternal.n08@gmail.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: multipart/mixed; boundary=089e0149d116b43c150506c065ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0149d116b43c150506c065ea
Content-Type: text/plain; charset=UTF-8

On Fri, Oct 31, 2014 at 1:58 PM, Kees Cook <keescook@chromium.org> wrote:
> This is useful for reporting various addresses or other values while
> debugging early boot. For example, when CONFIG_X86_VERBOSE_BOOTUP is set,
> this is now visible at boot time:
>
>         early console in setup code
>         early console in decompress_kernel
>         input_data: 0x0000000001e1526e
>         input_len: 0x0000000000732236
>         output: 0x0000000001000000
>         output_len: 0x0000000001535640
>         run_size: 0x00000000021fb000
>         KASLR using RDTSC...
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> Since this displays run_size, this patch depends on Junjie Mao's patch
> "x86, kaslr: Prevent .bss from overlaping initrd"
>
> ---
>  arch/x86/boot/compressed/misc.c | 24 ++++++++++++++++++++++++
>  arch/x86/boot/compressed/misc.h | 11 +++++++++++
>  2 files changed, 35 insertions(+)
...

We can reuse printf.c in arch/x86/boot.

I had attached one in local tree for a while. or even sent it before
several years ago.

Thanks

Yinghai


Subject: [PATCH] x86, boot: Add printf support for early console in
compressed/misc.c

Reuse printf.c in x86 setup code.
And print out decompress_kernel input and output info.

Later decompresser code could print out more info for debug info.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/compressed/Makefile |    2 +-
 arch/x86/boot/compressed/misc.c   |    8 ++++++++
 arch/x86/boot/compressed/misc.h   |    7 +++++++
 arch/x86/boot/compressed/printf.c |    5 +++++
 4 files changed, 21 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/boot/compressed/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/Makefile
+++ linux-2.6/arch/x86/boot/compressed/Makefile
@@ -28,7 +28,7 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/i

 vmlinux-objs-y := $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
     $(obj)/string.o $(obj)/cmdline.o \
-    $(obj)/piggy.o $(obj)/cpuflags.o
+    $(obj)/printf.o $(obj)/piggy.o $(obj)/cpuflags.o

 vmlinux-objs-$(CONFIG_EARLY_PRINTK) += $(obj)/early_serial_console.o
 vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/aslr.o
Index: linux-2.6/arch/x86/boot/compressed/printf.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/boot/compressed/printf.c
@@ -0,0 +1,5 @@
+#include "misc.h"
+
+#define puts(__x)  __putstr(__x)
+
+#include "../printf.c"
Index: linux-2.6/arch/x86/boot/compressed/misc.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/misc.c
+++ linux-2.6/arch/x86/boot/compressed/misc.c
@@ -390,6 +390,14 @@ asmlinkage __visible void *decompress_ke
     output = choose_kernel_location(input_data, input_len,
                     output, output_len);

+    debug_putstr("decompress_kernel:\n");
+    debug_printf("  input: [0x%lx-0x%lx], output: 0x%lx, heap:
[0x%lx-0x%lx]\n",
+         (unsigned long)input_data,
+         (unsigned long)input_data + input_len - 1,
+         (unsigned long)output,
+         (unsigned long)heap,
+         (unsigned long)heap + BOOT_HEAP_SIZE - 1);
+
     /* Validate memory location choices. */
     if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
         error("Destination address inappropriately aligned");
Index: linux-2.6/arch/x86/boot/compressed/misc.h
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/misc.h
+++ linux-2.6/arch/x86/boot/compressed/misc.h
@@ -36,14 +36,21 @@ extern struct boot_params *real_mode;        /
 void __putstr(const char *s);
 #define error_putstr(__x)  __putstr(__x)

+/* printf.c */
+int sprintf(char *buf, const char *fmt, ...);
+int printf(const char *fmt, ...);
+
 #ifdef CONFIG_X86_VERBOSE_BOOTUP

 #define debug_putstr(__x)  __putstr(__x)
+#define debug_printf printf

 #else

 static inline void debug_putstr(const char *s)
 { }
+static inline int debug_printf(const char *fmt, ...)
+{ }

 #endif

--089e0149d116b43c150506c065ea
Content-Type: text/x-patch; charset=US-ASCII; name="early_console_more_2_2x.patch"
Content-Disposition: attachment; filename="early_console_more_2_2x.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1y6c0k40

U3ViamVjdDogW1BBVENIXSB4ODYsIGJvb3Q6IEFkZCBwcmludGYgc3VwcG9ydCBmb3IgZWFybHkg
Y29uc29sZSBpbiBjb21wcmVzc2VkL21pc2MuYwoKUmV1c2UgcHJpbnRmLmMgaW4geDg2IHNldHVw
IGNvZGUuCkFuZCBwcmludCBvdXQgZGVjb21wcmVzc19rZXJuZWwgaW5wdXQgYW5kIG91dHB1dCBp
bmZvLgoKTGF0ZXIgZGVjb21wcmVzc2VyIGNvZGUgY291bGQgcHJpbnQgb3V0IG1vcmUgaW5mbyBm
b3IgZGVidWcgaW5mby4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVs
Lm9yZz4KCi0tLQogYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL01ha2VmaWxlIHwgICAgMiArLQog
YXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL21pc2MuYyAgIHwgICAgOCArKysrKysrKwogYXJjaC94
ODYvYm9vdC9jb21wcmVzc2VkL21pc2MuaCAgIHwgICAgNyArKysrKysrCiBhcmNoL3g4Ni9ib290
L2NvbXByZXNzZWQvcHJpbnRmLmMgfCAgICA1ICsrKysrCiA0IGZpbGVzIGNoYW5nZWQsIDIxIGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvYm9v
dC9jb21wcmVzc2VkL01ha2VmaWxlCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gv
eDg2L2Jvb3QvY29tcHJlc3NlZC9NYWtlZmlsZQorKysgbGludXgtMi42L2FyY2gveDg2L2Jvb3Qv
Y29tcHJlc3NlZC9NYWtlZmlsZQpAQCAtMjgsNyArMjgsNyBAQCBIT1NUX0VYVFJBQ0ZMQUdTICs9
IC1JJChzcmN0cmVlKS90b29scy9pCiAKIHZtbGludXgtb2Jqcy15IDo9ICQob2JqKS92bWxpbnV4
LmxkcyAkKG9iaikvaGVhZF8kKEJJVFMpLm8gJChvYmopL21pc2MubyBcCiAJJChvYmopL3N0cmlu
Zy5vICQob2JqKS9jbWRsaW5lLm8gXAotCSQob2JqKS9waWdneS5vICQob2JqKS9jcHVmbGFncy5v
CisJJChvYmopL3ByaW50Zi5vICQob2JqKS9waWdneS5vICQob2JqKS9jcHVmbGFncy5vCiAKIHZt
bGludXgtb2Jqcy0kKENPTkZJR19FQVJMWV9QUklOVEspICs9ICQob2JqKS9lYXJseV9zZXJpYWxf
Y29uc29sZS5vCiB2bWxpbnV4LW9ianMtJChDT05GSUdfUkFORE9NSVpFX0JBU0UpICs9ICQob2Jq
KS9hc2xyLm8KSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvcHJpbnRm
LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PQotLS0gL2Rldi9udWxsCisrKyBsaW51eC0yLjYvYXJjaC94ODYvYm9vdC9j
b21wcmVzc2VkL3ByaW50Zi5jCkBAIC0wLDAgKzEsNSBAQAorI2luY2x1ZGUgIm1pc2MuaCIKKwor
I2RlZmluZSBwdXRzKF9feCkgIF9fcHV0c3RyKF9feCkKKworI2luY2x1ZGUgIi4uL3ByaW50Zi5j
IgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9taXNjLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL21pc2MuYwor
KysgbGludXgtMi42L2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9taXNjLmMKQEAgLTM5MCw2ICsz
OTAsMTQgQEAgYXNtbGlua2FnZSBfX3Zpc2libGUgdm9pZCAqZGVjb21wcmVzc19rZQogCW91dHB1
dCA9IGNob29zZV9rZXJuZWxfbG9jYXRpb24oaW5wdXRfZGF0YSwgaW5wdXRfbGVuLAogCQkJCQlv
dXRwdXQsIG91dHB1dF9sZW4pOwogCisJZGVidWdfcHV0c3RyKCJkZWNvbXByZXNzX2tlcm5lbDpc
biIpOworCWRlYnVnX3ByaW50ZigiICBpbnB1dDogWzB4JWx4LTB4JWx4XSwgb3V0cHV0OiAweCVs
eCwgaGVhcDogWzB4JWx4LTB4JWx4XVxuIiwKKwkJICh1bnNpZ25lZCBsb25nKWlucHV0X2RhdGEs
CisJCSAodW5zaWduZWQgbG9uZylpbnB1dF9kYXRhICsgaW5wdXRfbGVuIC0gMSwKKwkJICh1bnNp
Z25lZCBsb25nKW91dHB1dCwKKwkJICh1bnNpZ25lZCBsb25nKWhlYXAsCisJCSAodW5zaWduZWQg
bG9uZyloZWFwICsgQk9PVF9IRUFQX1NJWkUgLSAxKTsKKwogCS8qIFZhbGlkYXRlIG1lbW9yeSBs
b2NhdGlvbiBjaG9pY2VzLiAqLwogCWlmICgodW5zaWduZWQgbG9uZylvdXRwdXQgJiAoTUlOX0tF
Uk5FTF9BTElHTiAtIDEpKQogCQllcnJvcigiRGVzdGluYXRpb24gYWRkcmVzcyBpbmFwcHJvcHJp
YXRlbHkgYWxpZ25lZCIpOwpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2Jvb3QvY29tcHJlc3Nl
ZC9taXNjLmgKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvYm9vdC9jb21w
cmVzc2VkL21pc2MuaAorKysgbGludXgtMi42L2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9taXNj
LmgKQEAgLTM2LDE0ICszNiwyMSBAQCBleHRlcm4gc3RydWN0IGJvb3RfcGFyYW1zICpyZWFsX21v
ZGU7CQkvCiB2b2lkIF9fcHV0c3RyKGNvbnN0IGNoYXIgKnMpOwogI2RlZmluZSBlcnJvcl9wdXRz
dHIoX194KSAgX19wdXRzdHIoX194KQogCisvKiBwcmludGYuYyAqLworaW50IHNwcmludGYoY2hh
ciAqYnVmLCBjb25zdCBjaGFyICpmbXQsIC4uLik7CitpbnQgcHJpbnRmKGNvbnN0IGNoYXIgKmZt
dCwgLi4uKTsKKwogI2lmZGVmIENPTkZJR19YODZfVkVSQk9TRV9CT09UVVAKIAogI2RlZmluZSBk
ZWJ1Z19wdXRzdHIoX194KSAgX19wdXRzdHIoX194KQorI2RlZmluZSBkZWJ1Z19wcmludGYgcHJp
bnRmCiAKICNlbHNlCiAKIHN0YXRpYyBpbmxpbmUgdm9pZCBkZWJ1Z19wdXRzdHIoY29uc3QgY2hh
ciAqcykKIHsgfQorc3RhdGljIGlubGluZSBpbnQgZGVidWdfcHJpbnRmKGNvbnN0IGNoYXIgKmZt
dCwgLi4uKQoreyB9CiAKICNlbmRpZgogCg==
--089e0149d116b43c150506c065ea--
