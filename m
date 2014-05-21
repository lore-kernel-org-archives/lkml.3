Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaEUNfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:35:45 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42175 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaEUNfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:35:43 -0400
MIME-Version: 1.0
In-Reply-To: <2643156.2tkLFqgYFg@sigyn>
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net>
	<1c6140633925b0838b7627e071e80761.squirrel@mungewell.org>
	<537BFEBF.8010601@logitech.com>
	<2643156.2tkLFqgYFg@sigyn>
Date: Wed, 21 May 2014 15:35:42 +0200
Message-ID: <CADbOyBQfHAnZYJj=z-SF77yg+yNpAzETX_W2UGh56NsZo3o8ew@mail.gmail.com>
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: =?UTF-8?B?TWljaGFsIE1hbMO9?= <madcatxster@devoid-pointer.net>
Cc: Roland Bosa <rbosa@logitech.com>, Simon Wood <simon@mungewell.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Anssi Hannula <anssi.hannula@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 4:13 AM, Michal Malý
<madcatxster@devoid-pointer.net> wrote:
> On Tuesday 20 of May 2014 18:17:51 Roland Bosa wrote:
>> In any case, the USB traffic should be decoupled from the app. Any force
>> updates should only change state in the ff-memless[-next] driver. Any
>> change there should trickle down to a 'slot' representation of the
>> device. If there's any change in the slots, the device is marked as
>> 'dirty' and USB transfers are scheduled to send the latest state to the
>> physical device.
>>
>> The scheduling should keep track of how many requests are in-flight and
>> delay writing the next output, until the previous one has completed.
>
> The approach I had in mind would keep track of the last effect that made it to
> the device and the last effect that arrived from userspace. This would be
> stored for each effect slot. An update would be scheduled at the desired update
> rate. The updating routine would figure out the state change between last
> update and "now", send the required data to the device and reschedule itself.
> The routine could check if there are any USB transfers still running and
> reschedule itself immediately.

I've got another/(a more detailed?) idea about this:
We can use round-robin scheduling for the slots, and use a priority
queue for e.g. LED data or data that doesn't fit in the
slot-methodology and doesn't permit in-between packets to be lost.
And I believe that ff-memless-next should generate a periodic force
with a constant/defined sample-period/update-rate, while the layer
between ff-memless-next and USB transfers, i.e. the round-robin and
priority queue scheduler, should send the dirty slots as soon as
possible, i.e. when the USB pipe is clear or when some custom
#maxAllowedPacketsInUsbBuffer (optimized for somewhere between latency
and throughput) is not exceeded by the kernel USB queue.
Now the question is, can we query the state of the kernel USB queue?

Optionally, this method of packet scheduling could be used by other
kernel drivers (even non-FF drivers) as well, and can further increase
flexibility of ff-memless-next and the HW-specific drivers, and it
will reduce code duplication.

>> Question back to the community: are there APIs in the USB layer to check
>> for presence of in-progress requests? Can one add a 'completion'
>> callback to a request, that gets invoked on completion/cancellation?
>
> For instance "usb_submit_urb()" can have a completion handler that is called
> once the transfer is done. The current code uses "hid_hw_request()" which is
> asynchronous and doesn't report anything back.
>
> Proper decoupling of the userspace and driver is the only important thing that
> is missing from the current code.

Also dynamic updating of periodic effects is not yet supported in
"ff-memless-next".
This can also be important in simulation games (=second type), e.g.
the "rFactor" game.

Elias
