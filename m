Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbaLVTrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:47:42 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:54046 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbaLVTrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:47:40 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com>
References: <20141219145528.GC13404@redhat.com>
	<CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
	<alpine.DEB.2.11.1412192201520.17382@nanos>
	<CA+55aFx4zjAVHN5DrSCh1_MJjqf4fxoAVT3RmC+1QGP6bq7b0Q@mail.gmail.com>
	<alpine.DEB.2.11.1412200100130.17382@nanos>
	<CA+55aFxY5hCuGaK0JvTwHFsQKFGeh3_82ukKrU9ss4x4uHMY3Q@mail.gmail.com>
	<CA+55aFzj_2tYJ1b=_7eKSz7UMuUL+qZX39r0xq5vOZkB4JmHMA@mail.gmail.com>
	<CA+55aFyQzpQgT91sqpEhXho8KoVRkA1MeRjk+fXO7w2dJkY_Gg@mail.gmail.com>
	<CA+55aFy8DCMmkPRz0kqNC80pn4VkeQr2Wz2fTRm=32oH2dhfRQ@mail.gmail.com>
	<CA+55aFwA7uOFgb-Y4dHS099HuoV+oQvxXf+cfZYh9T7H_c0PHA@mail.gmail.com>
	<20141221223204.GA9618@codemonkey.org.uk>
	<CA+55aFygv+PRcYScwCjGVQ7-0PA1mHOGYaKGKS4LBhxPm0YBJA@mail.gmail.com>
	<CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com>
Date: Mon, 22 Dec 2014 11:47:37 -0800
X-Google-Sender-Auth: -U7nwG09KO8TM-XMM3ruLs1LZOU
Message-ID: <CA+55aFz0n=sJgn5LeBLcTzj9=eCVkrWiQZNCKupuD7CMTwm=jQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@codemonkey.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: multipart/mixed; boundary=001a11c3c7ecbd2ce3050ad35467
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c3c7ecbd2ce3050ad35467
Content-Type: text/plain; charset=UTF-8

On Sun, Dec 21, 2014 at 4:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This is *not* to say that this is the bug you're hitting. But it does show that
>
>  (a) a flaky HPET can do some seriously bad stuff
>  (b) the kernel is very fragile wrt time going backwards.
>
> and maybe we can use this test program to at least try to alleviate problem (b).

Ok, so after several false starts (ktime_get() is really really
fragile - called in scheduler things, and doing magic things at
bootup), here is something that seems to alleviate the problem for me.

I still get a lot of RCU  messages like "self-detected stall" etc, but
that's to be expected. When the clock does odd things, crap *will*
happen.

But what this does is:

 (a) make the error more visible as a clock error rather than various
random downstream users

     IOW, it prints things out when it looks like we're getting odd
clock read errors (arbitrary cut-off: we expect clock read-outs to be
withing 1/8th of the range of the expected clock value)

 (b) try to alleviate the horrible things that happen when the clock
error is big

     The patch tries to "correct" for the huge time jump by basically
undoing it. We'll still see time jumps (there really is no way to
avoid it), but we limit the range of them.

With the attached patch, my machine seems to survive me writing to the
HPET master counter register. It spews warnings, and it is noisy about
the odd clock reads:

    ...
    Clocksource hpet had cycles off by 642817751
    Cutting it too close for hpet in in update_wall_time (offset = 4034102337)
    INFO: rcu_sched self-detected stall on CPU { 0}  (t=281743 jiffies
g=4722 c=4721 q=14)
    ...

and there may still be situations where it does horrible horrible
things due to the (smaller) time leaps, but it does seem a lot more
robust.

NOTE! There's an (intentional) difference in how we handle the time
leaps at time read time vs write (wall-clock update).

At time read time, we just refuse to believe the big delta, and we set
the "cycle_error" value so that future time reads will be relative to
the error we just got. We also don't print anything out, because we're
possibly deep in the scheduler or in tracing, and we do not want to
spam the console about our fixup.

At time *write* time, we first report about any read-time errors, and
then we report (but believe in) overlarge clocksource delta errors as
we update the time.

