Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaKOJnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 04:43:37 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45378 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaKOJne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 04:43:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVAWYdZvq3QDn-=06QX0+H=RynSS+VVmvTyAaU1BECR_g@mail.gmail.com>
References: <20141114204517.GA24402@www.outflux.net>
	<CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
	<CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com>
	<CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
	<CAE9FiQVAWYdZvq3QDn-=06QX0+H=RynSS+VVmvTyAaU1BECR_g@mail.gmail.com>
Date: Sat, 15 Nov 2014 01:43:32 -0800
X-Google-Sender-Auth: 518ZfpGJdyEa30eq_I2RdgXEBb8
Message-ID: <CAE9FiQWFa3e=XBzQOHQWv68L_H8OpH=k2fxcN-tJy4o0MccBGQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Content-Type: multipart/mixed; boundary=001a113f924e26a7be0507e2942a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a113f924e26a7be0507e2942a
Content-Type: text/plain; charset=UTF-8

On Fri, Nov 14, 2014 at 7:38 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Nov 14, 2014 at 6:46 PM, Kees Cook <keescook@chromium.org> wrote:
>> Is this correct? It sounded like tglx wanted the pmd split, like this:
>>
>> 0xffffffff82200000-0xffffffff82c00000    10M     RW   PSE GLB NX pmd
>> 0xffffffff82c00000-0xffffffff82df5000  2004K     RW       GLB NX pte
>> 0xffffffff82df5000-0xffffffff82e00000    44K     RW           NX pte
>> 0xffffffff82e00000-0xffffffffc0000000   978M                     pmd
>
> Need to remove GLB ?

Please check attached one that clean up the highmap tail...

Subject: [RFC PATCH] x86, 64bit: cleanup highmap tail near partial 2M range

1. should use _brk_end instead of &end, as we only use partial of
   brk.
2. [_brk_end, pm_end) page range is already converted mem. and
   is not wasted.
3. add cleanup_highmap_tail for [_brk_end, pm_end).

Kernel Layout:
[    0.000000]   .text: [0x01000000-0x0200d5c8]
[    0.000000] .rodata: [0x02200000-0x02a1cfff]
[    0.000000]   .data: [0x02c00000-0x02e50e7f]
[    0.000000]   .init: [0x02e52000-0x03212fff]
[    0.000000]    .bss: [0x03221000-0x0437bfff]
[    0.000000]    .brk: [0x0437c000-0x043a1fff]

Actually used brk:
[    0.272959] memblock_reserve: [0x0000000437c000-0x00000004382fff]
flags 0x0 BRK

Before patch:
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82200000          18M     ro         PSE GLB x  pmd
0xffffffff82200000-0xffffffff82c00000          10M     ro         PSE GLB NX pmd
0xffffffff82c00000-0xffffffff82e00000           2M     RW         PSE GLB NX pmd
0xffffffff82e00000-0xffffffff83000000           2M     RW             GLB NX pte
0xffffffff83000000-0xffffffff83200000           2M     RW         PSE GLB NX pmd
0xffffffff83200000-0xffffffff83400000           2M     RW             GLB NX pte
0xffffffff83400000-0xffffffff84200000          14M     RW         PSE GLB NX pmd
0xffffffff84200000-0xffffffff843a2000        1672K     RW             GLB NX pte
0xffffffff843a2000-0xffffffff84400000         376K     RW             GLB x  pte
0xffffffff84400000-0xffffffffa0000000         444M                           pmd
After patch:
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82200000          18M     ro         PSE GLB x  pmd
0xffffffff82200000-0xffffffff82c00000          10M     ro         PSE GLB NX pmd
0xffffffff82c00000-0xffffffff82e00000           2M     RW         PSE GLB NX pmd
0xffffffff82e00000-0xffffffff83000000           2M     RW             GLB NX pte
0xffffffff83000000-0xffffffff83200000           2M     RW         PSE GLB NX pmd
0xffffffff83200000-0xffffffff83400000           2M     RW             GLB NX pte
0xffffffff83400000-0xffffffff84200000          14M     RW         PSE GLB NX pmd
0xffffffff84200000-0xffffffff84383000        1548K     RW             GLB NX pte
0xffffffff84383000-0xffffffff84400000         500K                           pte
0xffffffff84400000-0xffffffffa0000000         444M                           pmd

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c  |   23 ++++++++++++++++++++++-
 arch/x86/mm/pageattr.c |    2 +-
 2 files changed, 23 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -375,6 +375,7 @@ void __init init_extra_mapping_uc(unsign
     __init_extra_mapping(phys, size, PAGE_KERNEL_LARGE_NOCACHE);
 }

