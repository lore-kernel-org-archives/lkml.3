Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaDFMPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 08:15:07 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:53149 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaDFMPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 08:15:01 -0400
Date: Sun, 6 Apr 2014 14:14:56 +0200
From: Julian Andres Klode <jak@jak-linux.org>
To: Julian Andres Klode <jak@jak-linux.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [ibm-acpi-devel] [PATCH 1/4] thinkpad_acpi: Add support for
 controlling charge thresholds
Message-ID: <20140406121456.GA8980@jak-x230>
Mail-Followup-To: Julian Andres Klode <jak@jak-linux.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	"open list:THINKPAD ACPI EXT..." <ibm-acpi-devel@lists.sourceforge.net>,
	"open list:THINKPAD ACPI EXT..." <platform-driver-x86@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
 <1384178195-12218-2-git-send-email-jak@jak-linux.org>
 <20131230132915.GB24241@jak-x230>
 <20131230215843.GB4938@khazad-dum.debian.net>
 <20131230224045.GC4938@khazad-dum.debian.net>
 <20131231000115.GA28120@jak-x230>
 <20131231121231.GB25729@khazad-dum.debian.net>
 <20131231224605.GA32669@jak-x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131231224605.GA32669@jak-x230>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 11:46:05PM +0100, Julian Andres Klode wrote:
> On Tue, Dec 31, 2013 at 10:12:31AM -0200, Henrique de Moraes Holschuh wrote:
> > On Tue, 31 Dec 2013, Julian Andres Klode wrote:
> > > We might be able to work around this by simple setting stop = start
> > > if a new write causes the stop threshold to be below the start
> > > threshold. But this also seems ugly.
> > 
> > It is the safest way, but the correct pseudo-code would be, assuiming
> > unsigned:
> > 
> > when someone changes start:
> > 
> > if (start > 99)
> > 	start = 99;
> 
> I think we should just return -EINVAL in such cases. Allowing users to
> write larger percentages is a bit pointless (we don't allow them to write
> negative ones either). And other promiment code (the backlight drivers)
> seem to reject out-of-range values.
> 
> > set_thresholds(start, stop);
> 
> I think there should not be some common set_thresholds, because we also
> need to write things in different orders for start / stop then:
> 
> 	DECREASE STOP  => Write new start if needed, then write stop
> 	INCREASE START => Write new stop if needed, then write start
> 
> Otherwise we might have a very very very short time in which start
> is greater than stop.
> 
> I'll incorporate this in real code and test it tomorrow. 
> 

OK, tommorow is now, 4 months later. I was to busy with
lectures. An updated patch is below that passes my small
test suite.

The next step is to integrate this properly with power supply
and/or acpi battery. One way would be to add additional power
supply properties and then add get/set_property() pointers to
the acpi battery which it can fall back to if it does not support
a requested property (and we would locate the ACPI battery and
set those pointers to new thinkpad_acpi functions).

Full changelog:
* Changed stop interval to 1..100
* Fixed name of attributes (tresh => thresh)
* Made sure to keep start < stop

-- >8 --
Subject: [PATCH 1/4] thinkpad_acpi: Add support for controlling charge
 thresholds

Add support for battery charge thresholds in new Sandy Bridge and Ivy Bridge
ThinkPads. Based on the unofficial documentation in tpacpi-bat.

Signed-off-by: Julian Andres Klode <jak@jak-linux.org>
---
 Documentation/laptops/thinkpad-acpi.txt |  15 ++
 drivers/platform/x86/thinkpad_acpi.c    | 235 ++++++++++++++++++++++++++++++++
 2 files changed, 250 insertions(+)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 86c5236..9b8a637 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -46,6 +46,7 @@ detailed description):
 	- Fan control and monitoring: fan speed, fan enable/disable
 	- WAN enable and disable
 	- UWB enable and disable
+	- Charging control
 
 A compatibility table by model and feature is maintained on the web
 site, http://ibm-acpi.sf.net/. I appreciate any success or failure
@@ -1352,6 +1353,20 @@ Sysfs notes:
 	rfkill controller switch "tpacpi_uwb_sw": refer to
 	Documentation/rfkill.txt for details.
 
