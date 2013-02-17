Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3BQU6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 15:58:20 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:60081 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab3BQU6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 15:58:18 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz4vO-JGv+A7h=uxwfyWEMcK=Q3gntwHfr=a4OUVs-f+g@mail.gmail.com>
References: <20130212193901.GA18906@redhat.com>
	<alpine.LNX.2.00.1302121549500.890@eggly.anvils>
	<20130213004059.GA14451@redhat.com>
	<alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
	<20130213041629.GA28622@redhat.com>
	<alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
	<20130213193411.GA15928@redhat.com>
	<CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
	<20130215011503.GA11914@redhat.com>
	<CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
	<20130215174435.GA2792@linux.vnet.ibm.com>
	<CA+55aFy8FeGMOnWwkfmyFYyVCw+k1LSVg7BG0tsTNZzqi5EKYg@mail.gmail.com>
	<CAFTL4hyTfwAZWz=gMokk5oG3HO8iGh7=FtoNv89CMg_Lm-TPNg@mail.gmail.com>
	<CA+55aFz4vO-JGv+A7h=uxwfyWEMcK=Q3gntwHfr=a4OUVs-f+g@mail.gmail.com>
Date: Sun, 17 Feb 2013 21:58:16 +0100
Message-ID: <CAFTL4hx7iX8vZFu7pO5wLSPpEzfMD8K7n0bUsY-wK-uCsDAsEw@mail.gmail.com>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Content-Type: multipart/mixed; boundary=f46d04083d151e432a04d5f1dea2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04083d151e432a04d5f1dea2
Content-Type: text/plain; charset=ISO-8859-1

2013/2/17 Linus Torvalds <torvalds@linux-foundation.org>:
> On Sun, Feb 17, 2013 at 7:11 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>
>> preempt_value_in_interrupt() looks buggy in your patch: it makes
>> invoke_softirq() returning if (val & HARDIRQ_MASK). But that's always
>> true since you have moved further the sub_preempt_count(IRQ_EXIT)
>> further.
>
> No, that's not it. The value hasn't been written back yet, but it already did:
>
> +       int offset = IRQ_EXIT_OFFSET;
> +       int count = preempt_count() - offset;
>
> so the 'count' has the IRQ_EXIT_OFFSET already subtracted. So no,
> HARDIRQ_MASK is *not* always set.

Another thing. Perhaps we can push the idea of your patch a little
further by re-entering HARDIRQ_OFFSET at the end of the softirq
processing and do the final sub_preempt_count(HARDIRQ_OFFSET) at the
very end of irq_exit().

