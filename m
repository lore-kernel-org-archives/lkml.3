Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaEUBSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 21:18:01 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:42634 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbaEUBR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 21:17:58 -0400
Message-ID: <537BFEBF.8010601@logitech.com>
Date: Tue, 20 May 2014 18:17:51 -0700
From: Roland Bosa <rbosa@logitech.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: simon@mungewell.org
CC: =?ISO-8859-1?Q?Michal_Mal=FD?= <madcatxster@devoid-pointer.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jkosina@suse.cz, elias.vds@gmail.com, anssi.hannula@iki.fi
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>    <1818063.tFLKhAd1oy@sigyn>    <20140514180558.GB30089@core.coreip.homeip.net>    <2965006.XKYHWj9YzJ@sigyn> <537B9FAE.9070602@logitech.com>    <8c45868c3cd4333d1098bdbc0fa83a2e.squirrel@mungewell.org>    <537BD184.9090608@logitech.com> <1c6140633925b0838b7627e071e80761.squirrel@mungewell.org>
In-Reply-To: <1c6140633925b0838b7627e071e80761.squirrel@mungewell.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 04:30 PM, simon@mungewell.org wrote:
> Sounds like these are the effect files produced by FEdit tool (from MS
> DirectX SDK), and/or played back by pressing buttons when configuring the
> Logitech driver on Windows ('wooden bridge', etc)...

Prior to the FEdit tool, there was Immersion Studio [1]. It created IFR
files, which were read using a DLL that Immersion provided. This DLL
produced arrays of DIEFFECTs, which had specific durations and start
offsets. By starting the entire array, you would get the desired effect.
Most of the original effects in the Logitech Control Panel were done
that way (by yours truly, as a matter of fact). To "sell" the effect, a
sound-effect was queued concurrently with the force effect.

(Trivia: part of the "Wooden bridge" sound effect was made by smashing a
cigarette lighter against real wooden clogs of a co-worker, then slowing
down the audio a bit.)

In 2003, all of these effects were 'hardcoded' in a series of arrays of
arrays of DI_EFFECTs. This allowed us to drop the Immersion loader DLL
and create them on the fly.

> Do you know if there is a mechanism for playing these under Linux?

I don't - I'm fairly new to the Linux platform itself.

> Under Windows do games just send a 'file' the DirectX driver, or do they
> parse them into individual effects to send?

With the IFR approach, you call a function in a library in userland with
the filename, and it returns an array of effects. With the FEdit tool,
you call a function on the IDirectInputDevice and calls a given callback
the the loaded effects.[2]

At the end of the day, you end up with a series of user-land effect
structures. It's up to the 'game' to download and start them on a given
device.

> If format is known/public it shouldn't be hard to write a userland client
> to play them back.

The file format of an IFR is probably easily deducible. There's a lot of
textual clues to parameters and the values are also written out in
string form.

I don't have a FEdit file at hand, but I suppose it will be similar.

> I assume that most AAA games, would implement these through some middle
> layer. I think that is probably via Steam using SDL2 haptic API, we have
> been testing against SDL2's 'testhaptic'.

I wasn't aware of this layer. I must read up on it. It sounds like a
simple way to access force feedback - I guess a game developer should
shed some light on this...

> Do you see another path (which we should be supporting/testing)?

Nope, not at this time.

> There was some discussion about rate limiting the USB packets to the
> wheel, and how to deal if app updates too quickly. Is there an upper limit
> for the wheel itself, or is it just the USB 'pipe' which is the limiting
> factor?

On the Windows side we send 125 reports/sec. The entire simulation loop
runs with a 8ms resolution. I assume this value was chosen for some
hardware constraints back in the days, but it has proven to be a good
compromise for simulated periodics and physics constraints.

In any case, the USB traffic should be decoupled from the app. Any force
updates should only change state in the ff-memless[-next] driver. Any
change there should trickle down to a 'slot' representation of the
device. If there's any change in the slots, the device is marked as
'dirty' and USB transfers are scheduled to send the latest state to the
physical device.

The scheduling should keep track of how many requests are in-flight and
delay writing the next output, until the previous one has completed.

Question back to the community: are there APIs in the USB layer to check
for presence of in-progress requests? Can one add a 'completion'
callback to a request, that gets invoked on completion/cancellation?

Thanks
roland

--

[1]
http://www.immersion.com/developers/index.php?option=com_content&view=article&id=423&Itemid=684

[2]
http://msdn.microsoft.com/en-us/library/windows/desktop/microsoft.directx_sdk.idirectinputdevice8.idirectinputdevice8.enumeffectsinfile(v=vs.85).aspx

