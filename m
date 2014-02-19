Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaBSHbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:31:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:8626 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaBSHbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:31:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="477512606"
Message-ID: <53045DD1.5010406@intel.com>
Date: Wed, 19 Feb 2014 15:31:29 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] drm/i915/opregion: work around buggy firmware that provides
 8+ output devices
References: <52FAE504.8020001@intel.com>	<20140212103156.GC5298@nuc-i3427.alporthouse.com>	<52FC8C01.1040002@intel.com>	<20140213100814.GM14909@nuc-i3427.alporthouse.com> <CAKMK7uGN3Of2VU6_LsSLh041kkx4TrhyH0H8zvE-PRvOtzJgfg@mail.gmail.com>
In-Reply-To: <CAKMK7uGN3Of2VU6_LsSLh041kkx4TrhyH0H8zvE-PRvOtzJgfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 08:03 PM, Daniel Vetter wrote:
> On Thu, Feb 13, 2014 at 11:08 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> On Thu, Feb 13, 2014 at 05:10:25PM +0800, Aaron Lu wrote:
>>> On 02/12/2014 06:31 PM, Chris Wilson wrote:
>>>> On Wed, Feb 12, 2014 at 11:05:40AM +0800, Aaron Lu wrote:
>>>>> The ACPI table on ASUS UX302LA has more than 8 output devices under the
>>>>> graphics controller device node. The problem is, the real active output
>>>>> device, the LCD panel, is listed the last. The result is, the LCD's
>>>>> device id doesn't get recorded in the active device list CADL array and
>>>>> when the _DCS control method for the LCD device is executed, it returns
>>>>> 0x1d, meaning it is not active. This affects the hotkey delivery ASL
>>>>> code that will not deliver a notification if the output device is not
>>>>> active on backlight hotkey press.
>>>>>
>>>>> I don't see a clean way to solve this problem since the operation region
>>>>> spec doesn't allow more than 8 output devices so we have no way of
>>>>> storing all these output devices. The fact that output devices that have
>>>>> _BCM control method usually means they have a higher possibility of being
>>>>> used than those who don't made me choose a simple way to work around
>>>>> the buggy firmware by replacing the last entry in CADL array with the one
>>>>> that has _BCM control method. There is no specific reason why the last
>>>>> entry is picked instead of others.
>>>>
>>>> Another possibility is that the connector list is in rough priority
>>>> order so might be useful for sorting the CADL array.
>>>>
>>>> Since the CADL should only be a list of currently active devices, we
>>>> could just bite the bullet and repopulate it correctly after every
>>>> setcrtc.
>>>
>>> Thanks for the suggestion. As a first step, does the following un-tested
>>> patch look OK?
>>
>> Yes. Maybe worth putting together the similar routines for blind
>> setting the didl and the cadl, or at least for computing the value from
>> the connector. For instance, the didl logic disagrees with the value of
>> index - is that relevant? I have a suspicion that the CADL entry should
>> match the DIDL entry for the connector, but that is not actually
>> mentioned in the opregion spec afaict.
> 
> I think a problem is that often we have more than one output for a
> given type. So we need to somehow match them up to make sure we put
> the right ones intot didl/cadl lists. The issue here is that our
> connectors don't match up perfectly with the acpi output entries
> (since we have separate dp/hdmi outputs). But I think it would be
> worthwhile trying to match them up and store a link from struct
> intel_connector to the right acpi node acpi node.

Is this possible? I don't see a way to match them up...
The _ADR control method uses a field that seems to be assigned by BIOS
like this:

                Device (LCDD)
                {
                  Method (_ADR, 0, Serialized)  // _ADR: Address
                    {
                        Return (And (0xFFFF, DID2))
                    }
		}
DID2 is in system memory region and has some assigned value like 0x400
when we read it. For this case it is easy since there is only one output
device that is of type LVDS so we can match it to connector of type eDP
or LVDS, suppose there is only one such connector. But for output
devices' whose _ADR has the value of 0x301, 0x302, etc. I have no idea
how to match them up to the connectors of that type as we can't be sure
the probe order we have used in i915 driver is the same as BIOS'.

In the mean time, it seems we can just use driver's information to
populate both DIDL and CADL and forget the _ADR of those devices like
the following patch does:

diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index a4ffc021c317..55956a517a77 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -204,6 +204,9 @@ struct intel_connector {
 	/* since POLL and HPD connectors may use the same HPD line keep the native
 	   state of connector->polled in case hotplug storm detection changes it */
 	u8 polled;
+
+	/* device id with type and index information */
+	u32 disp_id;
 };
 
 typedef struct dpll {
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 68459605bd12..ba08c894ce9a 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -221,11 +221,11 @@ struct opregion_asle {
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
 
@@ -600,78 +600,20 @@ static struct notifier_block intel_opregion_notifier = {
 	.notifier_call = intel_opregion_video_event,
 };
 
-/*
- * Initialise the DIDL field in opregion. This passes a list of devices to
- * the firmware. Values are defined by section B.4.2 of the ACPI specification
- * (version 3)
- */
-
-static void intel_didl_outputs(struct drm_device *dev)
+static void intel_connector_getid(struct drm_device *dev)
 {
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct intel_opregion *opregion = &dev_priv->opregion;
-	struct drm_connector *connector;
-	acpi_handle handle;
-	struct acpi_device *acpi_dev, *acpi_cdev, *acpi_video_bus = NULL;
-	unsigned long long device_id;
-	acpi_status status;
-	u32 temp;
 	int i = 0;
+	int index[5] = {0};
+	struct intel_connector *connector;
 
-	handle = ACPI_HANDLE(&dev->pdev->dev);
-	if (!handle || acpi_bus_get_device(handle, &acpi_dev))
-		return;
-
-	if (acpi_is_video_device(handle))
-		acpi_video_bus = acpi_dev;
-	else {
-		list_for_each_entry(acpi_cdev, &acpi_dev->children, node) {
-			if (acpi_is_video_device(acpi_cdev->handle)) {
-				acpi_video_bus = acpi_cdev;
-				break;
-			}
-		}
-	}
-
-	if (!acpi_video_bus) {
-		pr_warn("No ACPI video bus found\n");
-		return;
-	}
-
-	list_for_each_entry(acpi_cdev, &acpi_video_bus->children, node) {
-		if (i >= 8) {
-			dev_dbg(&dev->pdev->dev,
-				"More than 8 outputs detected via ACPI\n");
-			return;
-		}
-		status =
-			acpi_evaluate_integer(acpi_cdev->handle, "_ADR",
-						NULL, &device_id);
-		if (ACPI_SUCCESS(status)) {
-			if (!device_id)
-				goto blind_set;
-			iowrite32((u32)(device_id & 0x0f0f),
-				  &opregion->acpi->didl[i]);
-			i++;
-		}
-	}
-
-end:
-	/* If fewer than 8 outputs, the list must be null terminated */
-	if (i < 8)
-		iowrite32(0, &opregion->acpi->didl[i]);
-	return;
-
-blind_set:
-	i = 0;
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+	list_for_each_entry(connector, &dev->mode_config.connector_list, base.head) {
 		int output_type = ACPI_OTHER_OUTPUT;
 		if (i >= 8) {
 			dev_dbg(&dev->pdev->dev,
 				"More than 8 outputs in connector list\n");
 			return;
 		}
-		switch (connector->connector_type) {
+		switch (connector->base.connector_type) {
 		case DRM_MODE_CONNECTOR_VGA:
 		case DRM_MODE_CONNECTOR_DVIA:
 			output_type = ACPI_VGA_OUTPUT;
@@ -690,15 +632,35 @@ blind_set:
 			output_type = ACPI_DIGITAL_OUTPUT;
 			break;
 		case DRM_MODE_CONNECTOR_LVDS:
+		case DRM_MODE_CONNECTOR_eDP:
 			output_type = ACPI_LVDS_OUTPUT;
 			break;
 		}
-		temp = ioread32(&opregion->acpi->didl[i]);
-		iowrite32(temp | (1<<31) | output_type | i,
-			  &opregion->acpi->didl[i]);
+		connector->disp_id = (output_type << 8) | index[output_type]++;
 		i++;
 	}
-	goto end;
+}
+
+/*
+ * Initialise the DIDL field in opregion. This passes a list of devices to
+ * the firmware. Values are defined by section B.4.2 of the ACPI specification
+ * (version 3)
+ */
+
+static void intel_didl_outputs(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct intel_opregion *opregion = &dev_priv->opregion;
+	struct intel_connector *connector;
+	int i = 0;
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list, base.head)
+		iowrite32(connector->disp_id, &opregion->acpi->didl[i++]);
+
+	if (i < 8)
+		iowrite32(0, &opregion->acpi->didl[i]);
+
+	return;
 }
 
 static void intel_setup_cadls(struct drm_device *dev)
@@ -730,6 +692,7 @@ void intel_opregion_init(struct drm_device *dev)
 
 	if (opregion->acpi) {
 		if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+			intel_connector_getid(dev);
 			intel_didl_outputs(dev);
 			intel_setup_cadls(dev);
 		}


I've tested the patch locally on some laptops but I've no idea of what
impact it has on others.

Thanks,
Aaron
