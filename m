Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbaIDXkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 19:40:09 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:34108 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaIDXkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 19:40:08 -0400
From: Nix <nix@esperi.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
References: <878um4tg09.fsf@spindle.srvr.nix>
	<1409569752.24385.12.camel@linux-fkkt.site>
Emacs: the road to Hell is paved with extensibility.
Date: Fri, 05 Sep 2014 00:40:02 +0100
In-Reply-To: <1409569752.24385.12.camel@linux-fkkt.site> (Oliver Neukum's
	message of "Mon, 01 Sep 2014 13:09:12 +0200")
Message-ID: <874mwnosz1.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-dcc1-Metrics: spindle 1182; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 Sep 2014, Oliver Neukum stated:

>
>> I'll do a bisection of the cdc-acm changes since 3.15 tomorrow night and
>> see if I can find the commit at fault.
>
> Thank you for the report. Please let me know the results of your
> bisection.

Bisection underway (fifth attempt -- I *may* have characterized it well
enough after a few hours of thrashing at it to bisect accurately this
time).

Some more random info.

btw, when the Entropy Key has ended up in a messed up state due to this
bug, we sometimes see

[    2.330158] usb 2-1: new full-speed USB device number 2 using ohci-pci
[    2.552465] usb 2-1: device descriptor read/64, error -62
[    2.870142] usb 2-1: device descriptor read/64, error -62
[    3.190150] usb 2-1: new full-speed USB device number 3 using ohci-pci
[    3.410137] usb 2-1: device descriptor read/64, error -62
[    3.740142] usb 2-1: device descriptor read/64, error -62
[    4.060146] usb 2-1: new full-speed USB device number 4 using ohci-pci
[    4.520133] usb 2-1: device not accepting address 4, error -62
[    4.730139] usb 2-1: new full-speed USB device number 5 using ohci-pci
[    5.180117] usb 2-1: device not accepting address 5, error -62
[    5.215194] hub 2-0:1.0: unable to enumerate USB device on port 1

when starting up a working kernel (the key then doesn't work until
physically disconnected and reconnected again).

More generally, the problem may be at *shutdown* -- something goes wrong
during link suspension or something, such that the link never comes up
again until physically reconnected. So a straight bisect is misleading
-- the error may have been in the *last* kernel tested -- and even then,
some kernels (e.g. the 3.15.0 merge base) appear capable of making it
work fine. But even this is not consistent: sometimes a kernel that
works fine if you repeatedly reboot it (such as 3.15) malfunctions when
you reboot into 3.16 -- but sometimes a newly plugged USB key on a 3.16
kernel malfunctions upon reboot, even if you reboot into a working
kernel such as 3.15 (and it then proceeds to work indefinitely if you
unplug and replug it and stick with 3.15.x, but upon rebooting into
3.16.x it goes wrong again).

So sometimes a faulty kernel makes the key go wrong when you restart
into another kernel (faulty or not), and sometimes it makes a key go
wrong when it is restarted into. There doesn't seem to be any
consistency to this that I've spotted, at least not yet.

Upon physical reconnection, the USB key works again, even on afflicted
kernels.

I'm working around this confusing morass by rebooting into each test
kernel, unplugging and replugging the entropy key if it was fubared,
then rebooting into the same kernel again and seeing if it was still
fubared. But this is not terribly fast, particularly not on a headless
compact-flash-based Geode box which doesn't even complete booting
without the entropy source which this bug cuts off :) so it'll be
sometime tomorrow before I can get this bisection done, I'm afraid.
