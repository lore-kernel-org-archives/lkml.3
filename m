Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaCTQlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:41:35 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:60039 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaCTQld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:41:33 -0400
MIME-Version: 1.0
In-Reply-To: <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	<20140319154705.GB8557@laptop.programming.kicks-ass.net>
	<20140319170829.GD8557@laptop.programming.kicks-ass.net>
	<20140320053350.GB30295@linux.vnet.ibm.com>
	<1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 20 Mar 2014 09:41:31 -0700
X-Google-Sender-Auth: eYHkzonZ8YNXCm-eLKNWluY1uj4
Message-ID: <CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: multipart/mixed; boundary=047d7b6d83c012a47004f50c7104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6d83c012a47004f50c7104
Content-Type: text/plain; charset=UTF-8

On Wed, Mar 19, 2014 at 10:56 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> This problem suggests that we missed a wakeup for a task that was adding
> itself to the queue in a wait path. And the only place that can happen
> is with the hb spinlock check for any pending waiters.

Ok, so thinking about hb_waiters_pending():

 - spin_is_locked() test
 - read barrier
 - plist_head_empty() test

seems to be broken after all.

The race is against futex_wait() that does

 - futex_wait_setup():
   - queue_lock()
   - get_futex_value_locked()
 - futex_wait_queue_me()
   - queue_me()
     - plist_add()

right?

It strikes me that the "spin_is_locked()" test has no barriers wrt the
writing of the new futex value on the wake path. And the read barrier
obviously does nothing wrt the write either. Or am I missing
something? So the write that actually released the futex might be
almost arbitrarily delayed on the waking side. So the waiting side may
not see the new value, even though the waker assumes it does due to
the ordering of it doing the write first.

So maybe we need a memory barrier in hb_waiters_pending() just to make
sure that the new value is written.

But at that point, I suspect that Davidlohrs original patch that just
had explicit waiting counts is just as well. The whole point with the
head empty test was to emulate that "do we have waiters" without
having to actually add the atomics, but a memory barrier is really no
worse.

The attached is a TOTALLY UNTESTED interdiff that adds back Davidlohrs
atomic count. It may be terminally broken, I literally didn't test it
at all.

Davidlohr, mind checking and correcting this?

                     Linus

--047d7b6d83c012a47004f50c7104
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ht09ng6x0

