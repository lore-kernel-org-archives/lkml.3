Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbaDHWaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:30:10 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:44347 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaDHWaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <1860555101.1890107.1396990941681.JavaMail.zimbra@redhat.com>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
	<CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
	<CA+55aFyfKOv59hptv9rEcf31X5O8s26z+S8f-MchM1C0WtXx3A@mail.gmail.com>
	<20140408181305.GT10526@twins.programming.kicks-ass.net>
	<CA+55aFz+yMdXfsb-t3JzDhj6=M=-ggjDDGAQSbtfEcNhgyoopA@mail.gmail.com>
	<1860555101.1890107.1396990941681.JavaMail.zimbra@redhat.com>
Date: Tue, 8 Apr 2014 15:30:07 -0700
X-Google-Sender-Auth: mEJpO_Qghknw2xITA9BibzeEvrA
Message-ID: <CA+55aFzYwNde4ZyKgy_raRx9nz4+8he1-Fk9+_DDhWs-7fBbjw@mail.gmail.com>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Stancek <jstancek@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Content-Type: multipart/mixed; boundary=bcaec547c9d5b1981c04f68f86bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec547c9d5b1981c04f68f86bc
Content-Type: text/plain; charset=UTF-8

On Tue, Apr 8, 2014 at 2:02 PM, Jan Stancek <jstancek@redhat.com> wrote:
>
> I ran reproducer with following change on s390x system, where this
> can be reproduced usually within seconds:
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 67dacaf..9150ffd 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1095,6 +1095,7 @@ static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
>  static inline void
>  double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
>  {
> +       hb_waiters_inc(hb2);
>         if (hb1 <= hb2) {
>                 spin_lock(&hb1->lock);
>                 if (hb1 < hb2)
> @@ -1111,6 +1112,7 @@ double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
>         spin_unlock(&hb1->lock);
>         if (hb1 != hb2)
>                 spin_unlock(&hb2->lock);
> +       hb_waiters_dec(hb2);
>  }
>
>  /*
>
> Reproducer is running without failures over an hour now and
> made ~1.4 million iterations.

Ok, that's encouraging. That is the smallest patch I could come up
with, but as mentioned, it's not optimal. We only need it for
futex_requeue(), but if we do it there we'd have to handle all the
different error cases (there's only one call to double_lock_hb(), but
due to the error cases there's four calls to double_unlock_hb().

I'm not sure how much we care. The simple patch basically adds two
(unnecessary) atomics to the futex_wake_op() path. I don't know how
critical that path is - not as critical as the regular "futex_wake()",
I'd expect, but I guess pthread_cond_signal() is the main user.

So I'll have to leave this decision to the futex people. But the
attached slightly more complex patch *may* be the better one.

May I bother you to test this one too? I really think that
futex_requeue() is the only user that should need this, so doing it
there rather than in double_[un]lock_hb() should be slightly more
optimal, but who knows what I've missed. We clearly *all* missed this
race back when the ordering rules were documented..

Still hoping for comments from PeterZ and Davidlohr.

                  Linus

--bcaec547c9d5b1981c04f68f86bc
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_htrrgxfu0

IGtlcm5lbC9mdXRleC5jIHwgNSArKysrKwogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9mdXRleC5jIGIva2VybmVsL2Z1dGV4LmMKaW5kZXggNjdk
YWNhZjkzZTU2Li42ODAxYjM3NTFhOTUgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9mdXRleC5jCisrKyBi
L2tlcm5lbC9mdXRleC5jCkBAIC0xNDUyLDYgKzE0NTIsNyBAQCByZXRyeToKIAloYjIgPSBoYXNo
X2Z1dGV4KCZrZXkyKTsKIAogcmV0cnlfcHJpdmF0ZToKKwloYl93YWl0ZXJzX2luYyhoYjIpOwog
CWRvdWJsZV9sb2NrX2hiKGhiMSwgaGIyKTsKIAogCWlmIChsaWtlbHkoY21wdmFsICE9IE5VTEwp
KSB7CkBAIC0xNDYxLDYgKzE0NjIsNyBAQCByZXRyeV9wcml2YXRlOgogCiAJCWlmICh1bmxpa2Vs
eShyZXQpKSB7CiAJCQlkb3VibGVfdW5sb2NrX2hiKGhiMSwgaGIyKTsKKwkJCWhiX3dhaXRlcnNf
ZGVjKGhiMik7CiAKIAkJCXJldCA9IGdldF91c2VyKGN1cnZhbCwgdWFkZHIxKTsKIAkJCWlmIChy
ZXQpCkBAIC0xNTEwLDYgKzE1MTIsNyBAQCByZXRyeV9wcml2YXRlOgogCQkJYnJlYWs7CiAJCWNh
c2UgLUVGQVVMVDoKIAkJCWRvdWJsZV91bmxvY2tfaGIoaGIxLCBoYjIpOworCQkJaGJfd2FpdGVy
c19kZWMoaGIyKTsKIAkJCXB1dF9mdXRleF9rZXkoJmtleTIpOwogCQkJcHV0X2Z1dGV4X2tleSgm
a2V5MSk7CiAJCQlyZXQgPSBmYXVsdF9pbl91c2VyX3dyaXRlYWJsZSh1YWRkcjIpOwpAQCAtMTUx
OSw2ICsxNTIyLDcgQEAgcmV0cnlfcHJpdmF0ZToKIAkJY2FzZSAtRUFHQUlOOgogCQkJLyogVGhl
IG93bmVyIHdhcyBleGl0aW5nLCB0cnkgYWdhaW4uICovCiAJCQlkb3VibGVfdW5sb2NrX2hiKGhi
MSwgaGIyKTsKKwkJCWhiX3dhaXRlcnNfZGVjKGhiMik7CiAJCQlwdXRfZnV0ZXhfa2V5KCZrZXky
KTsKIAkJCXB1dF9mdXRleF9rZXkoJmtleTEpOwogCQkJY29uZF9yZXNjaGVkKCk7CkBAIC0xNTk0
LDYgKzE1OTgsNyBAQCByZXRyeV9wcml2YXRlOgogCiBvdXRfdW5sb2NrOgogCWRvdWJsZV91bmxv
Y2tfaGIoaGIxLCBoYjIpOworCWhiX3dhaXRlcnNfZGVjKGhiMik7CiAKIAkvKgogCSAqIGRyb3Bf
ZnV0ZXhfa2V5X3JlZnMoKSBtdXN0IGJlIGNhbGxlZCBvdXRzaWRlIHRoZSBzcGlubG9ja3MuIER1
cmluZwo=
--bcaec547c9d5b1981c04f68f86bc--
