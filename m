Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088AbaD2WAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:00:38 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58518 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964783AbaD2WAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:00:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKCJvYSrFSBVCfijLhZEojm29JCY8ubQV1eAoyCCZDRZA@mail.gmail.com>
References: <1397859600-11507-1-git-send-email-robherring2@gmail.com>
	<1397859600-11507-4-git-send-email-robherring2@gmail.com>
	<CAE9FiQVp5u-jF_xjCu68BgbZ=e0D508tn_-auoiT6cbkYtX8Og@mail.gmail.com>
	<CAL_JsqKiYmCNGrkiwS7m-OAt3rHZBq_yNGycen-AojbV-7famg@mail.gmail.com>
	<CAE9FiQVdwumX7Dsmt8NJhw4uWsj2sjUKaKS1wJQujW1fn1szLw@mail.gmail.com>
	<CAL_Jsq+uNunqfsvPNxZLQQ3y1ay_XMZKb4c=HNWvKtwuiZGQ0g@mail.gmail.com>
	<CAE9FiQU40p-e8mqZKzaGg6nTuPdep3inRdpQtNu5txPOJ6Aw-Q@mail.gmail.com>
	<CAL_JsqKCJvYSrFSBVCfijLhZEojm29JCY8ubQV1eAoyCCZDRZA@mail.gmail.com>
Date: Tue, 29 Apr 2014 15:00:34 -0700
X-Google-Sender-Auth: 5wGiUtswvxM8e_OUQ1-42Gs1Km4
Message-ID: <CAE9FiQXUMHQxRZOOb+XNg0xbU7d6QY=VL3qhd0JdAw=wYc4W-A@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] tty/serial: convert 8250 to generic earlycon
From: Yinghai Lu <yinghai@kernel.org>
To: Rob Herring <robherring2@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: multipart/mixed; boundary=047d7bdc1b70b7d6a304f8358f24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bdc1b70b7d6a304f8358f24
Content-Type: text/plain; charset=UTF-8

On Tue, Apr 29, 2014 at 1:41 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Tue, Apr 29, 2014 at 1:22 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> You want to obsolete "console=uart,io,0x3f8,115200n8" ?
>>
>>  Let's check with Andrew. He suggested to use uart and uart8250 at that time.
>
> No, that is not what I'm saying. For the 2 callers of
> setup_early_serial8250_console which are crafting a console string
> from firmware data, they can and do use uart8250. I don't expect this
> mechanism for setting up early console to expand to other users. The
> whole point of this series is to allow any uart to be supported for
> earlycon. For anyone using the kernel command line, both uart and
> uart8250 are still supported.

That is confusing, why not keeping them consistent?

I posted one patch before about "early early console for x86", and it
is in my local tree
 for some time.support both "uart,io" and "uart8250,io".

Peter, Can you check that patch again?  --- updated version attached.
and inlined.

Thanks

Yinghai

Subject: [PATCH -v4] x86: Setup early console as early as possible in
x86_start_kernel()

Analyze "console=uart8250,io,0x3f8,115200n8" in
i386_start_kernel/x86_64_start_kernel,
and call setup_early_serial8250_console() to init early serial console.

Only can handle io port kind of 8250, because mmio need ioremap.

Use boot_params.hdr.version instead of adding another variable,
Suggested by hpa.
Also need to apply this one after x86 memblock patchset.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/setup.h |    2 ++
 arch/x86/kernel/head.c       |   26 ++++++++++++++++++++++++++
 arch/x86/kernel/head32.c     |    1 +
 arch/x86/kernel/head64.c     |    5 ++++-
 kernel/printk/printk.c       |   11 +++++++----
 5 files changed, 40 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -49,6 +49,8 @@ static inline void x86_acpi_override_fin
 #endif

 extern unsigned long saved_video_mode;
+int setup_early_serial8250_console(char *cmdline);
+void setup_early_console(void);

 extern void reserve_standard_io_resources(void);
 extern void i386_reserve_resources(void);
Index: linux-2.6/arch/x86/kernel/head.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head.c
+++ linux-2.6/arch/x86/kernel/head.c
@@ -69,3 +69,29 @@ void __init reserve_ebda_region(void)
     /* reserve all memory between lowmem and the 1MB mark */
     memblock_reserve(lowmem, 0x100000 - lowmem);
 }
