Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaKOC3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 21:29:47 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:55870 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbaKOC3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 21:29:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
References: <20141114204517.GA24402@www.outflux.net>
	<CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
Date: Fri, 14 Nov 2014 18:29:45 -0800
X-Google-Sender-Auth: vxy8MDXU1hJeOscITDSzWOfyzMQ
Message-ID: <CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary=001a1134b964c83e730507dc84fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a1134b964c83e730507dc84fa
Content-Type: text/plain; charset=UTF-8

On Fri, Nov 14, 2014 at 5:29 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Nov 14, 2014 at 12:45 PM, Kees Cook <keescook@chromium.org> wrote:
>> v2:
>>  - added call to free_init_pages(), as suggested by tglx

> something is wrong:
>
> [    7.842479] Freeing unused kernel memory: 3844K (ffffffff82e52000 -
> ffffffff83213000)
> [    7.843305] Write protecting the kernel read-only data: 28672k

....
should use attached one instead.

1. should use _brk_end instead of &end, as we only use partial of
   brk.
2. [_brk_end, pm_end) page range is already converted. aka
   is not wasted.

---
 arch/x86/mm/init_64.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -1124,7 +1124,8 @@ void mark_rodata_ro(void)
     unsigned long end = (unsigned long) &__end_rodata_hpage_align;
     unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
     unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
-    unsigned long all_end = PFN_ALIGN(&_end);
+    unsigned long all_end = PFN_ALIGN(_brk_end);
+    unsigned long pmd_end = roundup(all_end, PMD_SIZE);

     printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
            (end - start) >> 10);
@@ -1136,7 +1137,7 @@ void mark_rodata_ro(void)
      * The rodata/data/bss/brk section (but not the kernel text!)
      * should also be not-executable.
      */
-    set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
+    set_memory_nx(rodata_start, (pmd_end - rodata_start) >> PAGE_SHIFT);

     rodata_test();

@@ -1148,6 +1149,7 @@ void mark_rodata_ro(void)
     set_memory_ro(start, (end-start) >> PAGE_SHIFT);
 #endif

+    /* all_end to pmd_end is handled via free_all_bootmem() */
     free_init_pages("unused kernel",
             (unsigned long) __va(__pa_symbol(text_end)),
             (unsigned long) __va(__pa_symbol(rodata_start)));

--001a1134b964c83e730507dc84fa
Content-Type: text/x-patch; charset=US-ASCII; name="nx_after_end.patch"
Content-Disposition: attachment; filename="nx_after_end.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2icw0p50

MS4gc2hvdWxkIHVzZSBfYnJrX2VuZCBpbnN0ZWFkIG9mICZlbmQsIGFzIHdlIG9ubHkgdXNlIHBh
cnRpYWwgb2YKICAgYnJrLgoyLiBbX2Jya19lbmQsIHBtX2VuZCkgcGFnZSByYW5nZSBpcyBhbHJl
YWR5IGNvbnZlcnRlZC4gYWthCiAgIGlzIG5vdCB3YXN0ZWQuCgotLS0KIGFyY2gveDg2L21tL2lu
aXRfNjQuYyB8ICAgIDYgKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9pbml0XzY0LmMKPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvbW0vaW5pdF82NC5jCisrKyBsaW51
eC0yLjYvYXJjaC94ODYvbW0vaW5pdF82NC5jCkBAIC0xMTI0LDcgKzExMjQsOCBAQCB2b2lkIG1h
cmtfcm9kYXRhX3JvKHZvaWQpCiAJdW5zaWduZWQgbG9uZyBlbmQgPSAodW5zaWduZWQgbG9uZykg
Jl9fZW5kX3JvZGF0YV9ocGFnZV9hbGlnbjsKIAl1bnNpZ25lZCBsb25nIHRleHRfZW5kID0gUEZO
X0FMSUdOKCZfX3N0b3BfX19leF90YWJsZSk7CiAJdW5zaWduZWQgbG9uZyByb2RhdGFfZW5kID0g
UEZOX0FMSUdOKCZfX2VuZF9yb2RhdGEpOwotCXVuc2lnbmVkIGxvbmcgYWxsX2VuZCA9IFBGTl9B
TElHTigmX2VuZCk7CisJdW5zaWduZWQgbG9uZyBhbGxfZW5kID0gUEZOX0FMSUdOKF9icmtfZW5k
KTsKKwl1bnNpZ25lZCBsb25nIHBtZF9lbmQgPSByb3VuZHVwKGFsbF9lbmQsIFBNRF9TSVpFKTsK
IAogCXByaW50ayhLRVJOX0lORk8gIldyaXRlIHByb3RlY3RpbmcgdGhlIGtlcm5lbCByZWFkLW9u
bHkgZGF0YTogJWx1a1xuIiwKIAkgICAgICAgKGVuZCAtIHN0YXJ0KSA+PiAxMCk7CkBAIC0xMTM2
LDcgKzExMzcsNyBAQCB2b2lkIG1hcmtfcm9kYXRhX3JvKHZvaWQpCiAJICogVGhlIHJvZGF0YS9k
YXRhL2Jzcy9icmsgc2VjdGlvbiAoYnV0IG5vdCB0aGUga2VybmVsIHRleHQhKQogCSAqIHNob3Vs
ZCBhbHNvIGJlIG5vdC1leGVjdXRhYmxlLgogCSAqLwotCXNldF9tZW1vcnlfbngocm9kYXRhX3N0
YXJ0LCAoYWxsX2VuZCAtIHJvZGF0YV9zdGFydCkgPj4gUEFHRV9TSElGVCk7CisJc2V0X21lbW9y
eV9ueChyb2RhdGFfc3RhcnQsIChwbWRfZW5kIC0gcm9kYXRhX3N0YXJ0KSA+PiBQQUdFX1NISUZU
KTsKIAogCXJvZGF0YV90ZXN0KCk7CiAKQEAgLTExNDgsNiArMTE0OSw3IEBAIHZvaWQgbWFya19y
b2RhdGFfcm8odm9pZCkKIAlzZXRfbWVtb3J5X3JvKHN0YXJ0LCAoZW5kLXN0YXJ0KSA+PiBQQUdF
X1NISUZUKTsKICNlbmRpZgogCisJLyogYWxsX2VuZCB0byBwbWRfZW5kIGlzIGhhbmRsZWQgdmlh
IGZyZWVfYWxsX2Jvb3RtZW0oKSAqLwogCWZyZWVfaW5pdF9wYWdlcygidW51c2VkIGtlcm5lbCIs
CiAJCQkodW5zaWduZWQgbG9uZykgX192YShfX3BhX3N5bWJvbCh0ZXh0X2VuZCkpLAogCQkJKHVu
c2lnbmVkIGxvbmcpIF9fdmEoX19wYV9zeW1ib2wocm9kYXRhX3N0YXJ0KSkpOwo=
--001a1134b964c83e730507dc84fa--
