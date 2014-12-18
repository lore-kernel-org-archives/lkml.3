Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaLRVSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:18:09 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58211 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaLRVSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:18:05 -0500
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <54934487.3010608@mit.edu>
Date: Thu, 18 Dec 2014 13:17:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: save_xstate_sig (Re: frequent lockups in 3.18rc4)
References: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>	<1417806247.4845.1@mail.thefacebook.com>	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>	<20141211145408.GB16800@redhat.com>	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>	<20141212185454.GB4716@redhat.com>	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>	<20141213165915.GA12756@redhat.com>	<20141213223616.GA22559@redhat.com>	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>	<20141214234654.GA396@redhat.com>	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com> <CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
In-Reply-To: <CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080207040006070008050907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080207040006070008050907
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/14/2014 09:47 PM, Linus Torvalds wrote:
> On Sun, Dec 14, 2014 at 4:38 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Can anybody make sense of that backtrace, keeping in mind that we're
>> looking for some kind of endless loop where we don't make progress?
>
> So looking at all the backtraces, which is kind of messy because
> there's some missing data (presumably buffers overflowed from all the
> CPU's printing at the same time), it looks  like:
>
>   - CPU 0 is missing. No idea why.
>   - CPU's 1-3 all have the same trace for
>
>      int_signal ->
>      do_notify_resume ->
>      do_signal ->
>        ....
>      page_fault ->
>      do_page_fault
>
> and "save_xstate_sig+0x81" shows up on all stacks, although only on
> CPU1 does it show up as a "guaranteed" part of the stack chain (ie it
> matches frame pointer data too). CPU1 also has that __clear_user show
> up (which is called from save_xstate_sig), but not other CPU's.  CPU2
> and CPU3 have "save_xstate_sig+0x98" in addition to that +0x81 thing.
>
> My guess is that "save_xstate_sig+0x81" is the instruction after the
> __clear_user call, and that CPU1 took the fault in __clear_user(),
> while CPU2 and CPU3 took the fault at "save_xstate_sig+0x98" instead,
> which I'd guess is the
>
>          xsave64 (%rdi)

I admit that my understanding of the disaster that is x86's FPU handling 
is limited, but I'm moderately confident that save_xstate_sig is broken.

The code is:

	if (user_has_fpu()) {
		/* Save the live register state to the user directly. */
		if (save_user_xstate(buf_fx))
			return -1;
		/* Update the thread's fxstate to save the fsave header. */
		if (ia32_fxstate)
			fpu_fxsave(&tsk->thread.fpu);
	} else {
		sanitize_i387_state(tsk);
		if (__copy_to_user(buf_fx, xsave, xstate_size))
			return -1;
	}

Suppose that user_has_fpu() returns true, we call save_user_xstate, and 
the xsave instruction (or anything else in there, for that matter) 
causes a page fault.

The page fault handler is well within its rights to schedule.  At that 
point, *we might not own the FPU any more*, depending on the vagaries of 
eager vs lazy mode.  So, when we schedule back in and resume from the 
page fault, we are in the wrong branch of the if statement.

At this point, we're going to write garbage (possibly sensitive garbage) 
to the userspace signal frame.  I don't see why this would cause an 
infinite loop, but I don't think it's healthy.

FWIW, if xsave traps with cr2 value, then there would indeed be an 
infinite loop in here.  It seems to work right on my machine.  Dave, 
want to run the attached little test?

--Andy

