Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaHQGHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 02:07:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:49045 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaHQGEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 02:04:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,878,1400050800"; 
   d="scan'208";a="577744106"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Max Eliaser <max.eliaser@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/9] ACPI: Document ACPI device specific properties
Date: Sun, 17 Aug 2014 09:04:12 +0300
Message-Id: <1408255459-17625-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0.rc1
In-Reply-To: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This document describes the data format and interfaces of ACPI device
specific properties.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 Documentation/acpi/properties.txt | 359 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 359 insertions(+)
 create mode 100644 Documentation/acpi/properties.txt

diff --git a/Documentation/acpi/properties.txt b/Documentation/acpi/properties.txt
new file mode 100644
index 000000000000..a1e93267c1fa
--- /dev/null
+++ b/Documentation/acpi/properties.txt
@@ -0,0 +1,359 @@
+ACPI device properties
+======================
+This document describes the format and interfaces of ACPI device
+properties as specified in "Device Properties UUID For _DSD" available
+here:
+
+http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
+
+1. Introduction
+---------------
+In systems that use ACPI and want to take advantage of device specific
+properties, there needs to be a standard way to return and extract
+name-value pairs for a given ACPI device.
+
+An ACPI device that wants to export its properties must implement a
+static name called _DSD that takes no arguments and returns a package of
+packages:
+
+	Name (_DSD, Package () {
+		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		Package () {
+			Package () {"name1", <VALUE1>},
+			Package () {"name2", <VALUE2>}
+		}
+	})
+
+The UUID identifies contents of the following package. In case of ACPI
+device properties it is daffd814-6eba-4d8c-8a91-bc9bbf4aa301.
+
+In each returned package, the first item is the name and must be a string.
+The corresponding value can be a string, integer, reference, or package. If
+a package it may only contain strings, integers, and references.
+
+An example device where we might need properties is a GPIO keys device.
+In addition to the GpioIo/GpioInt resources the driver needs to know how
+to map each GpioIo resource to the corresponding Linux input event.
+
+To solve this we add the following ACPI device properties from the
+gpio-keys schema:
+
+	Device (KEYS) {
+		Name (_DSD, Package () {
+			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+			Package () {
+				Package () {"poll-interval", 100},
+				Package () {"autorepeat", 1}
+			}
+		})
+
+		Device (BTN0) {
+			Name (_DSD, Package () {
+				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+				Package () {
+					Package () {"linux,code", 105},
+					Package () {"linux,input-type", 1},
+					...
+				}
+			})
+		}
+
+		...
+	}
+
+Of course the device driver then needs to iterate over these devices but
+it can be done easily via the ->children field of the companion ACPI
+device. This will be demonstrated later on in the document.
+
+If there is an existing Device Tree binding for a device, it is expected
+that the same bindings are used with ACPI properties, so that the driver
+dealing with the device needs only minor modifications if any.
+
+2. Formal definition of properties
+----------------------------------
+The following chapters define the currently supported properties. For
+these there exists a helper function that can be used to extract the
+property value.
+
+2.1 Integer types
+-----------------
+ACPI integers are always 64-bit. However, for drivers the full range is
+typically not needed so we provide a set of functions which convert the
+64-bit integer to a smaller Linux integer type.
+
+An integer property looks like this:
+
+	Package () {"poll-interval", 100},
+	Package () {"i2c-sda-hold-time-ns", 300},
+	Package () {"clock-frequency", 400000},
+
+To read a property value, use a unified property accessor as shown
+below:
+
+	u32 val;
+	int ret;
+
+	ret = device_property_read(dev, "poll-interval", DEV_PROP_U32, &val);
+	if (ret)
+		/* Handle error */
+
+The function returns 0 if the property is copied to 'val' or negative
+errno if something went wrong (or the property does not exist).
+
+2.2 Integer arrays
+------------------
+An integer array is a package holding only integers. Arrays can be used to
+represent different things like Linux input key codes to GPIO mappings, pin
+control settings, dma request lines, etc.
+
+An integer array looks like this:
+
+	Package () {
+		"max8952,dvs-mode-microvolt",
+		Package () {
+			1250000,
+			1200000,
+			1050000,
+			950000,
+		}
+	}
+
+The above array property can be accessed like:
+
+	u32 voltages[4];
+	int ret;
+
+	ret = device_property_read_array(dev, "max8952,dvs-mode-microvolt",
+					 DEV_PROP_U32, voltages,
+					 ARRAY_SIZE(voltages));
+	if (ret)
+		/* Handle error */
+
+
+All functions copy the resulting values cast to a requested type to the
+caller supplied array. If you pass NULL in the value pointer ('voltages' in
+this case), the function returns number of items in the array. This can be
+useful if caller does not know size of the array beforehand.
+
+2.3 Strings
+-----------
+String properties can be used to describe many things like labels for GPIO
+buttons, compability ids, etc.
+
+A string property looks like this:
+
+	Package () {"pwm-names", "backlight"},
+	Package () {"label", "Status-LED"},
+
+You can also use device_property_read() to extract strings:
+
+	const char *val;
+	int ret;
+
+	ret = device_property_read(dev, "label", DEV_PROP_STRING, &val);
+	if (ret)
+		/* Handle error */
+
+Note that the function does not copy the returned string but instead the
+value is modified to point to the string property itself.
+
+The memory is owned by the associated ACPI device object and released
+when it is removed. The user need not free the associated memory.
+
+2.4 String arrays
+-----------------
+String arrays can be useful in describing a list of labels, names for
+DMA channels, etc.
+
+A string array property looks like this:
+
+	Package () {"dma-names", Package () {"tx", "rx", "rx-tx"}},
+	Package () {"clock-output-names", Package () {"pll", "pll-switched"}},
+
+And these can be read in similar way that the integer arrrays:
+
+	const char *dma_names[3];
+	int ret;
+
+	ret = device_property_read_array(dev, "dma-names", DEV_PROP_STRING,
+					 dma_names, ARRAY_SIZE(dma_names));
+	if (ret)
+		/* Handle error */
+
+The memory management rules follow what is specified for single strings.
+Specifically the returned pointers should be treated as constant and not to
+be freed. That is done automatically when the correspondig ACPI device
+object is released.
+
+2.5 Object references
+---------------------
+An ACPI object reference is used to refer to some object in the
+namespace. For example, if a device has dependencies with some other
+object, an object reference can be used.
+
+An object reference looks like this:
+
+	Package () {"clock", \_SB.CLK0},
+
+At the time of writing this, there is no unified device_property_* accessor
+for references so one needs to use the following ACPI helper function:
+
+	int acpi_dev_get_property_reference(struct acpi_device *adev,
+					    const char *name,
+					    const char *size_prop, int index,
+					    struct acpi_reference_args *args);
+
+The referenced ACPI device is returned in args->adev if found.
+
+In addition to simple object references it is also possible to have object
+references with arguments. These are represented in ASL as follows:
+
+	Device (\_SB.PCI0.PWM) {
+		Name (_DSD, Package () {
+			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+			Package () {
+				Package () {"#pwm-cells", 2}
+			}
+		})
+	}
+
+	Device (\_SB.PCI0.BL) {
+		Name (_DSD, Package () {
+			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+			Package () {
+				Package () {
+					"pwms",
+					Package () {
+						\_SB.PCI0.PWM, 0, 5000000,
+						\_SB.PCI0.PWM, 1, 4500000,
+					}
+				}
+			}
+		})
+	}
+
+In the above example, the referenced device declares a property that
+returns the number of expected arguments (here it is "#pwm-cells"). If
+no such property is given we assume that all the integers following the
+reference are arguments.
+
+In the above example PWM device expects 2 additional arguments. This
+will be validated by the ACPI property core.
+
+The additional arguments must be integers. Nothing else is supported.
+
+It is possible, as in the above example, to have multiple references
+with varying number of integer arguments. It is up to the referenced
+device to declare how many arguments it expects. The 'index' parameter
+selects which reference is returned.
+
+One can use acpi_dev_get_property_reference() as well to extract the
+information in additional parameters:
+
+	struct acpi_reference_args args;
+	struct acpi_device *adev = /* this will point to the BL device */
+	int ret;
+
+	/* extract the first reference */
+	acpi_dev_get_property_reference(adev, "pwms", "#pwm-cells", 0, &args);
+
+	BUG_ON(args.nargs != 2);
+	BUG_ON(args.args[0] != 0);
+	BUG_ON(args.args[1] != 5000000);
+
+	/* extract the second reference */
+	acpi_dev_get_property_reference(adev, "pwms", "#pwm-cells", 1, &args);
+
+	BUG_ON(args.nargs != 2);
+	BUG_ON(args.args[0] != 1);
+	BUG_ON(args.args[1] != 4500000);
+
+In addition to arguments, args.adev now points to the ACPI device that
+corresponds to \_SB.PCI0.PWM.
+
+It is intended that this function is not used directly but instead
+subsystems like pwm implement their ACPI support on top of this function
+in such way that it is hidden from the client drivers, such as via
+pwm_get().
+
+3. Device property hierarchies
+------------------------------
+Devices are organized in a tree within the Linux kernel. It follows that
+the configuration data would also be hierarchical. In order to reach
+equivalence with Device Tree, the ACPI mechanism must also provide some
+sort of tree-like representation. Fortunately, the ACPI namespace is
+already such a structure.
+
+For example, we could have the following device in ACPI namespace. The
+KEYS device is much like gpio_keys_polled.c in that it includes "pseudo"
+devices for each GPIO:
+
+	Device (KEYS) {
+		Name (_CRS, ResourceTemplate () {
+			GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
+				"\\_SB.PCI0.LPC", 0, ResourceConsumer,,) { 0 }
+			GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
+				"\\_SB.PCI0.LPC", 0, ResourceConsumer,,) { 1 }
+			...
+		})
+
+		Name (_DSD, Package () {
+			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+			Package () {
+				// Properties for KEYS device
+				Package () {"#gpio-cells", 1}
+			}
+		})
+
+		// "pseudo" devices declared under the parent device
+		Device (BTN0) {
+			Name (_DSD, Package () {
+				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+				Package () {
+					Package () {"label", "minnow_btn0"}
+					Package () {"gpios", Package () { ^KEYS, 0 0 1 }}
+				}
+			})
+		}
+
+		Device (BTN1) {
+			Name (_DSD, Package () {
+				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+				Package () {
+					Package () {"label", "minnow_btn1"}
+					Package () {"gpios", Package () { ^KEYS, 1 0 1 }}
+				}
+			})
+		}
+	}
+
+We can extract the above in gpio_keys_polled.c like:
+
+	void gpio_keys_polled_acpi_probe(struct device *dev)
+	{
+		struct acpi_device *adev = ACPI_COMPANION(dev);
+		struct acpi_device *button;
+
+		/* Properties for the KEYS device itself */
+		device_property_read(dev, ...);
+		/* or acpi_dev_get_property(adev, ...) */
+
+		/*
+		 * Iterate over button devices and extract their
+		 * configuration. Here we need to use ACPI specific
+		 * functions instead because the pseudo devices don't have
+		 * physical device attached to them.
+		 */
+		list_for_each_entry(button, &adev->children, node) {
+			const union acpi_object *label;
+
+			acpi_dev_get_property(button, "label",
+				ACPI_TYPE_STRING, &label);
+			dev_info(dev, "label: %s\n", label->string.pointer);
+		}
+	}
+
+Note that you still need proper error handling which is omitted in the
+above example, and also if possible instead of calling to ACPI specific
+functions, one should add the support to the subsystem in question which
+can then provide this information to the drivers in more generic way.
-- 
2.1.0.rc1

