Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3CEUPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:15:04 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48460 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab3CEUPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:15:02 -0500
MIME-Version: 1.0
In-Reply-To: <20130305195229.GS3438@sgi.com>
References: <20130228205206.GC3438@sgi.com>
	<512FC697.3090608@zytor.com>
	<20130228210910.GD3438@sgi.com>
	<512FC82B.40909@zytor.com>
	<CAE9FiQU3FBwEiC86N1RC8=aMdN09EbUmRcsWP0yof7bmxBhPew@mail.gmail.com>
	<512FE3AE.4070903@zytor.com>
	<20130305081519.GA19165@sgi.com>
	<9bcd6241-37fd-4ae9-a997-2a5da1eaf997@email.android.com>
	<CAE9FiQV2Wk+yiqR8FnNM_L-p1iQFxDwopRzFWTwm6VCkyrbuoQ@mail.gmail.com>
	<20130305195229.GS3438@sgi.com>
Date: Tue, 5 Mar 2013 12:14:56 -0800
X-Google-Sender-Auth: 9IKMZp1GIaL_UsQxqJbyOpdGXFY
Message-ID: <CAE9FiQX_+WO4Zr7TGWdjCNo_cdk+aSAmRNzpPUW_NxirnMEBCw@mail.gmail.com>
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
From: Yinghai Lu <yinghai@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, hpa@sgi.com,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae9340ea9e0004f04d73320cb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9340ea9e0004f04d73320cb
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Mar 5, 2013 at 11:52 AM, Robin Holt <holt@sgi.com> wrote:
> That fixed it for me.
>
> Can you help me understand why sentinel is non-zero?  It looks to me
> like 3.14 allocates 16kB plus strlen of the command line, zeros it,
> and then proceeds to fill in fields, some differing from what is in the
> boot_params structure.  That said, it looks like the sentinel field
> should remain 0.  I am still trying to understand, but if this patch
> makes it in, I am happy.

sentinel is out of setup_header.
it is 0x1ef. setup_header is from 0x1f1.

it will be 0xff from arch/x86/boot/header.S for bzImage.

        .section ".header", "a"
        .globl  sentinel
sentinel:       .byte 0xff, 0xff        /* Used to detect broken loaders */

elilo first copy first page, and get 0x1f1 for setup code sector number.
then it copies all setup code ( include setup header).

after that sysdeps_create_boot_params will copy first two pages to bp...
CopyMem(bp, param_start, 0x2000);

in that case, it will keep all fields in boot_params around setup_header as
with setup code...thus 0x1ef will be 0xff.

elilo need attached fix.

Thanks

Yinghai

--14dae9340ea9e0004f04d73320cb
Content-Type: application/octet-stream; name="fix_boot_params.patch"
Content-Disposition: attachment; filename="fix_boot_params.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdxhuq3l0

LS0tCiBpYTMyL3N5c3RlbS5jICAgfCAgICA5ICsrKysrKysrLQogeDg2XzY0L3N5c3RlbS5jIHwg
ICAgOSArKysrKysrKy0KIDIgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkKCkluZGV4OiBlbGlsby9pYTMyL3N5c3RlbS5jCj09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGVsaWxv
Lm9yaWcvaWEzMi9zeXN0ZW0uYworKysgZWxpbG8vaWEzMi9zeXN0ZW0uYwpAQCAtNDg3LDcgKzQ4
NywxNCBAQCBzeXNkZXBzX2NyZWF0ZV9ib290X3BhcmFtcygKIAkgKiBjYW4gYmUgdXNlZCBieSB0
aGUgY29tbWFuZCBsaW5lLgogCSAqLwogCWlmIChwYXJhbV9zdGFydCAhPSBOVUxMKSB7Ci0JCUNv
cHlNZW0oYnAsIHBhcmFtX3N0YXJ0LCAweDIwMDApOworCQl1bnNpZ25lZCBjaGFyICpwID0gcGFy
YW1fc3RhcnQ7CisJCXVuc2lnbmVkIGxvbmcgc2V0dXBfaGVhZGVyX3NpemUgPSBwWzB4MjAxXSAr
IDB4MjAyIC0gMHgxZjE7CisKKwkJLyogb25seSBjb3B5IHNldHVwX2hlYWRlciAqLworCQlpZiAo
c2V0dXBfaGVhZGVyX3NpemUgPiAweDdmKQorCQkJc2V0dXBfaGVhZGVyX3NpemUgPSAweDdmOwor
CQlDb3B5TWVtKCh1bnNpZ25lZCBjaGFyICopYnAgKyAweDFmMSwgcCArIDB4MWYxLAorCQkJc2V0
dXBfaGVhZGVyX3NpemUpOwogCQlmcmVlKHBhcmFtX3N0YXJ0KTsKIAkJcGFyYW1fc3RhcnQgPSBO
VUxMOwogCQlwYXJhbV9zaXplID0gMDsKSW5kZXg6IGVsaWxvL3g4Nl82NC9zeXN0ZW0uYwo9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09Ci0tLSBlbGlsby5vcmlnL3g4Nl82NC9zeXN0ZW0uYworKysgZWxpbG8veDg2XzY0L3N5
c3RlbS5jCkBAIC02NDAsNyArNjQwLDE0IEBAIHN5c2RlcHNfY3JlYXRlX2Jvb3RfcGFyYW1zKAog
CSAqIGNhbiBiZSB1c2VkIGJ5IHRoZSBjb21tYW5kIGxpbmUuCiAJICovCiAJaWYgKHBhcmFtX3N0
YXJ0ICE9IE5VTEwpIHsKLQkJQ29weU1lbShicCwgcGFyYW1fc3RhcnQsIDB4MjAwMCk7CisJCXVu
c2lnbmVkIGNoYXIgKnAgPSBwYXJhbV9zdGFydDsKKwkJdW5zaWduZWQgbG9uZyBzZXR1cF9oZWFk
ZXJfc2l6ZSA9IHBbMHgyMDFdICsgMHgyMDIgLSAweDFmMTsKKworCQkvKiBvbmx5IGNvcHkgc2V0
dXBfaGVhZGVyICovCisJCWlmIChzZXR1cF9oZWFkZXJfc2l6ZSA+IDB4N2YpCisJCQlzZXR1cF9o
ZWFkZXJfc2l6ZSA9IDB4N2Y7CisJCUNvcHlNZW0oKHVuc2lnbmVkIGNoYXIgKilicCArIDB4MWYx
LCBwICsgMHgxZjEsCisJCQlzZXR1cF9oZWFkZXJfc2l6ZSk7CiAJCWZyZWUocGFyYW1fc3RhcnQp
OwogCQlwYXJhbV9zdGFydCA9IE5VTEw7CiAJCXBhcmFtX3NpemUgPSAwOwo=
--14dae9340ea9e0004f04d73320cb--
