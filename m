Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3LJWTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:19:46 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:40109 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3LJWTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:19:44 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	<CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	<20131210203559.GA1209@redhat.com>
	<20131210204925.GB27373@redhat.com>
	<20131210213431.GA6342@redhat.com>
	<20131210214143.GG27373@redhat.com>
	<CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
Date: Tue, 10 Dec 2013 14:19:43 -0800
X-Google-Sender-Auth: WWUOjR-O4pnPHmpkX49vl5VJLYI
Message-ID: <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
Subject: Re: process 'stuck' at exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Content-Type: multipart/mixed; boundary=047d7b5d879163045904ed35829f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b5d879163045904ed35829f
Content-Type: text/plain; charset=UTF-8

On Tue, Dec 10, 2013 at 1:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So it looks like __get_user_pages_fast() fails, and keeps failing.

Hmm.. Is any of the addresses unchecked, perhaps?
__get_user_pages_fast() does an access_ok() check, while
get_user_pages_fast() does *not* seem to do one.

That looks a bit dangerous. Yeah, users should have checked the
address range, but there really is no reason not to do it in
get_user_pages_fast().

And it looks like the futex code is actually seriously buggered. It
only does the access_ok() check for the non-shared case.

Why?

Shouldn't we do something like the attached?

               Linus

--047d7b5d879163045904ed35829f
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hp1pouqr0

IGFyY2gveDg2L21tL2d1cC5jIHwgNCArLS0tCiBrZXJuZWwvZnV0ZXguYyAgICB8IDUgKysrLS0K
IDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2FyY2gveDg2L21tL2d1cC5jIGIvYXJjaC94ODYvbW0vZ3VwLmMKaW5kZXggZGQ3NGU0
NjgyOGMwLi42MWU3MjY1OTc1OTkgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L21tL2d1cC5jCisrKyBi
L2FyY2gveDg2L21tL2d1cC5jCkBAIC0zMjYsMTAgKzMyNiw4IEBAIGludCBnZXRfdXNlcl9wYWdl
c19mYXN0KHVuc2lnbmVkIGxvbmcgc3RhcnQsIGludCBucl9wYWdlcywgaW50IHdyaXRlLAogCWlm
IChlbmQgPCBzdGFydCkKIAkJZ290byBzbG93X2lycW9uOwogCi0jaWZkZWYgQ09ORklHX1g4Nl82
NAotCWlmIChlbmQgPj4gX19WSVJUVUFMX01BU0tfU0hJRlQpCisJaWYgKGVuZCA+IFRBU0tfU0la
RV9NQVgpCiAJCWdvdG8gc2xvd19pcnFvbjsKLSNlbmRpZgogCiAJLyoKIAkgKiBYWFg6IGJhdGNo
IC8gbGltaXQgJ25yJywgdG8gYXZvaWQgbGFyZ2UgaXJxIG9mZiBsYXRlbmN5CmRpZmYgLS1naXQg
YS9rZXJuZWwvZnV0ZXguYyBiL2tlcm5lbC9mdXRleC5jCmluZGV4IDgwYmEwODZmMDIxZC4uMjNj
MTJhMzVkY2EyIDEwMDY0NAotLS0gYS9rZXJuZWwvZnV0ZXguYworKysgYi9rZXJuZWwvZnV0ZXgu
YwpAQCAtMjUxLDYgKzI1MSw5IEBAIGdldF9mdXRleF9rZXkodTMyIF9fdXNlciAqdWFkZHIsIGlu
dCBmc2hhcmVkLCB1bmlvbiBmdXRleF9rZXkgKmtleSwgaW50IHJ3KQogCQlyZXR1cm4gLUVJTlZB
TDsKIAlhZGRyZXNzIC09IGtleS0+Ym90aC5vZmZzZXQ7CiAKKwlpZiAodW5saWtlbHkoIWFjY2Vz
c19vayhWRVJJRllfV1JJVEUsIHVhZGRyLCBzaXplb2YodTMyKSkpKQorCQlyZXR1cm4gLUVGQVVM
VDsKKwogCS8qCiAJICogUFJPQ0VTU19QUklWQVRFIGZ1dGV4ZXMgYXJlIGZhc3QuCiAJICogQXMg
dGhlIG1tIGNhbm5vdCBkaXNhcHBlYXIgdW5kZXIgdXMgYW5kIHRoZSAna2V5JyBvbmx5IG5lZWRz
CkBAIC0yNTksOCArMjYyLDYgQEAgZ2V0X2Z1dGV4X2tleSh1MzIgX191c2VyICp1YWRkciwgaW50
IGZzaGFyZWQsIHVuaW9uIGZ1dGV4X2tleSAqa2V5LCBpbnQgcncpCiAJICogICAgICAgIGJ1dCBh
Y2Nlc3Nfb2soKSBzaG91bGQgYmUgZmFzdGVyIHRoYW4gZmluZF92bWEoKQogCSAqLwogCWlmICgh
ZnNoYXJlZCkgewotCQlpZiAodW5saWtlbHkoIWFjY2Vzc19vayhWRVJJRllfV1JJVEUsIHVhZGRy
LCBzaXplb2YodTMyKSkpKQotCQkJcmV0dXJuIC1FRkFVTFQ7CiAJCWtleS0+cHJpdmF0ZS5tbSA9
IG1tOwogCQlrZXktPnByaXZhdGUuYWRkcmVzcyA9IGFkZHJlc3M7CiAJCWdldF9mdXRleF9rZXlf
cmVmcyhrZXkpOwo=
--047d7b5d879163045904ed35829f--
