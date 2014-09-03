Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaICT6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:58:06 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:59745 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaICT6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:58:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140903175948.GH3001@console-pimps.org>
References: <5405E186.2080406@canonical.com>
	<20140902192941.GB3001@console-pimps.org>
	<CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
	<5406D0DB.90401@canonical.com>
	<CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>
	<54073409.6030004@canonical.com>
	<CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>
	<20140903175948.GH3001@console-pimps.org>
Date: Wed, 3 Sep 2014 21:57:59 +0200
Message-ID: <CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: multipart/mixed; boundary=089e0116071a2ad3c205022ea7bb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0116071a2ad3c205022ea7bb
Content-Type: text/plain; charset=UTF-8

On 3 September 2014 19:59, Matt Fleming <matt@console-pimps.org> wrote:
> On Wed, 03 Sep, at 05:37:26PM, Ard Biesheuvel wrote:
>>
>> Will do, thanks.
>>
>> @Matt: so there is two ways to fix this, the patch above addressing
>> this single instance, and alternatively, adding a #pragma GCC
>> visiblilty push(hidden) to all .c files under libstub/, *before* the
>> #includes. The latter would catch future problems regarding newly
>> introduced global variables, but it may be a bit overkill in this
>> case, as libstub is not expected to be in flux in the foreseeable
>> future.
>>
>> Any preferences?
>
> Any reason we can't reuse the existing GOT fixup code in the early x86
> boot code? We're not executing it before the EFI boot stub atm, which is
> the reason Maarten is hitting these difficulties.
>

I guess that is likely to work, I just wasn't aware it existed :-)
I think adding another visibility(hidden) attribute or 2 would
complete eliminate the need for GOT fixups, but I guess that is more
sensitive to compiler versions being recent enough etc.
The attached (build tested only) patch eliminates all GOT relocations
under boot/compressed for a 64-bit EFI stub build.

> Maarten, does the following help?
>
> If not, Ard please go ahead with option #2 above. Overkill yes, but I've
> done the single __attribute__() hacks in other projects and someone
> (usually me) always eventually forgets to tag some instance.
>

It appears we just got lucky on arm64, since we don't have any global
variables, but the issue does exist there as well.

-- 
Ard.


> ---
>
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 2884e0c3e8a5..7618857fcc60 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -32,6 +32,21 @@
>  #include <asm/processor-flags.h>
>  #include <asm/asm-offsets.h>
>
> +/*
> + * Adjust our own GOT
> + */
> +.macro FIXUP_GOT
> +       leaq    _got(%rip), %rdx
> +       leaq    _egot(%rip), %rcx
> +1:
> +       cmpq    %rcx, %rdx
> +       jae     2f
> +       addq    %rbx, (%rdx)
> +       addq    $8, %rdx
> +       jmp     1b
> +2:
> +.endm
> +
>         __HEAD
>         .code32
>  ENTRY(startup_32)
> @@ -256,6 +271,8 @@ ENTRY(efi_pe_entry)
>          */
>         addq    %rbp, efi64_config+88(%rip)
>
> +       FIXUP_GOT
> +
>         movq    %rax, %rdi
>         call    make_boot_params
>         cmpq    $0,%rax
> @@ -275,6 +292,7 @@ handover_entry:
>          */
>         movq    efi_config(%rip), %rax
>         addq    %rbp, 88(%rax)
> +       FIXUP_GOT
>  2:
>         movq    efi_config(%rip), %rdi
>         call    efi_main
> @@ -385,19 +403,8 @@ relocated:
>         shrq    $3, %rcx
>         rep     stosq
>
> -/*
> - * Adjust our own GOT
> - */
> -       leaq    _got(%rip), %rdx
> -       leaq    _egot(%rip), %rcx
> -1:
> -       cmpq    %rcx, %rdx
> -       jae     2f
> -       addq    %rbx, (%rdx)
> -       addq    $8, %rdx
> -       jmp     1b
> -2:
> -
> +       FIXUP_GOT
> +
>  /*
>   * Do the decompression, and jump to the new kernel..
>   */
>
> --
> Matt Fleming, Intel Open Source Technology Center

--089e0116071a2ad3c205022ea7bb
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-x86-eliminate-x86_64-GOT-relocations-in-early-boot-c.patch"
Content-Disposition: attachment; 
	filename="0001-x86-eliminate-x86_64-GOT-relocations-in-early-boot-c.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hzn2wmwv0

