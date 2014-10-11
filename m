Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaJKTGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 15:06:00 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:49156 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaJKTF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 15:05:59 -0400
From: Nix <nix@esperi.org.uk>
To: Oliver Neukum <oliver@neukum.org>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Martin <pm@debian.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
References: <878um4tg09.fsf@spindle.srvr.nix>
	<1409569752.24385.12.camel@linux-fkkt.site>
	<874mwnosz1.fsf@spindle.srvr.nix>
Emacs: is that a Lisp interpreter in your editor, or are you just happy to see me?
Date: Sat, 11 Oct 2014 20:05:46 +0100
In-Reply-To: <874mwnosz1.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of
	"Fri, 05 Sep 2014 00:40:02 +0100")
Message-ID: <871tqe2zqt.fsf_-_@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc:ed someone who knows the people behind the Entropy Key: they're not
 being manufactured at the moment, but he might want to know anyway]

On 5 Sep 2014, nix@esperi.org.uk stated:

> On 1 Sep 2014, Oliver Neukum stated:
>
>>> I'll do a bisection of the cdc-acm changes since 3.15 tomorrow night and
>>> see if I can find the commit at fault.
>>
>> Thank you for the report. Please let me know the results of your
>> bisection.
>
> Bisection underway (fifth attempt -- I *may* have characterized it well
> enough after a few hours of thrashing at it to bisect accurately this
> time).
[...]
> More generally, the problem may be at *shutdown* -- something goes wrong
> during link suspension or something, such that the link never comes up
> again until physically reconnected. So a straight bisect is misleading
> -- the error may have been in the *last* kernel tested -- and even then,
> some kernels (e.g. the 3.15.0 merge base) appear capable of making it
> work fine. But even this is not consistent: sometimes a kernel that
> works fine if you repeatedly reboot it (such as 3.15) malfunctions when
> you reboot into 3.16 -- but sometimes a newly plugged USB key on a 3.16
> kernel malfunctions upon reboot, even if you reboot into a working
> kernel such as 3.15 (and it then proceeds to work indefinitely if you
> unplug and replug it and stick with 3.15.x, but upon rebooting into
> 3.16.x it goes wrong again).

*Finally* bisected, not helped by the fact that I sometimes needed up to
five reboots (!) to see a failure. The guilty commit is this one:

commit 0943d8ead30e9474034cc5e92225ab0fd29fd0d4
Author: Johan Hovold <jhovold@gmail.com>
Date:   Mon May 26 19:23:51 2014 +0200

    USB: cdc-acm: use tty-port dtr_rts

    Add dtr_rts tty-port operation which implements proper DTR/RTS handling
    (e.g. only lower DTR/RTS during shutdown if HUPCL is set).

    Note that modem-control locking still needs to be added throughout the
    driver.

    Signed-off-by: Johan Hovold <jhovold@gmail.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

To re-describe this failure for the people who weren't in the thread: in
3.16.x I often see this output when asking the ekey daemon for the state
of my Simtec Entropy Key (a cdc-acm-based random number generator) after
rebooting my ohci-based Soekris net5501:

fold:~# ekeydctl stats 1
BytesRead=0
BytesWritten=0
ConnectionNonces=0
ConnectionPackets=0
ConnectionRekeys=0
ConnectionResets=0
ConnectionTime=65
EntropyRate=0
FipsFrameRate=0
FrameByteLast=0
FramesOk=0
FramingErrors=0
KeyDbsdShannonPerByteL=0
KeyDbsdShannonPerByteR=0
KeyEnglishBadness=No failure
KeyRawBadness=0
KeyRawShannonPerByteL=0
KeyRawShannonPerByteR=0
KeyRawShannonPerByteX=0
KeyShortBadness=efm_ok
KeyTemperatureC=-273.15
KeyTemperatureF=-459.67
KeyTemperatureK=0
KeyVoltage=0
PacketErrors=0
PacketOK=0
ReadRate=0
TotalEntropy=0
WriteRate=0

This device streams data continuously at at rate of several KiB/s, so
normally we would never expect to see a report of zero bytes read or
written if the key were functional (nor, indeed, a key temperature of
absolute zero!). This failure never occurred in 3.15.x nor any earlier
kernel. (Note: the 'no failure' message above is sent *from the key* to
indicate that the random numbers can be trusted: it is a bit unfortunate
that the code for 'No failure' is 0, which is also the default value
before anything is received from the key. In this case, we're just
seeing the daemon's initialization-time default. As BytesRead indicates,
the key is not talking to us.)

The symptoms are such that it is the kernel you reboot *from* that
causes the failure, not the one you reboot into: once the key fails it
never recovers without physical removal and reinsertion (or, one
presumes, a poweroff of the whole machine, but I haven't tried that)

This is not a consistent failure: sometimes it can take up to four
reboots for the key to fail. As a result, the bisection took forever (I
had to wait until I had a spare weekend day to devote to it). Despite
the errative nature, I'm fairly confident this commit is at fault: with
it reverted, I have restarted a couple of dozen times without failure
symptoms.

(I speculate that the device's firmware may be terminally confused by
having something try to hang it up, since it's not a modem nor anything
like one, as the boot messages correctly proclaim. The firmware isn't
open, so I can't check.)
