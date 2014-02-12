Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaBLKsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:48:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:7147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbaBLKs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:48:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,832,1384329600"; 
   d="scan'208";a="480181625"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Aaron Lu <aaron.lu@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] drm/i915/opregion: work around buggy firmware that provides 8+ output devices
In-Reply-To: <20140212103156.GC5298@nuc-i3427.alporthouse.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <52FAE504.8020001@intel.com> <20140212103156.GC5298@nuc-i3427.alporthouse.com>
User-Agent: Notmuch/0.17+61~gab0de040c7c1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 12 Feb 2014 12:52:13 +0200
Message-ID: <87vbwky55u.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, Feb 12, 2014 at 11:05:40AM +0800, Aaron Lu wrote:
>> The ACPI table on ASUS UX302LA has more than 8 output devices under the
>> graphics controller device node. The problem is, the real active output
>> device, the LCD panel, is listed the last. The result is, the LCD's
>> device id doesn't get recorded in the active device list CADL array and
>> when the _DCS control method for the LCD device is executed, it returns
>> 0x1d, meaning it is not active. This affects the hotkey delivery ASL
>> code that will not deliver a notification if the output device is not
>> active on backlight hotkey press.
>> 
>> I don't see a clean way to solve this problem since the operation region
>> spec doesn't allow more than 8 output devices so we have no way of
>> storing all these output devices. The fact that output devices that have
>> _BCM control method usually means they have a higher possibility of being
>> used than those who don't made me choose a simple way to work around
>> the buggy firmware by replacing the last entry in CADL array with the one
>> that has _BCM control method. There is no specific reason why the last
>> entry is picked instead of others.
>
> Another possibility is that the connector list is in rough priority
> order so might be useful for sorting the CADL array.
>
> Since the CADL should only be a list of currently active devices, we
> could just bite the bullet and repopulate it correctly after every
> setcrtc.

Agreed. Per spec,

DIDL: Writes - Graphics driver writes to this field once during its
initialization after determining platform supported connectors.

CPDL: Writes - Graphics driver writes to this field on every monitor
detection process.

CADL: Writes - Graphics driver writes to this field on every mode set
process and during boot.

And for all of the above: Writes - System BIOS POST or ASL code should
not write to these fields.


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
