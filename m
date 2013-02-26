Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab3BZQIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:08:17 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:59606 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab3BZQIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:08:16 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFycXwZi-U2uJWWusLGeaV3=BMEBdgcxGN9Lo0QcHHUrDA@mail.gmail.com>
References: <20130226045424.GA3576@osiris>
	<CA+55aFx8pUSHPhC_-ob2i5BbvBkEC4BVYtAbNkf3+FE+=3AmgA@mail.gmail.com>
	<20130226125739.GA3924@osiris>
	<CA+55aFycXwZi-U2uJWWusLGeaV3=BMEBdgcxGN9Lo0QcHHUrDA@mail.gmail.com>
Date: Tue, 26 Feb 2013 08:08:15 -0800
X-Google-Sender-Auth: kRn_F27yQn7JxIhGsLnVZQLbjhM
Message-ID: <CA+55aFzCU3jKDssYj9sDJU-VkugCfy_Cv5+VhMv9renZ94jRdQ@mail.gmail.com>
Subject: Re: bug in generic strncpy_from_user
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: multipart/mixed; boundary=bcaec5171ebf7ac6bb04d6a2ddbf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec5171ebf7ac6bb04d6a2ddbf
Content-Type: text/plain; charset=UTF-8

On Tue, Feb 26, 2013 at 7:51 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think the problem is that we add the guard page *after* we do the
> normal "let's try to expand" logic.
>
> I'll take a look.

Ahh, no. The guard page logic happens later at the fault time. We do
this in two phases - first "find_extend_vma()" does what the name
claims, and then check_stack_guard_page() is done for the last-page
case from within do_anonymous_page() when we actually touch the last
page itself.

But that's actually fine. We can simply make "find_extend_vma()" do
the obvious "refuse to extend the vma all the way", because we will
later allow the guard page to extend downwards to "touch" the mapping,
but that uses separate logic. So the attached trivial patch seems to
make perfect sense:

It is totally untested, though.  Does it work for you (and we should
do the same thing for the grows-up case, obviously)?

         Linus

--bcaec5171ebf7ac6bb04d6a2ddbf
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdn91xni0

IG1tL21tYXAuYyB8IDIgKysKIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykKCmRpZmYg
LS1naXQgYS9tbS9tbWFwLmMgYi9tbS9tbWFwLmMKaW5kZXggMzE4ZTEyMWFmZmRhLi5hZTQ3YzE2
MDlkOTkgMTAwNjQ0Ci0tLSBhL21tL21tYXAuYworKysgYi9tbS9tbWFwLmMKQEAgLTIyMjYsNiAr
MjIyNiw4IEBAIGZpbmRfZXh0ZW5kX3ZtYShzdHJ1Y3QgbW1fc3RydWN0ICogbW0sIHVuc2lnbmVk
IGxvbmcgYWRkcikKIAkJcmV0dXJuIHZtYTsKIAlpZiAoISh2bWEtPnZtX2ZsYWdzICYgVk1fR1JP
V1NET1dOKSkKIAkJcmV0dXJuIE5VTEw7CisJaWYgKHZtYS0+dm1fcHJldiAmJiB2bWEtPnZtX3By
ZXYtPnZtX2VuZCA9PSBhZGRyKQorCQlyZXR1cm4gTlVMTDsKIAlzdGFydCA9IHZtYS0+dm1fc3Rh
cnQ7CiAJaWYgKGV4cGFuZF9zdGFjayh2bWEsIGFkZHIpKQogCQlyZXR1cm4gTlVMTDsK
--bcaec5171ebf7ac6bb04d6a2ddbf--