RnJvbSBhZDE1MDNjM2M3NzAxODBjMzU0MGU5YzgyYTU4Zjg0ZTIxYmRiODY4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJv
Lm9yZz4KRGF0ZTogV2VkLCAzIFNlcCAyMDE0IDIxOjQ4OjQxICswMjAwClN1YmplY3Q6IFtQQVRD
SF0geDg2OiBlbGltaW5hdGUgeDg2XzY0IEdPVCByZWxvY2F0aW9ucyBpbiBlYXJseSBib290IGNv
ZGUKClNpZ25lZC1vZmYtYnk6IEFyZCBCaWVzaGV1dmVsIDxhcmQuYmllc2hldXZlbEBsaW5hcm8u
b3JnPgotLS0KIGFyY2gveDg2L2Jvb3QvYm9vdC5oICAgICAgICAgICAgfCA0ICsrKysKIGFyY2gv
eDg2L2Jvb3QvY29tcHJlc3NlZC9taXNjLmggfCA1ICsrKysrCiBhcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9lZmkuaCAgICAgIHwgMiArLQogMyBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvYm9vdC9ib290LmggYi9hcmNoL3g4
Ni9ib290L2Jvb3QuaAppbmRleCBiZDQ5ZWM2MTI1NWMuLjE4YTAwMTBlZmMyMCAxMDA2NDQKLS0t
IGEvYXJjaC94ODYvYm9vdC9ib290LmgKKysrIGIvYXJjaC94ODYvYm9vdC9ib290LmgKQEAgLTI5
NywxMCArMjk3LDE0IEBAIHN0YXRpYyBpbmxpbmUgaW50IGNtZGxpbmVfZmluZF9vcHRpb25fYm9v
bChjb25zdCBjaGFyICpvcHRpb24pCiBpbnQgY2hlY2tfY3B1KGludCAqY3B1X2xldmVsX3B0ciwg
aW50ICpyZXFfbGV2ZWxfcHRyLCB1MzIgKiplcnJfZmxhZ3NfcHRyKTsKIGludCB2YWxpZGF0ZV9j
cHUodm9pZCk7CiAKKyNwcmFnbWEgR0NDIHZpc2liaWxpdHkgcHVzaChoaWRkZW4pCisKIC8qIGVh
cmx5X3NlcmlhbF9jb25zb2xlLmMgKi8KIGV4dGVybiBpbnQgZWFybHlfc2VyaWFsX2Jhc2U7CiB2
b2lkIGNvbnNvbGVfaW5pdCh2b2lkKTsKIAorI3ByYWdtYSBHQ0MgdmlzaWJpbGl0eSBwb3AKKwog
LyogZWRkLmMgKi8KIHZvaWQgcXVlcnlfZWRkKHZvaWQpOwogCmRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9ib290L2NvbXByZXNzZWQvbWlzYy5oIGIvYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL21pc2Mu
aAppbmRleCAyNGUzZTU2OWExM2MuLmEwZmQ1MWY5MGFkZCAxMDA2NDQKLS0tIGEvYXJjaC94ODYv
Ym9vdC9jb21wcmVzc2VkL21pc2MuaAorKysgYi9hcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvbWlz
Yy5oCkBAIC0yOSwxMCArMjksMTUgQEAKICNkZWZpbmUgbWVtcHRyIHVuc2lnbmVkCiAjZW5kaWYK
IAorI3ByYWdtYSBHQ0MgdmlzaWJpbGl0eSBwdXNoKGhpZGRlbikKKwogLyogbWlzYy5jICovCiBl
eHRlcm4gbWVtcHRyIGZyZWVfbWVtX3B0cjsKIGV4dGVybiBtZW1wdHIgZnJlZV9tZW1fZW5kX3B0
cjsKIGV4dGVybiBzdHJ1Y3QgYm9vdF9wYXJhbXMgKnJlYWxfbW9kZTsJCS8qIFBvaW50ZXIgdG8g
cmVhbC1tb2RlIGRhdGEgKi8KKworI3ByYWdtYSBHQ0MgdmlzaWJpbGl0eSBwb3AKKwogdm9pZCBf
X3B1dHN0cihjb25zdCBjaGFyICpzKTsKICNkZWZpbmUgZXJyb3JfcHV0c3RyKF9feCkgIF9fcHV0
c3RyKF9feCkKIApkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vZWZpLmggYi9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9lZmkuaAppbmRleCAwNDRhMmZkM2M1ZmUuLjg3MjVkODVmMTkwMyAx
MDA2NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vZWZpLmgKKysrIGIvYXJjaC94ODYvaW5j
bHVkZS9hc20vZWZpLmgKQEAgLTE3OCw3ICsxNzgsNyBAQCBzdHJ1Y3QgZWZpX2NvbmZpZyB7CiAJ
Ym9vbCBpczY0OwogfSBfX3BhY2tlZDsKIAotZXh0ZXJuIHN0cnVjdCBlZmlfY29uZmlnICplZmlf
ZWFybHk7CitleHRlcm4gX19hdHRyaWJ1dGVfXygodmlzaWJpbGl0eSgiaGlkZGVuIikpKSBzdHJ1
Y3QgZWZpX2NvbmZpZyAqZWZpX2Vhcmx5OwogCiAjZGVmaW5lIGVmaV9jYWxsX2Vhcmx5KGYsIC4u
LikJCQkJCQlcCiAJZWZpX2Vhcmx5LT5jYWxsKGVmaV9lYXJseS0+ZiwgX19WQV9BUkdTX18pOwot
LSAKMS44LjMuMgoK
--089e0116071a2ad3c205022ea7bb--
