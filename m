Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaBMMDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:03:54 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35099 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaBMMDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:03:52 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140213100814.GM14909@nuc-i3427.alporthouse.com>
References: <52FAE504.8020001@intel.com>
	<20140212103156.GC5298@nuc-i3427.alporthouse.com>
	<52FC8C01.1040002@intel.com>
	<20140213100814.GM14909@nuc-i3427.alporthouse.com>
Date: Thu, 13 Feb 2014 13:03:51 +0100
Message-ID: <CAKMK7uGN3Of2VU6_LsSLh041kkx4TrhyH0H8zvE-PRvOtzJgfg@mail.gmail.com>
Subject: Re: [PATCH] drm/i915/opregion: work around buggy firmware that
 provides 8+ output devices
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>, Aaron Lu <aaron.lu@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:08 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu, Feb 13, 2014 at 05:10:25PM +0800, Aaron Lu wrote:
>> On 02/12/2014 06:31 PM, Chris Wilson wrote:
>> > On Wed, Feb 12, 2014 at 11:05:40AM +0800, Aaron Lu wrote:
>> >> The ACPI table on ASUS UX302LA has more than 8 output devices under the
>> >> graphics controller device node. The problem is, the real active output
>> >> device, the LCD panel, is listed the last. The result is, the LCD's
>> >> device id doesn't get recorded in the active device list CADL array and
>> >> when the _DCS control method for the LCD device is executed, it returns
>> >> 0x1d, meaning it is not active. This affects the hotkey delivery ASL
>> >> code that will not deliver a notification if the output device is not
>> >> active on backlight hotkey press.
>> >>
>> >> I don't see a clean way to solve this problem since the operation region
>> >> spec doesn't allow more than 8 output devices so we have no way of
>> >> storing all these output devices. The fact that output devices that have
>> >> _BCM control method usually means they have a higher possibility of being
>> >> used than those who don't made me choose a simple way to work around
>> >> the buggy firmware by replacing the last entry in CADL array with the one
>> >> that has _BCM control method. There is no specific reason why the last
>> >> entry is picked instead of others.
>> >
>> > Another possibility is that the connector list is in rough priority
>> > order so might be useful for sorting the CADL array.
>> >
>> > Since the CADL should only be a list of currently active devices, we
>> > could just bite the bullet and repopulate it correctly after every
>> > setcrtc.
>>
>> Thanks for the suggestion. As a first step, does the following un-tested
>> patch look OK?
>
> Yes. Maybe worth putting together the similar routines for blind
> setting the didl and the cadl, or at least for computing the value from
> the connector. For instance, the didl logic disagrees with the value of
> index - is that relevant? I have a suspicion that the CADL entry should
> match the DIDL entry for the connector, but that is not actually
> mentioned in the opregion spec afaict.

I think a problem is that often we have more than one output for a
given type. So we need to somehow match them up to make sure we put
the right ones intot didl/cadl lists. The issue here is that our
connectors don't match up perfectly with the acpi output entries
(since we have separate dp/hdmi outputs). But I think it would be
worthwhile trying to match them up and store a link from struct
intel_connector to the right acpi node acpi node.

Then we could generate the didl/cadl lists by walking all connectors
(only looking at the enabled ones for cadl) and evaluating the _ADR
node of the linked apci node. As long as we ensure that we don't have
duplicated entries we should be fine.

This is a bit more work though ... And I have no idea really how
firmware uses these lists (besides for backlight purposes apparently).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
