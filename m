Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3LCPT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:19:59 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:58485 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3LCPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:19:57 -0500
Date: Tue, 3 Dec 2013 10:19:53 -0500
From: Tejun Heo <tj@kernel.org>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [3.8-rc3 -> 3.8-rc4 regression] Re: [PATCH] module, async:
 async_synchronize_full() on module init iff async is used
Message-ID: <20131203151953.GK8277@htj.dyndns.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzbyPxU8sBRbYzL61VS6R_o5p+2RdPogJ0nOmQ8NBi2GSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 03, 2013 at 08:28:43AM -0600, Josh Hunt wrote:
> You're right. Thanks for pointing this out. I did not realize there
> was a bug in the init script. The version of initramfs-tools I was
> using had the following bug:
> https://bugs.launchpad.net/ubuntu/+source/initramfs-tools/+bug/1215911
> 
> Updating to 0.99ubuntu13.4 of initramfs-tools resolved my boot hangs.
> 
> I did try using the workaround as suggested by Linus. In my setup the
> dm_init() code was hit, however it still appeared to be too late at
> times. I also tried moving the call to async_synchronize_full() above
> the for loop and it still had the same issue (patch attached.) Out of
> around 10 reboot tests it failed to find root 1 or 2 times.
> 
> The ubuntu scripts don't ever actually call do_mount() if it can't
> find the device. It seems to rely on some udev functionality to tell
> it when the device is present, and if that fails it just bails out.
> 
> This change has introduced a regression. However, I only noticed it
> b/c my init script had a bug which caused it not to wait around for
> the device to appear.

Hmmm.... so, read the bug report, digged and asked around a bit.
Here's the root problem - ubuntu's initramfs uses a tool to wait for
the root device which uses libudev to listen for the device event;
unfortunately, its rx buffer is not set large enough and the receiver
isn't fast enough, which means that netlink broadcast messages from
the kernel can overrun the buffer.  When that happens, it sets an
error on the socket, so the next recv fails with -ENOBUFS.  If that
happens, the wait for root aborts immediately and initramfs proceeds
to mount non-existent root device.

The only thing which changes by these patches is the timing of events.
The problem likely wasn't as exposed before because things were slow
enough so that either the messages could be consumed fast enough or
there's enough delay between libata module load and the root device
wait hiding the bug in the wait logic.

So, yeah, it's a full blown timing bug.  I'm not sure what we can do
to work around from kernel side except for randomly slowing things
down or forcefully enlarging rx buffer size.  There really is no
interlocking to take advantage of. :(

Thanks.

-- 
tejun