This way irq_exit() looks a bit more simple to me: everything there
becomes considered as in hardirq: (ie: rcu_irq_exit() and
tick_nohz_irq_exit() won't appear anymore as weird special cases) and
we get rid of that IRQ_EXIT_OFFSET hack that fixes the CONFIG_PREEMPT
case.

I'm attaching an untested patch that modify yours. It's probably
missing some corner cases that rely on in_interrupt() value in
rcu_irq_exit() and tick_nohz_irq_exit() and may be other things.

--f46d04083d151e432a04d5f1dea2
Content-Type: application/octet-stream; name="patch2.diff"
Content-Disposition: attachment; filename="patch2.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdaof0940

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvaGFyZGlycS5oIGIvaW5jbHVkZS9saW51eC9oYXJk
aXJxLmgKaW5kZXggNjI0ZWYzZi4uOWUzNjY4MCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9o
YXJkaXJxLmgKKysrIGIvaW5jbHVkZS9saW51eC9oYXJkaXJxLmgKQEAgLTEwNyw3ICsxMDcsOCBA
QAogICogdXNlZCBpbiB0aGUgZ2VuZXJhbCBjYXNlIHRvIGRldGVybWluZSB3aGV0aGVyIHNsZWVw
aW5nIGlzIHBvc3NpYmxlLgogICogRG8gbm90IHVzZSBpbl9hdG9taWMoKSBpbiBkcml2ZXIgY29k
ZS4KICAqLwotI2RlZmluZSBpbl9hdG9taWMoKQkoKHByZWVtcHRfY291bnQoKSAmIH5QUkVFTVBU
X0FDVElWRSkgIT0gMCkKKyNkZWZpbmUgcHJlZW1wdF9vZmZzZXRfaW5fYXRvbWljKG9mZnNldCkJ
KChvZmZzZXQgJiB+UFJFRU1QVF9BQ1RJVkUpICE9IDApCisjZGVmaW5lIGluX2F0b21pYygpCXBy
ZWVtcHRfb2Zmc2V0X2luX2F0b21pYyhwcmVlbXB0X2NvdW50KCkpCiAKIC8qCiAgKiBDaGVjayB3
aGV0aGVyIHdlIHdlcmUgYXRvbWljIGJlZm9yZSB3ZSBkaWQgcHJlZW1wdF9kaXNhYmxlKCk6CkBA
IC0xMTgsMTAgKzExOSw4IEBACiAKICNpZmRlZiBDT05GSUdfUFJFRU1QVF9DT1VOVAogIyBkZWZp
bmUgcHJlZW1wdGlibGUoKQkocHJlZW1wdF9jb3VudCgpID09IDAgJiYgIWlycXNfZGlzYWJsZWQo
KSkKLSMgZGVmaW5lIElSUV9FWElUX09GRlNFVCAoSEFSRElSUV9PRkZTRVQtMSkKICNlbHNlCiAj
IGRlZmluZSBwcmVlbXB0aWJsZSgpCTAKLSMgZGVmaW5lIElSUV9FWElUX09GRlNFVCBIQVJESVJR
X09GRlNFVAogI2VuZGlmCiAKICNpZiBkZWZpbmVkKENPTkZJR19TTVApIHx8IGRlZmluZWQoQ09O
RklHX0dFTkVSSUNfSEFSRElSUVMpCmRpZmYgLS1naXQgYS9rZXJuZWwvc29mdGlycS5jIGIva2Vy
bmVsL3NvZnRpcnEuYwppbmRleCBlZDU2N2JhLi5iMTRlNDBlIDEwMDY0NAotLS0gYS9rZXJuZWwv
c29mdGlycS5jCisrKyBiL2tlcm5lbC9zb2Z0aXJxLmMKQEAgLTMyMCwyMCArMzIwLDQ1IEBAIHZv
aWQgaXJxX2VudGVyKHZvaWQpCiAJX19pcnFfZW50ZXIoKTsKIH0KIAorLyoKKyAqIEludm9jZSBz
b2Z0aXJxJ3MgZnJvbSBpcnFfZXhpdCgpLgorICoKKyAqIFJldHVybiB0aGUgcHJlZW1wdCBvZmZz
ZXQ6IGVpdGhlciBJUlFfRVhJVF9PRkZTRVQgKGlmIHdlCisgKiBkaWQgbm90aGluZyB0byB0aGUg
cHJlZW1wdGlvbiBjb3VudCkgb3IgU09GVElSUV9PRkZTRVQgKGluCisgKiBjYXNlIHdlIGRpZCBz
b2Z0aXJxIHByb2Nlc3NpbmcgYW5kIGNoYW5nZWQgdGhlIHByZWVtcHRpb24KKyAqIGNvdW50IHRv
IGFjY291bnQgZm9yIHRoYXQpLgorICovCiBzdGF0aWMgaW5saW5lIHZvaWQgaW52b2tlX3NvZnRp
cnEodm9pZCkKIHsKLQlpZiAoIWZvcmNlX2lycXRocmVhZHMpIHsKKwkvKiBDYW4gd2UgcnVuIHNv
ZnRpcnEncyBhdCBhbGw/IFdlIG1pZ3RoIGJlIG5lc3RpbmcgaW50ZXJydXB0cyAqLworCWlmIChw
cmVlbXB0X29mZnNldF9pbl9pbnRlcnJ1cHQocHJlZW1wdF9jb3VudCgpIC0gSEFSRElSUV9PRkZT
RVQpKQorCQlyZXR1cm47CisKKwkvKiBBcmUgdGhlcmUgYW55IHBlbmRpbmc/ICovCisJaWYgKCFs
b2NhbF9zb2Z0aXJxX3BlbmRpbmcoKSkKKwkJcmV0dXJuOworCisJLyogRG8gd2UgZm9yY2UgaXJx
IHRocmVhZHM/IElmIHNvLCBqdXN0IHdha2UgdXAgdGhlIGRhZW1vbiAqLworCWlmIChmb3JjZV9p
cnF0aHJlYWRzKSB7CisJCXdha2V1cF9zb2Z0aXJxZCgpOworCQlyZXR1cm47CisJfQorCisJLyoK
KwkgKiBPaywgZG8gYWN0dWFsIHNvZnRpcnEgaGFuZGxpbmchCisJICoKKwkgKiBUaGlzIGRvd25n
cmFkZXMgdXMgZnJvbSBoYXJkaXJxIGNvbnRleHQgdG8gc29mdGlycSBjb250ZXh0LgorCSAqLwor
CXByZWVtcHRfY291bnQoKSArPSBTT0ZUSVJRX09GRlNFVCAtIEhBUkRJUlFfT0ZGU0VUOworCisJ
dHJhY2Vfc29mdGlycXNfb2ZmKF9fYnVpbHRpbl9yZXR1cm5fYWRkcmVzcygwKSk7CiAjaWZkZWYg
X19BUkNIX0lSUV9FWElUX0lSUVNfRElTQUJMRUQKLQkJX19kb19zb2Z0aXJxKCk7CisJX19kb19z
b2Z0aXJxKCk7CiAjZWxzZQotCQlkb19zb2Z0aXJxKCk7CisJZG9fc29mdGlycSgpOwogI2VuZGlm
Ci0JfSBlbHNlIHsKLQkJX19sb2NhbF9iaF9kaXNhYmxlKCh1bnNpZ25lZCBsb25nKV9fYnVpbHRp
bl9yZXR1cm5fYWRkcmVzcygwKSwKLQkJCQlTT0ZUSVJRX09GRlNFVCk7Ci0JCXdha2V1cF9zb2Z0
aXJxZCgpOwotCQlfX2xvY2FsX2JoX2VuYWJsZShTT0ZUSVJRX09GRlNFVCk7Ci0JfQorCXByZWVt
cHRfY291bnQoKSArPSBIQVJESVJRX09GRlNFVCAtIFNPRlRJUlFfT0ZGU0VUOworCXRyYWNlX3Nv
ZnRpcnFzX29uKCh1bnNpZ25lZCBsb25nKV9fYnVpbHRpbl9yZXR1cm5fYWRkcmVzcygwKSk7CiB9
CiAKIC8qCkBAIC0zNDMsMTcgKzM2OCwxOSBAQCB2b2lkIGlycV9leGl0KHZvaWQpCiB7CiAJdnRp
bWVfYWNjb3VudF9pcnFfZXhpdChjdXJyZW50KTsKIAl0cmFjZV9oYXJkaXJxX2V4aXQoKTsKLQlz
dWJfcHJlZW1wdF9jb3VudChJUlFfRVhJVF9PRkZTRVQpOwotCWlmICghaW5faW50ZXJydXB0KCkg
JiYgbG9jYWxfc29mdGlycV9wZW5kaW5nKCkpCi0JCWludm9rZV9zb2Z0aXJxKCk7CisJaW52b2tl
X3NvZnRpcnEoKTsKIAogI2lmZGVmIENPTkZJR19OT19IWgogCS8qIE1ha2Ugc3VyZSB0aGF0IHRp
bWVyIHdoZWVsIHVwZGF0ZXMgYXJlIHByb3BhZ2F0ZWQgKi8KLQlpZiAoaWRsZV9jcHUoc21wX3By
b2Nlc3Nvcl9pZCgpKSAmJiAhaW5faW50ZXJydXB0KCkgJiYgIW5lZWRfcmVzY2hlZCgpKQotCQl0
aWNrX25vaHpfaXJxX2V4aXQoKTsKKwlpZiAoaWRsZV9jcHUoc21wX3Byb2Nlc3Nvcl9pZCgpKSkg
eworCQlpbnQgb2Zmc2V0ID0gcHJlZW1wdF9jb3VudCgpIC0gSEFSRElSUV9PRkZTRVQ7CisKKwkJ
aWYgKCFwcmVlbXB0X29mZnNldF9pbl9pbnRlcnJ1cHQob2Zmc2V0KSAmJiAhbmVlZF9yZXNjaGVk
KCkpCisJCQl0aWNrX25vaHpfaXJxX2V4aXQoKTsKKwl9CiAjZW5kaWYKIAlyY3VfaXJxX2V4aXQo
KTsKLQlzY2hlZF9wcmVlbXB0X2VuYWJsZV9ub19yZXNjaGVkKCk7CisJc3ViX3ByZWVtcHRfY291
bnQoSEFSRElSUV9PRkZTRVQpOwogfQogCiAvKgo=
--f46d04083d151e432a04d5f1dea2--
