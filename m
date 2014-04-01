Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaDAXJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:09:35 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:56451 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaDAXJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:09:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKMF9n9svQBhyQFvCoUe86QhLycDTt-fWyiRfySbn=Fug@mail.gmail.com>
References: <1396346657-7166-1-git-send-email-holler@ahsoftware.de>
 <533AFF77.5030106@codeaurora.org> <CAGXu5jKMF9n9svQBhyQFvCoUe86QhLycDTt-fWyiRfySbn=Fug@mail.gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Wed, 2 Apr 2014 01:08:45 +0200
X-Google-Sender-Auth: sSH6i4YdQdAJvP4gF0wJDWmo6yI
Message-ID: <CAH+eYFDkYczZXYF3be6tTRg7kkGhK2zyukDTo+N8mwEKcG89LA@mail.gmail.com>
Subject: Re: [PATCH] arm: don't allow CONFIG_DEBUG_SET_MODULE_RONX if
 CONFIG_JUMP_LABEL is enabled
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: multipart/mixed; boundary=001a11380ac46213f704f6034277
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11380ac46213f704f6034277
Content-Type: text/plain; charset=ISO-8859-1

2014-04-01 20:36 GMT+02:00 Kees Cook <keescook@chromium.org>:
> Is there something "sticky" about PMD sections that I'm not aware of?
> Even after calling set_kernel_text_rw(), any writes to kernel memory
> fault. :(

section_update() updates init_mm, but each mm has a copy of the first
level page tables.  So your updates to init_mm won't be visibile to
currently running processes.  (Have a look at arch/arm/mm/ioremap.c's
vmalloc_seq stuff for some background on how section support is
handled on non-SMP; the vmalloc code doesn't use sections on SMP.)

Here's a patch (probably whitespace damaged, hence also attached) with
which dynamic ftrace works for me on top your other paches.  Tested on
a non-LPAE SMP.

Notes:
- I commented out the other entries in section_perm except from the
kernel text only because I didn't want to figure out the mask values
to use
- I didn't/couldn't call set_kernel_text_rw in
ftrace_arch_code_modify_prepare() because that is called outside of
stop_machine(), and stop_machine() triggers another thread which
actually runs ftrace_modify_all_code() with the machine stopped.


>From 91d92b8e241835013cefaca0c5121b9d6df9d500 Mon Sep 17 00:00:00 2001
From: Rabin Vincent <rabin@rab.in>
Date: Wed, 2 Apr 2014 00:57:09 +0200
Subject: [PATCH] ftrace

---
 arch/arm/kernel/ftrace.c | 21 +++++++++++++
 arch/arm/mm/init.c       | 77 ++++++++++++++++++++++++++++++++++--------------
 2 files changed, 76 insertions(+), 22 deletions(-)

diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 34e5664..61cb8ef 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -14,6 +14,7 @@

 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
+#include <linux/stop_machine.h>

 #include <asm/cacheflush.h>
 #include <asm/opcodes.h>
@@ -34,6 +35,26 @@

 #define OLD_NOP 0xe1a00000 /* mov r0, r0 */

+static int __ftrace_modify_code(void *data)
+{
+ extern void set_kernel_text_rw(struct mm_struct *mm);
+ extern void set_kernel_text_ro(struct mm_struct *mm);
+
+ struct mm_struct *mm = current->active_mm;
+ int *command = data;
+
+ set_kernel_text_rw(mm);
+ ftrace_modify_all_code(*command);
+ set_kernel_text_ro(mm);
+
+ return 0;
+}
+
+void arch_ftrace_update_code(int command)
+{
+ stop_machine(__ftrace_modify_code, &command, NULL);
+}
+
 static unsigned long ftrace_nop_replace(struct dyn_ftrace *rec)
 {
  return rec->arch.old_mcount ? OLD_NOP : NOP;
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 5b1b049..c4da92d 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -630,22 +630,24 @@ void __init mem_init(void)
 struct section_perm {
  unsigned long start;
  unsigned long end;
+ pmdval_t mask;
  pmdval_t prot;
+ pmdval_t clear;
 };

-struct section_perm __initdata section_perms[] = {
+struct section_perm section_perms[] = {
  /* Make pages tables, etc before _stext RW (set NX). */
- {
- .start = PAGE_OFFSET,
- .end = (unsigned long)_stext,
- .prot = PMD_SECT_XN,
- },
- /* Make init RW (set NX). */
- {
- .start = (unsigned long)__init_begin,
- .end = (unsigned long)_sdata,
- .prot = PMD_SECT_XN,
- },
+ // {
+ // .start = PAGE_OFFSET,
+ // .end = (unsigned long)_stext,
+ // .prot = PMD_SECT_XN,
+ // },
+ // /* Make init RW (set NX). */
+ // {
+ // .start = (unsigned long)__init_begin,
+ // .end = (unsigned long)_sdata,
+ // .prot = PMD_SECT_XN,
+ // },
  /* Make kernel code and rodata RX (set RO). */
  {
  .start = (unsigned long)_stext,
@@ -653,30 +655,37 @@ struct section_perm __initdata section_perms[] = {
 #ifdef CONFIG_ARM_LPAE
  .prot = PMD_SECT_RDONLY,
 #else
+ .mask       = ~(PMD_SECT_APX | PMD_SECT_AP_WRITE),
  .prot = PMD_SECT_APX | PMD_SECT_AP_WRITE,
+ .clear       = PMD_SECT_AP_WRITE,
 #endif
  },
 #ifdef CONFIG_DEBUG_RODATA
  /* Make rodata RO (set NX). */
- {
- .start = (unsigned long)__start_rodata,
- .end = (unsigned long)__init_begin,
- .prot = PMD_SECT_XN,
- }
+ // {
+ // .start = (unsigned long)__start_rodata,
+ // .end = (unsigned long)__init_begin,
+ // .prot = PMD_SECT_XN,
+ // }
 #endif
 };

-static inline void section_update(unsigned long addr, pmdval_t prot)
+static inline pmd_t *pmd_off(struct mm_struct *mm, unsigned long virt)
+{
+ return pmd_offset(pud_offset(pgd_offset(mm, virt), virt), virt);
+}
+
+static inline void section_update(struct mm_struct *mm, unsigned long
addr, pmdval_t mask, pmdval_t prot)
 {
- pmd_t *pmd = pmd_off_k(addr);
+ pmd_t *pmd = pmd_off(mm, addr);

 #ifdef CONFIG_ARM_LPAE
  pmd[0] = __pmd(pmd_val(pmd[0]) | prot);
 #else
  if (addr & SECTION_SIZE)
- pmd[1] = __pmd(pmd_val(pmd[1]) | prot);
+ pmd[1] = __pmd((pmd_val(pmd[1]) & mask) | prot);
  else
- pmd[0] = __pmd(pmd_val(pmd[0]) | prot);
+ pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
 #endif
  flush_pmd_entry(pmd);
 }
@@ -702,13 +711,37 @@ static inline void fix_kernmem_perms(void)
  for (addr = section_perms[i].start;
      addr < section_perms[i].end;
      addr += SECTION_SIZE)
- section_update(addr, section_perms[i].prot);
+ section_update(&init_mm, addr, section_perms[i].mask, section_perms[i].prot);
  }
 }
 #else
 static inline void fix_kernmem_perms(void) { }
 #endif /* CONFIG_ARM_KERNMEM_PERMS */

+void set_kernel_text_rw(struct mm_struct *mm)
+{
+       unsigned long addr;
+
+       for (addr = section_perms[0].start;
+            addr < section_perms[0].end;
+            addr += SECTION_SIZE)
+              section_update(mm, addr, section_perms[0].mask,
+                            section_perms[0].clear);
+
+       flush_tlb_all();
+}
+
+void set_kernel_text_ro(struct mm_struct *mm)
+{
+       unsigned long addr;
+
+       for (addr = section_perms[0].start;
+            addr < section_perms[0].end;
+            addr += SECTION_SIZE)
+              section_update(mm, addr, section_perms[0].mask,
+                            section_perms[0].prot);
+}
+
 void free_initmem(void)
 {
 #ifdef CONFIG_HAVE_TCM
-- 
1.9.0

--001a11380ac46213f704f6034277
Content-Type: text/x-patch; charset=US-ASCII; name="0001-ftrace.patch"
Content-Disposition: attachment; filename="0001-ftrace.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hthsnm1r0

RnJvbSA5MWQ5MmI4ZTI0MTgzNTAxM2NlZmFjYTBjNTEyMWI5ZDZkZjlkNTAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSYWJpbiBWaW5jZW50IDxyYWJpbkByYWIuaW4+CkRhdGU6IFdl
ZCwgMiBBcHIgMjAxNCAwMDo1NzowOSArMDIwMApTdWJqZWN0OiBbUEFUQ0hdIGZ0cmFjZQoKLS0t
CiBhcmNoL2FybS9rZXJuZWwvZnRyYWNlLmMgfCAyMSArKysrKysrKysrKysrCiBhcmNoL2FybS9t
bS9pbml0LmMgICAgICAgfCA3NyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgNzYgaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm0va2VybmVsL2Z0cmFjZS5jIGIvYXJjaC9hcm0v
a2VybmVsL2Z0cmFjZS5jCmluZGV4IDM0ZTU2NjQuLjYxY2I4ZWYgMTAwNjQ0Ci0tLSBhL2FyY2gv
YXJtL2tlcm5lbC9mdHJhY2UuYworKysgYi9hcmNoL2FybS9rZXJuZWwvZnRyYWNlLmMKQEAgLTE0
LDYgKzE0LDcgQEAKIAogI2luY2x1ZGUgPGxpbnV4L2Z0cmFjZS5oPgogI2luY2x1ZGUgPGxpbnV4
L3VhY2Nlc3MuaD4KKyNpbmNsdWRlIDxsaW51eC9zdG9wX21hY2hpbmUuaD4KIAogI2luY2x1ZGUg
PGFzbS9jYWNoZWZsdXNoLmg+CiAjaW5jbHVkZSA8YXNtL29wY29kZXMuaD4KQEAgLTM0LDYgKzM1
LDI2IEBACiAKICNkZWZpbmUJT0xEX05PUAkJMHhlMWEwMDAwMAkvKiBtb3YgcjAsIHIwICovCiAK
K3N0YXRpYyBpbnQgX19mdHJhY2VfbW9kaWZ5X2NvZGUodm9pZCAqZGF0YSkKK3sKKwlleHRlcm4g
dm9pZCBzZXRfa2VybmVsX3RleHRfcncoc3RydWN0IG1tX3N0cnVjdCAqbW0pOworCWV4dGVybiB2
b2lkIHNldF9rZXJuZWxfdGV4dF9ybyhzdHJ1Y3QgbW1fc3RydWN0ICptbSk7CisKKwlzdHJ1Y3Qg
bW1fc3RydWN0ICptbSA9IGN1cnJlbnQtPmFjdGl2ZV9tbTsKKwlpbnQgKmNvbW1hbmQgPSBkYXRh
OworCisJc2V0X2tlcm5lbF90ZXh0X3J3KG1tKTsKKwlmdHJhY2VfbW9kaWZ5X2FsbF9jb2RlKCpj
b21tYW5kKTsKKwlzZXRfa2VybmVsX3RleHRfcm8obW0pOworCisJcmV0dXJuIDA7Cit9CisKK3Zv
aWQgYXJjaF9mdHJhY2VfdXBkYXRlX2NvZGUoaW50IGNvbW1hbmQpCit7CisJc3RvcF9tYWNoaW5l
KF9fZnRyYWNlX21vZGlmeV9jb2RlLCAmY29tbWFuZCwgTlVMTCk7Cit9CisKIHN0YXRpYyB1bnNp
Z25lZCBsb25nIGZ0cmFjZV9ub3BfcmVwbGFjZShzdHJ1Y3QgZHluX2Z0cmFjZSAqcmVjKQogewog
CXJldHVybiByZWMtPmFyY2gub2xkX21jb3VudCA/IE9MRF9OT1AgOiBOT1A7CmRpZmYgLS1naXQg
YS9hcmNoL2FybS9tbS9pbml0LmMgYi9hcmNoL2FybS9tbS9pbml0LmMKaW5kZXggNWIxYjA0OS4u
YzRkYTkyZCAxMDA2NDQKLS0tIGEvYXJjaC9hcm0vbW0vaW5pdC5jCisrKyBiL2FyY2gvYXJtL21t
L2luaXQuYwpAQCAtNjMwLDIyICs2MzAsMjQgQEAgdm9pZCBfX2luaXQgbWVtX2luaXQodm9pZCkK
IHN0cnVjdCBzZWN0aW9uX3Blcm0gewogCXVuc2lnbmVkIGxvbmcgc3RhcnQ7CiAJdW5zaWduZWQg
bG9uZyBlbmQ7CisJcG1kdmFsX3QgbWFzazsKIAlwbWR2YWxfdCBwcm90OworCXBtZHZhbF90IGNs
ZWFyOwogfTsKIAotc3RydWN0IHNlY3Rpb25fcGVybSBfX2luaXRkYXRhIHNlY3Rpb25fcGVybXNb
XSA9IHsKK3N0cnVjdCBzZWN0aW9uX3Blcm0gc2VjdGlvbl9wZXJtc1tdID0gewogCS8qIE1ha2Ug
cGFnZXMgdGFibGVzLCBldGMgYmVmb3JlIF9zdGV4dCBSVyAoc2V0IE5YKS4gKi8KLQl7Ci0JCS5z
dGFydAk9IFBBR0VfT0ZGU0VULAotCQkuZW5kCT0gKHVuc2lnbmVkIGxvbmcpX3N0ZXh0LAotCQku
cHJvdAk9IFBNRF9TRUNUX1hOLAotCX0sCi0JLyogTWFrZSBpbml0IFJXIChzZXQgTlgpLiAqLwot
CXsKLQkJLnN0YXJ0CT0gKHVuc2lnbmVkIGxvbmcpX19pbml0X2JlZ2luLAotCQkuZW5kCT0gKHVu
c2lnbmVkIGxvbmcpX3NkYXRhLAotCQkucHJvdAk9IFBNRF9TRUNUX1hOLAotCX0sCisJLy8gewor
CS8vIAkuc3RhcnQJPSBQQUdFX09GRlNFVCwKKwkvLyAJLmVuZAk9ICh1bnNpZ25lZCBsb25nKV9z
dGV4dCwKKwkvLyAJLnByb3QJPSBQTURfU0VDVF9YTiwKKwkvLyB9LAorCS8vIC8qIE1ha2UgaW5p
dCBSVyAoc2V0IE5YKS4gKi8KKwkvLyB7CisJLy8gCS5zdGFydAk9ICh1bnNpZ25lZCBsb25nKV9f
aW5pdF9iZWdpbiwKKwkvLyAJLmVuZAk9ICh1bnNpZ25lZCBsb25nKV9zZGF0YSwKKwkvLyAJLnBy
b3QJPSBQTURfU0VDVF9YTiwKKwkvLyB9LAogCS8qIE1ha2Uga2VybmVsIGNvZGUgYW5kIHJvZGF0
YSBSWCAoc2V0IFJPKS4gKi8KIAl7CiAJCS5zdGFydAk9ICh1bnNpZ25lZCBsb25nKV9zdGV4dCwK
QEAgLTY1MywzMCArNjU1LDM3IEBAIHN0cnVjdCBzZWN0aW9uX3Blcm0gX19pbml0ZGF0YSBzZWN0
aW9uX3Blcm1zW10gPSB7CiAjaWZkZWYgQ09ORklHX0FSTV9MUEFFCiAJCS5wcm90CT0gUE1EX1NF
Q1RfUkRPTkxZLAogI2Vsc2UKKwkJLm1hc2sgICAgICAgPSB+KFBNRF9TRUNUX0FQWCB8IFBNRF9T
RUNUX0FQX1dSSVRFKSwKIAkJLnByb3QJPSBQTURfU0VDVF9BUFggfCBQTURfU0VDVF9BUF9XUklU
RSwKKwkJLmNsZWFyICAgICAgID0gUE1EX1NFQ1RfQVBfV1JJVEUsCiAjZW5kaWYKIAl9LAogI2lm
ZGVmIENPTkZJR19ERUJVR19ST0RBVEEKIAkvKiBNYWtlIHJvZGF0YSBSTyAoc2V0IE5YKS4gKi8K
LQl7Ci0JCS5zdGFydAk9ICh1bnNpZ25lZCBsb25nKV9fc3RhcnRfcm9kYXRhLAotCQkuZW5kCT0g
KHVuc2lnbmVkIGxvbmcpX19pbml0X2JlZ2luLAotCQkucHJvdAk9IFBNRF9TRUNUX1hOLAotCX0K
KwkvLyB7CisJLy8gCS5zdGFydAk9ICh1bnNpZ25lZCBsb25nKV9fc3RhcnRfcm9kYXRhLAorCS8v
IAkuZW5kCT0gKHVuc2lnbmVkIGxvbmcpX19pbml0X2JlZ2luLAorCS8vIAkucHJvdAk9IFBNRF9T
RUNUX1hOLAorCS8vIH0KICNlbmRpZgogfTsKIAotc3RhdGljIGlubGluZSB2b2lkIHNlY3Rpb25f
dXBkYXRlKHVuc2lnbmVkIGxvbmcgYWRkciwgcG1kdmFsX3QgcHJvdCkKK3N0YXRpYyBpbmxpbmUg
cG1kX3QgKnBtZF9vZmYoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHVuc2lnbmVkIGxvbmcgdmlydCkK
K3sKKwlyZXR1cm4gcG1kX29mZnNldChwdWRfb2Zmc2V0KHBnZF9vZmZzZXQobW0sIHZpcnQpLCB2
aXJ0KSwgdmlydCk7Cit9CisKK3N0YXRpYyBpbmxpbmUgdm9pZCBzZWN0aW9uX3VwZGF0ZShzdHJ1
Y3QgbW1fc3RydWN0ICptbSwgdW5zaWduZWQgbG9uZyBhZGRyLCBwbWR2YWxfdCBtYXNrLCBwbWR2
YWxfdCBwcm90KQogewotCXBtZF90ICpwbWQgPSBwbWRfb2ZmX2soYWRkcik7CisJcG1kX3QgKnBt
ZCA9IHBtZF9vZmYobW0sIGFkZHIpOwogCiAjaWZkZWYgQ09ORklHX0FSTV9MUEFFCiAJcG1kWzBd
ID0gX19wbWQocG1kX3ZhbChwbWRbMF0pIHwgcHJvdCk7CiAjZWxzZQogCWlmIChhZGRyICYgU0VD
VElPTl9TSVpFKQotCQlwbWRbMV0gPSBfX3BtZChwbWRfdmFsKHBtZFsxXSkgfCBwcm90KTsKKwkJ
cG1kWzFdID0gX19wbWQoKHBtZF92YWwocG1kWzFdKSAmIG1hc2spIHwgcHJvdCk7CiAJZWxzZQot
CQlwbWRbMF0gPSBfX3BtZChwbWRfdmFsKHBtZFswXSkgfCBwcm90KTsKKwkJcG1kWzBdID0gX19w
bWQoKHBtZF92YWwocG1kWzBdKSAmIG1hc2spIHwgcHJvdCk7CiAjZW5kaWYKIAlmbHVzaF9wbWRf
ZW50cnkocG1kKTsKIH0KQEAgLTcwMiwxMyArNzExLDM3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBm
aXhfa2Vybm1lbV9wZXJtcyh2b2lkKQogCQlmb3IgKGFkZHIgPSBzZWN0aW9uX3Blcm1zW2ldLnN0
YXJ0OwogCQkgICAgIGFkZHIgPCBzZWN0aW9uX3Blcm1zW2ldLmVuZDsKIAkJICAgICBhZGRyICs9
IFNFQ1RJT05fU0laRSkKLQkJCXNlY3Rpb25fdXBkYXRlKGFkZHIsIHNlY3Rpb25fcGVybXNbaV0u
cHJvdCk7CisJCQlzZWN0aW9uX3VwZGF0ZSgmaW5pdF9tbSwgYWRkciwgc2VjdGlvbl9wZXJtc1tp
XS5tYXNrLCBzZWN0aW9uX3Blcm1zW2ldLnByb3QpOwogCX0KIH0KICNlbHNlCiBzdGF0aWMgaW5s
aW5lIHZvaWQgZml4X2tlcm5tZW1fcGVybXModm9pZCkgeyB9CiAjZW5kaWYgLyogQ09ORklHX0FS
TV9LRVJOTUVNX1BFUk1TICovCiAKK3ZvaWQgc2V0X2tlcm5lbF90ZXh0X3J3KHN0cnVjdCBtbV9z
dHJ1Y3QgKm1tKQoreworICAgICAgIHVuc2lnbmVkIGxvbmcgYWRkcjsKKworICAgICAgIGZvciAo
YWRkciA9IHNlY3Rpb25fcGVybXNbMF0uc3RhcnQ7CisgICAgICAgICAgICBhZGRyIDwgc2VjdGlv
bl9wZXJtc1swXS5lbmQ7CisgICAgICAgICAgICBhZGRyICs9IFNFQ1RJT05fU0laRSkKKyAgICAg
ICAgICAgICAgc2VjdGlvbl91cGRhdGUobW0sIGFkZHIsIHNlY3Rpb25fcGVybXNbMF0ubWFzaywK
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICBzZWN0aW9uX3Blcm1zWzBdLmNsZWFyKTsKKwor
ICAgICAgIGZsdXNoX3RsYl9hbGwoKTsKK30KKwordm9pZCBzZXRfa2VybmVsX3RleHRfcm8oc3Ry
dWN0IG1tX3N0cnVjdCAqbW0pCit7CisgICAgICAgdW5zaWduZWQgbG9uZyBhZGRyOworCisgICAg
ICAgZm9yIChhZGRyID0gc2VjdGlvbl9wZXJtc1swXS5zdGFydDsKKyAgICAgICAgICAgIGFkZHIg
PCBzZWN0aW9uX3Blcm1zWzBdLmVuZDsKKyAgICAgICAgICAgIGFkZHIgKz0gU0VDVElPTl9TSVpF
KQorICAgICAgICAgICAgICBzZWN0aW9uX3VwZGF0ZShtbSwgYWRkciwgc2VjdGlvbl9wZXJtc1sw
XS5tYXNrLAorICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNlY3Rpb25fcGVybXNbMF0ucHJv
dCk7Cit9CisKIHZvaWQgZnJlZV9pbml0bWVtKHZvaWQpCiB7CiAjaWZkZWYgQ09ORklHX0hBVkVf
VENNCi0tIAoxLjkuMAoK
--001a11380ac46213f704f6034277--
