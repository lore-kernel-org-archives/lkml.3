Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaKRHjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:39:46 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62799 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaKRHjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:39:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKynZtTu8T333v+ZeUSfhQxgOmc6S3g-GuZzN_e4FvP5Q@mail.gmail.com>
References: <20141114204517.GA24402@www.outflux.net>
	<CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
	<CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com>
	<CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
	<alpine.DEB.2.11.1411162127310.3909@nanos>
	<CAGXu5jKynZtTu8T333v+ZeUSfhQxgOmc6S3g-GuZzN_e4FvP5Q@mail.gmail.com>
Date: Mon, 17 Nov 2014 23:39:43 -0800
X-Google-Sender-Auth: ydbYyAWvsqjXnUleN_q6gVjArsk
Message-ID: <CAE9FiQVQg58Nadooo3U=8BBJ7Qr2ptxan52=LAD_eJMKzNXfMQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Laura Abbott <lauraa@codeaurora.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Content-Type: multipart/mixed; boundary=001a113fec66d4af9c05081d32d8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a113fec66d4af9c05081d32d8
Content-Type: text/plain; charset=UTF-8

On Mon, Nov 17, 2014 at 12:27 PM, Kees Cook <keescook@chromium.org> wrote:
> On Sun, Nov 16, 2014 at 3:44 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> So the initial patch to get rid of the X mapping is of course to just
>> extend the area to the PMD. A little bit different to your initial
>> patch, but essentially the same.
>>
>> -       unsigned long all_end = PFN_ALIGN(&_end);
>> +       unsigned long all_end = roundup((unsigned long) &_end, PMD_SIZE);
>>
>> I'm going to apply your V1 patch with the above roundup()
>> simplification. If a page of that area gets used later on then we are
>> going to split up the PMD anyway.
>
> That's fine by me. Yinghai Lu seems to have potentially better
> solutions, but my head is spinning after reading more of this thread.
> :) I just want to make sure that at the end of the day, there are no
> RW+x mappings.
>

Please check v3 that cleanup highmap in the middle.


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
0xffffffff81000000-0xffffffff82000000          16M     ro         PSE GLB x  pmd
0xffffffff82000000-0xffffffff82011000          68K     ro             GLB x  pte
0xffffffff82011000-0xffffffff82200000        1980K                           pte
0xffffffff82200000-0xffffffff82a00000           8M     ro         PSE GLB NX pmd
0xffffffff82a00000-0xffffffff82a1d000         116K     ro             GLB NX pte
0xffffffff82a1d000-0xffffffff82c00000        1932K                           pte
0xffffffff82c00000-0xffffffff82e00000           2M     RW         PSE GLB NX pmd
0xffffffff82e00000-0xffffffff82e52000         328K     RW             GLB NX pte
0xffffffff82e52000-0xffffffff83000000        1720K                           pte
0xffffffff83000000-0xffffffff83200000           2M                           pmd
0xffffffff83200000-0xffffffff83213000          76K                           pte
0xffffffff83213000-0xffffffff83400000        1972K     RW             GLB NX pte
0xffffffff83400000-0xffffffff84200000          14M     RW         PSE GLB NX pmd
0xffffffff84200000-0xffffffff84383000        1548K     RW             GLB NX pte
0xffffffff84383000-0xffffffff84400000         500K                           pte
0xffffffff84400000-0xffffffffa0000000         444M                           pmd

Thanks

Yinghai

--001a113fec66d4af9c05081d32d8
Content-Type: text/x-patch; charset=US-ASCII; name="nx_after_end_v3_1.patch"
Content-Disposition: attachment; filename="nx_after_end_v3_1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2my9th20

