Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab3GYL3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 07:29:09 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:63406 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3GYL3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 07:29:04 -0400
MIME-Version: 1.0
Date: Thu, 25 Jul 2013 13:29:04 +0200
Message-ID: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>
Subject: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
From: Margarita Manterola <margamanterola@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz,
        Maximiliano Curia <maxy@gnuservers.com.ar>
Content-Type: multipart/mixed; boundary=089e015370025f272b04e25455d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e015370025f272b04e25455d5
Content-Type: text/plain; charset=ISO-8859-1

Hi,

The problem:
Large pastes (5k or more) into a readline enabled program fail when
running kernels larger than v2.6.31-rc5.  "Fail" means that some lines
are incomplete.  From v2.6.39-rc1 onwards, "some lines" become "almost
all lines after the first 4k".  This turns up at least in Fedora,
Debian, Ubuntu and Gentoo.  From our findings, it should happen in any
readline enabled program on a system running kernels later than the
mentioned ones.

The problematic commits in the kernel tree:
1 - 2009-07-27 (never shipped) -
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=3a54297478e6578f96fd54bf4daa1751130aca86

After this commit, pastes start breaking.  For a 35k file, about 50%
of the times one or two lines are partially incomplete.

2 - 2009-07-29 (v2.6.31-rc5) -
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3

This commit reverts the previous one, but adds one extra call to
flush_to_ldisc.  Pastes still break, commenting out the function call
prevents breakage *up to 2.6.39-rc1*.

3 - 2011-03-22 (v2.6.39-rc1) -
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f23eb2b2b28547fc70df82dd5049eb39bec5ba12

This commit changes many schedule/flush/cancel_delayed_work calls into
schedule/flush/cancel_work.  After this commit, the big breakage
starts: for the 35k example file, it starts breaking at aprox. 4k and
then every line is partially incomplete or directly not there.

Still after this commit, commenting out the tty_flush_to_ldisc(tty)
call added by e043e42bdb66885b3ac10d27a01ccb9972e2b0a3 prevents the
breakage.

4 - 2011-04-04 (v2.6.39-rc2) -
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a5660b41af6a28f8004e70eb261e1202ad55c5e3

This commit modifies the behaviour of how the ttys are polled.  After
this commit, commenting out the tty_flush_to_ldisc(tty) call doesn't
prevent breakage anymore.

But then re-adding the call to schedule_work(&tty->buf.work) that was
removed in this commit, prevents the breakage even up to 3.11-rc2.
I'm attaching a diff of the patch that we applied, just to show what
had to be done, this is not a proposed fix, because this does cause a
busy loop that is particularly noticeable in VMs.

We haven't yet found a good fix for this issue, but we believe that
pasting into readline enabled programs shouldn't cause characters to
get lost, and it should be possible to do that properly without the
busy loop.

***
This was originally reported as a bug in readline, but it was found
that going back to very old kernels prevented the issue, regardless of
the version of readline.

Original Report (2012-06-25):
http://lists.gnu.org/archive/html/bug-readline/2012-06/msg00006.html
Follow Up thread (2013-07-22):
http://lists.gnu.org/archive/html/bug-readline/2013-07/msg00006.html

I'm attaching here a very simple readline enabled program that helps
with performing tests.  Compile, run, then copy and paste a large
enough file into it, close and diff.

Looking at the code in readline, the issue is triggered by these lines
in rltty.c, while preparing the input:

tiop->c_lflag &= ~(ICANON | ECHO);
(...)
tiop->c_iflag &= ~(ICRNL | INLCR);

If those two lines are replaced by:

tiop->c_lflag &= ~(ECHO);
(...)
tiop->c_iflag &= ~(INLCR);

Then the pastes work fine: no lines are missing.  Of course, this
means that readline doesn't work properly, but this is just to note
that those are the terminal settings that cause the issue to pop-up.

Credit: this investigation was done together with Maximiliano Curia.

-- 
Regards,
Margarita Manterola

--089e015370025f272b04e25455d5
Content-Type: text/x-csrc; name="minirl.c"
Content-Disposition: attachment; filename="minirl.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjjtu4j90

