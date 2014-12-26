Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaLZU5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 15:57:12 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:60493 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaLZU5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 15:57:08 -0500
MIME-Version: 1.0
In-Reply-To: <20141226181204.GA26527@codemonkey.org.uk>
References: <CA+55aFy8DCMmkPRz0kqNC80pn4VkeQr2Wz2fTRm=32oH2dhfRQ@mail.gmail.com>
	<CA+55aFwA7uOFgb-Y4dHS099HuoV+oQvxXf+cfZYh9T7H_c0PHA@mail.gmail.com>
	<20141221223204.GA9618@codemonkey.org.uk>
	<CA+55aFygv+PRcYScwCjGVQ7-0PA1mHOGYaKGKS4LBhxPm0YBJA@mail.gmail.com>
	<CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com>
	<CA+55aFz0n=sJgn5LeBLcTzj9=eCVkrWiQZNCKupuD7CMTwm=jQ@mail.gmail.com>
	<20141222225725.GA8140@codemonkey.org.uk>
	<CA+55aFzjA_KSqUJiKm5qeZEeFBdrg17doANao+8iphBvVM8boQ@mail.gmail.com>
	<20141224030125.GA8725@codemonkey.org.uk>
	<20141226163410.GA25161@codemonkey.org.uk>
	<20141226181204.GA26527@codemonkey.org.uk>
Date: Fri, 26 Dec 2014 12:57:07 -0800
X-Google-Sender-Auth: c-42JbzYFA-7zFX-nfDDJ1YBK4M
Message-ID: <CA+55aFyySYFJjV5689Ej+Rer_igR0R1S5=h0GwWpWpA6Tk1Okw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: multipart/mixed; boundary=001a11c231da8b635d050b24c454
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c231da8b635d050b24c454
Content-Type: text/plain; charset=UTF-8

On Fri, Dec 26, 2014 at 10:12 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
> On Fri, Dec 26, 2014 at 11:34:10AM -0500, Dave Jones wrote:
>
>  > One thing I think I'll try is to try and narrow down which
>  > syscalls are triggering those "Clocksource hpet had cycles off"
>  > messages.  I'm still unclear on exactly what is doing
>  > the stomping on the hpet.
>
> First I ran trinity with "-g vm" which limits it to use just
> a subset of syscalls, specifically VM related ones.
> That triggered the messages. Further experiments revealed:

So I can trigger the false positives with my original patch quite
easily by just putting my box under some load. My numbers are nowhere
near as bad as yours, but then, I didn't put it under as much load
anyway. Just a regular "make -j64" of the kernel.

I suspect your false positives are bigger partly because of the load,
but mostly because you presumably have preemption enabled too. I don't
do preemption in my normal kernels, and that limits the damage of the
race a bit.

I have a newer version of the patch that gets rid of the false
positives with some ordering rules instead, and just for you I hacked
it up to say where the problem happens too, but it's likely too late.

The fact that the original racy patch seems to make a difference for
you does say that yes, we seem to be zeroing in on the right area
here, but I'm not seeing what's wrong. I was hoping for big jumps from
your HPET, since your "TSC unstable" messages do kind of imply that
such really big jumps can happen.

I'm attaching my updated hacky patch, although I assume it's much too
late for that machine. Don't look too closely at the backtrace
generation part, that's just a quick hack, and only works with frame
pointers enabled anyway.

So I'm still a bit unhappy about not figuring out *what* is wrong. And
I'd still like the dmidecode from that machine, just for posterity. In
case we can figure out some pattern.

So right now I can imagine several reasons:

 - actual hardware bug.

   This is *really* unlikely, though. It should hit everybody. The
HPET is in the core intel chipset, we're not talking random unusual
hardware by fly-by-night vendors here.

 - some SMM/BIOS "power management" feature.

   We've seen this before, where the SMM saves/restores the TSC on
entry/exit in order to hide itself from the system. I could imagine
similar code for the HPET counter. SMM writers use some bad drugs to
dull their pain.

   And with the HPET counter, since it's not even per-CPU, the "save
and restore HPET" will actually show up as "HPET went backwards" to
the other non-SMM CPU's if it happens

 - a bug in our own clocksource handling.

   I'm not seeing it. But maybe my patch hides it for some magical reason.

 - gremlins.