+Charging control
+----------------
+sysfs attribute groups: BAT0, BAT1, and so on, depending on how many batteries
+are supported by the embedded controller.
+
+This feature controls the battery charging process.
+
+battery sysfs attribute: start_charge_thresh
+
+	A percentage value from 0-99%, controlling when charging should start
+
+battery sysfs attribute: stop_charge_thresh
+
+	A percentage value from 1-100%, controlling when charging should stop
 
 Multiple Commands, Module Parameters
 ------------------------------------
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 03ca6c1..fa29d82 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -323,6 +323,7 @@ static struct {
 	u32 sensors_pdrv_attrs_registered:1;
 	u32 sensors_pdev_attrs_registered:1;
 	u32 hotkey_poll_active:1;
+	u32 battery:1;
 } tp_features;
 
 static struct {
@@ -8350,6 +8351,236 @@ static struct ibm_struct fan_driver_data = {
 	.resume = fan_resume,
 };
 
+
+/*************************************************************************
+ * Battery subdriver
+ */
+
+/* Modify battery_init() if you modify them */
+#define BATTERY_MAX_COUNT 3
+#define BATTERY_MAX_ATTRS 2
+
+static struct battery {
+	char name[3 + 1 + 1];
+	struct attribute_set *set;
+	struct dev_ext_attribute attributes[BATTERY_MAX_ATTRS];
+} batteries[BATTERY_MAX_COUNT];
+
+static int battery_attribute_get_battery(struct device_attribute *attr)
+{
+	return (int) (unsigned long) container_of(attr,
+						  struct dev_ext_attribute,
+						  attr)->var;
+}
+
+static int battery_read_threshold(int bat, char *threshold)
+{
+	int result = 0;
+
+	if (!hkey_handle || !acpi_evalf(hkey_handle, &result, threshold,
+					"dd", bat) || result < 0)
+		return -EIO;
+
+	/* Translate 0 to 100 for stop threshold */
+	if (strcmp(threshold, "BCSG") == 0 && (result & 0xFF) == 0)
+		return 100;
+	/* Bits 0 - 7 contain the current threshold */
+	return result & 0xFF;
+}
+
+static int battery_write_stop_charge_thresh(int bat, int value,
+					     bool adjust_start);
+
+static int battery_write_start_charge_thresh(int bat, int value,
+					     bool adjust_stop)
+{
+	int res = 0;
+
+	if (value < 0 || value > 99)
+		return -EINVAL;
+
+	/* Adjust the stop value if stop < new start value */
+	if (adjust_stop) {
+		int stop = battery_read_threshold(bat, "BCSG");
+		if (stop < 0)
+			return stop;
+		if (stop <= value)
+			res = battery_write_stop_charge_thresh(bat, value + 1,
+							       FALSE);
+		if (res)
+			return res;
+	}
+
+	if (!hkey_handle || !acpi_evalf(hkey_handle, &res, "BCCS", "dd",
+					value | (bat << 8)) || res < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int battery_write_stop_charge_thresh(int bat, int value,
+					     bool adjust_start)
+{
+	int res = 0;
+
+	if (value < 1 || value > 100)
+		return -EINVAL;
+
+	/* Adjust the start value if start > new stop value */
+	if (adjust_start) {
+		int start = battery_read_threshold(bat, "BCTG");
+		if (start < 0)
+			return start;
+		if (value != 0)
+			res = battery_write_start_charge_thresh(bat, value - 1,
+								FALSE);
+		if (res)
+			return res;
+	}
+
+	/* 0 means default which seems to be 100%. */
+	if (value == 100)
+		value = 0;
+
+	if (!hkey_handle || !acpi_evalf(hkey_handle, &res, "BCSS", "dd",
+					value | (bat << 8)) || res < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static ssize_t battery_start_charge_thresh_store(struct device *dev,
+						 struct device_attribute *attr,
+						 const char *buf, size_t count)
+{
+	int bat = battery_attribute_get_battery(attr);
+	int res = -EINVAL;
+	unsigned long value;
+
+	res = kstrtoul(buf, 0, &value);
+	if (res)
+		return res;
+	res = battery_write_start_charge_thresh(bat, value, TRUE);
+	return res ? res : count;
+}
+
+static ssize_t battery_stop_charge_thresh_store(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	int bat = battery_attribute_get_battery(attr);
+	int res = -EINVAL;
+	unsigned long value;
+
+	res = kstrtoul(buf, 0, &value);
+	if (res)
+		return res;
+	res = battery_write_stop_charge_thresh(bat, value, TRUE);
+	return res ? res : count;
+}
+
+static ssize_t battery_start_charge_thresh_show(struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	int bat = battery_attribute_get_battery(attr);
+	int value = battery_read_threshold(bat, "BCTG");
+
+	return value < 0 ? value : snprintf(buf, PAGE_SIZE, "%d\n", value);
+}
+
+static ssize_t battery_stop_charge_thresh_show(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	int bat = battery_attribute_get_battery(attr);
+	int value = battery_read_threshold(bat, "BCSG");
+
+	return value < 0 ? value : snprintf(buf, PAGE_SIZE, "%d\n", value);
+}
+
+static int __init battery_init(struct ibm_init_struct *iibm)
+{
+	int res;
+	int i;
+	int state;
+
+	vdbg_printk(TPACPI_DBG_INIT,
+		    "initializing battery commands subdriver\n");
+
+	TPACPI_ACPIHANDLE_INIT(hkey);
+
+	/* Check whether getter for start threshold exists */
+	tp_features.battery = hkey_handle &&
+	    acpi_evalf(hkey_handle, &state, "BCTG", "qdd", 1);
+
+	vdbg_printk(TPACPI_DBG_INIT, "battery commands are %s\n",
+		    str_supported(tp_features.battery));
+
+	if (!tp_features.battery)
+		return 1;
+
+	for (i = 0; i < BATTERY_MAX_COUNT; i++) {
+		int j = 0;
+		if (!acpi_evalf(hkey_handle, &state, "BCTG", "qdd", i + 1))
+			continue;
+		/* If the sign bit was set, we could not get the start charge
+		 * threshold of that battery. Let's assume that this battery
+		 * (and all following ones) do not exist */
+		if (state < 0)
+			break;
+		/* Modify BATTERY_MAX_ATTRS if you add an attribute */
+		batteries[i].attributes[j++] = (struct dev_ext_attribute) {
+			.attr = __ATTR(start_charge_thresh,
+				       S_IWUSR | S_IRUGO,
+				       battery_start_charge_thresh_show,
+				       battery_start_charge_thresh_store),
+			.var = (void *)(unsigned long) (i + 1)
+		};
+		batteries[i].attributes[j++] = (struct dev_ext_attribute) {
+			.attr = __ATTR(stop_charge_thresh,
+				       S_IWUSR | S_IRUGO,
+				       battery_stop_charge_thresh_show,
+				       battery_stop_charge_thresh_store),
+			.var = (void *)(unsigned long) (i + 1)
+		};
+
+		strncpy(batteries[i].name, "BAT", 3);
+		batteries[i].name[3] = '0' + i;
+		batteries[i].name[4] = '\0';
+		batteries[i].set = create_attr_set(j, batteries[i].name);
+
+		for (j = j - 1; j >= 0; j--)
+			add_to_attr_set(batteries[i].set,
+					&batteries[i].attributes[j].attr.attr);
+
+		res = register_attr_set_with_sysfs(batteries[i].set,
+						   &tpacpi_pdev->dev.kobj);
+
+		if (res)
+			return res;
+	}
+
+	return 0;
+}
+
+static void battery_exit(void)
+{
+	int i;
+
+	for (i = 0; i < BATTERY_MAX_COUNT; i++) {
+		if (batteries[i].set != NULL) {
+			delete_attr_set(batteries[i].set,
+					&tpacpi_pdev->dev.kobj);
+		}
+	}
+}
+
+static struct ibm_struct battery_driver_data = {
+	.name = "battery",
+	.exit = battery_exit,
+};
+
 /****************************************************************************
  ****************************************************************************
  *
@@ -8741,6 +8972,10 @@ static struct ibm_init_struct ibms_init[] __initdata = {
 		.data = &light_driver_data,
 	},
 	{
+		.init = battery_init,
+		.data = &battery_driver_data,
+	},
+	{
 		.init = cmos_init,
 		.data = &cmos_driver_data,
 	},
-- 
1.9.1



-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.

Please do not top-post if possible.
