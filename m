Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaBFEda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 23:33:30 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:41388 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaBFEd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 23:33:28 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx70seh4VD+=ZKHrjTCrinG0Hq3=X6ygCeOeuNCSG8n8Q@mail.gmail.com>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
	<CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
	<20140206005534.GA27848@node.dhcp.inet.fi>
	<CA+55aFx70seh4VD+=ZKHrjTCrinG0Hq3=X6ygCeOeuNCSG8n8Q@mail.gmail.com>
Date: Wed, 5 Feb 2014 20:33:27 -0800
X-Google-Sender-Auth: y7Rnwh8PcKsP8hnQB-cXx4au9t4
Message-ID: <CA+55aFwfGVCVouh5uap3UPy92vc4N9OrRRa-NpYT9ZMicU6w8w@mail.gmail.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ning Qu <quning@google.com>
Content-Type: multipart/mixed; boundary=089e01294232f24eb904f1b55fdd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01294232f24eb904f1b55fdd
Content-Type: text/plain; charset=UTF-8

On Wed, Feb 5, 2014 at 6:32 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> No, I was thinking "try to optimistically map 8 adjacent aligned pages
> at a time" - that would be the same cacheline in the page tables, so
> it would be fairly cheap if we couple it with a gang-lookup of the
> pages in the page cache

Doing the gang-lookup is hard, since it's all abstracted away, but the
attached patch kind of tries to do what I described.

This patch probably doesn't work, but something *like* this might be
worth playing with.

Except I suspect the page-backed faults are actually the minority,
judging by how high clear_page_c_e is in the profile it's probably
mostly anonymous memory. I have no idea why I started with the (more
complex) case of file-backed prefaulting. Oh well.

            Linus

--089e01294232f24eb904f1b55fdd
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hrbj4pla0

IG1tL21lbW9yeS5jIHwgNDIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystCiAxIGZpbGUgY2hhbmdlZCwgNDEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlm
ZiAtLWdpdCBhL21tL21lbW9yeS5jIGIvbW0vbWVtb3J5LmMKaW5kZXggYmU2YTBjMGQ0YWUwLi5k
NTJlYzZhMzQ0ZGMgMTAwNjQ0Ci0tLSBhL21tL21lbW9yeS5jCisrKyBiL21tL21lbW9yeS5jCkBA
IC0zNDg3LDE1ICszNDg3LDU1IEBAIHVuY2hhcmdlX291dDoKIAlyZXR1cm4gcmV0OwogfQogCisj
ZGVmaW5lIG5vX2ZhdWx0X2Fyb3VuZCh4KSAoeCAmIChWTV9GQVVMVF9FUlJPUiB8IFZNX0ZBVUxU
X01BSk9SIHwgVk1fRkFVTFRfUkVUUlkpKQorI2RlZmluZSBGQVVMVF9BUk9VTkRfU0hJRlQgKDMp
CisKK3N0YXRpYyB2b2lkIGZhdWx0X2Fyb3VuZChzdHJ1Y3QgbW1fc3RydWN0ICptbSwgc3RydWN0
IHZtX2FyZWFfc3RydWN0ICp2bWEsCisJdW5zaWduZWQgbG9uZyBhZGRyZXNzLCBwbWRfdCAqcG1k
KQoreworCWludCBuciA9IDEgPDwgRkFVTFRfQVJPVU5EX1NISUZUOworCisJYWRkcmVzcyAmPSBQ
QUdFX01BU0sgPDwgRkFVTFRfQVJPVU5EX1NISUZUOworCWlmIChhZGRyZXNzIDwgdm1hLT52bV9z
dGFydCkKKwkJcmV0dXJuOworCisJZG8geworCQlwdGVfdCAqcHRlOworCQlwdGVfdCBlbnRyeTsK
KwkJcGdvZmZfdCBwZ29mZjsKKworCQlwdGUgPSBwdGVfb2Zmc2V0X21hcChwbWQsIGFkZHJlc3Mp
OworCQllbnRyeSA9ICpwdGU7CisKKwkJcHRlX3VubWFwKHB0ZSk7CisJCWlmICghcHRlX25vbmUo
ZW50cnkpKQorCQkJY29udGludWU7CisJCXBnb2ZmID0gKGFkZHJlc3MgLSB2bWEtPnZtX3N0YXJ0
KSA+PiBQQUdFX1NISUZUOworCQlwZ29mZiArPSB2bWEtPnZtX3Bnb2ZmOworCQlpZiAobm9fZmF1
bHRfYXJvdW5kKF9fZG9fZmF1bHQobW0sIHZtYSwgYWRkcmVzcywgcG1kLCBwZ29mZiwgMCwgZW50
cnkpKSkKKwkJCWJyZWFrOworCX0gd2hpbGUgKGFkZHJlc3MgKz0gUEFHRV9TSVpFLCBhZGRyZXNz
IDwgdm1hLT52bV9lbmQgJiYgLS1uciA+IDApOworfQorCiBzdGF0aWMgaW50IGRvX2xpbmVhcl9m
YXVsdChzdHJ1Y3QgbW1fc3RydWN0ICptbSwgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEsCiAJ
CXVuc2lnbmVkIGxvbmcgYWRkcmVzcywgcHRlX3QgKnBhZ2VfdGFibGUsIHBtZF90ICpwbWQsCiAJ
CXVuc2lnbmVkIGludCBmbGFncywgcHRlX3Qgb3JpZ19wdGUpCiB7CisJaW50IHJldDsKIAlwZ29m
Zl90IHBnb2ZmID0gKCgoYWRkcmVzcyAmIFBBR0VfTUFTSykKIAkJCS0gdm1hLT52bV9zdGFydCkg
Pj4gUEFHRV9TSElGVCkgKyB2bWEtPnZtX3Bnb2ZmOwogCiAJcHRlX3VubWFwKHBhZ2VfdGFibGUp
OwotCXJldHVybiBfX2RvX2ZhdWx0KG1tLCB2bWEsIGFkZHJlc3MsIHBtZCwgcGdvZmYsIGZsYWdz
LCBvcmlnX3B0ZSk7CisJcmV0ID0gX19kb19mYXVsdChtbSwgdm1hLCBhZGRyZXNzLCBwbWQsIHBn
b2ZmLCBmbGFncywgb3JpZ19wdGUpOworCisJLyoKKwkgKiBJZiB0aGUgcGFnZSB3ZSB3ZXJlIGxv
b2tpbmcgZm9yIHN1Y2NlZWRlZCB3aXRoIG5vIHJldHJpZXMsCisJICogc2VlIGlmIHdlIGNhbiBm
YXVsdCBhcm91bmQgaXQgdG9vLi4KKwkgKi8KKwlpZiAoIW5vX2ZhdWx0X2Fyb3VuZChyZXQpICYm
IChmbGFncyAmIEZBVUxUX0ZMQUdfQUxMT1dfUkVUUlkpKQorCQlmYXVsdF9hcm91bmQobW0sIHZt
YSwgYWRkcmVzcywgcG1kKTsKKworCXJldHVybiByZXQ7CiB9CiAKIC8qCg==
--089e01294232f24eb904f1b55fdd--