So I dunno. I hope more people will look at this after the holidays,
even if your machine is gone. My test-program to do bad things to the
HPET shows *something*, and works on any machine.

                    Linus

--001a11c231da8b635d050b24c454
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i460x2yq0

IGFyY2gveDg2L2tlcm5lbC9lbnRyeV82NC5TICAgICAgICAgIHwgIDUgKysrCiBpbmNsdWRlL2xp
bnV4L3RpbWVrZWVwZXJfaW50ZXJuYWwuaCB8ICAxICsKIGtlcm5lbC90aW1lL3RpbWVrZWVwaW5n
LmMgICAgICAgICAgIHwgNzggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQog
MyBmaWxlcyBjaGFuZ2VkLCA4MSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2tlcm5lbC9lbnRyeV82NC5TIGIvYXJjaC94ODYva2VybmVsL2VudHJ5
XzY0LlMKaW5kZXggOWViYWY2M2JhMTgyLi4wYTRjMzRiNDY1OGUgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9lbnRyeV82NC5TCisrKyBiL2FyY2gveDg2L2tlcm5lbC9lbnRyeV82NC5TCkBA
IC0zMTIsNiArMzEyLDExIEBAIEVOVFJZKHNhdmVfcGFyYW5vaWQpCiAJQ0ZJX0VORFBST0MKIEVO
RChzYXZlX3BhcmFub2lkKQogCitFTlRSWShzYXZlX2JhY2tfdHJhY2UpCisJbW92cSAlcmJwLCVy
ZGkKKwlqbXAgZG9fc2F2ZV9iYWNrX3RyYWNlCitFTkQoc2F2ZV9iYWNrX3RyYWNlKQorCiAvKgog
ICogQSBuZXdseSBmb3JrZWQgcHJvY2VzcyBkaXJlY3RseSBjb250ZXh0IHN3aXRjaGVzIGludG8g
dGhpcyBhZGRyZXNzLgogICoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvdGltZWtlZXBlcl9p
bnRlcm5hbC5oIGIvaW5jbHVkZS9saW51eC90aW1la2VlcGVyX2ludGVybmFsLmgKaW5kZXggMDVh
ZjlhMzM0ODkzLi4wZmNiNjBkNzcwNzkgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvdGltZWtl
ZXBlcl9pbnRlcm5hbC5oCisrKyBiL2luY2x1ZGUvbGludXgvdGltZWtlZXBlcl9pbnRlcm5hbC5o
CkBAIC0zMiw2ICszMiw3IEBAIHN0cnVjdCB0a19yZWFkX2Jhc2UgewogCWN5Y2xlX3QJCQkoKnJl
YWQpKHN0cnVjdCBjbG9ja3NvdXJjZSAqY3MpOwogCWN5Y2xlX3QJCQltYXNrOwogCWN5Y2xlX3QJ
CQljeWNsZV9sYXN0OworCWN5Y2xlX3QJCQljeWNsZV9lcnJvcjsKIAl1MzIJCQltdWx0OwogCXUz
MgkJCXNoaWZ0OwogCXU2NAkJCXh0aW1lX25zZWM7CmRpZmYgLS1naXQgYS9rZXJuZWwvdGltZS90
aW1la2VlcGluZy5jIGIva2VybmVsL3RpbWUvdGltZWtlZXBpbmcuYwppbmRleCA2YTkzMTg1MjA4
MmYuLjFjOTI0YzgwYjQ2MiAxMDA2NDQKLS0tIGEva2VybmVsL3RpbWUvdGltZWtlZXBpbmcuYwor
KysgYi9rZXJuZWwvdGltZS90aW1la2VlcGluZy5jCkBAIC0xNDAsNiArMTQwLDcgQEAgc3RhdGlj
IHZvaWQgdGtfc2V0dXBfaW50ZXJuYWxzKHN0cnVjdCB0aW1la2VlcGVyICp0aywgc3RydWN0IGNs
b2Nrc291cmNlICpjbG9jaykKIAl0ay0+dGtyLnJlYWQgPSBjbG9jay0+cmVhZDsKIAl0ay0+dGty
Lm1hc2sgPSBjbG9jay0+bWFzazsKIAl0ay0+dGtyLmN5Y2xlX2xhc3QgPSB0ay0+dGtyLnJlYWQo
Y2xvY2spOworCXRrLT50a3IuY3ljbGVfZXJyb3IgPSAwOwogCiAJLyogRG8gdGhlIG5zIC0+IGN5
Y2xlIGNvbnZlcnNpb24gZmlyc3QsIHVzaW5nIG9yaWdpbmFsIG11bHQgKi8KIAl0bXAgPSBOVFBf
SU5URVJWQUxfTEVOR1RIOwpAQCAtMTkxLDE2ICsxOTIsNTkgQEAgdTMyICgqYXJjaF9nZXR0aW1l
b2Zmc2V0KSh2b2lkKSA9IGRlZmF1bHRfYXJjaF9nZXR0aW1lb2Zmc2V0Owogc3RhdGljIGlubGlu
ZSB1MzIgYXJjaF9nZXR0aW1lb2Zmc2V0KHZvaWQpIHsgcmV0dXJuIDA7IH0KICNlbmRpZgogCit1
bnNpZ25lZCBsb25nIHRyYWNlYnVmZmVyWzE2XTsKKworZXh0ZXJuIHZvaWQgc2F2ZV9iYWNrX3Ry
YWNlKGxvbmcgZHVtbXksIHZvaWQgKnB0cik7CisKK3ZvaWQgZG9fc2F2ZV9iYWNrX3RyYWNlKGxv
bmcgcmJwLCB2b2lkICpwdHIpCit7CisJaW50IGk7CisJdW5zaWduZWQgbG9uZyBmcmFtZSA9IHJi
cDsKKworCWZvciAoaSA9IDA7IGkgPCAxNTsgaSsrKSB7CisJCXVuc2lnbmVkIGxvbmcgbmV4dGZy
YW1lID0gKCh1bnNpZ25lZCBsb25nICopZnJhbWUpWzBdOworCQl1bnNpZ25lZCBsb25nIHJpcCA9
ICgodW5zaWduZWQgbG9uZyAqKWZyYW1lKVsxXTsKKwkJdHJhY2VidWZmZXJbaV0gPSByaXA7CisJ
CWlmICgobmV4dGZyYW1lIF4gZnJhbWUpID4+IDEzKQorCQkJYnJlYWs7CisJCWlmIChuZXh0ZnJh
bWUgPD0gZnJhbWUpCisJCQlicmVhazsKKwkJZnJhbWUgPSBuZXh0ZnJhbWU7CisJfQorCXRyYWNl
YnVmZmVyW2ldID0gMDsKK30KKworLyoKKyAqIEF0IHJlYWQgdGltZSwgd2UgcmVhZCAiY3ljbGVf
bGFzdCIgKmJlZm9yZSogd2UgcmVhZAorICogdGhlIGNsb2NrLgorICoKKyAqIEF0IHdyaXRlIHRp
bWUsIHdlIHJlYWQgdGhlIGNsb2NrIGJlZm9yZSB3ZSB1cGRhdGUKKyAqICdjeWNsZV9sYXN0Jy4K
KyAqCisgKiBUaHVzLCBhbnkgJ2N5Y2xlX2xhc3QnIHZhbHVlIHJlYWQgaGVyZSAqbXVzdCogYmUg
c21hbGxlcgorICogdGhhbiB0aGUgY2xvY2sgcmVhZC4gVW5sZXNzIHRoZSBjbG9jayBpcyBidWdn
eS4KKyAqLwogc3RhdGljIGlubGluZSBzNjQgdGltZWtlZXBpbmdfZ2V0X25zKHN0cnVjdCB0a19y
ZWFkX2Jhc2UgKnRrcikKIHsKLQljeWNsZV90IGN5Y2xlX25vdywgZGVsdGE7CisJY3ljbGVfdCBj
eWNsZV9sYXN0LCBjeWNsZV9ub3csIGRlbHRhOwogCXM2NCBuc2VjOwogCisJLyogUmVhZCBwcmV2
aW91cyBjeWNsZSAtICpiZWZvcmUqIHJlYWRpbmcgY2xvY2tzb3VyY2UgKi8KKwljeWNsZV9sYXN0
ID0gc21wX2xvYWRfYWNxdWlyZSgmdGtyLT5jeWNsZV9sYXN0KTsKKwogCS8qIHJlYWQgY2xvY2tz
b3VyY2U6ICovCi0JY3ljbGVfbm93ID0gdGtyLT5yZWFkKHRrci0+Y2xvY2spOworCWN5Y2xlX25v
dyA9IHNtcF9sb2FkX2FjcXVpcmUoJnRrci0+Y3ljbGVfZXJyb3IpOworCWN5Y2xlX25vdyArPSB0
a3ItPnJlYWQodGtyLT5jbG9jayk7CiAKIAkvKiBjYWxjdWxhdGUgdGhlIGRlbHRhIHNpbmNlIHRo
ZSBsYXN0IHVwZGF0ZV93YWxsX3RpbWU6ICovCi0JZGVsdGEgPSBjbG9ja3NvdXJjZV9kZWx0YShj
eWNsZV9ub3csIHRrci0+Y3ljbGVfbGFzdCwgdGtyLT5tYXNrKTsKKwlkZWx0YSA9IGNsb2Nrc291
cmNlX2RlbHRhKGN5Y2xlX25vdywgY3ljbGVfbGFzdCwgdGtyLT5tYXNrKTsKKworCS8qIEhtbT8g
VGhpcyBpcyByZWFsbHkgbm90IGdvb2QsIHdlJ3JlIHRvbyBjbG9zZSB0byBvdmVyZmxvd2luZyAq
LworCWlmICh1bmxpa2VseShkZWx0YSA+ICh0a3ItPm1hc2sgPj4gMykpKSB7CisJCXNtcF9zdG9y
ZV9yZWxlYXNlKCZ0a3ItPmN5Y2xlX2Vycm9yLCBkZWx0YSk7CisJCWRlbHRhID0gMDsKKwkJc2F2
ZV9iYWNrX3RyYWNlKDAsIHRyYWNlYnVmZmVyKTsKKwl9CiAKIAluc2VjID0gZGVsdGEgKiB0a3It
Pm11bHQgKyB0a3ItPnh0aW1lX25zZWM7CiAJbnNlYyA+Pj0gdGtyLT5zaGlmdDsKQEAgLTQ2NSw2
ICs1MDksMjggQEAgc3RhdGljIHZvaWQgdGltZWtlZXBpbmdfdXBkYXRlKHN0cnVjdCB0aW1la2Vl
cGVyICp0aywgdW5zaWduZWQgaW50IGFjdGlvbikKIAl1cGRhdGVfZmFzdF90aW1la2VlcGVyKHRr
KTsKIH0KIAorc3RhdGljIHZvaWQgY2hlY2tfY3ljbGVfZXJyb3Ioc3RydWN0IHRrX3JlYWRfYmFz
ZSAqdGtyKQoreworCWN5Y2xlX3QgZXJyb3IgPSB0a3ItPmN5Y2xlX2Vycm9yOworCisJaWYgKHVu
bGlrZWx5KGVycm9yKSkgeworCQlpbnQgaTsKKwkJY29uc3QgY2hhciAqc2lnbiA9ICIiOworCQl0
a3ItPmN5Y2xlX2Vycm9yID0gMDsKKwkJaWYgKGVycm9yID4gdGtyLT5tYXNrLzIpIHsKKwkJCWVy
cm9yID0gdGtyLT5tYXNrIC0gZXJyb3IgKyAxOworCQkJc2lnbiA9ICItIjsKKwkJfQorCQlwcl9l
cnIoIkNsb2Nrc291cmNlICVzIGhhZCBjeWNsZXMgb2ZmIGJ5ICVzJWxsdVxuIiwgdGtyLT5jbG9j
ay0+bmFtZSwgc2lnbiwgZXJyb3IpOworCQlmb3IgKGkgPSAwOyBpIDwgMTY7IGkrKykgeworCQkJ
dW5zaWduZWQgbG9uZyByaXAgPSB0cmFjZWJ1ZmZlcltpXTsKKwkJCWlmICghcmlwKQorCQkJCWJy
ZWFrOworCQkJcHJpbnRrKCIgICVwU1xuIiwgKHZvaWQgKilyaXApOworCQl9CisJfQorfQorCiAv
KioKICAqIHRpbWVrZWVwaW5nX2ZvcndhcmRfbm93IC0gdXBkYXRlIGNsb2NrIHRvIHRoZSBjdXJy
ZW50IHRpbWUKICAqCkBAIC00ODEsNiArNTQ3LDcgQEAgc3RhdGljIHZvaWQgdGltZWtlZXBpbmdf
Zm9yd2FyZF9ub3coc3RydWN0IHRpbWVrZWVwZXIgKnRrKQogCWN5Y2xlX25vdyA9IHRrLT50a3Iu
cmVhZChjbG9jayk7CiAJZGVsdGEgPSBjbG9ja3NvdXJjZV9kZWx0YShjeWNsZV9ub3csIHRrLT50
a3IuY3ljbGVfbGFzdCwgdGstPnRrci5tYXNrKTsKIAl0ay0+dGtyLmN5Y2xlX2xhc3QgPSBjeWNs
ZV9ub3c7CisJY2hlY2tfY3ljbGVfZXJyb3IoJnRrLT50a3IpOwogCiAJdGstPnRrci54dGltZV9u
c2VjICs9IGRlbHRhICogdGstPnRrci5tdWx0OwogCkBAIC0xMjM3LDYgKzEzMDQsNyBAQCBzdGF0
aWMgdm9pZCB0aW1la2VlcGluZ19yZXN1bWUodm9pZCkKIAogCS8qIFJlLWJhc2UgdGhlIGxhc3Qg
Y3ljbGUgdmFsdWUgKi8KIAl0ay0+dGtyLmN5Y2xlX2xhc3QgPSBjeWNsZV9ub3c7CisJdGstPnRr
ci5jeWNsZV9lcnJvciA9IDA7CiAJdGstPm50cF9lcnJvciA9IDA7CiAJdGltZWtlZXBpbmdfc3Vz
cGVuZGVkID0gMDsKIAl0aW1la2VlcGluZ191cGRhdGUodGssIFRLX01JUlJPUiB8IFRLX0NMT0NL
X1dBU19TRVQpOwpAQCAtMTU5MSwxMSArMTY1OSwxNSBAQCB2b2lkIHVwZGF0ZV93YWxsX3RpbWUo
dm9pZCkKIAlpZiAodW5saWtlbHkodGltZWtlZXBpbmdfc3VzcGVuZGVkKSkKIAkJZ290byBvdXQ7
CiAKKwljaGVja19jeWNsZV9lcnJvcigmcmVhbF90ay0+dGtyKTsKKwogI2lmZGVmIENPTkZJR19B
UkNIX1VTRVNfR0VUVElNRU9GRlNFVAogCW9mZnNldCA9IHJlYWxfdGstPmN5Y2xlX2ludGVydmFs
OwogI2Vsc2UKIAlvZmZzZXQgPSBjbG9ja3NvdXJjZV9kZWx0YSh0ay0+dGtyLnJlYWQodGstPnRr
ci5jbG9jayksCiAJCQkJICAgdGstPnRrci5jeWNsZV9sYXN0LCB0ay0+dGtyLm1hc2spOworCWlm
ICh1bmxpa2VseShvZmZzZXQgPiAodGstPnRrci5tYXNrID4+IDMpKSkKKwkJcHJfZXJyKCJDdXR0
aW5nIGl0IHRvbyBjbG9zZSBmb3IgJXMgaW4gaW4gdXBkYXRlX3dhbGxfdGltZSAob2Zmc2V0ID0g
JWxsdSlcbiIsIHRrLT50a3IuY2xvY2stPm5hbWUsIG9mZnNldCk7CiAjZW5kaWYKIAogCS8qIENo
ZWNrIGlmIHRoZXJlJ3MgcmVhbGx5IG5vdGhpbmcgdG8gZG8gKi8K
--001a11c231da8b635d050b24c454--