--------------080207040006070008050907
Content-Type: text/plain; charset=UTF-8;
 name="xsave_cr2.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="xsave_cr2.c"

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8ZXJyLmg+CiNpbmNsdWRlIDxzdGRpby5o
PgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN5
cy9tbWFuLmg+CiNpbmNsdWRlIDxzeXMvdWNvbnRleHQuaD4KCnN0YXRpYyB2b2xhdGlsZSB1
bnNpZ25lZCBjaGFyICpidWYsICp4c2F2ZV9hZGRyOwpzdGF0aWMgdm9sYXRpbGUgaW50IG5m
YWlsdXJlcyA9IDA7CgpzdGF0aWMgdm9pZCBzZXRoYW5kbGVyKGludCBzaWcsIHZvaWQgKCpo
YW5kbGVyKShpbnQsIHNpZ2luZm9fdCAqLCB2b2lkICopLAoJCSAgICAgICBpbnQgZmxhZ3Mp
CnsKCXN0cnVjdCBzaWdhY3Rpb24gc2E7CgltZW1zZXQoJnNhLCAwLCBzaXplb2Yoc2EpKTsK
CXNhLnNhX3NpZ2FjdGlvbiA9IGhhbmRsZXI7CglzYS5zYV9mbGFncyA9IFNBX1NJR0lORk8g
fCBmbGFnczsKCXNpZ2VtcHR5c2V0KCZzYS5zYV9tYXNrKTsKCWlmIChzaWdhY3Rpb24oc2ln
LCAmc2EsIDApKQoJCWVycigxLCAic2lnYWN0aW9uIik7Cn0KCnN0YXRpYyB2b2lkIGNsZWFy
aGFuZGxlcihpbnQgc2lnKQp7CglzdHJ1Y3Qgc2lnYWN0aW9uIHNhOwoJbWVtc2V0KCZzYSwg
MCwgc2l6ZW9mKHNhKSk7CglzYS5zYV9oYW5kbGVyID0gU0lHX0RGTDsKCXNpZ2VtcHR5c2V0
KCZzYS5zYV9tYXNrKTsKCWlmIChzaWdhY3Rpb24oc2lnLCAmc2EsIDApKQoJCWVycigxLCAi
c2lnYWN0aW9uIik7Cn0KCnN0YXRpYyB2b2lkIHNpZ3NlZ3YoaW50IHNpZywgc2lnaW5mb190
ICpzaSwgdm9pZCAqY3R4X3ZvaWQpCnsKCXVjb250ZXh0X3QgKmN0eCA9ICh1Y29udGV4dF90
KiljdHhfdm9pZDsKCgl1bnNpZ25lZCBsb25nIGNyMiA9ICh1bnNpZ25lZCBsb25nKWN0eC0+
dWNfbWNvbnRleHQuZ3JlZ3NbUkVHX0NSMl07Cgl1bnNpZ25lZCBsb25nIHN0YXJ0ID0gKHVu
c2lnbmVkIGxvbmcpYnVmOwoKCWV4dGVybiB1bnNpZ25lZCBjaGFyIHhzYXZlX2luc25bXSwg
YWZ0ZXJfeHNhdmVfaW5zbltdOwoJCglpZiAoY3R4LT51Y19tY29udGV4dC5ncmVnc1tSRUdf
UklQXSAhPSAodW5zaWduZWQgbG9uZyl4c2F2ZV9pbnNuKSB7CgkJcHJpbnRmKCJVbmNvcnJl
Y3RhYmxlIHNlZ2ZhdWx0XG4iKTsKCQljbGVhcmhhbmRsZXIoU0lHU0VHVik7CgkJcmV0dXJu
OwoJfQoKCWlmIChzaS0+c2lfY29kZSAhPSBTRUdWX0FDQ0VSUikgewoJCXByaW50ZigiU2Vn
ZmF1bHQgd2FzICVkICh0cmFwICVkKSwgbm90IFNFR1ZfQUNDRVJSXG4iLAoJCSAgICAgICBz
aS0+c2lfY29kZSwgY3R4LT51Y19tY29udGV4dC5ncmVnc1tSRUdfVFJBUE5PXSk7CgkJY2xl
YXJoYW5kbGVyKFNJR1NFR1YpOwoJCXJldHVybjsKCX0KCglpZiAoY3IyICE9ICh1bnNpZ25l
ZCBsb25nKXNpLT5zaV9hZGRyKSB7CgkJcHJpbnRmKCJDUjIgKDB4JWx4KSAhPSBzaV9hZGRy
ICgweCVseClcbiIsCgkJICAgICAgIGNyMiwgKHVuc2lnbmVkIGxvbmcpc2ktPnNpX2FkZHIp
OwoJCWNsZWFyaGFuZGxlcihTSUdTRUdWKTsKCQlyZXR1cm47Cgl9CgoJaWYgKGNyMiA+PSBz
dGFydCAmJiBjcjIgPD0gKHN0YXJ0ICsgNDA5NSkpIHsKCQlwcmludGYoIltPS11cdHhzYXZl
IG9mZnNldCA9ICVkLCBjcjIgb2Zmc2V0ID0gJWRcbiIsCgkJICAgICAgIChpbnQpKHhzYXZl
X2FkZHIgLSBidWYpLCAoaW50KShjcjIgLSBzdGFydCkpOwoJfSBlbHNlIGlmIChjcjIgPj0g
c3RhcnQgKyA0MDk2ICYmIGNyMiA8PSBzdGFydCArIDgxOTEpIHsKCQlwcmludGYoIltGQUlM
XVx0eHNhdmUgb2Zmc2V0ID0gJWQsIGNyMiBvZmZzZXQgPSAlZFxuIiwKCQkgICAgICAgKGlu
dCkoeHNhdmVfYWRkciAtIGJ1ZiksIChpbnQpKGNyMiAtIHN0YXJ0KSk7CgoJCW5mYWlsdXJl
cysrOwoJfSBlbHNlIGlmIChjcjIgPj0gc3RhcnQgKyA4MTkyICYmIGNyMiA8PSBzdGFydCAr
IDEyMjg3KSB7CgkJcHJpbnRmKCJbT0tdXHR4c2F2ZSBvZmZzZXQgPSAlZCwgY3IyIG9mZnNl
dCA9ICVkXG4iLAoJCSAgICAgICAoaW50KSh4c2F2ZV9hZGRyIC0gYnVmKSwgKGludCkoY3Iy
IC0gc3RhcnQpKTsKCX0gZWxzZSB7CgkJcHJpbnRmKCJbRkFJTF1cdGNyMiBpcyBjb21wbGV0
ZWx5IG91dCBvZiByYW5nZVxuIik7CgkJYWJvcnQoKTsKCX0KCgljdHgtPnVjX21jb250ZXh0
LmdyZWdzW1JFR19SSVBdID0gKHVuc2lnbmVkIGxvbmcpYWZ0ZXJfeHNhdmVfaW5zbjsKfQoK
aW50IG1haW4oKQp7CglpbnQgaTsKCglidWYgPSBtbWFwKE5VTEwsIDQwOTYqMywgUFJPVF9O
T05FLAoJCSAgIE1BUF9QUklWQVRFIHwgTUFQX0FOT05ZTU9VUyB8IE1BUF9OT1JFU0VSVkUs
IC0xLCAwKTsKCWlmIChidWYgPT0gTUFQX0ZBSUxFRCkKCQllcnIoMSwgIm1tYXAiKTsKCglp
ZiAobW1hcCgodW5zaWduZWQgY2hhciAqKWJ1ZiArIDQwOTYsIDQwOTYsIFBST1RfUkVBRCB8
IFBST1RfV1JJVEUsCgkJIE1BUF9QUklWQVRFIHwgTUFQX0FOT05ZTU9VUyB8IE1BUF9GSVhF
RCwgLTEsIDApID09IE1BUF9GQUlMRUQpCgkJZXJyKDEsICJtbWFwIik7CgoJc2V0aGFuZGxl
cihTSUdTRUdWLCBzaWdzZWd2LCAwKTsKCglmb3IgKGkgPSAwOyBpIDwgODE5MzsgaSArPSA2
NCkgewoJCXhzYXZlX2FkZHIgPSBidWYgKyBpOwoJCXByaW50ZigiWFNBVkUgdG8gb2Zmc2V0
ICVkXG4iLCBpKTsKCQlhc20gdm9sYXRpbGUgKCJ4c2F2ZV9pbnNuOiB4c2F2ZXEgJTAgOyBh
ZnRlcl94c2F2ZV9pbnNuOiIKCQkJICAgICAgOiAiPW0iICgqeHNhdmVfYWRkcikKCQkJICAg
ICAgOiAiYSIgKDB4ZmZmZmZmZmYpLCAiZCIgKDB4ZmZmZmZmZmYpKTsKCX0KCglpZiAobmZh
aWx1cmVzKQoJCXByaW50ZigiJWQgZmFpbHVyZXNcbiIsIG5mYWlsdXJlcyk7CgllbHNlCgkJ
cHJpbnRmKCJQQVNTIVxuIik7CgoJcmV0dXJuIDA7Cn0K
--------------080207040006070008050907--
