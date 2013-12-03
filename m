Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3LCO3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:29:07 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:34353 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3LCO2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:28:46 -0500
MIME-Version: 1.0
In-Reply-To: <20131126222945.GC8588@mtj.dyndns.org>
References: <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
	<20130115235043.GJ2668@htj.dyndns.org>
	<CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
	<CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
	<20130116025251.GM2668@htj.dyndns.org>
	<20130812070411.GA2878@elie.Belkin>
	<20130812150900.GJ15892@htj.dyndns.org>
	<CAKA=qzY5NBZSv8r9sHqX-3fY-yrSXq26zPM1AvjoANaZkqJavQ@mail.gmail.com>
	<CA+55aFw9wNBoJBYQ+kjpqs6cnVjGHVs2oxfguMmyYXNPcqqzkQ@mail.gmail.com>
	<CAKA=qzY2JYxbO=0s8_SnUn-8b=1+RqsdAzXQhfHYxo1isv0K-g@mail.gmail.com>
	<20131126222945.GC8588@mtj.dyndns.org>
Date: Tue, 3 Dec 2013 08:28:43 -0600
Message-ID: <CAKA=qzbyPxU8sBRbYzL61VS6R_o5p+2RdPogJ0nOmQ8NBi2GSA@mail.gmail.com>
Subject: Re: [3.8-rc3 -> 3.8-rc4 regression] Re: [PATCH] module, async:
 async_synchronize_full() on module init iff async is used
From: Josh Hunt <joshhunt00@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: multipart/mixed; boundary=089e014941f41c819d04eca21d20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e014941f41c819d04eca21d20
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Nov 26, 2013 at 4:29 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Nov 26, 2013 at 04:12:41PM -0600, Josh Hunt wrote:
>> I should have clarified that I'm not using dm/md in my setup. I know
>> the modules are getting loaded in the log I attached, but root is not
>> a md/dm device.
>
> Can you please still try it?  The init script is broken and we're now
> just trying to restore just enough of the old behavior so that the
> issue is not exposed.  The boot script in use seems to load md/dm
> modules after storage drivers and use their termination as the signal
> for "storage ready", so it could be a good enough bandaid even if
> you're not using dm/md.
>
> Thanks.
>
> --
> tejun

Tejun

You're right. Thanks for pointing this out. I did not realize there
was a bug in the init script. The version of initramfs-tools I was
using had the following bug:
https://bugs.launchpad.net/ubuntu/+source/initramfs-tools/+bug/1215911

Updating to 0.99ubuntu13.4 of initramfs-tools resolved my boot hangs.

I did try using the workaround as suggested by Linus. In my setup the
dm_init() code was hit, however it still appeared to be too late at
times. I also tried moving the call to async_synchronize_full() above
the for loop and it still had the same issue (patch attached.) Out of
around 10 reboot tests it failed to find root 1 or 2 times.

The ubuntu scripts don't ever actually call do_mount() if it can't
find the device. It seems to rely on some udev functionality to tell
it when the device is present, and if that fails it just bails out.

This change has introduced a regression. However, I only noticed it
b/c my init script had a bug which caused it not to wait around for
the device to appear.

-- 
Josh

--089e014941f41c819d04eca21d20
Content-Type: text/x-patch; charset=US-ASCII; name="async-dbg.patch"
Content-Disposition: attachment; filename="async-dbg.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hor8qrgj0