This seems to be the best way to limit the damage.

Also note that the patch is entirely clock-agnostic. It's just that I
can trivially screw up my HPET, I didn't look at other clocks.

One note: my current limit of clocksource delta errors is based on the
range of the clock (1/8th of the range). I actually think that's
bogus, and it should instead be based on the expected frequency of the
clock (ie "we are guaranteed to update the wall clock at least once
every second, so if the clock source delta read is larger than one
second, we've done something wrong"). So this patch is meant very much
as an RFC, rather than anything else. It's pretty hacky. But it does
actually make a huge difference for me wrt the "mess up HPET time on
purpose". That used to crash my machine pretty hard, and pretty
reliably. With this patch, I've done it ten+ times, and while it spews
a lot of garbage, the machine stays up and _works_.

Making the sanity check tighter (ie the "one second" band rather than
"1/8th of the clock range") would probably just improve it further.

Thomas, what do you think? Hate it? Any better ideas?

And again: this is not trying to make the kernel clock not jump. There
is no way I can come up with even in theory to try to really *fix* a
fundamentally broken clock.

So this is not meant to be a real "fix" for anything, but is meant to
make sure that if the clock is unreliable, we pinpoint the clock
itself, and it mitigates the absolutely horrendously bad behavior we
currently with bad clocks. So think of this as debug and band-aid
rather than "this makes clocks magically reliable".

.. and we might still lock up under some circumstances. But at least
from my limited testing, it is infinitely much better, even if it
might not be perfect. Also note that my "testing" has been writing
zero to the HPET lock (so the HPET clock difference tends to be pretty
specific), while my next step is to see what happens when I write
random values (and a lot of them).

Since I expect that to cause more problems, I thought I'd send this
RFC out before I start killing my machine again ;)

                             Linus

--001a11c3c7ecbd2ce3050ad35467
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i4094rop1

