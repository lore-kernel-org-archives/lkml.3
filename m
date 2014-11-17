Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaKQDa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 22:30:58 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54299 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbaKQDa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 22:30:57 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411162216180.3909@nanos>
References: <20141114204517.GA24402@www.outflux.net>
	<CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
	<CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com>
	<CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
	<CAE9FiQVAWYdZvq3QDn-=06QX0+H=RynSS+VVmvTyAaU1BECR_g@mail.gmail.com>
	<CAE9FiQWFa3e=XBzQOHQWv68L_H8OpH=k2fxcN-tJy4o0MccBGQ@mail.gmail.com>
	<alpine.DEB.2.11.1411162216180.3909@nanos>
Date: Sun, 16 Nov 2014 19:30:56 -0800
X-Google-Sender-Auth: V0ee7MeIEInPHrxYV3tcteu0NfE
Message-ID: <CAE9FiQU2yGtz5csQPYb-eqM30abDestgJ30RxJew-4dbB8+U4Q@mail.gmail.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Content-Type: multipart/mixed; boundary=047d7bdc9dae4896da0508059bbe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bdc9dae4896da0508059bbe
Content-Type: text/plain; charset=UTF-8

On Sun, Nov 16, 2014 at 1:26 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 15 Nov 2014, Yinghai Lu wrote:
>> +static pmd_t *last_pmd;
>>  /*
>>   * The head.S code sets up the kernel high mapping:
>>   *
>> @@ -408,9 +409,26 @@ void __init cleanup_highmap(void)
>>              continue;
>>          if (vaddr < (unsigned long) _text || vaddr > end)
>>              set_pmd(pmd, __pmd(0));
>> +        else
>> +            last_pmd = pmd;
>
> Why do you need to store this? You can compute this.

I'm not quite sure about the xen path.

>
>> +static void __init cleanup_highmap_tail(unsigned long addr)
>
> Brilliant stuff. mark_rodata_ro() is called AFTER free_initmem() which
> will free exactly that code.

I missed that.

Please check this one that address three problems that you pointed out.

Subject: [PATCH v2] x86, 64bit: cleanup highmap tail near partial 2M range

1. should use _brk_end instead of &_end in mark_rodata_ro().
   _brk_end can move up to &_end, i.e. to __brk_limit.  It's safe to
   use _brk_end when mark_rodata_ro() is called because extend_brk()
   is gone already at that point.
2. [_brk_end, pm_end) page range is already converted mem. and
   is not wasted.
3. add cleanup_highmap_tail for [_brk_end, pm_end).

Kernel Layout:
[    0.000000]    .brk: [0x0437c000-0x043a1fff]

Actually used brk:
[    0.272959] memblock_reserve: [0x0000000437c000-0x00000004382fff]
flags 0x0 BRK

Before patch:
---[ High Kernel Mapping ]---
...
0xffffffff83400000-0xffffffff84200000          14M     RW         PSE GLB NX pmd
0xffffffff84200000-0xffffffff843a2000        1672K     RW             GLB NX pte
0xffffffff843a2000-0xffffffff84400000         376K     RW             GLB x  pte
0xffffffff84400000-0xffffffffa0000000         444M                           pmd
After patch:
---[ High Kernel Mapping ]---
...
0xffffffff83400000-0xffffffff84200000          14M     RW         PSE GLB NX pmd
0xffffffff84200000-0xffffffff84383000        1548K     RW             GLB NX pte
0xffffffff84383000-0xffffffff84400000         500K                           pte
0xffffffff84400000-0xffffffffa0000000         444M                           pmd

-v2: according to tglx
 caculate the pmd postion instead of passing last_pmd.
 cleanup_highmap_tail could not have __init, as it is called in mark_rodata_ro
 and mark_rodata_ro is called after free_initmem.
 highmap_end_pfn should keep PMD_SIZE alignment on !CONFIG_DEBUG_RODATA

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c  |   22 +++++++++++++++++++++-
 arch/x86/mm/pageattr.c |    4 ++++
 2 files changed, 25 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -411,6 +411,23 @@ void __init cleanup_highmap(void)
     }
 }

+static void cleanup_highmap_tail(unsigned long addr)
+{
+    int i;
+    pgd_t *pgd;
+    pud_t *pud;
+    pmd_t *pmd;
+    pte_t *pte;
+
+    pgd = pgd_offset_k(addr);
+    pud = (pud_t *)pgd_page_vaddr(*pgd) + pud_index(addr);
+    pmd = (pmd_t *)pud_page_vaddr(*pud) + pmd_index(addr);
+    pte = (pte_t *)pmd_page_vaddr(*pmd) + pte_index(addr);
+
+    for (i = pte_index(addr); i < PTRS_PER_PTE; i++, pte++)
+        set_pte(pte, __pte(0));
+}
+
 static unsigned long __meminit
 phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
           pgprot_t prot)
@@ -1124,7 +1141,8 @@ void mark_rodata_ro(void)
     unsigned long end = (unsigned long) &__end_rodata_hpage_align;
     unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
     unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
-    unsigned long all_end = PFN_ALIGN(&_end);
+    unsigned long all_end = PFN_ALIGN(_brk_end);
+    unsigned long pmd_end = roundup(all_end, PMD_SIZE);

     printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
            (end - start) >> 10);
@@ -1137,6 +1155,8 @@ void mark_rodata_ro(void)
      * should also be not-executable.
      */
     set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
