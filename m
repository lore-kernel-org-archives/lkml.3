Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbaLOSV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:21:59 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:50098 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaLOSV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:21:57 -0500
MIME-Version: 1.0
In-Reply-To: <20141215055707.GA26225@redhat.com>
References: <20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<20141214234654.GA396@redhat.com>
	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
	<CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
	<20141215055707.GA26225@redhat.com>
Date: Mon, 15 Dec 2014 10:21:56 -0800
X-Google-Sender-Auth: H3KIp3axAh55bG4zs16cC1vR7oU
Message-ID: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: multipart/mixed; boundary=001a11c13d364e5e5b050a45512b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c13d364e5e5b050a45512b
Content-Type: text/plain; charset=UTF-8

On Sun, Dec 14, 2014 at 9:57 PM, Dave Jones <davej@redhat.com> wrote:
>
> We had a flashback to that old bug last month too.
> See this mail & your followup. : https://lkml.org/lkml/2014/11/25/1171
> That was during a bisect though, so may have been something
> entirely different, but it is a spooky coincidence.

Yeah, there's something funny going on there.

Anyway, I've looked at the page fault patch, and I mentioned this last
time it came up: there's a nasty possible kernel loop in the "retry"
case if there's also a fatal signal pending, and we're returning to
kernel mode rather than returning to user mode.

If we return to user mode, the return will handle signals, and we'll
kill the process due to the fatal pending signal and everything is
fine.

But if we're returning to kernel mode, we'll just take the page fault
again. And again. And again. Until the condition that caused the retry
is finally cleared.

Now, normally finishing IO on the page or whatever should get things
done, but whatever. Us busy-looping on it in kernel space might end up
delaying that too forever.

So let's just fix it. Here's a completely untested patch. It looks
bigger than it really is: it moves the "up_read()" up a bit in
__do_page_fault(), so that all the logic is saner. This is "tested" in
the sense that I am running a kernel with this patch, but I could
easily have screwed up some fault handling case.

Anyway, at least CPU1 in your traces was actually going through that
__lock_page_or_retry() code that could trigger this, so...

                               Linus

--001a11c13d364e5e5b050a45512b
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i3q5ybw40

