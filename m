Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbaJVKSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:18:04 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:60086 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbaJVKSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:18:01 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 22 Oct 2014 12:14:58 +0200
From: Johan Hovold <johan@kernel.org>
To: Nix <nix@esperi.org.uk>
Cc: Johan Hovold <johan@kernel.org>, Paul Martin <pm@debian.org>,
        Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm)
 broken in 3.16
Message-ID: <20141022101458.GK2113@localhost>
References: <878um4tg09.fsf@spindle.srvr.nix>
 <1409569752.24385.12.camel@linux-fkkt.site>
 <874mwnosz1.fsf@spindle.srvr.nix>
 <871tqe2zqt.fsf_-_@spindle.srvr.nix>
 <20141011195108.GA8275@thinkpad.nowster.org.uk>
 <87y4smz1l0.fsf@spindle.srvr.nix>
 <20141012185845.GB2786@localhost>
 <878uklynq9.fsf@spindle.srvr.nix>
 <20141014083432.GB7958@localhost>
 <871tq04fiy.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871tq04fiy.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:31:17AM +0100, Nix wrote:
> On 14 Oct 2014, Johan Hovold verbalised:
> 
> > On Sun, Oct 12, 2014 at 10:36:30PM +0100, Nix wrote:
> >> I have checked: this code is being executed against a symlink that
> >> points to /dev/ttyACM0, and the tcsetattr() succeeds. (At least, it's
> >> succeeding on the kernel I'm running now, but of course that's 3.16.5
> >> with this commit reverted...)
> >
> > You could verify that by enabling debugging in the cdc-acm driver and
> > making sure that the corresponding control messages are indeed sent on
> > close.
> 
> I have a debugging dump at
> <http://www.esperi.org.uk/~nix/temporary/cdc-acm.log>; it's fairly

What kernel were you using here? The log seems to suggest that it was
generated with the commit in question reverted.

> voluminous because the ekeyd is constantly doing USB reads, but the end
> says

You can enable debugging selectively using the debugfs control file of
dynamic debug, see:

	Documentation/dynamic-debug-howto.txt

> Oct 22 10:19:13 fold kern debug: : [   88.423970] cdc_acm 2-1:1.0: acm_tty_close
> Oct 22 10:19:13 fold kern debug: : [   88.424012] cdc_acm 2-1:1.0: acm_port_shutdown
> Oct 22 10:19:13 fold kern debug: : [   88.440038] cdc_acm 2-1:1.0: acm_ctrl_msg - rq 0x22, val 0x0, len 0x0, result 0

So DTR/RTS is indeed lowered (i.e. HUPCL is set).

> Oct 22 10:19:13 fold kern debug: : [   88.440038] cdc_acm 2-1:1.0: acm_ctrl_irq - urb shutting down with status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.440038] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 0, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.440038] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.447588] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 1, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.447613] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.448575] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 2, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.448599] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.449576] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 3, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.449599] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.450578] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 4, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.450602] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.451573] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 5, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.451596] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.452574] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 6, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.452597] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.453567] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 7, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.453588] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.454570] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 8, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.454592] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.462591] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 9, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.462619] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.463568] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 10, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.463590] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.464564] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 11, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.464585] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.465578] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 12, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.465602] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> Oct 22 10:19:13 fold kern debug: : [   88.466566] cdc_acm 2-1:1.1: acm_read_bulk_callback - urb 13, len 0
> Oct 22 10:19:13 fold kern debug: : [   88.466587] cdc_acm 2-1:1.1: acm_read_bulk_callback - non-zero urb status: -2
> 
> which looks, hm, a bit suspicious to me.

That's normal, it's just the urbs being killed (stopped) at close.

> > But you haven't seen any fw crashes since you reverted the commit in
> > question?
> 
> Not a one.
> 
> > Another thing you could try is to add back the 
> >
> > 	acm_set_control(acm, 0);
> >
> > just after the dev_info message in probe.
> 
> Tried that (with, obviously, the commit not reverted) -- rebooted, and
> 
> BytesRead=0
> BytesWritten=0
> ConnectionNonces=0
> ConnectionPackets=0
> ConnectionRekeys=0
> ConnectionResets=0
> ConnectionTime=46
> EntropyRate=0
> FipsFrameRate=0
> FrameByteLast=0
> FramesOk=0
> FramingErrors=0
> KeyDbsdShannonPerByteL=0
> KeyDbsdShannonPerByteR=0
> KeyEnglishBadness=No failure
> KeyRawBadness=0
> KeyRawShannonPerByteL=0
> KeyRawShannonPerByteR=0
> KeyRawShannonPerByteX=0
> KeyShortBadness=efm_ok
> KeyTemperatureC=-273.15
> KeyTemperatureF=-459.67
> KeyTemperatureK=0
> KeyVoltage=0
> PacketErrors=0
> PacketOK=0
> ReadRate=0
> TotalEntropy=0
> WriteRate=0
> 
> So that doesn't help.

Good to know. It was a bit of a long shot.

It seems the only thing that have changed then is that DTR/RTS is now
raised after the read urbs have been submitted during open (rather than
after the ctrlurb was submitted).

Perhaps this slight change in timing causes the device to misbehave
occasionally.

What kernel version are you using? And do you have autosuspend enabled?

Johan