+    if (all_end < pmd_end)
+        cleanup_highmap_tail(all_end);

     rodata_test();

Index: linux-2.6/arch/x86/mm/pageattr.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pageattr.c
+++ linux-2.6/arch/x86/mm/pageattr.c
@@ -100,7 +100,11 @@ static inline unsigned long highmap_star

 static inline unsigned long highmap_end_pfn(void)
 {
+#ifdef CONFIG_DEBUG_RODATA
+    return __pa_symbol(PFN_ALIGN(_brk_end)) >> PAGE_SHIFT;
+#else
     return __pa_symbol(roundup(_brk_end, PMD_SIZE)) >> PAGE_SHIFT;
+#endif
 }

 #endif

--047d7bdc9dae4896da0508059bbe
Content-Type: text/x-patch; charset=US-ASCII; name="nx_after_end_v2.patch"
Content-Disposition: attachment; filename="nx_after_end_v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2l9yrm00

U3ViamVjdDogW1BBVENIIHYyXSB4ODYsIDY0Yml0OiBjbGVhbnVwIGhpZ2htYXAgdGFpbCBuZWFy
IHBhcnRpYWwgMk0gcmFuZ2UKCjEuIHNob3VsZCB1c2UgX2Jya19lbmQgaW5zdGVhZCBvZiAmX2Vu
ZCBpbiBtYXJrX3JvZGF0YV9ybygpLgogICBfYnJrX2VuZCBjYW4gbW92ZSB1cCB0byAmX2VuZCwg
aS5lLiB0byBfX2Jya19saW1pdC4gIEl0J3Mgc2FmZSB0bwogICB1c2UgX2Jya19lbmQgd2hlbiBt
YXJrX3JvZGF0YV9ybygpIGlzIGNhbGxlZCBiZWNhdXNlIGV4dGVuZF9icmsoKQogICBpcyBnb25l
IGFscmVhZHkgYXQgdGhhdCBwb2ludC4KMi4gW19icmtfZW5kLCBwbV9lbmQpIHBhZ2UgcmFuZ2Ug
aXMgYWxyZWFkeSBjb252ZXJ0ZWQgbWVtLiBhbmQKICAgaXMgbm90IHdhc3RlZC4KMy4gYWRkIGNs
ZWFudXBfaGlnaG1hcF90YWlsIGZvciBbX2Jya19lbmQsIHBtX2VuZCkuCgpLZXJuZWwgTGF5b3V0
OgpbICAgIDAuMDAwMDAwXSAgICAuYnJrOiBbMHgwNDM3YzAwMC0weDA0M2ExZmZmXQoKQWN0dWFs
bHkgdXNlZCBicms6ClsgICAgMC4yNzI5NTldIG1lbWJsb2NrX3Jlc2VydmU6IFsweDAwMDAwMDA0
MzdjMDAwLTB4MDAwMDAwMDQzODJmZmZdIGZsYWdzIDB4MCBCUksKCkJlZm9yZSBwYXRjaDoKLS0t
WyBIaWdoIEtlcm5lbCBNYXBwaW5nIF0tLS0KLi4uCjB4ZmZmZmZmZmY4MzQwMDAwMC0weGZmZmZm
ZmZmODQyMDAwMDAgICAgICAgICAgMTRNICAgICBSVyAgICAgICAgIFBTRSBHTEIgTlggcG1kCjB4
ZmZmZmZmZmY4NDIwMDAwMC0weGZmZmZmZmZmODQzYTIwMDAgICAgICAgIDE2NzJLICAgICBSVyAg
ICAgICAgICAgICBHTEIgTlggcHRlCjB4ZmZmZmZmZmY4NDNhMjAwMC0weGZmZmZmZmZmODQ0MDAw
MDAgICAgICAgICAzNzZLICAgICBSVyAgICAgICAgICAgICBHTEIgeCAgcHRlCjB4ZmZmZmZmZmY4
NDQwMDAwMC0weGZmZmZmZmZmYTAwMDAwMDAgICAgICAgICA0NDRNICAgICAgICAgICAgICAgICAg
ICAgICAgICAgcG1kCkFmdGVyIHBhdGNoOgotLS1bIEhpZ2ggS2VybmVsIE1hcHBpbmcgXS0tLQou
Li4KMHhmZmZmZmZmZjgzNDAwMDAwLTB4ZmZmZmZmZmY4NDIwMDAwMCAgICAgICAgICAxNE0gICAg
IFJXICAgICAgICAgUFNFIEdMQiBOWCBwbWQKMHhmZmZmZmZmZjg0MjAwMDAwLTB4ZmZmZmZmZmY4
NDM4MzAwMCAgICAgICAgMTU0OEsgICAgIFJXICAgICAgICAgICAgIEdMQiBOWCBwdGUKMHhmZmZm
ZmZmZjg0MzgzMDAwLTB4ZmZmZmZmZmY4NDQwMDAwMCAgICAgICAgIDUwMEsgICAgICAgICAgICAg
ICAgICAgICAgICAgICBwdGUKMHhmZmZmZmZmZjg0NDAwMDAwLTB4ZmZmZmZmZmZhMDAwMDAwMCAg
ICAgICAgIDQ0NE0gICAgICAgICAgICAgICAgICAgICAgICAgICBwbWQKCi12MjogYWNjb3JkaW5n
IHRvIHRnbHgKIGNhY3VsYXRlIHRoZSBwbWQgcG9zdGlvbiBpbnN0ZWFkIG9mIHBhc3NpbmcgbGFz
dF9wbWQuCiBjbGVhbnVwX2hpZ2htYXBfdGFpbCBjb3VsZCBub3QgaGF2ZSBfX2luaXQsIGFzIGl0
IGlzIGNhbGxlZCBpbiBtYXJrX3JvZGF0YV9ybwogYW5kIG1hcmtfcm9kYXRhX3JvIGlzIGNhbGxl
ZCBhZnRlciBmcmVlX2luaXRtZW0uCiBoaWdobWFwX2VuZF9wZm4gc2hvdWxkIGtlZXAgUE1EX1NJ
WkUgYWxpZ25tZW50IG9uICFDT05GSUdfREVCVUdfUk9EQVRBCgpTaWduZWQtb2ZmLWJ5OiBZaW5n
aGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CgotLS0KIGFyY2gveDg2L21tL2luaXRfNjQuYyAg
fCAgIDIyICsrKysrKysrKysrKysrKysrKysrKy0KIGFyY2gveDg2L21tL3BhZ2VhdHRyLmMgfCAg
ICA0ICsrKysKIDIgZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9pbml0XzY0LmMKPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0g
bGludXgtMi42Lm9yaWcvYXJjaC94ODYvbW0vaW5pdF82NC5jCisrKyBsaW51eC0yLjYvYXJjaC94
ODYvbW0vaW5pdF82NC5jCkBAIC00MTEsNiArNDExLDIzIEBAIHZvaWQgX19pbml0IGNsZWFudXBf
aGlnaG1hcCh2b2lkKQogCX0KIH0KIAorc3RhdGljIHZvaWQgY2xlYW51cF9oaWdobWFwX3RhaWwo
dW5zaWduZWQgbG9uZyBhZGRyKQoreworCWludCBpOworCXBnZF90ICpwZ2Q7CisJcHVkX3QgKnB1
ZDsKKwlwbWRfdCAqcG1kOworCXB0ZV90ICpwdGU7CisKKwlwZ2QgPSBwZ2Rfb2Zmc2V0X2soYWRk
cik7CisJcHVkID0gKHB1ZF90ICopcGdkX3BhZ2VfdmFkZHIoKnBnZCkgKyBwdWRfaW5kZXgoYWRk
cik7CisJcG1kID0gKHBtZF90ICopcHVkX3BhZ2VfdmFkZHIoKnB1ZCkgKyBwbWRfaW5kZXgoYWRk
cik7CisJcHRlID0gKHB0ZV90ICopcG1kX3BhZ2VfdmFkZHIoKnBtZCkgKyBwdGVfaW5kZXgoYWRk
cik7CisKKwlmb3IgKGkgPSBwdGVfaW5kZXgoYWRkcik7IGkgPCBQVFJTX1BFUl9QVEU7IGkrKywg
cHRlKyspCisJCXNldF9wdGUocHRlLCBfX3B0ZSgwKSk7Cit9CisKIHN0YXRpYyB1bnNpZ25lZCBs
b25nIF9fbWVtaW5pdAogcGh5c19wdGVfaW5pdChwdGVfdCAqcHRlX3BhZ2UsIHVuc2lnbmVkIGxv
bmcgYWRkciwgdW5zaWduZWQgbG9uZyBlbmQsCiAJICAgICAgcGdwcm90X3QgcHJvdCkKQEAgLTEx
MjQsNyArMTE0MSw4IEBAIHZvaWQgbWFya19yb2RhdGFfcm8odm9pZCkKIAl1bnNpZ25lZCBsb25n
IGVuZCA9ICh1bnNpZ25lZCBsb25nKSAmX19lbmRfcm9kYXRhX2hwYWdlX2FsaWduOwogCXVuc2ln
bmVkIGxvbmcgdGV4dF9lbmQgPSBQRk5fQUxJR04oJl9fc3RvcF9fX2V4X3RhYmxlKTsKIAl1bnNp
Z25lZCBsb25nIHJvZGF0YV9lbmQgPSBQRk5fQUxJR04oJl9fZW5kX3JvZGF0YSk7Ci0JdW5zaWdu
ZWQgbG9uZyBhbGxfZW5kID0gUEZOX0FMSUdOKCZfZW5kKTsKKwl1bnNpZ25lZCBsb25nIGFsbF9l
bmQgPSBQRk5fQUxJR04oX2Jya19lbmQpOworCXVuc2lnbmVkIGxvbmcgcG1kX2VuZCA9IHJvdW5k
dXAoYWxsX2VuZCwgUE1EX1NJWkUpOwogCiAJcHJpbnRrKEtFUk5fSU5GTyAiV3JpdGUgcHJvdGVj
dGluZyB0aGUga2VybmVsIHJlYWQtb25seSBkYXRhOiAlbHVrXG4iLAogCSAgICAgICAoZW5kIC0g
c3RhcnQpID4+IDEwKTsKQEAgLTExMzcsNiArMTE1NSw4IEBAIHZvaWQgbWFya19yb2RhdGFfcm8o
dm9pZCkKIAkgKiBzaG91bGQgYWxzbyBiZSBub3QtZXhlY3V0YWJsZS4KIAkgKi8KIAlzZXRfbWVt
b3J5X254KHJvZGF0YV9zdGFydCwgKGFsbF9lbmQgLSByb2RhdGFfc3RhcnQpID4+IFBBR0VfU0hJ
RlQpOworCWlmIChhbGxfZW5kIDwgcG1kX2VuZCkKKwkJY2xlYW51cF9oaWdobWFwX3RhaWwoYWxs
X2VuZCk7CiAKIAlyb2RhdGFfdGVzdCgpOwogCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvbW0v
cGFnZWF0dHIuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9tbS9wYWdl
YXR0ci5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYvbW0vcGFnZWF0dHIuYwpAQCAtMTAwLDcgKzEw
MCwxMSBAQCBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgaGlnaG1hcF9zdGFyCiAKIHN0YXRp
YyBpbmxpbmUgdW5zaWduZWQgbG9uZyBoaWdobWFwX2VuZF9wZm4odm9pZCkKIHsKKyNpZmRlZiBD
T05GSUdfREVCVUdfUk9EQVRBCisJcmV0dXJuIF9fcGFfc3ltYm9sKFBGTl9BTElHTihfYnJrX2Vu
ZCkpID4+IFBBR0VfU0hJRlQ7CisjZWxzZQogCXJldHVybiBfX3BhX3N5bWJvbChyb3VuZHVwKF9i
cmtfZW5kLCBQTURfU0laRSkpID4+IFBBR0VfU0hJRlQ7CisjZW5kaWYKIH0KIAogI2VuZGlmCg==
--047d7bdc9dae4896da0508059bbe--