IGluY2x1ZGUvbGludXgvdGltZWtlZXBlcl9pbnRlcm5hbC5oIHwgIDEgKwoga2VybmVsL3RpbWUv
dGltZWtlZXBpbmcuYyAgICAgICAgICAgfCAyNSArKysrKysrKysrKysrKysrKysrKysrKystCiAy
IGZpbGVzIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1n
aXQgYS9pbmNsdWRlL2xpbnV4L3RpbWVrZWVwZXJfaW50ZXJuYWwuaCBiL2luY2x1ZGUvbGludXgv
dGltZWtlZXBlcl9pbnRlcm5hbC5oCmluZGV4IDA1YWY5YTMzNDg5My4uMGZjYjYwZDc3MDc5IDEw
MDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3RpbWVrZWVwZXJfaW50ZXJuYWwuaAorKysgYi9pbmNs
dWRlL2xpbnV4L3RpbWVrZWVwZXJfaW50ZXJuYWwuaApAQCAtMzIsNiArMzIsNyBAQCBzdHJ1Y3Qg
dGtfcmVhZF9iYXNlIHsKIAljeWNsZV90CQkJKCpyZWFkKShzdHJ1Y3QgY2xvY2tzb3VyY2UgKmNz
KTsKIAljeWNsZV90CQkJbWFzazsKIAljeWNsZV90CQkJY3ljbGVfbGFzdDsKKwljeWNsZV90CQkJ
Y3ljbGVfZXJyb3I7CiAJdTMyCQkJbXVsdDsKIAl1MzIJCQlzaGlmdDsKIAl1NjQJCQl4dGltZV9u
c2VjOwpkaWZmIC0tZ2l0IGEva2VybmVsL3RpbWUvdGltZWtlZXBpbmcuYyBiL2tlcm5lbC90aW1l
L3RpbWVrZWVwaW5nLmMKaW5kZXggNmE5MzE4NTIwODJmLi4xYzg0MmRkZDU2N2YgMTAwNjQ0Ci0t
LSBhL2tlcm5lbC90aW1lL3RpbWVrZWVwaW5nLmMKKysrIGIva2VybmVsL3RpbWUvdGltZWtlZXBp
bmcuYwpAQCAtMTQwLDYgKzE0MCw3IEBAIHN0YXRpYyB2b2lkIHRrX3NldHVwX2ludGVybmFscyhz
dHJ1Y3QgdGltZWtlZXBlciAqdGssIHN0cnVjdCBjbG9ja3NvdXJjZSAqY2xvY2spCiAJdGstPnRr
ci5yZWFkID0gY2xvY2stPnJlYWQ7CiAJdGstPnRrci5tYXNrID0gY2xvY2stPm1hc2s7CiAJdGst
PnRrci5jeWNsZV9sYXN0ID0gdGstPnRrci5yZWFkKGNsb2NrKTsKKwl0ay0+dGtyLmN5Y2xlX2Vy
cm9yID0gMDsKIAogCS8qIERvIHRoZSBucyAtPiBjeWNsZSBjb252ZXJzaW9uIGZpcnN0LCB1c2lu
ZyBvcmlnaW5hbCBtdWx0ICovCiAJdG1wID0gTlRQX0lOVEVSVkFMX0xFTkdUSDsKQEAgLTE5Nywx
MSArMTk4LDE3IEBAIHN0YXRpYyBpbmxpbmUgczY0IHRpbWVrZWVwaW5nX2dldF9ucyhzdHJ1Y3Qg
dGtfcmVhZF9iYXNlICp0a3IpCiAJczY0IG5zZWM7CiAKIAkvKiByZWFkIGNsb2Nrc291cmNlOiAq
LwotCWN5Y2xlX25vdyA9IHRrci0+cmVhZCh0a3ItPmNsb2NrKTsKKwljeWNsZV9ub3cgPSB0a3It
PnJlYWQodGtyLT5jbG9jaykgKyB0a3ItPmN5Y2xlX2Vycm9yOwogCiAJLyogY2FsY3VsYXRlIHRo
ZSBkZWx0YSBzaW5jZSB0aGUgbGFzdCB1cGRhdGVfd2FsbF90aW1lOiAqLwogCWRlbHRhID0gY2xv
Y2tzb3VyY2VfZGVsdGEoY3ljbGVfbm93LCB0a3ItPmN5Y2xlX2xhc3QsIHRrci0+bWFzayk7CiAK
KwkvKiBIbW0/IFRoaXMgaXMgcmVhbGx5IG5vdCBnb29kLCB3ZSdyZSB0b28gY2xvc2UgdG8gb3Zl
cmZsb3dpbmcgKi8KKwlpZiAodW5saWtlbHkoZGVsdGEgPiAodGtyLT5tYXNrID4+IDMpKSkgewor
CQl0a3ItPmN5Y2xlX2Vycm9yID0gZGVsdGE7CisJCWRlbHRhID0gMDsKKwl9CisKIAluc2VjID0g
ZGVsdGEgKiB0a3ItPm11bHQgKyB0a3ItPnh0aW1lX25zZWM7CiAJbnNlYyA+Pj0gdGtyLT5zaGlm
dDsKIApAQCAtNDY1LDYgKzQ3MiwxNiBAQCBzdGF0aWMgdm9pZCB0aW1la2VlcGluZ191cGRhdGUo
c3RydWN0IHRpbWVrZWVwZXIgKnRrLCB1bnNpZ25lZCBpbnQgYWN0aW9uKQogCXVwZGF0ZV9mYXN0
X3RpbWVrZWVwZXIodGspOwogfQogCitzdGF0aWMgdm9pZCBjaGVja19jeWNsZV9lcnJvcihzdHJ1
Y3QgdGtfcmVhZF9iYXNlICp0a3IpCit7CisJY3ljbGVfdCBlcnJvciA9IHRrci0+Y3ljbGVfZXJy
b3I7CisKKwlpZiAodW5saWtlbHkoZXJyb3IpKSB7CisJCXRrci0+Y3ljbGVfZXJyb3IgPSAwOwor
CQlwcl9lcnIoIkNsb2Nrc291cmNlICVzIGhhZCBjeWNsZXMgb2ZmIGJ5ICVsbHVcbiIsIHRrci0+
Y2xvY2stPm5hbWUsIGVycm9yKTsKKwl9Cit9CisKIC8qKgogICogdGltZWtlZXBpbmdfZm9yd2Fy
ZF9ub3cgLSB1cGRhdGUgY2xvY2sgdG8gdGhlIGN1cnJlbnQgdGltZQogICoKQEAgLTQ4MSw2ICs0
OTgsNyBAQCBzdGF0aWMgdm9pZCB0aW1la2VlcGluZ19mb3J3YXJkX25vdyhzdHJ1Y3QgdGltZWtl
ZXBlciAqdGspCiAJY3ljbGVfbm93ID0gdGstPnRrci5yZWFkKGNsb2NrKTsKIAlkZWx0YSA9IGNs
b2Nrc291cmNlX2RlbHRhKGN5Y2xlX25vdywgdGstPnRrci5jeWNsZV9sYXN0LCB0ay0+dGtyLm1h
c2spOwogCXRrLT50a3IuY3ljbGVfbGFzdCA9IGN5Y2xlX25vdzsKKwljaGVja19jeWNsZV9lcnJv
cigmdGstPnRrcik7CiAKIAl0ay0+dGtyLnh0aW1lX25zZWMgKz0gZGVsdGEgKiB0ay0+dGtyLm11
bHQ7CiAKQEAgLTEyMzcsNiArMTI1NSw3IEBAIHN0YXRpYyB2b2lkIHRpbWVrZWVwaW5nX3Jlc3Vt
ZSh2b2lkKQogCiAJLyogUmUtYmFzZSB0aGUgbGFzdCBjeWNsZSB2YWx1ZSAqLwogCXRrLT50a3Iu
Y3ljbGVfbGFzdCA9IGN5Y2xlX25vdzsKKwl0ay0+dGtyLmN5Y2xlX2Vycm9yID0gMDsKIAl0ay0+
bnRwX2Vycm9yID0gMDsKIAl0aW1la2VlcGluZ19zdXNwZW5kZWQgPSAwOwogCXRpbWVrZWVwaW5n
X3VwZGF0ZSh0aywgVEtfTUlSUk9SIHwgVEtfQ0xPQ0tfV0FTX1NFVCk7CkBAIC0xNTkxLDExICsx
NjEwLDE1IEBAIHZvaWQgdXBkYXRlX3dhbGxfdGltZSh2b2lkKQogCWlmICh1bmxpa2VseSh0aW1l
a2VlcGluZ19zdXNwZW5kZWQpKQogCQlnb3RvIG91dDsKIAorCWNoZWNrX2N5Y2xlX2Vycm9yKCZy
ZWFsX3RrLT50a3IpOworCiAjaWZkZWYgQ09ORklHX0FSQ0hfVVNFU19HRVRUSU1FT0ZGU0VUCiAJ
b2Zmc2V0ID0gcmVhbF90ay0+Y3ljbGVfaW50ZXJ2YWw7CiAjZWxzZQogCW9mZnNldCA9IGNsb2Nr
c291cmNlX2RlbHRhKHRrLT50a3IucmVhZCh0ay0+dGtyLmNsb2NrKSwKIAkJCQkgICB0ay0+dGty
LmN5Y2xlX2xhc3QsIHRrLT50a3IubWFzayk7CisJaWYgKHVubGlrZWx5KG9mZnNldCA+ICh0ay0+
dGtyLm1hc2sgPj4gMykpKQorCQlwcl9lcnIoIkN1dHRpbmcgaXQgdG9vIGNsb3NlIGZvciAlcyBp
biBpbiB1cGRhdGVfd2FsbF90aW1lIChvZmZzZXQgPSAlbGx1KVxuIiwgdGstPnRrci5jbG9jay0+
bmFtZSwgb2Zmc2V0KTsKICNlbmRpZgogCiAJLyogQ2hlY2sgaWYgdGhlcmUncyByZWFsbHkgbm90
aGluZyB0byBkbyAqLwo=
--001a11c3c7ecbd2ce3050ad35467--
