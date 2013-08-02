Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3HBBPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:15:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:19919 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab3HBBPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:15:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,797,1367996400"; 
   d="scan'208";a="276561915"
Message-ID: <51FB0853.9090105@intel.com>
Date: Fri, 02 Aug 2013 09:16:03 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>, Borislav Petkov <bp@alien8.de>
CC: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: i915 backlight
References: <20130731162252.GC4724@pd.tnic> <20130731163623.GD4724@pd.tnic> <51F9B63F.7060509@intel.com> <20130801081215.GB3448@nazgul.tnic> <51FA2537.5040208@intel.com>
In-Reply-To: <51FA2537.5040208@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 05:07 PM, Aaron Lu wrote:
> On 08/01/2013 04:12 PM, Borislav Petkov wrote:
>> On Thu, Aug 01, 2013 at 09:13:35AM +0800, Aaron Lu wrote:
>>> Can you please run acpi_listen and then press the Fn-Fx key, see if the
>>> events are correctly sent out?
>>
>> Like this?
>>
>> # acpi_listen
>> video/brightnessdown BRTDN 00000087 00000000
>> video/brightnessup BRTUP 00000086 00000000
>> video/brightnessdown BRTDN 00000087 00000000
>> video/brightnessup BRTUP 00000086 00000000
>> video/brightnessdown BRTDN 00000087 00000000
>> video/brightnessup BRTUP 00000086 00000000
>> video/brightnessdown BRTDN 00000087 00000000
>> video/brightnessup BRTUP 00000086 00000000
>> video/brightnessdown BRTDN 00000087 00000000
>> ^C
> 
> Yes, so the event is correctly sent out.
> 
>>
>>> From the bug page:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=51231#c80
>>> I got the impression that both the acpi_video interface and the vendor
>>> interface thinkpad_screen are broken. So adding this cmdline here works
>>> suggests that either thinkpad_screen works or thinkpad vendor driver
>>> doesn't get loaded or doesn't create that interface for some reason.
>>>
>>> Alternatively, if the intel_backlight interface works(highly possible),
>>> you can use xorg.conf to specify the that backlight interface for X.
>>>
>>> Section "Device"
>>>         Option     "Backlight"	"intel_backlight"
>>> 	Identifier  "Card0"
>>> 	Driver      "intel"
>>> 	BusID       "PCI:0:2:0"
>>> EndSection
>>
>> Yeah, that didn't work *but* manually writing to both:
>>
>> /sys/class/backlight/acpi_video0/brightness
>>
>> and
>>
>> /sys/class/backlight/intel_backlight/brightness
>>
>> works.
> 
> Err...we have the event sent out on hotkey press and the interface also
> works, but still, using hotkey to adjust brightness level is broken...
> 
> I just found an old acer laptop that has similar issue(or even worse: on
> X starts, an almost black screen is shown and hotkey adjust doesn't
> work), I'll look into this.

Hi Jani & Daniel,

It turned out there is an integer overflow problem, and the below patch
fixed this problem on Acer Aspire 4732Z and thinkpad R61i.

From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH] drm/i915: avoid brightness overflow when doing scale

Some card's max brightness level is pretty large, e.g. on Acer Aspire
4732Z, the max level is 989910. If user space set a large enough level
then the current scale done in intel_panel_set_backlight will cause an
integer overflow and the scaled level will be mistakenly small, leaving
user with an almost black screen. This patch fixes this problem.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
Since the only external user of intel_panel_set_backlight is operation
region code where the max will be a constant of 255, this patch fixes
the problem by comparing freq and max and then do things accordingly
instead of converting to 64 bits.

 drivers/gpu/drm/i915/intel_panel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 67e2c1f..7c674f0 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -498,7 +498,10 @@ void intel_panel_set_backlight(struct drm_device *dev, u32 level, u32 max)
 	}
 
 	/* scale to hardware */
-	level = level * freq / max;
+	if (freq < max)
+		level = level * freq / max;
+	else
+		level = freq / max * level;
 
 	dev_priv->backlight.level = level;
 	if (dev_priv->backlight.device)
-- 
1.8.3.1


Hi Boris,

Since the sysfs interface works on your system, I think your problem
should be different. Can you please file a bug for this? I can provide
you with a debug patch and then see what happened. Please attach
acpidump when filing the bug.

https://bugzilla.kernel.org, ACPI/Power-Video.

Thanks,
Aaron

> 
>>
>> The ranges are different, though:
>>
>> intel_backlight/actual_brightness:1000
>> intel_backlight/bl_power:0
>> intel_backlight/brightness:1000
>> intel_backlight/max_brightness:4437
>> intel_backlight/type:raw
>>
>> acpi_video0/actual_brightness:41
>> acpi_video0/bl_power:0
>> acpi_video0/brightness:41
>> acpi_video0/max_brightness:100
>> acpi_video0/type:firmware
> 
> Yes, different interface has different brightness ranges and a value in
> one range may turn out to be the same actual brightness level of another
> value in another range.
> 
>>
>> I guess I need to write me a dirty script for now ... :-)
> 
> :-)
> 
>>
>> Thanks guys.
>>
> Thanks,
> Aaron
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

