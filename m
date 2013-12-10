Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881Ab3LJWdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:33:18 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35042 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3LJWdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:33:17 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	<CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	<20131210203559.GA1209@redhat.com>
	<20131210204925.GB27373@redhat.com>
	<20131210213431.GA6342@redhat.com>
	<20131210214143.GG27373@redhat.com>
	<CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
	<CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
Date: Tue, 10 Dec 2013 14:33:16 -0800
X-Google-Sender-Auth: Cbh1SaTSqCKaSStdblbZjqwomA4
Message-ID: <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
Subject: Re: process 'stuck' at exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Content-Type: multipart/mixed; boundary=047d7b673c86e0748304ed35b268
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b673c86e0748304ed35b268
Content-Type: text/plain; charset=UTF-8

On Tue, Dec 10, 2013 at 2:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Shouldn't we do something like the attached?

So I think that kernel/futex.c part of the patch might be a good idea,
but on x86-64 (which is what Dave is running), the

        if (end >> __VIRTUAL_MASK_SHIFT)

test in get_user_pages_fast() should have been equivalent. And even on
32-bit, we do check the _PAGE_USER bits in the page tables, so I guess
it's all good on a get_user_pages_fast() side.

So never mind. It's not the address checking.

And I think I see what's up.

I think what happens is:
 - get_user_pages_fast(address, 1, 1, &page) fails (because it's read-only)
 - get_user_pages_fast(address, 1, 0, &page) succeeds and gets a large-page
 - __get_user_pages_fast(address, 1, 1, &page) fails (because it's read-only).

so what triggers this is likely that Dave now does large-pages, and
one of them is a read-only mapping.

So I would suggest replacing the second "1" in the
__get_user_pages_fast() call with a "!ro" instead. So how about this
second patch instead (the access_ok() move remains).

Comments?

                Linus

--047d7b673c86e0748304ed35b268
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hp1q6knz1

IGtlcm5lbC9mdXRleC5jIHwgNyArKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9mdXRleC5jIGIva2VybmVs
L2Z1dGV4LmMKaW5kZXggODBiYTA4NmYwMjFkLi42MjcyZjU2MDM4NWMgMTAwNjQ0Ci0tLSBhL2tl
cm5lbC9mdXRleC5jCisrKyBiL2tlcm5lbC9mdXRleC5jCkBAIC0yNTEsNiArMjUxLDkgQEAgZ2V0
X2Z1dGV4X2tleSh1MzIgX191c2VyICp1YWRkciwgaW50IGZzaGFyZWQsIHVuaW9uIGZ1dGV4X2tl
eSAqa2V5LCBpbnQgcncpCiAJCXJldHVybiAtRUlOVkFMOwogCWFkZHJlc3MgLT0ga2V5LT5ib3Ro
Lm9mZnNldDsKIAorCWlmICh1bmxpa2VseSghYWNjZXNzX29rKFZFUklGWV9XUklURSwgdWFkZHIs
IHNpemVvZih1MzIpKSkpCisJCXJldHVybiAtRUZBVUxUOworCiAJLyoKIAkgKiBQUk9DRVNTX1BS
SVZBVEUgZnV0ZXhlcyBhcmUgZmFzdC4KIAkgKiBBcyB0aGUgbW0gY2Fubm90IGRpc2FwcGVhciB1
bmRlciB1cyBhbmQgdGhlICdrZXknIG9ubHkgbmVlZHMKQEAgLTI1OSw4ICsyNjIsNiBAQCBnZXRf
ZnV0ZXhfa2V5KHUzMiBfX3VzZXIgKnVhZGRyLCBpbnQgZnNoYXJlZCwgdW5pb24gZnV0ZXhfa2V5
ICprZXksIGludCBydykKIAkgKiAgICAgICAgYnV0IGFjY2Vzc19vaygpIHNob3VsZCBiZSBmYXN0
ZXIgdGhhbiBmaW5kX3ZtYSgpCiAJICovCiAJaWYgKCFmc2hhcmVkKSB7Ci0JCWlmICh1bmxpa2Vs
eSghYWNjZXNzX29rKFZFUklGWV9XUklURSwgdWFkZHIsIHNpemVvZih1MzIpKSkpCi0JCQlyZXR1
cm4gLUVGQVVMVDsKIAkJa2V5LT5wcml2YXRlLm1tID0gbW07CiAJCWtleS0+cHJpdmF0ZS5hZGRy
ZXNzID0gYWRkcmVzczsKIAkJZ2V0X2Z1dGV4X2tleV9yZWZzKGtleSk7CkBAIC0yODgsNyArMjg5
LDcgQEAgYWdhaW46CiAJCXB1dF9wYWdlKHBhZ2UpOwogCQkvKiBzZXJpYWxpemUgYWdhaW5zdCBf
X3NwbGl0X2h1Z2VfcGFnZV9zcGxpdHRpbmcoKSAqLwogCQlsb2NhbF9pcnFfZGlzYWJsZSgpOwot
CQlpZiAobGlrZWx5KF9fZ2V0X3VzZXJfcGFnZXNfZmFzdChhZGRyZXNzLCAxLCAxLCAmcGFnZSkg
PT0gMSkpIHsKKwkJaWYgKGxpa2VseShfX2dldF91c2VyX3BhZ2VzX2Zhc3QoYWRkcmVzcywgMSwg
IXJvLCAmcGFnZSkgPT0gMSkpIHsKIAkJCXBhZ2VfaGVhZCA9IGNvbXBvdW5kX2hlYWQocGFnZSk7
CiAJCQkvKgogCQkJICogcGFnZV9oZWFkIGlzIHZhbGlkIHBvaW50ZXIgYnV0IHdlIG11c3QgcGlu
Cg==
--047d7b673c86e0748304ed35b268--
