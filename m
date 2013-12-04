Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3LDXB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:01:57 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:44086 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab3LDXBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:01:55 -0500
MIME-Version: 1.0
In-Reply-To: <20131203151953.GK8277@htj.dyndns.org>
References: <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
	<CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
	<20130116025251.GM2668@htj.dyndns.org>
	<20130812070411.GA2878@elie.Belkin>
	<20130812150900.GJ15892@htj.dyndns.org>
	<CAKA=qzY5NBZSv8r9sHqX-3fY-yrSXq26zPM1AvjoANaZkqJavQ@mail.gmail.com>
	<CA+55aFw9wNBoJBYQ+kjpqs6cnVjGHVs2oxfguMmyYXNPcqqzkQ@mail.gmail.com>
	<CAKA=qzY2JYxbO=0s8_SnUn-8b=1+RqsdAzXQhfHYxo1isv0K-g@mail.gmail.com>
	<20131126222945.GC8588@mtj.dyndns.org>
	<CAKA=qzbyPxU8sBRbYzL61VS6R_o5p+2RdPogJ0nOmQ8NBi2GSA@mail.gmail.com>
	<20131203151953.GK8277@htj.dyndns.org>
Date: Wed, 4 Dec 2013 17:01:53 -0600
Message-ID: <CAKA=qzbFU_Mwra4z=KENUkJuG-o6y11_2Pc1H159uiWi1ooEaA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary=047d7b3a81ce29bca004ecbd6634
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b3a81ce29bca004ecbd6634
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Dec 3, 2013 at 9:19 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Dec 03, 2013 at 08:28:43AM -0600, Josh Hunt wrote:
>> You're right. Thanks for pointing this out. I did not realize there
>> was a bug in the init script. The version of initramfs-tools I was
>> using had the following bug:
>> https://bugs.launchpad.net/ubuntu/+source/initramfs-tools/+bug/1215911
>>
>> Updating to 0.99ubuntu13.4 of initramfs-tools resolved my boot hangs.
>>
>> I did try using the workaround as suggested by Linus. In my setup the
>> dm_init() code was hit, however it still appeared to be too late at
>> times. I also tried moving the call to async_synchronize_full() above
>> the for loop and it still had the same issue (patch attached.) Out of
>> around 10 reboot tests it failed to find root 1 or 2 times.
>>
>> The ubuntu scripts don't ever actually call do_mount() if it can't
>> find the device. It seems to rely on some udev functionality to tell
>> it when the device is present, and if that fails it just bails out.
>>
>> This change has introduced a regression. However, I only noticed it
>> b/c my init script had a bug which caused it not to wait around for
>> the device to appear.
>
> Hmmm.... so, read the bug report, digged and asked around a bit.
> Here's the root problem - ubuntu's initramfs uses a tool to wait for
> the root device which uses libudev to listen for the device event;
> unfortunately, its rx buffer is not set large enough and the receiver
> isn't fast enough, which means that netlink broadcast messages from
> the kernel can overrun the buffer.  When that happens, it sets an
> error on the socket, so the next recv fails with -ENOBUFS.  If that
> happens, the wait for root aborts immediately and initramfs proceeds
> to mount non-existent root device.
>
> The only thing which changes by these patches is the timing of events.
> The problem likely wasn't as exposed before because things were slow
> enough so that either the messages could be consumed fast enough or
> there's enough delay between libata module load and the root device
> wait hiding the bug in the wait logic.
>
> So, yeah, it's a full blown timing bug.  I'm not sure what we can do
> to work around from kernel side except for randomly slowing things
> down or forcefully enlarging rx buffer size.  There really is no
> interlocking to take advantage of. :(

So there used to be a call to async_synchronize_full() in
ata_host_register(), but it was removed by
f29d3b23238e1955a8094e038c72546e99308e61 as part of some fastboot
changes. Adding it back (in the attached patch) seems to resolve the
issue when using the broken initrd. I'm guessing adding it back isn't
an option, but I wanted to point it out.

-- 
Josh

--047d7b3a81ce29bca004ecbd6634
Content-Type: text/x-patch; charset=US-ASCII; name="dbg-ata.patch"
Content-Disposition: attachment; filename="dbg-ata.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hot6hlu70

SW5kZXg6IGIvZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYwo9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBhL2RyaXZl
cnMvYXRhL2xpYmF0YS1jb3JlLmMKKysrIGIvZHJpdmVycy9hdGEvbGliYXRhLWNvcmUuYwpAQCAt
NjE4MSwxMiArNjE4MSwxNCBAQCBpbnQgYXRhX2hvc3RfcmVnaXN0ZXIoc3RydWN0IGF0YV9ob3N0
ICpoCiAJLyogcGVyZm9ybSBlYWNoIHByb2JlIGFzeW5jaHJvbm91c2x5ICovCiAJZm9yIChpID0g
MDsgaSA8IGhvc3QtPm5fcG9ydHM7IGkrKykgewogCQlzdHJ1Y3QgYXRhX3BvcnQgKmFwID0gaG9z
dC0+cG9ydHNbaV07CiAJCWFzeW5jX3NjaGVkdWxlKGFzeW5jX3BvcnRfcHJvYmUsIGFwKTsKIAl9
CiAKKwlhc3luY19zeW5jaHJvbml6ZV9mdWxsKCk7CisKIAlyZXR1cm4gMDsKIAogIGVycl90YWRk
OgogCXdoaWxlICgtLWkgPj0gMCkgewogCQlhdGFfdHBvcnRfZGVsZXRlKGhvc3QtPnBvcnRzW2ld
KTsKIAl9Cg==
--047d7b3a81ce29bca004ecbd6634--
