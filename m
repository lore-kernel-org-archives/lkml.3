Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747AbaDCBsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 21:48:24 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:35017 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaDCBr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 21:47:59 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<alpine.LRH.2.00.1404030119270.23421@twin.jikos.cz>
	<20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
	<CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
	<alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
	<CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
Date: Wed, 2 Apr 2014 18:47:57 -0700
X-Google-Sender-Auth: 754H8_GVI8NDGcm4WdEkhl2mqAQ
Message-ID: <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Content-Type: multipart/mixed; boundary=001a1134044e335e1004f6199711
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a1134044e335e1004f6199711
Content-Type: text/plain; charset=UTF-8

On Wed, Apr 2, 2014 at 4:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> TOTALLY UNTESTED. But it really isn't complex.

Oh, and here's a patch that is actually lightly tested. I did

    while :; do echo hello; done > /dev/kmsg

(the 'yes' program buffers output, so won't work) and I get

    [  122.062912] hello
    [  122.062915] hello
    [  122.062918] hello
    [  122.062921] hello
    [  122.062924] hello
    [  122.062927] hello
    [  122.062930] hello
    [  122.062932] hello
    [  122.062935] hello
    [  122.062938] hello
    [  127.062671] bash: 2104439 callbacks suppressed

so it works (repeating every five seconds, as expected).

It's definitely not perfect - if we suppress output, and the process
then closes the file descriptor rather than continuing to write more,
you won't  get that "suppressed" message. But it's a usable starting
point for testing and commentary on the actual limits.

So we should probably add reporting about suppressed messages at file
close time, and we should tweak the limits (for example, perhaps not
limit things if the buffers are largely empty - which happens at
bootup), but on the whole I think this is a reasonable thing to do.

Whether it actually fixes the problem that Borislav had is
questionable, of course. For all I know, systemd debug mode generates
so much data in *other* ways and then causes feedback loops with the
kernel debugging that this patch is totally immaterial, and dmesg was
never the main issue. But unlike the "hide 'debug' from
/proc/cmdline", I think this patch at least _conceptually_ makes a lot
of sense, even if systemd gets fixed, so ...

Borislav?

                Linus

--001a1134044e335e1004f6199711
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_htjduu8n1

IGtlcm5lbC9wcmludGsvcHJpbnRrLmMgfCAyNiArKysrKysrKysrKysrKysrLS0tLS0tLS0tLQog
MSBmaWxlIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2tlcm5lbC9wcmludGsvcHJpbnRrLmMgYi9rZXJuZWwvcHJpbnRrL3ByaW50ay5jCmlu
ZGV4IDRkYWU5Y2JlOTI1OS4uYjAxYmExMGZiMWI5IDEwMDY0NAotLS0gYS9rZXJuZWwvcHJpbnRr
L3ByaW50ay5jCisrKyBiL2tlcm5lbC9wcmludGsvcHJpbnRrLmMKQEAgLTQxMCw2ICs0MTAsNyBA
QCBzdHJ1Y3QgZGV2a21zZ191c2VyIHsKIAl1NjQgc2VxOwogCXUzMiBpZHg7CiAJZW51bSBsb2df
ZmxhZ3MgcHJldjsKKwlzdHJ1Y3QgcmF0ZWxpbWl0X3N0YXRlIHJzOwogCXN0cnVjdCBtdXRleCBs
b2NrOwogCWNoYXIgYnVmWzgxOTJdOwogfTsKQEAgLTQyMSwxMSArNDIyLDE1IEBAIHN0YXRpYyBz
c2l6ZV90IGRldmttc2dfd3JpdGV2KHN0cnVjdCBraW9jYiAqaW9jYiwgY29uc3Qgc3RydWN0IGlv
dmVjICppdiwKIAlpbnQgaTsKIAlpbnQgbGV2ZWwgPSBkZWZhdWx0X21lc3NhZ2VfbG9nbGV2ZWw7
CiAJaW50IGZhY2lsaXR5ID0gMTsJLyogTE9HX1VTRVIgKi8KKwlzdHJ1Y3QgZmlsZSAqZmlsZSA9
IGlvY2ItPmtpX2ZpbHA7CisJc3RydWN0IGRldmttc2dfdXNlciAqdXNlciA9IGZpbGUtPnByaXZh
dGVfZGF0YTsKIAlzaXplX3QgbGVuID0gaW92X2xlbmd0aChpdiwgY291bnQpOwogCXNzaXplX3Qg
cmV0ID0gbGVuOwogCi0JaWYgKGxlbiA+IExPR19MSU5FX01BWCkKKwlpZiAoIXVzZXIgfHwgbGVu
ID4gTE9HX0xJTkVfTUFYKQogCQlyZXR1cm4gLUVJTlZBTDsKKwlpZiAoIV9fX3JhdGVsaW1pdCgm
dXNlci0+cnMsIGN1cnJlbnQtPmNvbW0pKQorCQlyZXR1cm4gcmV0OwogCWJ1ZiA9IGttYWxsb2Mo
bGVuKzEsIEdGUF9LRVJORUwpOwogCWlmIChidWYgPT0gTlVMTCkKIAkJcmV0dXJuIC1FTk9NRU07
CkBAIC02NTYsMjEgKzY2MSwyMiBAQCBzdGF0aWMgdW5zaWduZWQgaW50IGRldmttc2dfcG9sbChz
dHJ1Y3QgZmlsZSAqZmlsZSwgcG9sbF90YWJsZSAqd2FpdCkKIHN0YXRpYyBpbnQgZGV2a21zZ19v
cGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogewogCXN0cnVjdCBk
ZXZrbXNnX3VzZXIgKnVzZXI7Ci0JaW50IGVycjsKLQotCS8qIHdyaXRlLW9ubHkgZG9lcyBub3Qg
bmVlZCBhbnkgZmlsZSBjb250ZXh0ICovCi0JaWYgKChmaWxlLT5mX2ZsYWdzICYgT19BQ0NNT0RF
KSA9PSBPX1dST05MWSkKLQkJcmV0dXJuIDA7CiAKLQllcnIgPSBjaGVja19zeXNsb2dfcGVybWlz
c2lvbnMoU1lTTE9HX0FDVElPTl9SRUFEX0FMTCwKLQkJCQkgICAgICAgU1lTTE9HX0ZST01fUkVB
REVSKTsKLQlpZiAoZXJyKQotCQlyZXR1cm4gZXJyOworCS8qIHdyaXRlLW9ubHkgZG9lcyBub3Qg
bmVlZCB0byBjaGVjayByZWFkIHBlcm1pc3Npb25zICovCisJaWYgKChmaWxlLT5mX2ZsYWdzICYg
T19BQ0NNT0RFKSAhPSBPX1dST05MWSkgeworCQlpbnQgZXJyID0gY2hlY2tfc3lzbG9nX3Blcm1p
c3Npb25zKFNZU0xPR19BQ1RJT05fUkVBRF9BTEwsCisJCQkJCSAgICAgICBTWVNMT0dfRlJPTV9S
RUFERVIpOworCQlpZiAoZXJyKQorCQkJcmV0dXJuIGVycjsKKwl9CiAKIAl1c2VyID0ga21hbGxv
YyhzaXplb2Yoc3RydWN0IGRldmttc2dfdXNlciksIEdGUF9LRVJORUwpOwogCWlmICghdXNlcikK
IAkJcmV0dXJuIC1FTk9NRU07CiAKKwkvKiBDb25maWd1cmFibGU/ICovCisJcmF0ZWxpbWl0X3N0
YXRlX2luaXQoJnVzZXItPnJzLCBERUZBVUxUX1JBVEVMSU1JVF9JTlRFUlZBTCwgREVGQVVMVF9S
QVRFTElNSVRfQlVSU1QpOworCiAJbXV0ZXhfaW5pdCgmdXNlci0+bG9jayk7CiAKIAlyYXdfc3Bp
bl9sb2NrX2lycSgmbG9nYnVmX2xvY2spOwo=
--001a1134044e335e1004f6199711--
