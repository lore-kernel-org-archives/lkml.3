Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaBMJKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:10:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:1328 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbaBMJKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:10:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,837,1384329600"; 
   d="scan'208";a="482718095"
Message-ID: <52FC8C01.1040002@intel.com>
Date: Thu, 13 Feb 2014 17:10:25 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] drm/i915/opregion: work around buggy firmware that provides
 8+ output devices
References: <52FAE504.8020001@intel.com> <20140212103156.GC5298@nuc-i3427.alporthouse.com>
In-Reply-To: <20140212103156.GC5298@nuc-i3427.alporthouse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 06:31 PM, Chris Wilson wrote:
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

Thanks for the suggestion. As a first step, does the following un-tested
patch look OK?

diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index acde2945eb8a..afdd7d84fb32 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -220,11 +220,11 @@ struct opregion_asle {
 #define SWSCI_SBCB_POST_VBE_PM		SWSCI_FUNCTION_CODE(SWSCI_SBCB, 19)
 #define SWSCI_SBCB_ENABLE_DISABLE_AUDIO	SWSCI_FUNCTION_CODE(SWSCI_SBCB, 21)
 
-#define ACPI_OTHER_OUTPUT (0<<8)
-#define ACPI_VGA_OUTPUT (1<<8)
-#define ACPI_TV_OUTPUT (2<<8)
-#define ACPI_DIGITAL_OUTPUT (3<<8)
-#define ACPI_LVDS_OUTPUT (4<<8)
+#define ACPI_OTHER_OUTPUT 0
+#define ACPI_VGA_OUTPUT 1
+#define ACPI_TV_OUTPUT 2
+#define ACPI_DIGITAL_OUTPUT 3
+#define ACPI_LVDS_OUTPUT 4
 
 #define MAX_DSLP	1500
 
@@ -616,6 +616,7 @@ static void intel_didl_outputs(struct drm_device *dev)
 	acpi_status status;
 	u32 temp;
 	int i = 0;
+	int index[5] = {0};
 
 	handle = ACPI_HANDLE(&dev->pdev->dev);
 	if (!handle || acpi_bus_get_device(handle, &acpi_dev))
@@ -693,8 +694,8 @@ blind_set:
 			break;
 		}
 		temp = ioread32(&opregion->acpi->didl[i]);
-		iowrite32(temp | (1<<31) | output_type | i,
-			  &opregion->acpi->didl[i]);
+		iowrite32(temp | (1<<31) | (output_type << 8) |
+			  index[output_type]++, &opregion->acpi->didl[i]);
 		i++;
 	}
 	goto end;
@@ -705,18 +706,44 @@ static void intel_setup_cadls(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_opregion *opregion = &dev_priv->opregion;
 	int i = 0;
+	int index[5] = {0};
 	u32 disp_id;
+	struct drm_connector *connector;
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		int output_type = ACPI_OTHER_OUTPUT;
 
-	/* Initialize the CADL field by duplicating the DIDL values.
-	 * Technically, this is not always correct as display outputs may exist,
-	 * but not active. This initialization is necessary for some Clevo
-	 * laptops that check this field before processing the brightness and
-	 * display switching hotkeys. Just like DIDL, CADL is NULL-terminated if
-	 * there are less than eight devices. */
-	do {
-		disp_id = ioread32(&opregion->acpi->didl[i]);
+		switch (connector->connector_type) {
+		case DRM_MODE_CONNECTOR_VGA:
+		case DRM_MODE_CONNECTOR_DVIA:
+			output_type = ACPI_VGA_OUTPUT;
+			break;
+		case DRM_MODE_CONNECTOR_Composite:
+		case DRM_MODE_CONNECTOR_SVIDEO:
+		case DRM_MODE_CONNECTOR_Component:
+		case DRM_MODE_CONNECTOR_9PinDIN:
+			output_type = ACPI_TV_OUTPUT;
+			break;
+		case DRM_MODE_CONNECTOR_DVII:
+		case DRM_MODE_CONNECTOR_DVID:
+		case DRM_MODE_CONNECTOR_DisplayPort:
+		case DRM_MODE_CONNECTOR_HDMIA:
+		case DRM_MODE_CONNECTOR_HDMIB:
+			output_type = ACPI_DIGITAL_OUTPUT;
+			break;
+		case DRM_MODE_CONNECTOR_eDP:
+		case DRM_MODE_CONNECTOR_LVDS:
+			output_type = ACPI_LVDS_OUTPUT;
+			break;
+		}
+		disp_id = (opregion->acpi->didl[0] & (1 << 31)) |
+			  (output_type << 8) | index[output_type]++;
 		iowrite32(disp_id, &opregion->acpi->cadl[i]);
-	} while (++i < 8 && disp_id != 0);
+		i++;
+	}
+
+	if (i < 8)
+		iowrite32(0, &opregion->acpi->cadl[i]);
 }
 
 void intel_opregion_init(struct drm_device *dev)


Thanks,
Aaron