U3ViamVjdDogW1BBVENIIDEvMl0geDg2LCA2NGJpdDogYWRkIHBmbl9yYW5nZV9pc19oaWdobWFw
cGVkKCkKCndpbGwgdXNlIGl0IHRvIHN1cHBvcnQgaG9sZXMgaW4gaGlnaG1hcC4KClNpZ25lZC1v
ZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogYXJjaC94ODYvaW5j
bHVkZS9hc20vcGd0YWJsZV82NC5oIHwgICAgMiArKwogYXJjaC94ODYvbW0vaW5pdF82NC5jICAg
ICAgICAgICAgIHwgICAyMiArKysrKysrKysrKysrKysrKysrKysrCiBhcmNoL3g4Ni9tbS9wYWdl
YXR0ci5jICAgICAgICAgICAgfCAgIDE2ICstLS0tLS0tLS0tLS0tLS0KIDMgZmlsZXMgY2hhbmdl
ZCwgMjUgaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42L2Fy
Y2gveDg2L21tL2luaXRfNjQuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4
Ni9tbS9pbml0XzY0LmMKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9pbml0XzY0LmMKQEAgLTM3
NSw2ICszNzUsMjMgQEAgdm9pZCBfX2luaXQgaW5pdF9leHRyYV9tYXBwaW5nX3VjKHVuc2lnbgog
CV9faW5pdF9leHRyYV9tYXBwaW5nKHBoeXMsIHNpemUsIFBBR0VfS0VSTkVMX0xBUkdFX05PQ0FD
SEUpOwogfQogCisvKiB0aHJlZSBob2xlcyBhdCBtb3N0Ki8KKyNkZWZpbmUgTlJfUkFOR0UgNAor
c3RhdGljIHN0cnVjdCByYW5nZSBwZm5faGlnaG1hcHBlZFtOUl9SQU5HRV07CitzdGF0aWMgaW50
IG5yX3Bmbl9oaWdobWFwcGVkOworCitpbnQgcGZuX3JhbmdlX2lzX2hpZ2htYXBwZWQodW5zaWdu
ZWQgbG9uZyBzdGFydF9wZm4sIHVuc2lnbmVkIGxvbmcgZW5kX3BmbikKK3sKKwlpbnQgaTsKKwor
CWZvciAoaSA9IDA7IGkgPCBucl9wZm5faGlnaG1hcHBlZDsgaSsrKQorCQlpZiAoKHN0YXJ0X3Bm
biA+PSBwZm5faGlnaG1hcHBlZFtpXS5zdGFydCkgJiYKKwkJICAgIChlbmRfcGZuIDw9IHBmbl9o
aWdobWFwcGVkW2ldLmVuZCkpCisJCQlyZXR1cm4gMTsKKworCXJldHVybiAwOworfQorCiAvKgog
ICogVGhlIGhlYWQuUyBjb2RlIHNldHMgdXAgdGhlIGtlcm5lbCBoaWdoIG1hcHBpbmc6CiAgKgpA
QCAtNDA5LDYgKzQyNiwxMSBAQCB2b2lkIF9faW5pdCBjbGVhbnVwX2hpZ2htYXAodm9pZCkKIAkJ
aWYgKHZhZGRyIDwgKHVuc2lnbmVkIGxvbmcpIF90ZXh0IHx8IHZhZGRyID4gZW5kKQogCQkJc2V0
X3BtZChwbWQsIF9fcG1kKDApKTsKIAl9CisKKwlucl9wZm5faGlnaG1hcHBlZCA9IGFkZF9yYW5n
ZShwZm5faGlnaG1hcHBlZCwgTlJfUkFOR0UsCisJCQlucl9wZm5faGlnaG1hcHBlZCwKKwkJCV9f
cGFfc3ltYm9sKF90ZXh0KSA+PiBQQUdFX1NISUZULAorCQkJX19wYV9zeW1ib2wocm91bmR1cChf
YnJrX2VuZCwgUE1EX1NJWkUpKSA+PiBQQUdFX1NISUZUKTsKIH0KIAogc3RhdGljIHVuc2lnbmVk
IGxvbmcgX19tZW1pbml0CkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYvbW0vcGFnZWF0dHIuYwo9
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9tbS9wYWdlYXR0ci5jCisrKyBs
aW51eC0yLjYvYXJjaC94ODYvbW0vcGFnZWF0dHIuYwpAQCAtOTEsMjAgKzkxLDYgQEAgdm9pZCBh
cmNoX3JlcG9ydF9tZW1pbmZvKHN0cnVjdCBzZXFfZmlsZQogc3RhdGljIGlubGluZSB2b2lkIHNw
bGl0X3BhZ2VfY291bnQoaW50IGxldmVsKSB7IH0KICNlbmRpZgogCi0jaWZkZWYgQ09ORklHX1g4
Nl82NAotCi1zdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgaGlnaG1hcF9zdGFydF9wZm4odm9p
ZCkKLXsKLQlyZXR1cm4gX19wYV9zeW1ib2woX3RleHQpID4+IFBBR0VfU0hJRlQ7Ci19Ci0KLXN0
YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyBoaWdobWFwX2VuZF9wZm4odm9pZCkKLXsKLQlyZXR1
cm4gX19wYV9zeW1ib2wocm91bmR1cChfYnJrX2VuZCwgUE1EX1NJWkUpKSA+PiBQQUdFX1NISUZU
OwotfQotCi0jZW5kaWYKLQogI2lmZGVmIENPTkZJR19ERUJVR19QQUdFQUxMT0MKICMgZGVmaW5l
IGRlYnVnX3BhZ2VhbGxvYyAxCiAjZWxzZQpAQCAtMTI0Miw3ICsxMjI4LDcgQEAgc3RhdGljIGlu
dCBjcGFfcHJvY2Vzc19hbGlhcyhzdHJ1Y3QgY3BhXwogCSAqIHRvIHRvdWNoIHRoZSBoaWdoIG1h
cHBlZCBrZXJuZWwgYXMgd2VsbDoKIAkgKi8KIAlpZiAoIXdpdGhpbih2YWRkciwgKHVuc2lnbmVk
IGxvbmcpX3RleHQsIF9icmtfZW5kKSAmJgotCSAgICB3aXRoaW4oY3BhLT5wZm4sIGhpZ2htYXBf
c3RhcnRfcGZuKCksIGhpZ2htYXBfZW5kX3BmbigpKSkgeworCSAgICBwZm5fcmFuZ2VfaXNfaGln
aG1hcHBlZChjcGEtPnBmbiwgMSkpIHsKIAkJdW5zaWduZWQgbG9uZyB0ZW1wX2NwYV92YWRkciA9
IChjcGEtPnBmbiA8PCBQQUdFX1NISUZUKSArCiAJCQkJCSAgICAgICBfX1NUQVJUX0tFUk5FTF9t
YXAgLSBwaHlzX2Jhc2U7CiAJCWFsaWFzX2NwYSA9ICpjcGE7CkluZGV4OiBsaW51eC0yLjYvYXJj
aC94ODYvaW5jbHVkZS9hc20vcGd0YWJsZV82NC5oCj09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5v
cmlnL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BndGFibGVfNjQuaAorKysgbGludXgtMi42L2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3BndGFibGVfNjQuaApAQCAtMTY3LDYgKzE2Nyw4IEBAIHN0YXRpYyBp
bmxpbmUgaW50IHBnZF9sYXJnZShwZ2RfdCBwZ2QpIHsKIGV4dGVybiBpbnQga2Vybl9hZGRyX3Zh
bGlkKHVuc2lnbmVkIGxvbmcgYWRkcik7CiBleHRlcm4gdm9pZCBjbGVhbnVwX2hpZ2htYXAodm9p
ZCk7CiAKK2ludCBwZm5fcmFuZ2VfaXNfaGlnaG1hcHBlZCh1bnNpZ25lZCBsb25nIHN0YXJ0X3Bm
biwgdW5zaWduZWQgbG9uZyBlbmRfcGZuKTsKKwogI2RlZmluZSBIQVZFX0FSQ0hfVU5NQVBQRURf
QVJFQQogI2RlZmluZSBIQVZFX0FSQ0hfVU5NQVBQRURfQVJFQV9UT1BET1dOCiAK
--001a113fec66d4af9c05081d32d8
Content-Type: text/x-patch; charset=US-ASCII; name="nx_after_end_v3_2.patch"
Content-Disposition: attachment; filename="nx_after_end_v3_2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i2mya1vy1

