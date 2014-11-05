Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaKEMAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:00:01 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:59795 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbaKEL76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:59:58 -0500
Date: Wed, 5 Nov 2014 12:56:43 +0100
From: Johan Hovold <johan@kernel.org>
To: Nix <nix@esperi.org.uk>
Cc: Johan Hovold <johan@kernel.org>, Paul Martin <pm@debian.org>,
        Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm)
 broken in 3.16
Message-ID: <20141105115643.GR31358@localhost>
References: <20141011195108.GA8275@thinkpad.nowster.org.uk>
 <87y4smz1l0.fsf@spindle.srvr.nix>
 <20141012185845.GB2786@localhost>
 <878uklynq9.fsf@spindle.srvr.nix>
 <20141014083432.GB7958@localhost>
 <871tq04fiy.fsf@spindle.srvr.nix>
 <20141022101458.GK2113@localhost>
 <87y4s8yv38.fsf@spindle.srvr.nix>
 <20141024111442.GA19377@localhost>
 <87d298i3y9.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d298i3y9.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 04:44:46PM +0000, Nix wrote:
> Sorry for the delay: illness and work-related release time flurries.
> 
> On 24 Oct 2014, Johan Hovold told this:
> 
> > [ +CC: linux-usb ]
> >
> > On Wed, Oct 22, 2014 at 04:36:59PM +0100, Nix wrote:
> >> On 22 Oct 2014, Johan Hovold outgrape:
> >> 
> >> > On Wed, Oct 22, 2014 at 10:31:17AM +0100, Nix wrote:
> >> >> On 14 Oct 2014, Johan Hovold verbalised:
> >> >> 
> >> >> > On Sun, Oct 12, 2014 at 10:36:30PM +0100, Nix wrote:
> >> >> >> I have checked: this code is being executed against a symlink that
> >> >> >> points to /dev/ttyACM0, and the tcsetattr() succeeds. (At least, it's
> >> >> >> succeeding on the kernel I'm running now, but of course that's 3.16.5
> >> >> >> with this commit reverted...)
> >> >> >
> >> >> > You could verify that by enabling debugging in the cdc-acm driver and
> >> >> > making sure that the corresponding control messages are indeed sent on
> >> >> > close.
> >> >> 
> >> >> I have a debugging dump at
> >> >> <http://www.esperi.org.uk/~nix/temporary/cdc-acm.log>; it's fairly
> >> >
> >> > What kernel were you using here? The log seems to suggest that it was
> >> > generated with the commit in question reverted.
> >> 
> >> Look now :) (the previous log is still there in cdc-acm-reverted.log.)
> >
> > Unfortunately, it seems the logs are incomplete. There are lots of
> > entries missing (e.g. "acm_tty_install" when opening, but also some
> > "acm_submit_read_urb"), some of which were there in your first log.
> 
> OK. What we have now in
> <http://www.esperi.org.uk/~nix/temporary/cdc-acm.log> is a log from the
> pristine upstream 3.16.6 kernel with cdc-acm debugging turned on and the
> acm_tty_write - count stuff in acm_tty_write() disabled: I've increased
> the dmesg buffer size so the top isn't being cut off any more. It took a
> lot of boots for it to fail this time: about a dozen. The log contains
> the boot that failed and the one before.
> 
> (To my uneducated eye, the initial traffic to/from the key looks *very*
> different in the second boot. Something is clearly wrong by this point,
> but that's not much of a surprise!)

The log appears incomplete again, this time it seems the last part is
completely missing (the device is never closed for example). The device
still seems to be responding.

> >> This contains two boots -- one on which the USB key worked, and the next
> >> (with an identical kernel) with which the key was broken. (I'm not sure
> >> whether this problem happens at startup or shutdown time, so it seemed
> >> best to provide both.)
> >
> > That's a good idea.
> >
> > Is it only after reboot you've seen the device fail?
> 
> So far.
> 
> >                                                      What if you
> > physically disconnect and reconnect the device instead, or simply
> 
> That fixes it, in fact it's the only way to fix it once it's broken by
> this bug.

I didn't mean whether it would get the device working again, but rather
whether you could kill it this way.

> > repeatedly open and close it?
> 
> Hm. Good idea.

Same here, but the below test was also informative.
 
> ... no, that doesn't help. Additional log from that shows a lot of what
> looks like error returns:
> 
> Oct 31 16:38:03 fold kern debug: : [  168.135213] cdc_acm 2-1:1.0: acm_tty_close
> Oct 31 16:38:08 fold kern debug: : [  173.130531] cdc_acm 2-1:1.0: acm_ctrl_msg - rq 0x22, val 0x0, len 0x0, result -110

Yeah, it seems your device firmware has crashed. It stops responding to
control requests.

> Oct 31 16:38:08 fold kern debug: : [  173.130557] cdc_acm 2-1:1.0: acm_port_shutdown
> Oct 31 16:38:08 fold kern debug: : [  173.131475] cdc_acm 2-1:1.0: acm_ctrl_irq - urb shutting down with status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.132474] cdc_acm 2-1:1.1: acm_write_bulk - len 0/1, status -2
> Oct 31 16:38:08 fold kern debug: : [  173.132519] cdc_acm 2-1:1.1: acm_softint
> Oct 31 16:38:08 fold kern debug: : [  173.133473] cdc_acm 2-1:1.1: acm_write_bulk - len 0/1, status -2
> Oct 31 16:38:08 fold kern debug: : [  173.133510] cdc_acm 2-1:1.1: acm_softint
> Oct 31 16:38:08 fold kern debug: : [  173.134471] cdc_acm 2-1:1.1: acm_write_bulk - len 0/1, status -2
> Oct 31 16:38:08 fold kern debug: : [  173.134507] cdc_acm 2-1:1.1: acm_softint
> Oct 31 16:38:08 fold kern debug: : [  173.135471] cdc_acm 2-1:1.1: acm_write_bulk - len 0/1, status -2
> Oct 31 16:38:08 fold kern debug: : [  173.135509] cdc_acm 2-1:1.1: acm_softint
> Oct 31 16:38:08 fold kern debug: : [  173.136472] cdc_acm 2-1:1.1: acm_write_bulk - len 0/1, status -2
> Oct 31 16:38:08 fold kern debug: : [  173.136507] cdc_acm 2-1:1.1: acm_softint
> Oct 31 16:38:08 fold kern debug: : [  173.137471] cdc_acm 2-1:1.1: acm_write_bulk - len 0/1, status -2
> Oct 31 16:38:08 fold kern debug: : [  173.137517] cdc_acm 2-1:1.1: acm_softint
> Oct 31 16:38:08 fold kern debug: : [  173.138471] cdc_acm 2-1:1.1: acm_write_bulk - len 0/1, status -2
> Oct 31 16:38:08 fold kern debug: : [  173.138520] cdc_acm 2-1:1.1: acm_softint
> Oct 31 16:38:08 fold kern debug: : [  173.139469] cdc_acm 2-1:1.1: acm_write_bulk - len 0/1, status -2
> Oct 31 16:38:08 fold kern debug: : [  173.139515] cdc_acm 2-1:1.1: acm_softint
> Oct 31 16:38:08 fold kern debug: : [  173.140470] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 0, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.140491] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.141469] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 1, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.141489] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.142469] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 2, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.142490] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.143468] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 3, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.143488] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.144468] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 4, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.144488] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.145467] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 5, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.145488] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.146467] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 6, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.146487] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.147477] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 7, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.147498] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.153496] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 8, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.153524] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.154468] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 9, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.154489] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.155466] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 10, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.155487] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.156466] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 11, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.156487] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.157466] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 12, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.157487] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.158466] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 13, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.158486] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.159465] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 14, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.159486] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.160475] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 15, len 0
> Oct 31 16:38:08 fold kern debug: : [  173.160496] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 31 16:38:08 fold kern debug: : [  173.160567] tty ttyACM0: acm_tty_open
> Oct 31 16:38:08 fold kern debug: : [  173.160588] cdc_acm 2-1:1.0: acm_port_activate
> Oct 31 16:38:08 fold kern debug: : [  173.160626] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 0
> Oct 31 16:38:08 fold kern debug: : [  173.160651] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 1
> Oct 31 16:38:08 fold kern debug: : [  173.160674] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 2
> Oct 31 16:38:08 fold kern debug: : [  173.160796] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 3
> Oct 31 16:38:08 fold kern debug: : [  173.160820] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 4
> Oct 31 16:38:08 fold kern debug: : [  173.160842] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 5
> Oct 31 16:38:08 fold kern debug: : [  173.160863] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 6
> Oct 31 16:38:08 fold kern debug: : [  173.160884] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 7
> Oct 31 16:38:08 fold kern debug: : [  173.160906] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 8
> Oct 31 16:38:08 fold kern debug: : [  173.160927] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 9
> Oct 31 16:38:08 fold kern debug: : [  173.160948] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 10
> Oct 31 16:38:08 fold kern debug: : [  173.160969] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 11
> Oct 31 16:38:08 fold kern debug: : [  173.160991] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 12
> Oct 31 16:38:08 fold kern debug: : [  173.161012] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 13
> Oct 31 16:38:08 fold kern debug: : [  173.161033] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 14
> Oct 31 16:38:08 fold kern debug: : [  173.161054] cdc_acm 2-1:1.1: acm_submit_read_urb - urb 15

The above is all normal, but

> Oct 31 16:38:08 fold kern debug: : [  173.161489] cdc_acm 2-1:1.0: acm_ctrl_msg - rq 0x22, val 0x3, len 0x0, result -62

here's another timeout. It's dead.

Did you get anywhere with trying to look at the device firmware?

Johan
