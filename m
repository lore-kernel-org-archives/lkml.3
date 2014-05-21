Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaEUCNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:13:45 -0400
Received: from imap.devoid-pointer.net ([31.31.77.140]:33081 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaEUCNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:13:44 -0400
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
To: Roland Bosa <rbosa@logitech.com>
Cc: simon@mungewell.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, elias.vds@gmail.com, anssi.hannula@iki.fi
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
Date: Wed, 21 May 2014 04:13:40 +0200
Message-ID: <2643156.2tkLFqgYFg@sigyn>
User-Agent: KMail/4.13.1 (Linux/3.14.1-1-my-rd; KDE/4.13.1; x86_64; ; )
In-Reply-To: <537BFEBF.8010601@logitech.com>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net> <1c6140633925b0838b7627e071e80761.squirrel@mungewell.org> <537BFEBF.8010601@logitech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 of May 2014 18:17:51 Roland Bosa wrote:
> 
> The file format of an IFR is probably easily deducible. There's a lot of
> textual clues to parameters and the values are also written out in
> string form.
> 
> I don't have a FEdit file at hand, but I suppose it will be similar.

I believe that Elias successfully reverse engineered the effect file format 
produced by FEdit. There is no support for this kind of prefabricated effects 
in the Linux FF API.

> > I assume that most AAA games, would implement these through some middle
> > layer. I think that is probably via Steam using SDL2 haptic API, we have
> > been testing against SDL2's 'testhaptic'.
> 
> I wasn't aware of this layer. I must read up on it. It sounds like a
> simple way to access force feedback - I guess a game developer should
> shed some light on this...
>
>
> > Do you see another path (which we should be supporting/testing)?
> 
> Nope, not at this time.
> 
> > There was some discussion about rate limiting the USB packets to the
> > wheel, and how to deal if app updates too quickly. Is there an upper limit
> > for the wheel itself, or is it just the USB 'pipe' which is the limiting
> > factor?
> 
> On the Windows side we send 125 reports/sec. The entire simulation loop
> runs with a 8ms resolution. I assume this value was chosen for some
> hardware constraints back in the days, but it has proven to be a good
> compromise for simulated periodics and physics constraints.

Our current code uses 8 msecs delay as well.

> In any case, the USB traffic should be decoupled from the app. Any force
> updates should only change state in the ff-memless[-next] driver. Any
> change there should trickle down to a 'slot' representation of the
> device. If there's any change in the slots, the device is marked as
> 'dirty' and USB transfers are scheduled to send the latest state to the
> physical device.
> 
> The scheduling should keep track of how many requests are in-flight and
> delay writing the next output, until the previous one has completed.

The approach I had in mind would keep track of the last effect that made it to 
the device and the last effect that arrived from userspace. This would be 
stored for each effect slot. An update would be scheduled at the desired update 
rate. The updating routine would figure out the state change between last 
update and "now", send the required data to the device and reschedule itself. 
The routine could check if there are any USB transfers still running and 
reschedule itself immediately.

> Question back to the community: are there APIs in the USB layer to check
> for presence of in-progress requests? Can one add a 'completion'
> callback to a request, that gets invoked on completion/cancellation?

For instance "usb_submit_urb()" can have a completion handler that is called 
once the transfer is done. The current code uses "hid_hw_request()" which is 
asynchronous and doesn't report anything back.

Proper decoupling of the userspace and driver is the only important thing that 
is missing from the current code.

Michal