LyogbWluaSBwcm9ncmFtIHRvIGRlbW9uc3RyYXRlIHByb2JsZW0gd2l0aCBjdXQgYW5kIHBhc3Rl
LCAgRnJhbmsgTPxiZWNrICovCi8qIFNpbXBsaWZpZWQgYnkgTWFyZ2FyaXRhIE1hbnRlcm9sYS4g
Ki8KLyogQ29tcGlsZToKICogICAgZ2NjIC1XYWxsIC1vIG1pbmlybCAtTzIgbWluaXJsLmMgLWxy
ZWFkbGluZQogKiAgICBnY2MgLVdhbGwgLW8gbWluaXJsIC1PMiBtaW5pcmwuYyAkQ1BQRkxBR1Mg
JExERkxBR1MgLWxyZWFkbGluZSAtbG5jdXJzZXMKICogUnVuOgogKiAgICAuL21pbmlybCBURVNU
T1VUCiAqIGFuZCBwYXN0ZSB0aGUgY29udGVudCBvZiBhbnkgdGV4dCBmaWxlIChzYXkgMTBrQiB3
aXRob3V0IGxvbmcgbGluZXMpLAogKiBlbmQgcHJvZ3JhbSB3aXRoIEN0cmwtZC4KICoKICogVGhl
bgogKiAgICBkaWZmIG9yaWdpbmFsLWZpbGUgVEVTVE9VVAogKiBzaG93cyB0aGF0IGluIHNvbWUg
bGluZXMgdHJhaWxpbmcgY2hhcmFjdGVycyBnZXQgbG9zdC4gT3IgbGluZXMgY29tcGxldGVseQog
KiBsb3N0LgoqLwoKI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1
ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8cmVhZGxpbmUvcmVhZGxpbmUuaD4KCmludCBtYWluKGlu
dCBhcmdjLCBjaGFyKiogYXJndikgewoKICBjaGFyKiBzOwogIEZJTEUgKm91dDsKCiAgaWYgKGFy
Z2MgPT0gMSkgcmV0dXJuIDE7CiAgb3V0ID0gZm9wZW4oYXJndlsxXSwgInciKTsKICB3aGlsZSAo
MSkgewogICAgcyA9IHJlYWRsaW5lKCI+ICIpOwogICAgaWYgKCFzKSBicmVhazsKICAgIGZwcmlu
dGYob3V0LCIlc1xuIixzKTsKICAgIGZyZWUocyk7CiAgfQogIGZmbHVzaChvdXQpOwogIHJldHVy
biAwOwp9Cg==
--089e015370025f272b04e25455d5
Content-Type: application/octet-stream; 
	name="prevent_readline_paste_breakage.diff"
Content-Disposition: attachment; 
	filename="prevent_readline_paste_breakage.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjjvh17o1

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdHR5L25fdHR5LmMgYi9kcml2ZXJzL3R0eS9uX3R0eS5jCmlu
ZGV4IDRiZjBmYzAuLjZkNGI2NDcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdHR5L25fdHR5LmMKKysr
IGIvZHJpdmVycy90dHkvbl90dHkuYwpAQCAtMTY2Nyw3ICsxNjY3LDcgQEAgc3RhdGljIGlubGlu
ZSBpbnQgaW5wdXRfYXZhaWxhYmxlX3Aoc3RydWN0IHR0eV9zdHJ1Y3QKKnR0eSwgaW50IGFtdCkK
IHsKICAgICAgICBzdHJ1Y3Qgbl90dHlfZGF0YSAqbGRhdGEgPSB0dHktPmRpc2NfZGF0YTsKCi0g
ICAgICAgdHR5X2ZsdXNoX3RvX2xkaXNjKHR0eSk7CisgICAgICAgLy8gdHR5X2ZsdXNoX3RvX2xk
aXNjKHR0eSk7CiAgICAgICAgaWYgKGxkYXRhLT5pY2Fub24gJiYgIUxfRVhUUFJPQyh0dHkpKSB7
CiAgICAgICAgICAgICAgICBpZiAobGRhdGEtPmNhbm9uX2RhdGEpCiAgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiAxOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy90dHkvdHR5X2J1ZmZlci5jIGIv
ZHJpdmVycy90dHkvdHR5X2J1ZmZlci5jCmluZGV4IDkxMjFjMWYuLjZjMmRhOTUgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvdHR5L3R0eV9idWZmZXIuYworKysgYi9kcml2ZXJzL3R0eS90dHlfYnVmZmVy
LmMKQEAgLTQ0OSw4ICs0NDksMTAgQEAgc3RhdGljIHZvaWQgZmx1c2hfdG9fbGRpc2Moc3RydWN0
IHdvcmtfc3RydWN0ICp3b3JrKQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHR0eV9i
dWZmZXJfZnJlZShwb3J0LCBoZWFkKTsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBj
b250aW51ZTsKICAgICAgICAgICAgICAgICAgICAgICAgfQotICAgICAgICAgICAgICAgICAgICAg
ICBpZiAoIXR0eS0+cmVjZWl2ZV9yb29tKQorICAgICAgICAgICAgICAgICAgICAgICBpZiAoIXR0
eS0+cmVjZWl2ZV9yb29tKSB7CisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNjaGVk
dWxlX3dvcmsoJmJ1Zi0+d29yayk7CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnJl
YWs7CisgICAgICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICAgICAgICAgIGlm
IChjb3VudCA+IHR0eS0+cmVjZWl2ZV9yb29tKQogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGNvdW50ID0gdHR5LT5yZWNlaXZlX3Jvb207CiAgICAgICAgICAgICAgICAgICAgICAgIGNo
YXJfYnVmID0gaGVhZC0+Y2hhcl9idWZfcHRyICsgaGVhZC0+cmVhZDsKCg==
--089e015370025f272b04e25455d5--