IGFyY2gveDg2L21tL2ZhdWx0LmMgfCA2NSArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKyks
IDM1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL2ZhdWx0LmMgYi9hcmNo
L3g4Ni9tbS9mYXVsdC5jCmluZGV4IGQ5NzNlNjFlNDUwZC4uYjM4YWRjMWNkMzlmIDEwMDY0NAot
LS0gYS9hcmNoL3g4Ni9tbS9mYXVsdC5jCisrKyBiL2FyY2gveDg2L21tL2ZhdWx0LmMKQEAgLTg0
NCwxMSArODQ0LDggQEAgZG9fc2lnYnVzKHN0cnVjdCBwdF9yZWdzICpyZWdzLCB1bnNpZ25lZCBs
b25nIGVycm9yX2NvZGUsIHVuc2lnbmVkIGxvbmcgYWRkcmVzcywKIAkgIHVuc2lnbmVkIGludCBm
YXVsdCkKIHsKIAlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzayA9IGN1cnJlbnQ7Ci0Jc3RydWN0IG1t
X3N0cnVjdCAqbW0gPSB0c2stPm1tOwogCWludCBjb2RlID0gQlVTX0FEUkVSUjsKIAotCXVwX3Jl
YWQoJm1tLT5tbWFwX3NlbSk7Ci0KIAkvKiBLZXJuZWwgbW9kZT8gSGFuZGxlIGV4Y2VwdGlvbnMg
b3IgZGllOiAqLwogCWlmICghKGVycm9yX2NvZGUgJiBQRl9VU0VSKSkgewogCQlub19jb250ZXh0
KHJlZ3MsIGVycm9yX2NvZGUsIGFkZHJlc3MsIFNJR0JVUywgQlVTX0FEUkVSUik7CkBAIC04Nzks
NyArODc2LDYgQEAgbW1fZmF1bHRfZXJyb3Ioc3RydWN0IHB0X3JlZ3MgKnJlZ3MsIHVuc2lnbmVk
IGxvbmcgZXJyb3JfY29kZSwKIAkgICAgICAgdW5zaWduZWQgbG9uZyBhZGRyZXNzLCB1bnNpZ25l
ZCBpbnQgZmF1bHQpCiB7CiAJaWYgKGZhdGFsX3NpZ25hbF9wZW5kaW5nKGN1cnJlbnQpICYmICEo
ZXJyb3JfY29kZSAmIFBGX1VTRVIpKSB7Ci0JCXVwX3JlYWQoJmN1cnJlbnQtPm1tLT5tbWFwX3Nl
bSk7CiAJCW5vX2NvbnRleHQocmVncywgZXJyb3JfY29kZSwgYWRkcmVzcywgMCwgMCk7CiAJCXJl
dHVybjsKIAl9CkBAIC04ODcsMTQgKzg4MywxMSBAQCBtbV9mYXVsdF9lcnJvcihzdHJ1Y3QgcHRf
cmVncyAqcmVncywgdW5zaWduZWQgbG9uZyBlcnJvcl9jb2RlLAogCWlmIChmYXVsdCAmIFZNX0ZB
VUxUX09PTSkgewogCQkvKiBLZXJuZWwgbW9kZT8gSGFuZGxlIGV4Y2VwdGlvbnMgb3IgZGllOiAq
LwogCQlpZiAoIShlcnJvcl9jb2RlICYgUEZfVVNFUikpIHsKLQkJCXVwX3JlYWQoJmN1cnJlbnQt
Pm1tLT5tbWFwX3NlbSk7CiAJCQlub19jb250ZXh0KHJlZ3MsIGVycm9yX2NvZGUsIGFkZHJlc3Ms
CiAJCQkJICAgU0lHU0VHViwgU0VHVl9NQVBFUlIpOwogCQkJcmV0dXJuOwogCQl9CiAKLQkJdXBf
cmVhZCgmY3VycmVudC0+bW0tPm1tYXBfc2VtKTsKLQogCQkvKgogCQkgKiBXZSByYW4gb3V0IG9m
IG1lbW9yeSwgY2FsbCB0aGUgT09NIGtpbGxlciwgYW5kIHJldHVybiB0aGUKIAkJICogdXNlcnNw
YWNlICh3aGljaCB3aWxsIHJldHJ5IHRoZSBmYXVsdCwgb3Iga2lsbCB1cyBpZiB3ZSBnb3QKQEAg
LTEwNjIsNyArMTA1NSw3IEBAIF9fZG9fcGFnZV9mYXVsdChzdHJ1Y3QgcHRfcmVncyAqcmVncywg
dW5zaWduZWQgbG9uZyBlcnJvcl9jb2RlLAogCXN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hOwog
CXN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrOwogCXN0cnVjdCBtbV9zdHJ1Y3QgKm1tOwotCWludCBm
YXVsdDsKKwlpbnQgZmF1bHQsIG1ham9yID0gMDsKIAl1bnNpZ25lZCBpbnQgZmxhZ3MgPSBGQVVM
VF9GTEFHX0FMTE9XX1JFVFJZIHwgRkFVTFRfRkxBR19LSUxMQUJMRTsKIAogCXRzayA9IGN1cnJl
bnQ7CkBAIC0xMjM3LDE0ICsxMjMwLDMxIEBAIGdvb2RfYXJlYToKIAkgKiB3ZSBnZXQgVk1fRkFV
TFRfUkVUUlkgYmFjaywgdGhlIG1tYXBfc2VtIGhhcyBiZWVuIHVubG9ja2VkLgogCSAqLwogCWZh
dWx0ID0gaGFuZGxlX21tX2ZhdWx0KG1tLCB2bWEsIGFkZHJlc3MsIGZsYWdzKTsKKwltYWpvciB8
PSBmYXVsdCAmIFZNX0ZBVUxUX01BSk9SOwogCiAJLyoKLQkgKiBJZiB3ZSBuZWVkIHRvIHJldHJ5
IGJ1dCBhIGZhdGFsIHNpZ25hbCBpcyBwZW5kaW5nLCBoYW5kbGUgdGhlCi0JICogc2lnbmFsIGZp
cnN0LiBXZSBkbyBub3QgbmVlZCB0byByZWxlYXNlIHRoZSBtbWFwX3NlbSBiZWNhdXNlIGl0Ci0J
ICogd291bGQgYWxyZWFkeSBiZSByZWxlYXNlZCBpbiBfX2xvY2tfcGFnZV9vcl9yZXRyeSBpbiBt
bS9maWxlbWFwLmMuCisJICogSWYgd2UgbmVlZCB0byByZXRyeSB0aGUgbW1hcF9zZW0gaGFzIGFs
cmVhZHkgYmVlbiByZWxlYXNlZCwKKwkgKiBhbmQgaWYgdGhlcmUgaXMgYSBmYXRhbCBzaWduYWwg
cGVuZGluZyB0aGVyZSBpcyBubyBndWFyYW50ZWUKKwkgKiB0aGF0IHdlIG1hZGUgYW55IHByb2dy
ZXNzLiBIYW5kbGUgdGhpcyBjYXNlIGZpcnN0LgogCSAqLwotCWlmICh1bmxpa2VseSgoZmF1bHQg
JiBWTV9GQVVMVF9SRVRSWSkgJiYgZmF0YWxfc2lnbmFsX3BlbmRpbmcoY3VycmVudCkpKQorCWlm
ICh1bmxpa2VseShmYXVsdCAmIFZNX0ZBVUxUX1JFVFJZKSkgeworCQlpZiAoKGZsYWdzICYgRkFV
TFRfRkxBR19BTExPV19SRVRSWSkgJiYgIWZhdGFsX3NpZ25hbF9wZW5kaW5nKGN1cnJlbnQpKSB7
CisJCQkvKiBDbGVhciBGQVVMVF9GTEFHX0FMTE9XX1JFVFJZIHRvIGF2b2lkIGFueSByaXNrCisJ
CQkgKiBvZiBzdGFydmF0aW9uLiAqLworCQkJZmxhZ3MgJj0gfkZBVUxUX0ZMQUdfQUxMT1dfUkVU
Ulk7CisJCQlmbGFncyB8PSBGQVVMVF9GTEFHX1RSSUVEOworCQkJZ290byByZXRyeTsKKwkJfQor
CisJCS8qIE5vdCByZXR1cm5pbmcgdG8gdXNlciBtb2RlPyBIYW5kbGUgZXhjZXB0aW9ucyBvciBk
aWU6ICovCisJCWlmICghKGZhdWx0ICYgRkFVTFRfRkxBR19VU0VSKSkKKwkJCW5vX2NvbnRleHQo
cmVncywgZXJyb3JfY29kZSwgYWRkcmVzcywgU0lHQlVTLCBCVVNfQURSRVJSKTsKKworCQkvKiBV
c2VyIG1vZGU/IEp1c3QgcmV0dXJuIHRvIGhhbmRsZSB0aGUgZmF0YWwgZXhjZXB0aW9uICovCiAJ
CXJldHVybjsKKwl9CisKKwl1cF9yZWFkKCZtbS0+bW1hcF9zZW0pOwogCiAJaWYgKHVubGlrZWx5
KGZhdWx0ICYgVk1fRkFVTFRfRVJST1IpKSB7CiAJCW1tX2ZhdWx0X2Vycm9yKHJlZ3MsIGVycm9y
X2NvZGUsIGFkZHJlc3MsIGZhdWx0KTsKQEAgLTEyNTIsMzIgKzEyNjIsMTcgQEAgZ29vZF9hcmVh
OgogCX0KIAogCS8qCi0JICogTWFqb3IvbWlub3IgcGFnZSBmYXVsdCBhY2NvdW50aW5nIGlzIG9u
bHkgZG9uZSBvbiB0aGUKLQkgKiBpbml0aWFsIGF0dGVtcHQuIElmIHdlIGdvIHRocm91Z2ggYSBy
ZXRyeSwgaXQgaXMgZXh0cmVtZWx5Ci0JICogbGlrZWx5IHRoYXQgdGhlIHBhZ2Ugd2lsbCBiZSBm
b3VuZCBpbiBwYWdlIGNhY2hlIGF0IHRoYXQgcG9pbnQuCisJICogTWFqb3IvbWlub3IgcGFnZSBm
YXVsdCBhY2NvdW50aW5nLiBJZiBhbnkgb2YgdGhlIGV2ZW50cworCSAqIHJldHVybmVkIFZNX0ZB
VUxUX01BSk9SLCB3ZSBhY2NvdW50IGl0IGFzIGEgbWFqb3IgZmF1bHQuCiAJICovCi0JaWYgKGZs
YWdzICYgRkFVTFRfRkxBR19BTExPV19SRVRSWSkgewotCQlpZiAoZmF1bHQgJiBWTV9GQVVMVF9N
QUpPUikgewotCQkJdHNrLT5tYWpfZmx0Kys7Ci0JCQlwZXJmX3N3X2V2ZW50KFBFUkZfQ09VTlRf
U1dfUEFHRV9GQVVMVFNfTUFKLCAxLAotCQkJCSAgICAgIHJlZ3MsIGFkZHJlc3MpOwotCQl9IGVs
c2UgewotCQkJdHNrLT5taW5fZmx0Kys7Ci0JCQlwZXJmX3N3X2V2ZW50KFBFUkZfQ09VTlRfU1df
UEFHRV9GQVVMVFNfTUlOLCAxLAotCQkJCSAgICAgIHJlZ3MsIGFkZHJlc3MpOwotCQl9Ci0JCWlm
IChmYXVsdCAmIFZNX0ZBVUxUX1JFVFJZKSB7Ci0JCQkvKiBDbGVhciBGQVVMVF9GTEFHX0FMTE9X
X1JFVFJZIHRvIGF2b2lkIGFueSByaXNrCi0JCQkgKiBvZiBzdGFydmF0aW9uLiAqLwotCQkJZmxh
Z3MgJj0gfkZBVUxUX0ZMQUdfQUxMT1dfUkVUUlk7Ci0JCQlmbGFncyB8PSBGQVVMVF9GTEFHX1RS
SUVEOwotCQkJZ290byByZXRyeTsKLQkJfQorCWlmIChtYWpvcikgeworCQl0c2stPm1hal9mbHQr
KzsKKwkJcGVyZl9zd19ldmVudChQRVJGX0NPVU5UX1NXX1BBR0VfRkFVTFRTX01BSiwgMSwgcmVn
cywgYWRkcmVzcyk7CisJfSBlbHNlIHsKKwkJdHNrLT5taW5fZmx0Kys7CisJCXBlcmZfc3dfZXZl
bnQoUEVSRl9DT1VOVF9TV19QQUdFX0ZBVUxUU19NSU4sIDEsIHJlZ3MsIGFkZHJlc3MpOwogCX0K
LQogCWNoZWNrX3Y4MDg2X21vZGUocmVncywgYWRkcmVzcywgdHNrKTsKLQotCXVwX3JlYWQoJm1t
LT5tbWFwX3NlbSk7CiB9CiBOT0tQUk9CRV9TWU1CT0woX19kb19wYWdlX2ZhdWx0KTsKIAo=
--001a11c13d364e5e5b050a45512b--