U3ViamVjdDogW1BBVENIIDIvMl0geDg2LCA2NGJpdDogY2xlYW51cCBoaWdobWFwIGxhdGUgZm9y
IG5vdCBuZWVkZWQgcmFuZ2UKCjEuIHNob3VsZCB1c2UgX2Jya19lbmQgaW5zdGVhZCBvZiAmX2Vu
ZCBpbiBtYXJrX3JvZGF0YV9ybygpLgogICBfYnJrX2VuZCBjYW4gbW92ZSB1cCB0byAmX2VuZCwg
aS5lLiB0byBfX2Jya19saW1pdC4gIEl0J3Mgc2FmZSB0bwogICB1c2UgX2Jya19lbmQgd2hlbiBt
YXJrX3JvZGF0YV9ybygpIGlzIGNhbGxlZCBiZWNhdXNlIGV4dGVuZF9icmsoKQogICBpcyBnb25l
IGFscmVhZHkgYXQgdGhhdCBwb2ludC4KMi4gYWRkIGNsZWFudXBfaGlnaG1hcF9sYXRlIGZvciBy
YW5nZSBmb3IgaW5pdG1lbSwgYXJvdW5kIHJvZGF0YSwgYW5kCiAgIFtfYnJrX2VuZCwgcG1kX2Vu
ZF0KCktlcm5lbCBMYXlvdXQ6CgpbICAgIDAuMDAwMDAwXSAgIC50ZXh0OiBbMHgwMTAwMDAwMC0w
eDAyMDBkNjA4XQpbICAgIDAuMDAwMDAwXSAucm9kYXRhOiBbMHgwMjIwMDAwMC0weDAyYTFjZmZm
XQpbICAgIDAuMDAwMDAwXSAgIC5kYXRhOiBbMHgwMmMwMDAwMC0weDAyZTUwZTdmXQpbICAgIDAu
MDAwMDAwXSAgIC5pbml0OiBbMHgwMmU1MjAwMC0weDAzMjEyZmZmXQpbICAgIDAuMDAwMDAwXSAg
ICAuYnNzOiBbMHgwMzIyMTAwMC0weDA0MzdiZmZmXQpbICAgIDAuMDAwMDAwXSAgICAuYnJrOiBb
MHgwNDM3YzAwMC0weDA0M2ExZmZmXQoKQWN0dWFsbHkgdXNlZCBicms6ClsgICAgMC4yNzI5NTld
IG1lbWJsb2NrX3Jlc2VydmU6IFsweDAwMDAwMDA0MzdjMDAwLTB4MDAwMDAwMDQzODJmZmZdIGZs
YWdzIDB4MCBCUksKCkJlZm9yZSBwYXRjaDoKLS0tWyBIaWdoIEtlcm5lbCBNYXBwaW5nIF0tLS0K
MHhmZmZmZmZmZjgwMDAwMDAwLTB4ZmZmZmZmZmY4MTAwMDAwMCAgICAgICAgICAxNk0gICAgICAg
ICAgICAgICAgICAgICAgICAgICBwbWQKMHhmZmZmZmZmZjgxMDAwMDAwLTB4ZmZmZmZmZmY4MjIw
MDAwMCAgICAgICAgICAxOE0gICAgIHJvICAgICAgICAgUFNFIEdMQiB4ICBwbWQKMHhmZmZmZmZm
ZjgyMjAwMDAwLTB4ZmZmZmZmZmY4MmMwMDAwMCAgICAgICAgICAxME0gICAgIHJvICAgICAgICAg
UFNFIEdMQiBOWCBwbWQKMHhmZmZmZmZmZjgyYzAwMDAwLTB4ZmZmZmZmZmY4MmUwMDAwMCAgICAg
ICAgICAgMk0gICAgIFJXICAgICAgICAgUFNFIEdMQiBOWCBwbWQKMHhmZmZmZmZmZjgyZTAwMDAw
LTB4ZmZmZmZmZmY4MzAwMDAwMCAgICAgICAgICAgMk0gICAgIFJXICAgICAgICAgICAgIEdMQiBO
WCBwdGUKMHhmZmZmZmZmZjgzMDAwMDAwLTB4ZmZmZmZmZmY4MzIwMDAwMCAgICAgICAgICAgMk0g
ICAgIFJXICAgICAgICAgUFNFIEdMQiBOWCBwbWQKMHhmZmZmZmZmZjgzMjAwMDAwLTB4ZmZmZmZm
ZmY4MzQwMDAwMCAgICAgICAgICAgMk0gICAgIFJXICAgICAgICAgICAgIEdMQiBOWCBwdGUKMHhm
ZmZmZmZmZjgzNDAwMDAwLTB4ZmZmZmZmZmY4NDIwMDAwMCAgICAgICAgICAxNE0gICAgIFJXICAg
ICAgICAgUFNFIEdMQiBOWCBwbWQKMHhmZmZmZmZmZjg0MjAwMDAwLTB4ZmZmZmZmZmY4NDNhMjAw
MCAgICAgICAgMTY3MksgICAgIFJXICAgICAgICAgICAgIEdMQiBOWCBwdGUKMHhmZmZmZmZmZjg0
M2EyMDAwLTB4ZmZmZmZmZmY4NDQwMDAwMCAgICAgICAgIDM3NksgICAgIFJXICAgICAgICAgICAg
IEdMQiB4ICBwdGUKMHhmZmZmZmZmZjg0NDAwMDAwLTB4ZmZmZmZmZmZhMDAwMDAwMCAgICAgICAg
IDQ0NE0gICAgICAgICAgICAgICAgICAgICAgICAgICBwbWQKCkFmdGVyIHBhdGNoOgotLS1bIEhp
Z2ggS2VybmVsIE1hcHBpbmcgXS0tLQoweGZmZmZmZmZmODAwMDAwMDAtMHhmZmZmZmZmZjgxMDAw
MDAwICAgICAgICAgIDE2TSAgICAgICAgICAgICAgICAgICAgICAgICAgIHBtZAoweGZmZmZmZmZm
ODEwMDAwMDAtMHhmZmZmZmZmZjgyMDAwMDAwICAgICAgICAgIDE2TSAgICAgcm8gICAgICAgICBQ
U0UgR0xCIHggIHBtZAoweGZmZmZmZmZmODIwMDAwMDAtMHhmZmZmZmZmZjgyMDExMDAwICAgICAg
ICAgIDY4SyAgICAgcm8gICAgICAgICAgICAgR0xCIHggIHB0ZQoweGZmZmZmZmZmODIwMTEwMDAt
MHhmZmZmZmZmZjgyMjAwMDAwICAgICAgICAxOTgwSyAgICAgICAgICAgICAgICAgICAgICAgICAg
IHB0ZQoweGZmZmZmZmZmODIyMDAwMDAtMHhmZmZmZmZmZjgyYTAwMDAwICAgICAgICAgICA4TSAg
ICAgcm8gICAgICAgICBQU0UgR0xCIE5YIHBtZAoweGZmZmZmZmZmODJhMDAwMDAtMHhmZmZmZmZm
ZjgyYTFkMDAwICAgICAgICAgMTE2SyAgICAgcm8gICAgICAgICAgICAgR0xCIE5YIHB0ZQoweGZm
ZmZmZmZmODJhMWQwMDAtMHhmZmZmZmZmZjgyYzAwMDAwICAgICAgICAxOTMySyAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHB0ZQoweGZmZmZmZmZmODJjMDAwMDAtMHhmZmZmZmZmZjgyZTAwMDAw
ICAgICAgICAgICAyTSAgICAgUlcgICAgICAgICBQU0UgR0xCIE5YIHBtZAoweGZmZmZmZmZmODJl
MDAwMDAtMHhmZmZmZmZmZjgyZTUyMDAwICAgICAgICAgMzI4SyAgICAgUlcgICAgICAgICAgICAg
R0xCIE5YIHB0ZQoweGZmZmZmZmZmODJlNTIwMDAtMHhmZmZmZmZmZjgzMDAwMDAwICAgICAgICAx
NzIwSyAgICAgICAgICAgICAgICAgICAgICAgICAgIHB0ZQoweGZmZmZmZmZmODMwMDAwMDAtMHhm
ZmZmZmZmZjgzMjAwMDAwICAgICAgICAgICAyTSAgICAgICAgICAgICAgICAgICAgICAgICAgIHBt
ZAoweGZmZmZmZmZmODMyMDAwMDAtMHhmZmZmZmZmZjgzMjEzMDAwICAgICAgICAgIDc2SyAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHB0ZQoweGZmZmZmZmZmODMyMTMwMDAtMHhmZmZmZmZmZjgz
NDAwMDAwICAgICAgICAxOTcySyAgICAgUlcgICAgICAgICAgICAgR0xCIE5YIHB0ZQoweGZmZmZm
ZmZmODM0MDAwMDAtMHhmZmZmZmZmZjg0MjAwMDAwICAgICAgICAgIDE0TSAgICAgUlcgICAgICAg
ICBQU0UgR0xCIE5YIHBtZAoweGZmZmZmZmZmODQyMDAwMDAtMHhmZmZmZmZmZjg0MzgzMDAwICAg
ICAgICAxNTQ4SyAgICAgUlcgICAgICAgICAgICAgR0xCIE5YIHB0ZQoweGZmZmZmZmZmODQzODMw
MDAtMHhmZmZmZmZmZjg0NDAwMDAwICAgICAgICAgNTAwSyAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHB0ZQoweGZmZmZmZmZmODQ0MDAwMDAtMHhmZmZmZmZmZmEwMDAwMDAwICAgICAgICAgNDQ0
TSAgICAgICAgICAgICAgICAgICAgICAgICAgIHBtZAoKLXYzOiByZW1vdmUgYWxsIG5vdCB1c2Vk
IGhpZ2htYXAgcmFuZ2VzLgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJu
ZWwub3JnPgoKLS0tCiBhcmNoL3g4Ni9tbS9pbml0XzY0LmMgfCAgIDcwICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNjkg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9t
bS9pbml0XzY0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvbW0vaW5p
dF82NC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYvbW0vaW5pdF82NC5jCkBAIC0xMDk4LDYgKzEw
OTgsNjcgQEAgdm9pZCBfX2luaXQgbWVtX2luaXQodm9pZCkKIH0KIAogI2lmZGVmIENPTkZJR19E
RUJVR19ST0RBVEEKK3N0YXRpYyB2b2lkIHJlbW92ZV9oaWdobWFwXzJtKHVuc2lnbmVkIGxvbmcg
YWRkcikKK3sKKwlwZ2RfdCAqcGdkOworCXB1ZF90ICpwdWQ7CisJcG1kX3QgKnBtZDsKKworCXBn
ZCA9IHBnZF9vZmZzZXRfayhhZGRyKTsKKwlwdWQgPSAocHVkX3QgKilwZ2RfcGFnZV92YWRkcigq
cGdkKSArIHB1ZF9pbmRleChhZGRyKTsKKwlwbWQgPSAocG1kX3QgKilwdWRfcGFnZV92YWRkcigq
cHVkKSArIHBtZF9pbmRleChhZGRyKTsKKworCXNldF9wbWQocG1kLCBfX3BtZCgwKSk7Cit9CisK
K3N0YXRpYyB2b2lkIHJlbW92ZV9oaWdobWFwXzJtX3BhcnRpYWwodW5zaWduZWQgbG9uZyBhZGRy
LCB1bnNpZ25lZCBsb25nIGVuZCkKK3sKKwlpbnQgaTsKKwlwZ2RfdCAqcGdkOworCXB1ZF90ICpw
dWQ7CisJcG1kX3QgKnBtZDsKKwlwdGVfdCAqcHRlOworCWludCBzdGFydF9pbmRleCA9IHB0ZV9p
bmRleChhZGRyKTsKKwlpbnQgZW5kX2luZGV4ID0gcHRlX2luZGV4KGVuZCAtIDEpICsgMTsKKwor
CXNldF9tZW1vcnlfNGsoYWRkciwgZW5kX2luZGV4IC0gc3RhcnRfaW5kZXgpOworCisJcGdkID0g
cGdkX29mZnNldF9rKGFkZHIpOworCXB1ZCA9IChwdWRfdCAqKXBnZF9wYWdlX3ZhZGRyKCpwZ2Qp
ICsgcHVkX2luZGV4KGFkZHIpOworCXBtZCA9IChwbWRfdCAqKXB1ZF9wYWdlX3ZhZGRyKCpwdWQp
ICsgcG1kX2luZGV4KGFkZHIpOworCXB0ZSA9IChwdGVfdCAqKXBtZF9wYWdlX3ZhZGRyKCpwbWQp
ICsgc3RhcnRfaW5kZXg7CisKKwlmb3IgKGkgPSBzdGFydF9pbmRleDsgaSA8IGVuZF9pbmRleDsg
aSsrLCBwdGUrKykKKwkJc2V0X3B0ZShwdGUsIF9fcHRlKDApKTsKK30KKworc3RhdGljIHZvaWQg
Y2xlYW51cF9oaWdobWFwX2xhdGUodW5zaWduZWQgbG9uZyBzdGFydCwgdW5zaWduZWQgbG9uZyBl
bmQpCit7CisJdW5zaWduZWQgbG9uZyBhZGRyOworCXVuc2lnbmVkIGxvbmcgc3RhcnRfMm1fYWxp
Z25lZCA9IHJvdW5kdXAoc3RhcnQsIFBNRF9TSVpFKTsKKwl1bnNpZ25lZCBsb25nIGVuZF8ybV9h
bGlnbmVkID0gcm91bmRkb3duKGVuZCwgUE1EX1NJWkUpOworCisJc3RhcnQgPSBQRk5fQUxJR04o
c3RhcnQpOworCWVuZCAmPSBQQUdFX01BU0s7CisKKwlpZiAoc3RhcnQgPj0gZW5kKQorCQlyZXR1
cm47CisKKwlpZiAoc3RhcnQgPCBzdGFydF8ybV9hbGlnbmVkICYmIHN0YXJ0XzJtX2FsaWduZWQg
PD0gZW5kKQorCQlyZW1vdmVfaGlnaG1hcF8ybV9wYXJ0aWFsKHN0YXJ0LCBzdGFydF8ybV9hbGln
bmVkKTsKKworCWZvciAoYWRkciA9IHN0YXJ0XzJtX2FsaWduZWQ7IGFkZHIgPCBlbmRfMm1fYWxp
Z25lZDsgYWRkciArPSBQTURfU0laRSkKKwkJcmVtb3ZlX2hpZ2htYXBfMm0oYWRkcik7CisKKwlp
ZiAoc3RhcnQgPD0gZW5kXzJtX2FsaWduZWQgJiYgZW5kXzJtX2FsaWduZWQgPCBlbmQpCisJCXJl
bW92ZV9oaWdobWFwXzJtX3BhcnRpYWwoZW5kXzJtX2FsaWduZWQsIGVuZCk7CisKKwlzdWJ0cmFj
dF9yYW5nZShwZm5faGlnaG1hcHBlZCwgTlJfUkFOR0UsCisJCQlfX3BhX3N5bWJvbChzdGFydCkg
Pj4gUEFHRV9TSElGVCwKKwkJCV9fcGFfc3ltYm9sKGVuZCkgPj4gUEFHRV9TSElGVCk7CisJbnJf
cGZuX2hpZ2htYXBwZWQgPSBjbGVhbl9zb3J0X3JhbmdlKHBmbl9oaWdobWFwcGVkLCBOUl9SQU5H
RSk7Cit9CisKIGNvbnN0IGludCByb2RhdGFfdGVzdF9kYXRhID0gMHhDMzsKIEVYUE9SVF9TWU1C
T0xfR1BMKHJvZGF0YV90ZXN0X2RhdGEpOwogCkBAIC0xMTQ2LDcgKzEyMDcsOCBAQCB2b2lkIG1h
cmtfcm9kYXRhX3JvKHZvaWQpCiAJdW5zaWduZWQgbG9uZyBlbmQgPSAodW5zaWduZWQgbG9uZykg
Jl9fZW5kX3JvZGF0YV9ocGFnZV9hbGlnbjsKIAl1bnNpZ25lZCBsb25nIHRleHRfZW5kID0gUEZO
X0FMSUdOKCZfX3N0b3BfX19leF90YWJsZSk7CiAJdW5zaWduZWQgbG9uZyByb2RhdGFfZW5kID0g
UEZOX0FMSUdOKCZfX2VuZF9yb2RhdGEpOwotCXVuc2lnbmVkIGxvbmcgYWxsX2VuZCA9IFBGTl9B
TElHTigmX2VuZCk7CisJdW5zaWduZWQgbG9uZyBkYXRhX3N0YXJ0ID0gUEZOX0FMSUdOKCZfc2Rh
dGEpOworCXVuc2lnbmVkIGxvbmcgYWxsX2VuZCA9IFBGTl9BTElHTihfYnJrX2VuZCk7CiAKIAlw
cmludGsoS0VSTl9JTkZPICJXcml0ZSBwcm90ZWN0aW5nIHRoZSBrZXJuZWwgcmVhZC1vbmx5IGRh
dGE6ICVsdWtcbiIsCiAJICAgICAgIChlbmQgLSBzdGFydCkgPj4gMTApOwpAQCAtMTE2MCw2ICsx
MjIyLDEyIEBAIHZvaWQgbWFya19yb2RhdGFfcm8odm9pZCkKIAkgKi8KIAlzZXRfbWVtb3J5X254
KHJvZGF0YV9zdGFydCwgKGFsbF9lbmQgLSByb2RhdGFfc3RhcnQpID4+IFBBR0VfU0hJRlQpOwog
CisJY2xlYW51cF9oaWdobWFwX2xhdGUodGV4dF9lbmQsIHJvZGF0YV9zdGFydCk7CisJY2xlYW51
cF9oaWdobWFwX2xhdGUocm9kYXRhX2VuZCwgZGF0YV9zdGFydCk7CisJY2xlYW51cF9oaWdobWFw
X2xhdGUoYWxsX2VuZCwgcm91bmR1cChfYnJrX2VuZCwgUE1EX1NJWkUpKTsKKwljbGVhbnVwX2hp
Z2htYXBfbGF0ZSgodW5zaWduZWQgbG9uZykoJl9faW5pdF9iZWdpbiksCisJCQkJKHVuc2lnbmVk
IGxvbmcpKCZfX2luaXRfZW5kKSk7CisKIAlyb2RhdGFfdGVzdCgpOwogCiAjaWZkZWYgQ09ORklH
X0NQQV9ERUJVRwo=
--001a113fec66d4af9c05081d32d8--