SW5kZXg6IGxpbnV4LTMuMTAvZHJpdmVycy9tZC9kbS5jCj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTMu
MTAub3JpZy9kcml2ZXJzL21kL2RtLmMKKysrIGxpbnV4LTMuMTAvZHJpdmVycy9tZC9kbS5jCkBA
IC0xNiwxMiArMTYsMTMgQEAKICNpbmNsdWRlIDxsaW51eC9iaW8uaD4KICNpbmNsdWRlIDxsaW51
eC9tZW1wb29sLmg+CiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgogI2luY2x1ZGUgPGxpbnV4L2lk
ci5oPgogI2luY2x1ZGUgPGxpbnV4L2hkcmVnLmg+CiAjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4K
KyNpbmNsdWRlIDxsaW51eC9hc3luYy5oPgogCiAjaW5jbHVkZSA8dHJhY2UvZXZlbnRzL2Jsb2Nr
Lmg+CiAKICNkZWZpbmUgRE1fTVNHX1BSRUZJWCAiY29yZSIKIAogI2lmZGVmIENPTkZJR19QUklO
VEsKQEAgLTI3NSwxMiArMjc2LDE1IEBAIHN0YXRpYyB2b2lkICgqX2V4aXRzW10pKHZvaWQpID0g
ewogc3RhdGljIGludCBfX2luaXQgZG1faW5pdCh2b2lkKQogewogCWNvbnN0IGludCBjb3VudCA9
IEFSUkFZX1NJWkUoX2luaXRzKTsKIAogCWludCByLCBpOwogCisJcHJpbnRrKEtFUk5fQ1JJVCAi
REJHOiAlczogQ2FsbGluZyBhc3luY19zeW5jaHJvbml6ZV9mdWxsKCk7XG4iLCBfX2Z1bmNfXyk7
CisJYXN5bmNfc3luY2hyb25pemVfZnVsbCgpOworCiAJZm9yIChpID0gMDsgaSA8IGNvdW50OyBp
KyspIHsKIAkJciA9IF9pbml0c1tpXSgpOwogCQlpZiAocikKIAkJCWdvdG8gYmFkOwogCX0KIApJ
bmRleDogbGludXgtMy4xMC9kcml2ZXJzL21kL21kLmMKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMy4x
MC5vcmlnL2RyaXZlcnMvbWQvbWQuYworKysgbGludXgtMy4xMC9kcml2ZXJzL21kL21kLmMKQEAg
LTQ4LDEyICs0OCwxMyBAQAogI2luY2x1ZGUgPGxpbnV4L2ZpbGUuaD4KICNpbmNsdWRlIDxsaW51
eC9jb21wYXQuaD4KICNpbmNsdWRlIDxsaW51eC9kZWxheS5oPgogI2luY2x1ZGUgPGxpbnV4L3Jh
aWQvbWRfcC5oPgogI2luY2x1ZGUgPGxpbnV4L3JhaWQvbWRfdS5oPgogI2luY2x1ZGUgPGxpbnV4
L3NsYWIuaD4KKyNpbmNsdWRlIDxsaW51eC9hc3luYy5oPgogI2luY2x1ZGUgIm1kLmgiCiAjaW5j
bHVkZSAiYml0bWFwLmgiCiAKICNpZm5kZWYgTU9EVUxFCiBzdGF0aWMgdm9pZCBhdXRvc3RhcnRf
YXJyYXlzKGludCBwYXJ0KTsKICNlbmRpZgpAQCAtODU3MywxMiArODU3NCwxNCBAQCBzdGF0aWMg
dm9pZCBhdXRvc3RhcnRfYXJyYXlzKGludCBwYXJ0KQogCWRldl90IGRldjsKIAlpbnQgaV9zY2Fu
bmVkLCBpX3Bhc3NlZDsKIAogCWlfc2Nhbm5lZCA9IDA7CiAJaV9wYXNzZWQgPSAwOwogCisJcHJp
bnRrKEtFUk5fQ1JJVCAiREJHOiAlczogQ2FsbGluZyBhc3luY19zeW5jaHJvbml6ZV9mdWxsKClc
biIsIF9fZnVuY19fKTsKKwlhc3luY19zeW5jaHJvbml6ZV9mdWxsKCk7CiAJcHJpbnRrKEtFUk5f
SU5GTyAibWQ6IEF1dG9kZXRlY3RpbmcgUkFJRCBhcnJheXMuXG4iKTsKIAogCXdoaWxlICghbGlz
dF9lbXB0eSgmYWxsX2RldGVjdGVkX2RldmljZXMpICYmIGlfc2Nhbm5lZCA8IElOVF9NQVgpIHsK
IAkJaV9zY2FubmVkKys7CiAJCW5vZGVfZGV0ZWN0ZWRfZGV2ID0gbGlzdF9lbnRyeShhbGxfZGV0
ZWN0ZWRfZGV2aWNlcy5uZXh0LAogCQkJCQlzdHJ1Y3QgZGV0ZWN0ZWRfZGV2aWNlc19ub2RlLCBs
aXN0KTsK
--089e014941f41c819d04eca21d20--