+static pmd_t *last_pmd;
 /*
  * The head.S code sets up the kernel high mapping:
  *
@@ -408,9 +409,26 @@ void __init cleanup_highmap(void)
             continue;
         if (vaddr < (unsigned long) _text || vaddr > end)
             set_pmd(pmd, __pmd(0));
+        else
+            last_pmd = pmd;
     }
 }

+static void __init cleanup_highmap_tail(unsigned long addr)
+{
+    int i;
+    pte_t *pte;
+
+    if (!last_pmd || pmd_none(*last_pmd))
+        return;
+
+    pte = (pte_t *)pmd_page_vaddr(*last_pmd);
+    pte += pte_index(addr);
+
+    for (i = pte_index(addr); i < PTRS_PER_PTE; i++, pte++)
+        set_pte(pte, __pte(0));
+}
+
 static unsigned long __meminit
 phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
           pgprot_t prot)
@@ -1124,7 +1142,8 @@ void mark_rodata_ro(void)
     unsigned long end = (unsigned long) &__end_rodata_hpage_align;
     unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
     unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
-    unsigned long all_end = PFN_ALIGN(&_end);
+    unsigned long all_end = PFN_ALIGN(_brk_end);
+    unsigned long pmd_end = roundup(all_end, PMD_SIZE);

     printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
            (end - start) >> 10);
@@ -1137,6 +1156,8 @@ void mark_rodata_ro(void)
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
@@ -100,7 +100,7 @@ static inline unsigned long highmap_star

 static inline unsigned long highmap_end_pfn(void)
 {
-    return __pa_symbol(roundup(_brk_end, PMD_SIZE)) >> PAGE_SHIFT;
+    return __pa_symbol(PFN_ALIGN(_brk_end)) >> PAGE_SHIFT;
 }

 #endif

--001a113f924e26a7be0507e2942a
Content-Type: text/x-patch; charset=US-ASCII; name="nx_after_end.patch"
Content-Disposition: attachment; filename="nx_after_end.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2iscoxj0

U3ViamVjdDogW1JGQyBQQVRDSF0geDg2LCA2NGJpdDogY2xlYW51cCBoaWdobWFwIHRhaWwgbmVh
ciBwYXJ0aWFsIDJNIHJhbmdlCgoxLiBzaG91bGQgdXNlIF9icmtfZW5kIGluc3RlYWQgb2YgJmVu
ZCwgYXMgd2Ugb25seSB1c2UgcGFydGlhbCBvZgogICBicmsuCjIuIFtfYnJrX2VuZCwgcG1fZW5k
KSBwYWdlIHJhbmdlIGlzIGFscmVhZHkgY29udmVydGVkIG1lbS4gYW5kCiAgIGlzIG5vdCB3YXN0
ZWQuCjMuIGFkZCBjbGVhbnVwX2hpZ2htYXBfdGFpbCBmb3IgW19icmtfZW5kLCBwbV9lbmQpLgoK
S2VybmVsIExheW91dDoKWyAgICAwLjAwMDAwMF0gICAudGV4dDogWzB4MDEwMDAwMDAtMHgwMjAw
ZDVjOF0KWyAgICAwLjAwMDAwMF0gLnJvZGF0YTogWzB4MDIyMDAwMDAtMHgwMmExY2ZmZl0KWyAg
ICAwLjAwMDAwMF0gICAuZGF0YTogWzB4MDJjMDAwMDAtMHgwMmU1MGU3Zl0KWyAgICAwLjAwMDAw
MF0gICAuaW5pdDogWzB4MDJlNTIwMDAtMHgwMzIxMmZmZl0KWyAgICAwLjAwMDAwMF0gICAgLmJz
czogWzB4MDMyMjEwMDAtMHgwNDM3YmZmZl0KWyAgICAwLjAwMDAwMF0gICAgLmJyazogWzB4MDQz
N2MwMDAtMHgwNDNhMWZmZl0KCkFjdHVhbGx5IHVzZWQgYnJrOgpbICAgIDAuMjcyOTU5XSBtZW1i
bG9ja19yZXNlcnZlOiBbMHgwMDAwMDAwNDM3YzAwMC0weDAwMDAwMDA0MzgyZmZmXSBmbGFncyAw
eDAgQlJLCgpCZWZvcmUgcGF0Y2g6Ci0tLVsgSGlnaCBLZXJuZWwgTWFwcGluZyBdLS0tCjB4ZmZm
ZmZmZmY4MDAwMDAwMC0weGZmZmZmZmZmODEwMDAwMDAgICAgICAgICAgMTZNICAgICAgICAgICAg
ICAgICAgICAgICAgICAgcG1kCjB4ZmZmZmZmZmY4MTAwMDAwMC0weGZmZmZmZmZmODIyMDAwMDAg
ICAgICAgICAgMThNICAgICBybyAgICAgICAgIFBTRSBHTEIgeCAgcG1kCjB4ZmZmZmZmZmY4MjIw
MDAwMC0weGZmZmZmZmZmODJjMDAwMDAgICAgICAgICAgMTBNICAgICBybyAgICAgICAgIFBTRSBH
TEIgTlggcG1kCjB4ZmZmZmZmZmY4MmMwMDAwMC0weGZmZmZmZmZmODJlMDAwMDAgICAgICAgICAg
IDJNICAgICBSVyAgICAgICAgIFBTRSBHTEIgTlggcG1kCjB4ZmZmZmZmZmY4MmUwMDAwMC0weGZm
ZmZmZmZmODMwMDAwMDAgICAgICAgICAgIDJNICAgICBSVyAgICAgICAgICAgICBHTEIgTlggcHRl
CjB4ZmZmZmZmZmY4MzAwMDAwMC0weGZmZmZmZmZmODMyMDAwMDAgICAgICAgICAgIDJNICAgICBS
VyAgICAgICAgIFBTRSBHTEIgTlggcG1kCjB4ZmZmZmZmZmY4MzIwMDAwMC0weGZmZmZmZmZmODM0
MDAwMDAgICAgICAgICAgIDJNICAgICBSVyAgICAgICAgICAgICBHTEIgTlggcHRlCjB4ZmZmZmZm
ZmY4MzQwMDAwMC0weGZmZmZmZmZmODQyMDAwMDAgICAgICAgICAgMTRNICAgICBSVyAgICAgICAg
IFBTRSBHTEIgTlggcG1kCjB4ZmZmZmZmZmY4NDIwMDAwMC0weGZmZmZmZmZmODQzYTIwMDAgICAg
ICAgIDE2NzJLICAgICBSVyAgICAgICAgICAgICBHTEIgTlggcHRlCjB4ZmZmZmZmZmY4NDNhMjAw
MC0weGZmZmZmZmZmODQ0MDAwMDAgICAgICAgICAzNzZLICAgICBSVyAgICAgICAgICAgICBHTEIg
eCAgcHRlCjB4ZmZmZmZmZmY4NDQwMDAwMC0weGZmZmZmZmZmYTAwMDAwMDAgICAgICAgICA0NDRN
ICAgICAgICAgICAgICAgICAgICAgICAgICAgcG1kCkFmdGVyIHBhdGNoOgotLS1bIEhpZ2ggS2Vy
bmVsIE1hcHBpbmcgXS0tLQoweGZmZmZmZmZmODAwMDAwMDAtMHhmZmZmZmZmZjgxMDAwMDAwICAg
ICAgICAgIDE2TSAgICAgICAgICAgICAgICAgICAgICAgICAgIHBtZAoweGZmZmZmZmZmODEwMDAw
MDAtMHhmZmZmZmZmZjgyMjAwMDAwICAgICAgICAgIDE4TSAgICAgcm8gICAgICAgICBQU0UgR0xC
IHggIHBtZAoweGZmZmZmZmZmODIyMDAwMDAtMHhmZmZmZmZmZjgyYzAwMDAwICAgICAgICAgIDEw
TSAgICAgcm8gICAgICAgICBQU0UgR0xCIE5YIHBtZAoweGZmZmZmZmZmODJjMDAwMDAtMHhmZmZm
ZmZmZjgyZTAwMDAwICAgICAgICAgICAyTSAgICAgUlcgICAgICAgICBQU0UgR0xCIE5YIHBtZAow
eGZmZmZmZmZmODJlMDAwMDAtMHhmZmZmZmZmZjgzMDAwMDAwICAgICAgICAgICAyTSAgICAgUlcg
ICAgICAgICAgICAgR0xCIE5YIHB0ZQoweGZmZmZmZmZmODMwMDAwMDAtMHhmZmZmZmZmZjgzMjAw
MDAwICAgICAgICAgICAyTSAgICAgUlcgICAgICAgICBQU0UgR0xCIE5YIHBtZAoweGZmZmZmZmZm
ODMyMDAwMDAtMHhmZmZmZmZmZjgzNDAwMDAwICAgICAgICAgICAyTSAgICAgUlcgICAgICAgICAg
ICAgR0xCIE5YIHB0ZQoweGZmZmZmZmZmODM0MDAwMDAtMHhmZmZmZmZmZjg0MjAwMDAwICAgICAg
ICAgIDE0TSAgICAgUlcgICAgICAgICBQU0UgR0xCIE5YIHBtZAoweGZmZmZmZmZmODQyMDAwMDAt
MHhmZmZmZmZmZjg0MzgzMDAwICAgICAgICAxNTQ4SyAgICAgUlcgICAgICAgICAgICAgR0xCIE5Y
IHB0ZQoweGZmZmZmZmZmODQzODMwMDAtMHhmZmZmZmZmZjg0NDAwMDAwICAgICAgICAgNTAwSyAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHB0ZQoweGZmZmZmZmZmODQ0MDAwMDAtMHhmZmZmZmZm
ZmEwMDAwMDAwICAgICAgICAgNDQ0TSAgICAgICAgICAgICAgICAgICAgICAgICAgIHBtZAoKU2ln
bmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBhcmNoL3g4
Ni9tbS9pbml0XzY0LmMgIHwgICAyMyArKysrKysrKysrKysrKysrKysrKysrLQogYXJjaC94ODYv
bW0vcGFnZWF0dHIuYyB8ICAgIDIgKy0KIDIgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvbW0vaW5pdF82NC5j
Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L21tL2luaXRfNjQuYworKysg
bGludXgtMi42L2FyY2gveDg2L21tL2luaXRfNjQuYwpAQCAtMzc1LDYgKzM3NSw3IEBAIHZvaWQg
X19pbml0IGluaXRfZXh0cmFfbWFwcGluZ191Yyh1bnNpZ24KIAlfX2luaXRfZXh0cmFfbWFwcGlu
ZyhwaHlzLCBzaXplLCBQQUdFX0tFUk5FTF9MQVJHRV9OT0NBQ0hFKTsKIH0KIAorc3RhdGljIHBt
ZF90ICpsYXN0X3BtZDsKIC8qCiAgKiBUaGUgaGVhZC5TIGNvZGUgc2V0cyB1cCB0aGUga2VybmVs
IGhpZ2ggbWFwcGluZzoKICAqCkBAIC00MDgsOSArNDA5LDI2IEBAIHZvaWQgX19pbml0IGNsZWFu
dXBfaGlnaG1hcCh2b2lkKQogCQkJY29udGludWU7CiAJCWlmICh2YWRkciA8ICh1bnNpZ25lZCBs
b25nKSBfdGV4dCB8fCB2YWRkciA+IGVuZCkKIAkJCXNldF9wbWQocG1kLCBfX3BtZCgwKSk7CisJ
CWVsc2UKKwkJCWxhc3RfcG1kID0gcG1kOwogCX0KIH0KIAorc3RhdGljIHZvaWQgX19pbml0IGNs
ZWFudXBfaGlnaG1hcF90YWlsKHVuc2lnbmVkIGxvbmcgYWRkcikKK3sKKwlpbnQgaTsKKwlwdGVf
dCAqcHRlOworCisJaWYgKCFsYXN0X3BtZCB8fCBwbWRfbm9uZSgqbGFzdF9wbWQpKQorCQlyZXR1
cm47CisKKwlwdGUgPSAocHRlX3QgKilwbWRfcGFnZV92YWRkcigqbGFzdF9wbWQpOworCXB0ZSAr
PSBwdGVfaW5kZXgoYWRkcik7CisKKwlmb3IgKGkgPSBwdGVfaW5kZXgoYWRkcik7IGkgPCBQVFJT
X1BFUl9QVEU7IGkrKywgcHRlKyspCisJCXNldF9wdGUocHRlLCBfX3B0ZSgwKSk7Cit9CisKIHN0
YXRpYyB1bnNpZ25lZCBsb25nIF9fbWVtaW5pdAogcGh5c19wdGVfaW5pdChwdGVfdCAqcHRlX3Bh
Z2UsIHVuc2lnbmVkIGxvbmcgYWRkciwgdW5zaWduZWQgbG9uZyBlbmQsCiAJICAgICAgcGdwcm90
X3QgcHJvdCkKQEAgLTExMjQsNyArMTE0Miw4IEBAIHZvaWQgbWFya19yb2RhdGFfcm8odm9pZCkK
IAl1bnNpZ25lZCBsb25nIGVuZCA9ICh1bnNpZ25lZCBsb25nKSAmX19lbmRfcm9kYXRhX2hwYWdl
X2FsaWduOwogCXVuc2lnbmVkIGxvbmcgdGV4dF9lbmQgPSBQRk5fQUxJR04oJl9fc3RvcF9fX2V4
X3RhYmxlKTsKIAl1bnNpZ25lZCBsb25nIHJvZGF0YV9lbmQgPSBQRk5fQUxJR04oJl9fZW5kX3Jv
ZGF0YSk7Ci0JdW5zaWduZWQgbG9uZyBhbGxfZW5kID0gUEZOX0FMSUdOKCZfZW5kKTsKKwl1bnNp
Z25lZCBsb25nIGFsbF9lbmQgPSBQRk5fQUxJR04oX2Jya19lbmQpOworCXVuc2lnbmVkIGxvbmcg
cG1kX2VuZCA9IHJvdW5kdXAoYWxsX2VuZCwgUE1EX1NJWkUpOwogCiAJcHJpbnRrKEtFUk5fSU5G
TyAiV3JpdGUgcHJvdGVjdGluZyB0aGUga2VybmVsIHJlYWQtb25seSBkYXRhOiAlbHVrXG4iLAog
CSAgICAgICAoZW5kIC0gc3RhcnQpID4+IDEwKTsKQEAgLTExMzcsNiArMTE1Niw4IEBAIHZvaWQg
bWFya19yb2RhdGFfcm8odm9pZCkKIAkgKiBzaG91bGQgYWxzbyBiZSBub3QtZXhlY3V0YWJsZS4K
IAkgKi8KIAlzZXRfbWVtb3J5X254KHJvZGF0YV9zdGFydCwgKGFsbF9lbmQgLSByb2RhdGFfc3Rh
cnQpID4+IFBBR0VfU0hJRlQpOworCWlmIChhbGxfZW5kIDwgcG1kX2VuZCkKKwkJY2xlYW51cF9o
aWdobWFwX3RhaWwoYWxsX2VuZCk7CiAKIAlyb2RhdGFfdGVzdCgpOwogCkluZGV4OiBsaW51eC0y
LjYvYXJjaC94ODYvbW0vcGFnZWF0dHIuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9h
cmNoL3g4Ni9tbS9wYWdlYXR0ci5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYvbW0vcGFnZWF0dHIu
YwpAQCAtMTAwLDcgKzEwMCw3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBoaWdobWFw
X3N0YXIKIAogc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIGhpZ2htYXBfZW5kX3Bmbih2b2lk
KQogewotCXJldHVybiBfX3BhX3N5bWJvbChyb3VuZHVwKF9icmtfZW5kLCBQTURfU0laRSkpID4+
IFBBR0VfU0hJRlQ7CisJcmV0dXJuIF9fcGFfc3ltYm9sKFBGTl9BTElHTihfYnJrX2VuZCkpID4+
IFBBR0VfU0hJRlQ7CiB9CiAKICNlbmRpZgo=
--001a113f924e26a7be0507e2942a--