+
+void __init setup_early_console(void)
+{
+#ifdef CONFIG_SERIAL_8250_CONSOLE
+    char constr[64], *p, *q;
+
+    /* Can not handle mmio type 8250 uart yet, too early */
+    p = strstr(boot_command_line, "console=uart8250,io,");
+    if (!p)
+        p = strstr(boot_command_line, "console=uart,io,");
+    if (!p)
+        return;
+
+    p += 8;    /* sizeof "console=" */
+    q = strchr(p, ' ');
+    if ((q - p) >= sizeof(constr))
+        return;
+
+    memset(constr, 0, sizeof(constr));
+    memcpy(constr, p, q - p);
+
+    lockdep_init();
+
+    setup_early_serial8250_console(constr);
+#endif
+}
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -32,6 +32,7 @@ static void __init i386_default_early_se
 void __init i386_start_kernel(void)
 {
     sanitize_boot_params(&boot_params);
+    setup_early_console();

     /* Call the subarch specific early setup function */
     switch (boot_params.hdr.hardware_subarch) {
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -166,6 +166,7 @@ void __init x86_64_start_kernel(char * r
     load_idt((const struct desc_ptr *)&idt_descr);

     copy_bootdata(__va(real_mode_data));
+    setup_early_console();

     /*
      * Load microcode early on BSP.
@@ -187,8 +188,10 @@ void __init x86_64_start_kernel(char * r
 void __init x86_64_start_reservations(char *real_mode_data)
 {
     /* version is always not zero if it is copied */
-    if (!boot_params.hdr.version)
+    if (!boot_params.hdr.version) {
         copy_bootdata(__va(real_mode_data));
+        setup_early_console();
+    }

     reserve_ebda_region();

Index: linux-2.6/kernel/printk/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk/printk.c
+++ linux-2.6/kernel/printk/printk.c
@@ -2227,11 +2227,14 @@ void register_console(struct console *ne
     struct console_cmdline *c;

     if (console_drivers)
-        for_each_console(bcon)
-            if (WARN(bcon == newcon,
-                    "console '%s%d' already registered\n",
-                    bcon->name, bcon->index))
+        for_each_console(bcon) {
+            /* not again */
+            if (bcon == newcon) {
+                printk(KERN_INFO "console '%s%d' already registered\n",
+                    bcon->name, bcon->index);
                 return;
+            }
+    }

     /*
      * before we register a new CON_BOOT console, make sure we don't

--047d7bdc1b70b7d6a304f8358f24
Content-Type: text/x-patch; charset=US-ASCII; 
	name="setup_early_console_x1_pa_symbol_before_earlcon.patch"
Content-Disposition: attachment; 
	filename="setup_early_console_x1_pa_symbol_before_earlcon.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hulqdind0

U3ViamVjdDogW1BBVENIIC12NF0geDg2OiBTZXR1cCBlYXJseSBjb25zb2xlIGFzIGVhcmx5IGFz
IHBvc3NpYmxlIGluIHg4Nl9zdGFydF9rZXJuZWwoKQoKQW5hbHl6ZSAiY29uc29sZT11YXJ0ODI1
MCxpbywweDNmOCwxMTUyMDBuOCIgaW4gaTM4Nl9zdGFydF9rZXJuZWwveDg2XzY0X3N0YXJ0X2tl
cm5lbCwKYW5kIGNhbGwgc2V0dXBfZWFybHlfc2VyaWFsODI1MF9jb25zb2xlKCkgdG8gaW5pdCBl
YXJseSBzZXJpYWwgY29uc29sZS4KCk9ubHkgY2FuIGhhbmRsZSBpbyBwb3J0IGtpbmQgb2YgODI1
MCwgYmVjYXVzZSBtbWlvIG5lZWQgaW9yZW1hcC4KClVzZSBib290X3BhcmFtcy5oZHIudmVyc2lv
biBpbnN0ZWFkIG9mIGFkZGluZyBhbm90aGVyIHZhcmlhYmxlLCBTdWdnZXN0ZWQgYnkgaHBhLgpB
bHNvIG5lZWQgdG8gYXBwbHkgdGhpcyBvbmUgYWZ0ZXIgeDg2IG1lbWJsb2NrIHBhdGNoc2V0LgoK
U2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgotLS0KIGFyY2gv
eDg2L2luY2x1ZGUvYXNtL3NldHVwLmggfCAgICAyICsrCiBhcmNoL3g4Ni9rZXJuZWwvaGVhZC5j
ICAgICAgIHwgICAyNiArKysrKysrKysrKysrKysrKysrKysrKysrKwogYXJjaC94ODYva2VybmVs
L2hlYWQzMi5jICAgICB8ICAgIDEgKwogYXJjaC94ODYva2VybmVsL2hlYWQ2NC5jICAgICB8ICAg
IDUgKysrKy0KIGtlcm5lbC9wcmludGsvcHJpbnRrLmMgICAgICAgfCAgIDExICsrKysrKystLS0t
CiA1IGZpbGVzIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpJbmRl
eDogbGludXgtMi42L2FyY2gveDg2L2luY2x1ZGUvYXNtL3NldHVwLmgKPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0g
bGludXgtMi42Lm9yaWcvYXJjaC94ODYvaW5jbHVkZS9hc20vc2V0dXAuaAorKysgbGludXgtMi42
L2FyY2gveDg2L2luY2x1ZGUvYXNtL3NldHVwLmgKQEAgLTQ5LDYgKzQ5LDggQEAgc3RhdGljIGlu
bGluZSB2b2lkIHg4Nl9hY3BpX292ZXJyaWRlX2ZpbgogI2VuZGlmCiAKIGV4dGVybiB1bnNpZ25l
ZCBsb25nIHNhdmVkX3ZpZGVvX21vZGU7CitpbnQgc2V0dXBfZWFybHlfc2VyaWFsODI1MF9jb25z
b2xlKGNoYXIgKmNtZGxpbmUpOwordm9pZCBzZXR1cF9lYXJseV9jb25zb2xlKHZvaWQpOwogCiBl
eHRlcm4gdm9pZCByZXNlcnZlX3N0YW5kYXJkX2lvX3Jlc291cmNlcyh2b2lkKTsKIGV4dGVybiB2
b2lkIGkzODZfcmVzZXJ2ZV9yZXNvdXJjZXModm9pZCk7CkluZGV4OiBsaW51eC0yLjYvYXJjaC94
ODYva2VybmVsL2hlYWQuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9r
ZXJuZWwvaGVhZC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2hlYWQuYwpAQCAtNjks
MyArNjksMjkgQEAgdm9pZCBfX2luaXQgcmVzZXJ2ZV9lYmRhX3JlZ2lvbih2b2lkKQogCS8qIHJl
c2VydmUgYWxsIG1lbW9yeSBiZXR3ZWVuIGxvd21lbSBhbmQgdGhlIDFNQiBtYXJrICovCiAJbWVt
YmxvY2tfcmVzZXJ2ZShsb3dtZW0sIDB4MTAwMDAwIC0gbG93bWVtKTsKIH0KKwordm9pZCBfX2lu
aXQgc2V0dXBfZWFybHlfY29uc29sZSh2b2lkKQoreworI2lmZGVmIENPTkZJR19TRVJJQUxfODI1
MF9DT05TT0xFCisJY2hhciBjb25zdHJbNjRdLCAqcCwgKnE7CisKKwkvKiBDYW4gbm90IGhhbmRs
ZSBtbWlvIHR5cGUgODI1MCB1YXJ0IHlldCwgdG9vIGVhcmx5ICovCisJcCA9IHN0cnN0cihib290
X2NvbW1hbmRfbGluZSwgImNvbnNvbGU9dWFydDgyNTAsaW8sIik7CisJaWYgKCFwKQorCQlwID0g
c3Ryc3RyKGJvb3RfY29tbWFuZF9saW5lLCAiY29uc29sZT11YXJ0LGlvLCIpOworCWlmICghcCkK
KwkJcmV0dXJuOworCisJcCArPSA4OwkvKiBzaXplb2YgImNvbnNvbGU9IiAqLworCXEgPSBzdHJj
aHIocCwgJyAnKTsKKwlpZiAoKHEgLSBwKSA+PSBzaXplb2YoY29uc3RyKSkKKwkJcmV0dXJuOwor
CisJbWVtc2V0KGNvbnN0ciwgMCwgc2l6ZW9mKGNvbnN0cikpOworCW1lbWNweShjb25zdHIsIHAs
IHEgLSBwKTsKKworCWxvY2tkZXBfaW5pdCgpOworCisJc2V0dXBfZWFybHlfc2VyaWFsODI1MF9j
b25zb2xlKGNvbnN0cik7CisjZW5kaWYKK30KSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJu
ZWwvaGVhZDMyLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVs
L2hlYWQzMi5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2hlYWQzMi5jCkBAIC0zMiw2
ICszMiw3IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBpMzg2X2RlZmF1bHRfZWFybHlfc2UKIHZvaWQg
X19pbml0IGkzODZfc3RhcnRfa2VybmVsKHZvaWQpCiB7CiAJc2FuaXRpemVfYm9vdF9wYXJhbXMo
JmJvb3RfcGFyYW1zKTsKKwlzZXR1cF9lYXJseV9jb25zb2xlKCk7CiAKIAkvKiBDYWxsIHRoZSBz
dWJhcmNoIHNwZWNpZmljIGVhcmx5IHNldHVwIGZ1bmN0aW9uICovCiAJc3dpdGNoIChib290X3Bh
cmFtcy5oZHIuaGFyZHdhcmVfc3ViYXJjaCkgewpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tl
cm5lbC9oZWFkNjQuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9rZXJu
ZWwvaGVhZDY0LmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvaGVhZDY0LmMKQEAgLTE2
Niw2ICsxNjYsNyBAQCB2b2lkIF9faW5pdCB4ODZfNjRfc3RhcnRfa2VybmVsKGNoYXIgKiByCiAJ
bG9hZF9pZHQoKGNvbnN0IHN0cnVjdCBkZXNjX3B0ciAqKSZpZHRfZGVzY3IpOwogCiAJY29weV9i
b290ZGF0YShfX3ZhKHJlYWxfbW9kZV9kYXRhKSk7CisJc2V0dXBfZWFybHlfY29uc29sZSgpOwog
CiAJLyoKIAkgKiBMb2FkIG1pY3JvY29kZSBlYXJseSBvbiBCU1AuCkBAIC0xODcsOCArMTg4LDEw
IEBAIHZvaWQgX19pbml0IHg4Nl82NF9zdGFydF9rZXJuZWwoY2hhciAqIHIKIHZvaWQgX19pbml0
IHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMoY2hhciAqcmVhbF9tb2RlX2RhdGEpCiB7CiAJLyog
dmVyc2lvbiBpcyBhbHdheXMgbm90IHplcm8gaWYgaXQgaXMgY29waWVkICovCi0JaWYgKCFib290
X3BhcmFtcy5oZHIudmVyc2lvbikKKwlpZiAoIWJvb3RfcGFyYW1zLmhkci52ZXJzaW9uKSB7CiAJ
CWNvcHlfYm9vdGRhdGEoX192YShyZWFsX21vZGVfZGF0YSkpOworCQlzZXR1cF9lYXJseV9jb25z
b2xlKCk7CisJfQogCiAJcmVzZXJ2ZV9lYmRhX3JlZ2lvbigpOwogCkluZGV4OiBsaW51eC0yLjYv
a2VybmVsL3ByaW50ay9wcmludGsuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9rZXJu
ZWwvcHJpbnRrL3ByaW50ay5jCisrKyBsaW51eC0yLjYva2VybmVsL3ByaW50ay9wcmludGsuYwpA
QCAtMjIyNywxMSArMjIyNywxNCBAQCB2b2lkIHJlZ2lzdGVyX2NvbnNvbGUoc3RydWN0IGNvbnNv
bGUgKm5lCiAJc3RydWN0IGNvbnNvbGVfY21kbGluZSAqYzsKIAogCWlmIChjb25zb2xlX2RyaXZl
cnMpCi0JCWZvcl9lYWNoX2NvbnNvbGUoYmNvbikKLQkJCWlmIChXQVJOKGJjb24gPT0gbmV3Y29u
LAotCQkJCQkiY29uc29sZSAnJXMlZCcgYWxyZWFkeSByZWdpc3RlcmVkXG4iLAotCQkJCQliY29u
LT5uYW1lLCBiY29uLT5pbmRleCkpCisJCWZvcl9lYWNoX2NvbnNvbGUoYmNvbikgeworCQkJLyog
bm90IGFnYWluICovCisJCQlpZiAoYmNvbiA9PSBuZXdjb24pIHsKKwkJCQlwcmludGsoS0VSTl9J
TkZPICJjb25zb2xlICclcyVkJyBhbHJlYWR5IHJlZ2lzdGVyZWRcbiIsCisJCQkJCWJjb24tPm5h
bWUsIGJjb24tPmluZGV4KTsKIAkJCQlyZXR1cm47CisJCQl9CisJfQogCiAJLyoKIAkgKiBiZWZv
cmUgd2UgcmVnaXN0ZXIgYSBuZXcgQ09OX0JPT1QgY29uc29sZSwgbWFrZSBzdXJlIHdlIGRvbid0
Cg==
--047d7bdc1b70b7d6a304f8358f24--
