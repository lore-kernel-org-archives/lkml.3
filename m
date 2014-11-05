Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaKEPPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:15:02 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:34187 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbaKEPPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:15:00 -0500
From: Nix <nix@esperi.org.uk>
To: Johan Hovold <johan@kernel.org>
Cc: Paul Martin <pm@debian.org>, Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
References: <20141011195108.GA8275@thinkpad.nowster.org.uk>
	<87y4smz1l0.fsf@spindle.srvr.nix> <20141012185845.GB2786@localhost>
	<878uklynq9.fsf@spindle.srvr.nix> <20141014083432.GB7958@localhost>
	<871tq04fiy.fsf@spindle.srvr.nix> <20141022101458.GK2113@localhost>
	<87y4s8yv38.fsf@spindle.srvr.nix> <20141024111442.GA19377@localhost>
	<87d298i3y9.fsf@spindle.srvr.nix> <20141105115643.GR31358@localhost>
Emacs: ed  ::  20-megaton hydrogen bomb : firecracker
Date: Wed, 05 Nov 2014 15:14:49 +0000
In-Reply-To: <20141105115643.GR31358@localhost> (Johan Hovold's message of
	"Wed, 5 Nov 2014 12:56:43 +0100")
Message-ID: <87vbmtbrx2.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=7 Fuz1=7 Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Nov 2014, Johan Hovold stated:

> On Fri, Oct 31, 2014 at 04:44:46PM +0000, Nix wrote:
>> Sorry for the delay: illness and work-related release time flurries.
>> 
>> On 24 Oct 2014, Johan Hovold told this:
>> 
>> > [ +CC: linux-usb ]
>> >
>> > On Wed, Oct 22, 2014 at 04:36:59PM +0100, Nix wrote:
>> >> On 22 Oct 2014, Johan Hovold outgrape:
>> >> 
>> >> > On Wed, Oct 22, 2014 at 10:31:17AM +0100, Nix wrote:
>> >> >> On 14 Oct 2014, Johan Hovold verbalised:
>> >> >> 
>> >> >> > On Sun, Oct 12, 2014 at 10:36:30PM +0100, Nix wrote:
>> >> >> >> I have checked: this code is being executed against a symlink that
>> >> >> >> points to /dev/ttyACM0, and the tcsetattr() succeeds. (At least, it's
>> >> >> >> succeeding on the kernel I'm running now, but of course that's 3.16.5
>> >> >> >> with this commit reverted...)
>> >> >> >
>> >> >> > You could verify that by enabling debugging in the cdc-acm driver and
>> >> >> > making sure that the corresponding control messages are indeed sent on
>> >> >> > close.
>> >> >> 
>> >> >> I have a debugging dump at
>> >> >> <http://www.esperi.org.uk/~nix/temporary/cdc-acm.log>; it's fairly
>> >> >
>> >> > What kernel were you using here? The log seems to suggest that it was
>> >> > generated with the commit in question reverted.
>> >> 
>> >> Look now :) (the previous log is still there in cdc-acm-reverted.log.)
>> >
>> > Unfortunately, it seems the logs are incomplete. There are lots of
>> > entries missing (e.g. "acm_tty_install" when opening, but also some
>> > "acm_submit_read_urb"), some of which were there in your first log.
>> 
>> OK. What we have now in
>> <http://www.esperi.org.uk/~nix/temporary/cdc-acm.log> is a log from the
>> pristine upstream 3.16.6 kernel with cdc-acm debugging turned on and the
>> acm_tty_write - count stuff in acm_tty_write() disabled: I've increased
>> the dmesg buffer size so the top isn't being cut off any more. It took a
>> lot of boots for it to fail this time: about a dozen. The log contains
>> the boot that failed and the one before.
>> 
>> (To my uneducated eye, the initial traffic to/from the key looks *very*
>> different in the second boot. Something is clearly wrong by this point,
>> but that's not much of a surprise!)
>
> The log appears incomplete again, this time it seems the last part is
> completely missing (the device is never closed for example). The device
> still seems to be responding.

Nope -- by the time I clipped the log, the device was definitely
nonresponsive.

I've appended the remaining log, just in case. This is the same as the
snapshot I added to the email itself last time: a close-and-open as I
tried restarting the daemon, and another close as part of system
shutdown.

>> >                                                      What if you
>> > physically disconnect and reconnect the device instead, or simply
>> 
>> That fixes it, in fact it's the only way to fix it once it's broken by
>> this bug.
>
> I didn't mean whether it would get the device working again, but rather
> whether you could kill it this way.

Never seen it fail after a physical disconnection.

>> ... no, that doesn't help. Additional log from that shows a lot of what
>> looks like error returns:
>> 
>> Oct 31 16:38:03 fold kern debug: : [  168.135213] cdc_acm 2-1:1.0: acm_tty_close
>> Oct 31 16:38:08 fold kern debug: : [  173.130531] cdc_acm 2-1:1.0: acm_ctrl_msg - rq 0x22, val 0x0, len 0x0, result -110
>
> Yeah, it seems your device firmware has crashed. It stops responding to
> control requests.

Not surprising: I was fairly sure we were provoking a key firmware crash
or something like that. This is a device with no support for flow
control at all, after all, so I'm not terribly surprised that trying to
do flow control confuses it.

> The above is all normal, but
>
>> Oct 31 16:38:08 fold kern debug: : [  173.161489] cdc_acm 2-1:1.0: acm_ctrl_msg - rq 0x22, val 0x3, len 0x0, result -62
>
> here's another timeout. It's dead.

Again, not surprising.

> Did you get anywhere with trying to look at the device firmware?

Look at it? Only Daniel Silverstone (Cc:ed) can do that. The only copy
of the firmware I have is baked into the sealed key. :)

-- 
NULL && (void)