IGtlcm5lbC9mdXRleC5jIHwgNTMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0MyBpbnNlcnRpb25zKCspLCAxMCBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvZnV0ZXguYyBiL2tlcm5lbC9mdXRleC5j
CmluZGV4IDQ0YTEyNjFjYjlmZi4uMDhlYzgxNGFkOWQyIDEwMDY0NAotLS0gYS9rZXJuZWwvZnV0
ZXguYworKysgYi9rZXJuZWwvZnV0ZXguYwpAQCAtMjM0LDYgKzIzNCw3IEBAIHN0YXRpYyBjb25z
dCBzdHJ1Y3QgZnV0ZXhfcSBmdXRleF9xX2luaXQgPSB7CiAgKiB3YWl0aW5nIG9uIGEgZnV0ZXgu
CiAgKi8KIHN0cnVjdCBmdXRleF9oYXNoX2J1Y2tldCB7CisJYXRvbWljX3Qgd2FpdGVyczsKIAlz
cGlubG9ja190IGxvY2s7CiAJc3RydWN0IHBsaXN0X2hlYWQgY2hhaW47CiB9IF9fX19jYWNoZWxp
bmVfYWxpZ25lZF9pbl9zbXA7CkBAIC0yNTMsMjIgKzI1NCwzNyBAQCBzdGF0aWMgaW5saW5lIHZv
aWQgZnV0ZXhfZ2V0X21tKHVuaW9uIGZ1dGV4X2tleSAqa2V5KQogCXNtcF9tYl9fYWZ0ZXJfYXRv
bWljX2luYygpOwogfQogCi1zdGF0aWMgaW5saW5lIGJvb2wgaGJfd2FpdGVyc19wZW5kaW5nKHN0
cnVjdCBmdXRleF9oYXNoX2J1Y2tldCAqaGIpCisvKgorICogUmVmbGVjdHMgYSBuZXcgd2FpdGVy
IGJlaW5nIGFkZGVkIHRvIHRoZSB3YWl0cXVldWUuCisgKi8KK3N0YXRpYyBpbmxpbmUgdm9pZCBo
Yl93YWl0ZXJzX2luYyhzdHJ1Y3QgZnV0ZXhfaGFzaF9idWNrZXQgKmhiKQogewogI2lmZGVmIENP
TkZJR19TTVAKKwlhdG9taWNfaW5jKCZoYi0+d2FpdGVycyk7CiAJLyoKLQkgKiBUYXNrcyB0cnlp
bmcgdG8gZW50ZXIgdGhlIGNyaXRpY2FsIHJlZ2lvbiBhcmUgbW9zdCBsaWtlbHkKLQkgKiBwb3Rl
bnRpYWwgd2FpdGVycyB0aGF0IHdpbGwgYmUgYWRkZWQgdG8gdGhlIHBsaXN0LiBFbnN1cmUKLQkg
KiB0aGF0IHdha2VycyB3b24ndCBtaXNzIHRvLWJlLXNsZXB0IHRhc2tzIGluIHRoZSB3aW5kb3cg
YmV0d2VlbgotCSAqIHRoZSB3YWl0IGNhbGwgYW5kIHRoZSBhY3R1YWwgcGxpc3RfYWRkLgorCSAq
IEZ1bGwgYmFycmllciAoQSksIHNlZSB0aGUgb3JkZXJpbmcgY29tbWVudCBhYm92ZS4KIAkgKi8K
LQlpZiAoc3Bpbl9pc19sb2NrZWQoJmhiLT5sb2NrKSkKLQkJcmV0dXJuIHRydWU7Ci0Jc21wX3Jt
YigpOyAvKiBNYWtlIHN1cmUgd2UgY2hlY2sgdGhlIGxvY2sgc3RhdGUgZmlyc3QgKi8KKwlzbXBf
bWJfX2FmdGVyX2F0b21pY19pbmMoKTsKKyNlbmRpZgorfQorCisvKgorICogUmVmbGVjdHMgYSB3
YWl0ZXIgYmVpbmcgcmVtb3ZlZCBmcm9tIHRoZSB3YWl0cXVldWUgYnkgd2FrZXVwCisgKiBwYXRo
cy4KKyAqLworc3RhdGljIGlubGluZSB2b2lkIGhiX3dhaXRlcnNfZGVjKHN0cnVjdCBmdXRleF9o
YXNoX2J1Y2tldCAqaGIpCit7CisjaWZkZWYgQ09ORklHX1NNUAorCWF0b21pY19kZWMoJmhiLT53
YWl0ZXJzKTsKKyNlbmRpZgorfQogCi0JcmV0dXJuICFwbGlzdF9oZWFkX2VtcHR5KCZoYi0+Y2hh
aW4pOworc3RhdGljIGlubGluZSBpbnQgaGJfd2FpdGVyc19wZW5kaW5nKHN0cnVjdCBmdXRleF9o
YXNoX2J1Y2tldCAqaGIpCit7CisjaWZkZWYgQ09ORklHX1NNUAorCXJldHVybiBhdG9taWNfcmVh
ZCgmaGItPndhaXRlcnMpOwogI2Vsc2UKLQlyZXR1cm4gdHJ1ZTsKKwlyZXR1cm4gMTsKICNlbmRp
ZgogfQogCkBAIC05NTQsNiArOTcwLDcgQEAgc3RhdGljIHZvaWQgX191bnF1ZXVlX2Z1dGV4KHN0
cnVjdCBmdXRleF9xICpxKQogCiAJaGIgPSBjb250YWluZXJfb2YocS0+bG9ja19wdHIsIHN0cnVj
dCBmdXRleF9oYXNoX2J1Y2tldCwgbG9jayk7CiAJcGxpc3RfZGVsKCZxLT5saXN0LCAmaGItPmNo
YWluKTsKKwloYl93YWl0ZXJzX2RlYyhoYik7CiB9CiAKIC8qCkBAIC0xMjU3LDcgKzEyNzQsOSBA
QCB2b2lkIHJlcXVldWVfZnV0ZXgoc3RydWN0IGZ1dGV4X3EgKnEsIHN0cnVjdCBmdXRleF9oYXNo
X2J1Y2tldCAqaGIxLAogCSAqLwogCWlmIChsaWtlbHkoJmhiMS0+Y2hhaW4gIT0gJmhiMi0+Y2hh
aW4pKSB7CiAJCXBsaXN0X2RlbCgmcS0+bGlzdCwgJmhiMS0+Y2hhaW4pOworCQloYl93YWl0ZXJz
X2RlYyhoYjEpOwogCQlwbGlzdF9hZGQoJnEtPmxpc3QsICZoYjItPmNoYWluKTsKKwkJaGJfd2Fp
dGVyc19pbmMoaGIyKTsKIAkJcS0+bG9ja19wdHIgPSAmaGIyLT5sb2NrOwogCX0KIAlnZXRfZnV0
ZXhfa2V5X3JlZnMoa2V5Mik7CkBAIC0xNjAwLDYgKzE2MTksMTcgQEAgc3RhdGljIGlubGluZSBz
dHJ1Y3QgZnV0ZXhfaGFzaF9idWNrZXQgKnF1ZXVlX2xvY2soc3RydWN0IGZ1dGV4X3EgKnEpCiAJ
c3RydWN0IGZ1dGV4X2hhc2hfYnVja2V0ICpoYjsKIAogCWhiID0gaGFzaF9mdXRleCgmcS0+a2V5
KTsKKworCS8qCisJICogSW5jcmVtZW50IHRoZSBjb3VudGVyIGJlZm9yZSB0YWtpbmcgdGhlIGxv
Y2sgc28gdGhhdAorCSAqIGEgcG90ZW50aWFsIHdha2VyIHdvbid0IG1pc3MgYSB0by1iZS1zbGVw
dCB0YXNrIHRoYXQgaXMKKwkgKiB3YWl0aW5nIGZvciB0aGUgc3BpbmxvY2suIFRoaXMgaXMgc2Fm
ZSBhcyBhbGwgcXVldWVfbG9jaygpCisJICogdXNlcnMgZW5kIHVwIGNhbGxpbmcgcXVldWVfbWUo
KS4gU2ltaWxhcmx5LCBmb3IgaG91c2VrZWVwaW5nLAorCSAqIGRlY3JlbWVudCB0aGUgY291bnRl
ciBhdCBxdWV1ZV91bmxvY2soKSB3aGVuIHNvbWUgZXJyb3IgaGFzCisJICogb2NjdXJyZWQgYW5k
IHdlIGRvbid0IGVuZCB1cCBhZGRpbmcgdGhlIHRhc2sgdG8gdGhlIGxpc3QuCisJICovCisJaGJf
d2FpdGVyc19pbmMoaGIpOworCiAJcS0+bG9ja19wdHIgPSAmaGItPmxvY2s7CiAKIAlzcGluX2xv
Y2soJmhiLT5sb2NrKTsgLyogaW1wbGllcyBNQiAoQSkgKi8KQEAgLTE2MTEsNiArMTY0MSw3IEBA
IHF1ZXVlX3VubG9jayhzdHJ1Y3QgZnV0ZXhfaGFzaF9idWNrZXQgKmhiKQogCV9fcmVsZWFzZXMo
JmhiLT5sb2NrKQogewogCXNwaW5fdW5sb2NrKCZoYi0+bG9jayk7CisJaGJfd2FpdGVyc19kZWMo
aGIpOwogfQogCiAvKioKQEAgLTIzNDIsNiArMjM3Myw3IEBAIGludCBoYW5kbGVfZWFybHlfcmVx
dWV1ZV9waV93YWtldXAoc3RydWN0IGZ1dGV4X2hhc2hfYnVja2V0ICpoYiwKIAkJICogVW5xdWV1
ZSB0aGUgZnV0ZXhfcSBhbmQgZGV0ZXJtaW5lIHdoaWNoIGl0IHdhcy4KIAkJICovCiAJCXBsaXN0
X2RlbCgmcS0+bGlzdCwgJmhiLT5jaGFpbik7CisJCWhiX3dhaXRlcnNfZGVjKGhiKTsKIAogCQkv
KiBIYW5kbGUgc3B1cmlvdXMgd2FrZXVwcyBncmFjZWZ1bGx5ICovCiAJCXJldCA9IC1FV09VTERC
TE9DSzsKQEAgLTI4NzUsNiArMjkwNyw3IEBAIHN0YXRpYyBpbnQgX19pbml0IGZ1dGV4X2luaXQo
dm9pZCkKIAkJZnV0ZXhfY21weGNoZ19lbmFibGVkID0gMTsKIAogCWZvciAoaSA9IDA7IGkgPCBm
dXRleF9oYXNoc2l6ZTsgaSsrKSB7CisJCWF0b21pY19zZXQoJmZ1dGV4X3F1ZXVlc1tpXS53YWl0
ZXJzLCAwKTsKIAkJcGxpc3RfaGVhZF9pbml0KCZmdXRleF9xdWV1ZXNbaV0uY2hhaW4pOwogCQlz
cGluX2xvY2tfaW5pdCgmZnV0ZXhfcXVldWVzW2ldLmxvY2spOwogCX0K
--047d7b6d83c012a47004f50c7104--
