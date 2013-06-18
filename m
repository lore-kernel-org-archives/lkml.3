Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab3FRVsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:48:18 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:38211 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933709Ab3FRVsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:48:12 -0400
Date: Tue, 18 Jun 2013 23:47:24 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH V3 2/6] FMC: add documentation for the core
Message-ID: <2e59a83f63bec7c19a38270fcc8d72d61be24118.1371591538.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1371591538.git.rubini@gnudd.com>
In-Reply-To: <cover.1371591538.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is selected sections of the current manual for fmc-bus, as
developed outside of the kernel before submission.

Like the other patches in this set, it corresponds to commit ab23167f of
the repository at ohwr.org

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Emilio G. Cota <cota@braap.org>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Acked-by: Rob Landley <rob@landley.net>
---
 Documentation/00-INDEX            |    2 +
 Documentation/fmc/00-INDEX        |   26 +++
 Documentation/fmc/API.txt         |   47 ++++++
 Documentation/fmc/FMC-and-SDB.txt |   88 +++++++++++
 Documentation/fmc/carrier.txt     |  311 +++++++++++++++++++++++++++++++++++++
 Documentation/fmc/identifiers.txt |  168 ++++++++++++++++++++
 Documentation/fmc/mezzanine.txt   |  123 +++++++++++++++
 Documentation/fmc/parameters.txt  |   56 +++++++
 8 files changed, 821 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/fmc/00-INDEX
 create mode 100644 Documentation/fmc/API.txt
 create mode 100644 Documentation/fmc/FMC-and-SDB.txt
 create mode 100644 Documentation/fmc/carrier.txt
 create mode 100644 Documentation/fmc/identifiers.txt
 create mode 100644 Documentation/fmc/mezzanine.txt
 create mode 100644 Documentation/fmc/parameters.txt

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 45b3df9..0c4cc68 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -187,6 +187,8 @@ firmware_class/
 	- request_firmware() hotplug interface info.
 flexible-arrays.txt
 	- how to make use of flexible sized arrays in linux
+fmc/
+	- information about the FMC bus abstraction
 frv/
 	- Fujitsu FR-V Linux documentation.
 futex-requeue-pi.txt
diff --git a/Documentation/fmc/00-INDEX b/Documentation/fmc/00-INDEX
new file mode 100644
index 0000000..71304b7
--- /dev/null
+++ b/Documentation/fmc/00-INDEX
@@ -0,0 +1,26 @@
+
+Documentation in this directory comes from sections of the manual we
+wrote for the externally-developed fmc-bus package. The complete
+manual as of today (2013-02) is available in PDF format at
+http://www.ohwr.org/projects/fmc-bus/files
+
+00-INDEX
+	- this file.
+
+FMC-and-SDB.txt
+	- What are FMC and SDB, basic concepts for this framework
+
+API.txt
+	- The functions that are exported by the bus driver
+
+parameters.txt
+	- The module parameters
+
+carrier.txt
+	- writing a carrier (a device)
+
+mezzanine.txt
+	- writing code for your mezzanine (a driver)
+
+identifiers.txt
+	- how identification and matching works
diff --git a/Documentation/fmc/API.txt b/Documentation/fmc/API.txt
new file mode 100644
index 0000000..06b06b92
--- /dev/null
+++ b/Documentation/fmc/API.txt
@@ -0,0 +1,47 @@
+Functions Exported by fmc.ko
+****************************
+
+The FMC core exports the usual 4 functions that are needed for a bus to
+work, and a few more:
+
+        int fmc_driver_register(struct fmc_driver *drv);
+        void fmc_driver_unregister(struct fmc_driver *drv);
+        int fmc_device_register(struct fmc_device *fmc);
+        void fmc_device_unregister(struct fmc_device *fmc);
+
+        int fmc_device_register_n(struct fmc_device **fmc, int n);
+        void fmc_device_unregister_n(struct fmc_device **fmc, int n);
+
+        uint32_t fmc_readl(struct fmc_device *fmc, int offset);
+        void fmc_writel(struct fmc_device *fmc, uint32_t val, int off);
+        void *fmc_get_drvdata(struct fmc_device *fmc);
+        void fmc_set_drvdata(struct fmc_device *fmc, void *data);
+
+        int fmc_reprogram(struct fmc_device *f, struct fmc_driver *d, char *gw,
+                          int sdb_entry);
+
+The data structure that describe a device is detailed in *note FMC
+Device::, the one that describes a driver is detailed in *note FMC
+Driver::.  Please note that structures of type fmc_device must be
+allocated by the caller, but must not be released after unregistering.
+The fmc-bus itself takes care of releasing the structure when their use
+count reaches zero - actually, the device model does that in lieu of us.
+
+The functions to register and unregister n devices are meant to be used
+by carriers that host more than one mezzanine. The devices must all be
+registered at the same time because if the FPGA is reprogrammed, all
+devices in the array are affected. Usually, the driver matching the
+first device will reprogram the FPGA, so other devices must know they
+are already driven by a reprogrammed FPGA.
+
+If a carrier hosts slots that are driven by different FPGA devices, it
+should register as a group only mezzanines that are driven by the same
+FPGA, for the reason outlined above.
+
+Finally, the fmc_reprogram function calls the reprogram method (see
+*note The API Offered by Carriers:: and also scans the memory area for
+an SDB tree. You can pass -1 as sdb_entry to disable such scan.
+Otherwise, the function fails if no tree is found at the specified
+entry point.  The function is meant to factorize common code, and by
+the time you read this it is already used by the spec-sw and fine-delay
+modules.
diff --git a/Documentation/fmc/FMC-and-SDB.txt b/Documentation/fmc/FMC-and-SDB.txt
new file mode 100644
index 0000000..fa14e0b
--- /dev/null
+++ b/Documentation/fmc/FMC-and-SDB.txt
@@ -0,0 +1,88 @@
+
+FMC (FPGA Mezzanine Card) is the standard we use for our I/O devices,
+in the context of White Rabbit and related hardware.
+
+In our I/O environments we need to write drivers for each mezzanine
+card, and such drivers must work regardless of the carrier being used.
+To achieve this, we abstract the FMC interface.
+
+We have a carrier for PCI-E called SPEC and one for VME called SVEC,
+but more are planned.  Also, we support stand-alone devices (usually
+plugged on a SPEC card), controlled through Etherbone, developed by GSI.
+
+Code and documentation for the FMC bus was born as part of the spec-sw
+project, but now it lives in its own project. Other projects, i.e.
+software support for the various carriers, should include this as a
+submodule.
+
+The most up to date version of code and documentation is always
+available from the repository you can clone from:
+
+        git://ohwr.org/fmc-projects/fmc-bus.git (read-only)
+        git@ohwr.org:fmc-projects/fmc-bus.git (read-write for developers)
+
+Selected versions of the documentation, as well as complete tar
+archives for selected revisions are placed to the Files section of the
+project: `http://www.ohwr.org/projects/fmc-bus/files'
+
+
+What is FMC
+***********
+
+FMC, as said, stands for "FPGA Mezzanine Card". It is a standard
+developed by the VME consortium called VITA (VMEbus International Trade
+Association and ratified by ANSI, the American National Standard
+Institute.  The official documentation is called "ANSI-VITA 57.1".
+
+The FMC card is an almost square PCB, around 70x75 millimeters, that is
+called mezzanine in this document.  It usually lives plugged into
+another PCB for power supply and control; such bigger circuit board is
+called carrier from now on, and a single carrier may host more than one
+mezzanine.
+
+In the typical application the mezzanine is mostly analog while the
+carrier is mostly digital, and hosts an FPGA that must be configured to
+match the specific mezzanine and the desired application. Thus, you may
+need to load different FPGA images to drive different instances of the
+same mezzanine.
+
+FMC, as such, is not a bus in the usual meaning of the term, because
+most carriers have only one connector, and carriers with several
+connectors have completely separate electrical connections to them.
+This package, however, implements a bus as a software abstraction.
+
+
+What is SDB
+***********
+
+SDB (Self Describing Bus) is a set of data structures that we use for
+enumerating the internal structure of an FPGA image. We also use it as
+a filesystem inside the FMC EEPROM.
+
+SDB is not mandatory for use of this FMC kernel bus, but if you have SDB
+this package can make good use of it.  SDB itself is developed in the
+fpga-config-space OHWR project. The link to the repository is
+`git://ohwr.org/hdl-core-lib/fpga-config-space.git' and what is used in
+this project lives in the sdbfs subdirectory in there.
+
+SDB support for FMC is described in *note FMC Identification:: and
+*note SDB Support::
+
+
+SDB Support
+***********
+
+The fmc.ko bus driver exports a few functions to help drivers taking
+advantage of the SDB information that may be present in your own FPGA
+memory image.
+
+The module exports the following functions, in the special header
+<linux/fmc-sdb.h>. The linux/ prefix in the name is there because we
+plan to submit it upstream in the future, and don't want to force
+changes on our drivers if that happens.
+
+         int fmc_scan_sdb_tree(struct fmc_device *fmc, unsigned long address);
+         void fmc_show_sdb_tree(struct fmc_device *fmc);
+         signed long fmc_find_sdb_device(struct sdb_array *tree, uint64_t vendor,
+                                         uint32_t device, unsigned long *sz);
+         int fmc_free_sdb_tree(struct fmc_device *fmc);
diff --git a/Documentation/fmc/carrier.txt b/Documentation/fmc/carrier.txt
new file mode 100644
index 0000000..173f6d6
--- /dev/null
+++ b/Documentation/fmc/carrier.txt
@@ -0,0 +1,311 @@
+FMC Device
+**********
+
+Within the Linux bus framework, the FMC device is created and
+registered by the carrier driver. For example, the PCI driver for the
+SPEC card fills a data structure for each SPEC that it drives, and
+registers an associated FMC device for each card.  The SVEC driver can
+do exactly the same for the VME carrier (actually, it should do it
+twice, because the SVEC carries two FMC mezzanines).  Similarly, an
+Etherbone driver will be able to register its own FMC devices, offering
+communication primitives through frame exchange.
+
+The contents of the EEPROM within the FMC are used for identification
+purposes, i.e. for matching the device with its own driver. For this
+reason the device structure includes a complete copy of the EEPROM
+(actually, the carrier driver may choose whether or not to return it -
+for example we most likely won't have the whole EEPROM available for
+Etherbone devices.
+
+The following listing shows the current structure defining a device.
+Please note that all the machinery is in place but some details may
+still change in the future.  For this reason, there is a version field
+at the beginning of the structure.  As usual, the minor number will
+change for compatible changes (like a new flag) and the major number
+will increase when an incompatible change happens (for example, a
+change in layout of some fmc data structures).  Device writers should
+just set it to the value FMC_VERSION, and be ready to get back -EINVAL
+at registration time.
+
+     struct fmc_device {
+             unsigned long version;
+             unsigned long flags;
+             struct module *owner;           /* char device must pin it */
+             struct fmc_fru_id id;           /* for EEPROM-based match */
+             struct fmc_operations *op;      /* carrier-provided */
+             int irq;                        /* according to host bus. 0 == none */
+             int eeprom_len;                 /* Usually 8kB, may be less */
+             int eeprom_addr;                /* 0x50, 0x52 etc */
+             uint8_t *eeprom;                /* Full contents or leading part */
+             char *carrier_name;             /* "SPEC" or similar, for special use */
+             void *carrier_data;             /* "struct spec *" or equivalent */
+             __iomem void *fpga_base;        /* May be NULL (Etherbone) */
+             __iomem void *slot_base;        /* Set by the driver */
+             struct fmc_device **devarray;   /* Allocated by the bus */
+             int slot_id;                    /* Index in the slot array */
+             int nr_slots;                   /* Number of slots in this carrier */
+             unsigned long memlen;           /* Used for the char device */
+             struct device dev;              /* For Linux use */
+             struct device *hwdev;           /* The underlying hardware device */
+             unsigned long sdbfs_entry;
+             struct sdb_array *sdb;
+             uint32_t device_id;             /* Filled by the device */
+             char *mezzanine_name;           /* Defaults to ``fmc'' */
+             void *mezzanine_data;
+     };
+
+The meaning of most fields is summarized in the code comment above.
+
+The following fields must be filled by the carrier driver before
+registration:
+
+   * version: must be set to FMC_VERSION.
+
+   * owner: set to MODULE_OWNER.
+
+   * op: the operations to act on the device.
+
+   * irq: number for the mezzanine; may be zero.
+
+   * eeprom_len: length of the following array.
+
+   * eeprom_addr: 0x50 for first mezzanine and so on.
+
+   * eeprom: the full content of the I2C EEPROM.
+
+   * carrier_name.
+
+   * carrier_data: a unique pointer for the carrier.
+
+   * fpga_base: the I/O memory address (may be NULL).
+
+   * slot_id: the index of this slot (starting from zero).
+
+   * memlen: if fpga_base is valid, the length of I/O memory.
+
+   * hwdev: to be used in some dev_err() calls.
+
+   * device_id: a slot-specific unique integer number.
+
+
+Please note that the carrier should read its own EEPROM memory before
+registering the device, as well as fill all other fields listed above.
+
+The following fields should not be assigned, because they are filled
+later by either the bus or the device driver:
+
+   * flags.
+
+   * fru_id: filled by the bus, parsing the eeprom.
+
+   * slot_base: filled and used by the driver, if useful to it.
+
+   * devarray: an array og all mezzanines driven by a singe FPGA.
+
+   * nr_slots: set by the core at registration time.
+
+   * dev: used by Linux.
+
+   * sdb: FPGA contents, scanned according to driver's directions.
+
+   * sdbfs_entry: SDB entry point in EEPROM: autodetected.
+
+   * mezzanine_data: available for the driver.
+
+   * mezzanine_name: filled by fmc-bus during identification.
+
+
+Note: mezzanine_data may be redundant, because Linux offers the drvdata
+approach, so the field may be removed in later versions of this bus
+implementation.
+
+As I write this, she SPEC carrier is already completely functional in
+the fmc-bus environment, and is a good reference to look at.
+
+
+The API Offered by Carriers
+===========================
+
+The carrier provides a number of methods by means of the
+`fmc_operations' structure, which currently is defined like this
+(again, it is a moving target, please refer to the header rather than
+this document):
+
+     struct fmc_operations {
+             uint32_t (*readl)(struct fmc_device *fmc, int offset);
+             void (*writel)(struct fmc_device *fmc, uint32_t value, int offset);
+             int (*reprogram)(struct fmc_device *f, struct fmc_driver *d, char *gw);
+             int (*validate)(struct fmc_device *fmc, struct fmc_driver *drv);
+             int (*irq_request)(struct fmc_device *fmc, irq_handler_t h,
+                                char *name, int flags);
+             void (*irq_ack)(struct fmc_device *fmc);
+             int (*irq_free)(struct fmc_device *fmc);
+             int (*gpio_config)(struct fmc_device *fmc, struct fmc_gpio *gpio,
+                                int ngpio);
+             int (*read_ee)(struct fmc_device *fmc, int pos, void *d, int l);
+             int (*write_ee)(struct fmc_device *fmc, int pos, const void *d, int l);
+     };
+
+The individual methods perform the following tasks:
+
+`readl'
+`writel'
+     These functions access FPGA registers by whatever means the
+     carrier offers. They are not expected to fail, and most of the time
+     they will just make a memory access to the host bus. If the
+     carrier provides a fpga_base pointer, the driver may use direct
+     access through that pointer. For this reason the header offers the
+     inline functions fmc_readl and fmc_writel that access fpga_base if
+     the respective method is NULL. A driver that wants to be portable
+     and efficient should use fmc_readl and fmc_writel.  For Etherbone,
+     or other non-local carriers, error-management is still to be
+     defined.
+
+`validate'
+     Module parameters are used to manage different applications for
+     two or more boards of the same kind. Validation is based on the
+     busid module parameter, if provided, and returns the matching
+     index in the associated array. See *note Module Parameters:: in in
+     doubt. If no match is found, `-ENOENT' is returned; if the user
+     didn't pass `busid=', all devices will pass validation.  The value
+     returned by the validate method can be used as index into other
+     parameters (for example, some drivers use the `lm32=' parameter in
+     this way). Such "generic parameters" are documented in *note
+     Module Parameters::, below. The validate method is used by
+     `fmc-trivial.ko', described in *note fmc-trivial::.
+
+`reprogram'
+     The carrier enumerates FMC devices by loading a standard (or
+     golden) FPGA binary that allows EEPROM access. Each driver, then,
+     will need to reprogram the FPGA by calling this function.  If the
+     name argument is NULL, the carrier should reprogram the golden
+     binary. If the gateware name has been overridden through module
+     parameters (in a carrier-specific way) the file loaded will match
+     the parameters. Per-device gateware names can be specified using
+     the `gateware=' parameter, see *note Module Parameters::.  Note:
+     Clients should call rhe new helper, fmc_reprogram, which both
+     calls this method and parse the SDB tree of the FPGA.
+
+`irq_request'
+`irq_ack'
+`irq_free'
+     Interrupt management is carrier-specific, so it is abstracted as
+     operations. The interrupt number is listed in the device
+     structure, and for the mezzanine driver the number is only
+     informative.  The handler will receive the fmc pointer as dev_id;
+     the flags argument is passed to the Linux request_irq function,
+     but fmc-specific flags may be added in the future. You'll most
+     likely want to pass the `IRQF_SHARED' flag.
+
+`gpio_config'
+     The method allows to configure a GPIO pin in the carrier, and read
+     its current value if it is configured as input. See *note The GPIO
+     Abstraction:: for details.
+
+`read_ee'
+`write_ee'
+     Read or write the EEPROM. The functions are expected to be only
+     called before reprogramming and the carrier should refuse them
+     with `ENODEV' after reprogramming.  The offset is expected to be
+     within 8kB (the current size), but addresses up to 1MB are
+     reserved to fit bigger I2C devices in the future. Carriers may
+     offer access to other internal flash memories using these same
+     methods: for example the SPEC driver may define that its carrier
+     I2C memory is seen at offset 1M and the internal SPI flash is seen
+     at offset 16M.  This multiplexing of several flash memories in the
+     same address space is is carrier-specific and should only be used
+     by a driver that has verified the `carrier_name' field.
+
+
+
+The GPIO Abstraction
+====================
+
+Support for GPIO pins in the fmc-bus environment is not very
+straightforward and deserves special discussion.
+
+While the general idea of a carrier-independent driver seems to fly,
+configuration of specific signals within the carrier needs at least
+some knowledge of the carrier itself.  For this reason, the specific
+driver can request to configure carrier-specific GPIO pins, numbered
+from 0 to at most 4095.  Configuration is performed by passing a
+pointer to an array of struct fmc_gpio items, as well as the length of
+the array. This is the data structure:
+
+        struct fmc_gpio {
+                char *carrier_name;
+                int gpio;
+                int _gpio;      /* internal use by the carrier */
+                int mode;       /* GPIOF_DIR_OUT etc, from <linux/gpio.h> */
+                int irqmode;    /* IRQF_TRIGGER_LOW and so on */
+        };
+
+By specifying a carrier_name for each pin, the driver may access
+different pins in different carriers.  The gpio_config method is
+expected to return the number of pins successfully configured, ignoring
+requests for other carriers. However, if no pin is configured (because
+no structure at all refers to the current carrier_name), the operation
+returns an error so the caller will know that it is running under a
+yet-unsupported carrier.
+
+So, for example, a driver that has been developed and tested on both
+the SPEC and the SVEC may request configuration of two different GPIO
+pins, and expect one such configuration to succeed - if none succeeds
+it most likely means that the current carrier is a still-unknown one.
+
+If, however, your GPIO pin has a specific known role, you can pass a
+special number in the gpio field, using one of the following macros:
+
+        #define FMC_GPIO_RAW(x)         (x)             /* 4096 of them */
+        #define FMC_GPIO_IRQ(x)         ((x) + 0x1000)  /*  256 of them */
+        #define FMC_GPIO_LED(x)         ((x) + 0x1100)  /*  256 of them */
+        #define FMC_GPIO_KEY(x)         ((x) + 0x1200)  /*  256 of them */
+        #define FMC_GPIO_TP(x)          ((x) + 0x1300)  /*  256 of them */
+        #define FMC_GPIO_USER(x)        ((x) + 0x1400)  /*  256 of them */
+
+Use of virtual GPIO numbers (anything but FMC_GPIO_RAW) is allowed
+provided the carrier_name field in the data structure is left
+unspecified (NULL). Each carrier is responsible for providing a mapping
+between virtual and physical GPIO numbers. The carrier may then use the
+_gpio field to cache the result of this mapping.
+
+All carriers must map their I/O lines to the sets above starting from
+zero.  The SPEC, for example, maps interrupt pins 0 and 1, and test
+points 0 through 3 (even if the test points on the PCB are called
+5,6,7,8).
+
+If, for example, a driver requires a free LED and a test point (for a
+scope probe to be plugged at some point during development) it may ask
+for FMC_GPIO_LED(0) and FMC_GPIO_TP(0). Each carrier will provide
+suitable GPIO pins.  Clearly, the person running the drivers will know
+the order used by the specific carrier driver in assigning leds and
+testpoints, so to make a carrier-dependent use of the diagnostic tools.
+
+In theory, some form of autodetection should be possible: a driver like
+the wr-nic (which uses IRQ(1) on the SPEC card) should configure
+IRQ(0), make a test with software-generated interrupts and configure
+IRQ(1) if the test fails. This probing step should be used because even
+if the wr-nic gateware is known to use IRQ1 on the SPEC, the driver
+should be carrier-independent and thus use IRQ(0) as a first bet -
+actually, the knowledge that IRQ0 may fail is carrier-dependent
+information, but using it doesn't make the driver unsuitable for other
+carriers.
+
+The return value of gpio_config is defined as follows:
+
+   * If no pin in the array can be used by the carrier, `-ENODEV'.
+
+   * If at least one virtual GPIO number cannot be mapped, `-ENOENT'.
+
+   * On success, 0 or positive. The value returned is the number of
+     high input bits (if no input is configured, the value for success
+     is 0).
+
+While I admit the procedure is not completely straightforward, it
+allows configuration, input and output with a single carrier operation.
+Given the typical use case of FMC devices, GPIO operations are not
+expected to ever by in hot paths, and GPIO access so fare has only been
+used to configure the interrupt pin, mode and polarity. Especially
+reading inputs is not expected to be common. If your device has GPIO
+capabilities in the hot path, you should consider using the kernel's
+GPIO mechanisms.
diff --git a/Documentation/fmc/identifiers.txt b/Documentation/fmc/identifiers.txt
new file mode 100644
index 0000000..3bb577f
--- /dev/null
+++ b/Documentation/fmc/identifiers.txt
@@ -0,0 +1,168 @@
+FMC Identification
+******************
+
+The FMC standard requires every compliant mezzanine to carry
+identification information in an I2C EEPROM.  The information must be
+laid out according to the "IPMI Platform Management FRU Information",
+where IPMI is a lie I'd better not expand, and FRU means "Field
+Replaceable Unit".
+
+The FRU information is an intricate unreadable binary blob that must
+live at offset 0 of the EEPROM, and typically extends for a few hundred
+bytes. The standard allows the application to use all the remaining
+storage area of the EEPROM as it wants.
+
+This chapter explains how to create your own EEPROM image and how to
+write it in your mezzanine, as well as how devices and drivers are
+paired at run time.  EEPROM programming uses tools that are part of this
+package and SDB (part of the fpga-config-space package).
+
+The first sections are only interesting for manufacturers who need to
+write the EEPROM. If you are just a software developer writing an FMC
+device or driver, you may jump straight to *note SDB Support::.
+
+
+Building the FRU Structure
+==========================
+
+If you want to know the internals of the FRU structure and despair, you
+can retrieve the document from
+`http://download.intel.com/design/servers/ipmi/FRU1011.pdf' .  The
+standard is awful and difficult without reason, so we only support the
+minimum mandatory subset - we create a simple structure and parse it
+back at run time, but we are not able to either generate or parse more
+arcane features like non-english languages and 6-bit text.  If you need
+more items of the FRU standard for your boards, please submit patches.
+
+This package includes the Python script that Matthieu Cattin wrote to
+generate the FRU binary blob, based on an helper libipmi by Manohar
+Vanga and Matthieu himself.  I changed the test script to receive
+parameters from the command line or from the environment (the command
+line takes precedence)
+
+To make a long story short, in order to build a standard-compliant
+binary file to be burned in your EEPROM, you need the following items:
+
+        Environment    Opt     Official Name          Default
+---------------------------------------------------------------------
+        FRU_VENDOR     -v      "Board Manufacturer"   fmc-example
+        FRU_NAME       -n      "Board Product Name"   mezzanine
+        FRU_SERIAL     -s      `Board Serial Number"  0001
+        FRU_PART       -p      "Board Part Number"    sample-part
+        FRU_OUTPUT     -o      not applicable         /dev/stdout
+
+The "Official Name" above is what you find in the FRU official
+documentation, chapter 11, page 7 ("Board Info Area Format").  The
+output option is used to save the generated binary to a specific file
+name instead of stdout.
+
+You can pass the items to the FRU generator either in the environment
+or on the command line.  This package has currently no support for
+specifying power consumption or such stuff, but I plan to add it as
+soon as I find some time for that.
+
+FIXME: consumption etc for FRU are here or in PTS?
+
+The following example creates a binary image for a specific board:
+
+        ./tools/fru-generator -v CERN -n FmcAdc100m14b4cha \
+               -s HCCFFIA___-CR000003 -p EDA-02063-V5-0 > eeprom.bin
+
+The following example shows a script that builds several binary EEPROM
+images for a series of boards, changing the serial number for each of
+them. The script uses a mix of environment variables and command line
+options, and uses the same string patterns shown above.
+
+        #!/bin/sh
+
+        export FRU_VENDOR="CERN"
+        export FRU_NAME="FmcAdc100m14b4cha"
+        export FRU_PART="EDA-02063-V5-0"
+
+        serial="HCCFFIA___-CR"
+
+        for number in $(seq 1 50); do
+           # build number-string "ns"
+           ns="$(printf %06d $number)"
+           ./fru-generator -s "${serial}${ns}" > eeprom-${ns}.bin
+        done
+
+
+Using SDB-FS in the EEPROM
+==========================
+
+If you want to use SDB as a filesystem in the EEPROM device within the
+mezzanine, you should create one such filesystem using gensdbfs, from
+the fpga-config-space package on OHWR.
+
+By using an SBD filesystem you can cluster several files in a single
+EEPROM, so both the host system and a soft-core running in the FPGA (if
+any) can access extra production-time information.
+
+We chose to use SDB as a storage filesystem because the format is very
+simple, and both the host system and the soft-core will likely already
+include support code for such format. The SDB library offered by the
+fpga-config-space is less than 1kB under LM32, so it proves quite up to
+the task.
+
+The SDB entry point (which acts as a directory listing) cannot live at
+offset zero in the flash device, because the FRU information must live
+there.  To avoid wasting precious storage space while still allowing
+for more-than-minimal FRU structures, the fmc.ko will look for the SDB
+record at address 256, 512 and 1024.
+
+In order to generate the complete EEPROM image you'll need a
+configuration file for gensdbfs: you tell the program where to place
+the sdb entry point, and you must force the FRU data file to be placed
+at the beginning of the storage device. If needed, you can also place
+other files at a special offset (we sometimes do it for backward
+compatibility with drivers we wrote before implementing SDB for flash
+memory).
+
+The directory tools/sdbfs of this package includes a well-commented
+example that you may want to use as a starting point (the comments are
+in the file called -SDB-CONFIG-).  Reading documentation for gensdbfs
+is a suggested first step anyways.
+
+This package (generic FMC bus support) only accesses two files in the
+EEPROM: the FRU information, at offset zero, with a suggested filename
+of IPMI-FRU and the short name for the mezzanine, in a file called
+name. The IPMI-FRU name is not mandatory, but a strongly suggested
+choice; the name filename is mandatory, because this is the preferred
+short name used by the FMC core.  For example, a name of "fdelay" may
+supplement a Product Name like "FmcDelay1ns4cha" - exactly as
+demonstrated in `tools/sdbfs'.
+
+Note: SDB access to flash memory is not yet supported, so the short
+name currently in use is just the "Product Name" FRU string.
+
+The example in tools/sdbfs includes an extra file, that is needed by
+the fine-delay driver, and must live at a known address of 0x1800.  By
+running gensdbfs on that directory you can output your binary EEPROM
+image (here below spusa$ is the shell prompt):
+
+        spusa$ ../fru-generator -v CERN -n FmcDelay1ns4cha -s proto-0 \
+                      -p EDA-02267-V3 > IPMI-FRU
+        spusa$ ls -l
+        total 16
+        -rw-rw-r-- 1 rubini staff 975 Nov 19 18:08 --SDB-CONFIG--
+        -rw-rw-r-- 1 rubini staff 216 Nov 19 18:13 IPMI-FRU
+        -rw-rw-r-- 1 rubini staff  11 Nov 19 18:04 fd-calib
+        -rw-rw-r-- 1 rubini staff   7 Nov 19 18:04 name
+        spusa$ sudo gensdbfs . /lib/firmware/fdelay-eeprom.bin
+        spusa$ sdb-read -l -e 0x100 /lib/firmware/fdelay-eeprom.bin
+        /home/rubini/wip/sdbfs/userspace/sdb-read: listing format is to be defined
+        46696c6544617461:2e202020  00000100-000018ff .
+        46696c6544617461:6e616d65  00000200-00000206 name
+        46696c6544617461:66642d63  00001800-000018ff fd-calib
+        46696c6544617461:49504d49  00000000-000000d7 IPMI-FRU
+        spusa$ ../fru-dump /lib/firmware/fdelay-eeprom.bin
+        /lib/firmware/fdelay-eeprom.bin: manufacturer: CERN
+        /lib/firmware/fdelay-eeprom.bin: product-name: FmcDelay1ns4cha
+        /lib/firmware/fdelay-eeprom.bin: serial-number: proto-0
+        /lib/firmware/fdelay-eeprom.bin: part-number: EDA-02267-V3
+
+As expected, the output file is both a proper sdbfs object and an IPMI
+FRU information blob. The fd-calib file lives at offset 0x1800 and is
+over-allocated to 256 bytes, according to the configuration file for
+gensdbfs.
diff --git a/Documentation/fmc/mezzanine.txt b/Documentation/fmc/mezzanine.txt
new file mode 100644
index 0000000..87910db
--- /dev/null
+++ b/Documentation/fmc/mezzanine.txt
@@ -0,0 +1,123 @@
+FMC Driver
+**********
+
+An FMC driver is concerned with the specific mezzanine and associated
+gateware. As such, it is expected to be independent of the carrier
+being used: it will perform I/O accesses only by means of
+carrier-provided functions.
+
+The matching between device and driver is based on the content of the
+EEPROM (as mandated by the FMC standard) or by the actual cores
+configured in the FPGA; the latter technique is used when the FPGA is
+already programmed when the device is registered to the bus core.
+
+In some special cases it is possible for a driver to directly access
+FPGA registers, by means of the `fpga_base' field of the device
+structure. This may be needed for high-bandwidth peripherals like fast
+ADC cards. If the device module registered a remote device (for example
+by means of Etherbone), the `fpga_base' pointer will be NULL.
+Therefore, drivers must be ready to deal with NULL base pointers, and
+fail gracefully.  Most driver, however, are not expected to access the
+pointer directly but run fmc_readl and fmc_writel instead, which will
+work in any case.
+
+In even more special cases, the driver may access carrier-specific
+functionality: the `carrier_name' string allows the driver to check
+which is the current carrier and make use of the `carrier_data'
+pointer.  We chose to use carrier names rather than numeric identifiers
+for greater flexibility, but also to avoid a central registry within
+the `fmc.h' file - we hope other users will exploit our framework with
+their own carriers.  An example use of carrier names is in GPIO setup
+(see *note The GPIO Abstraction::), although the name match is not
+expected to be performed by the driver.  If you depend on specific
+carriers, please check the carrier name and fail gracefully if your
+driver finds it is running in a yet-unknown-to-it environment.
+
+
+ID Table
+========
+
+Like most other Linux drivers, and FMC driver must list all the devices
+which it is able to drive.  This is usually done by means of a device
+table, but in FMC we can match hardware based either on the contents of
+their EEPROM or on the actual FPGA cores that can be enumerated.
+Therefore, we have two tables of identifiers.
+
+Matching of FRU information depends on two names, the manufacturer (or
+vendor) and the device (see *note FMC Identification::); for
+flexibility during production (i.e. before writing to the EEPROM) the
+bus supports a catch-all driver that specifies NULL strings. For this
+reason, the table is specified as pointer-and-length, not a a
+null-terminated array - the entry with NULL names can be a valid entry.
+
+Matching on FPGA cores depends on two numeric fields: the 64-bit vendor
+number and the 32-bit device number. Support for matching based on
+class is not yet implemented.  Each device is expected to be uniquely
+identified by an array of cores (it matches if all of the cores are
+instantiated), and for consistency the list is passed as
+pointer-and-length.  Several similar devices can be driven by the same
+driver, and thus the driver specifies and array of such arrays.
+
+The complete set of involved data structures is thus the following:
+
+        struct fmc_fru_id { char *manufacturer; char *product_name; };
+        struct fmc_sdb_one_id { uint64_t vendor; uint32_t device; };
+        struct fmc_sdb_id { struct fmc_sdb_one_id *cores; int cores_nr; };
+
+        struct fmc_device_id {
+                struct fmc_fru_id *fru_id; int fru_id_nr;
+                struct fmc_sdb_id *sdb_id; int sdb_id_nr;
+        };
+
+A better reference, with full explanation, is the <linux/fmc.h> header.
+
+
+Module Parameters
+=================
+
+Most of the FMC drivers need the same set of kernel parameters. This
+package includes support to implement common parameters by means of
+fields in the `fmc_driver' structure and simple macro definitions.
+
+The parameters are carrier-specific, in that they rely on the busid
+concept, that varies among carriers. For the SPEC, the identifier is a
+PCI bus and devfn number, 16 bits wide in total; drivers for other
+carriers will most likely offer something similar but not identical,
+and some code duplication is unavoidable.
+
+This is the list of parameters that are common to several modules to
+see how they are actually used, please look at spec-trivial.c.
+
+`busid='
+     This is an array of integers, listing carrier-specific
+     identification numbers. For PIC, for example, `0x0400' represents
+     bus 4, slot 0.  If any such ID is specified, the driver will only
+     accept to drive cards that appear in the list (even if the FMC ID
+     matches). This is accomplished by the validate carrier method.
+
+`gateware='
+     The argument is an array of strings. If no busid= is specified,
+     the first string of gateware= is used for all cards; otherwise the
+     identifiers and gateware names are paired one by one, in the order
+     specified.
+
+`show_sdb='
+     For modules supporting it, this parameter asks to show the SDB
+     internal structure by means of kernel messages. It is disabled by
+     default because those lines tend to hide more important messages,
+     if you look at the system console while loading the drivers.
+     Note: the parameter is being obsoleted, because fmc.ko itself now
+     supports dump_sdb= that applies to every client driver.
+
+
+For example, if you are using the trivial driver to load two different
+gateware files to two different cards, you can use the following
+parameters to load different binaries to the cards, after looking up
+the PCI identifiers. This has been tested with a SPEC carrier.
+
+        insmod fmc-trivial.ko \
+                              busid=0x0200,0x0400 \
+                              gateware=fmc/fine-delay.bin,fmc/simple-dio.bin
+
+Please note that not all sub-modules support all of those parameters.
+You can use modinfo to check what is supported by each module.
diff --git a/Documentation/fmc/parameters.txt b/Documentation/fmc/parameters.txt
new file mode 100644
index 0000000..59edf08
--- /dev/null
+++ b/Documentation/fmc/parameters.txt
@@ -0,0 +1,56 @@
+Module Parameters in fmc.ko
+***************************
+
+The core driver receives two module parameters, meant to help debugging
+client modules. Both parameters can be modified by writing to
+/sys/module/fmc/parameters/, because they are used when client drivers
+are devices are registered, not when fmc.ko is loaded.
+
+`dump_eeprom='
+     If not zero, the parameter asks the bus controller to dump the
+     EEPROM of any device that is registered, using printk.
+
+`dump_sdb='
+     If not zero, the parameter prints the SDB tree of every FPGA it is
+     loaded by fmc_reprogram(). If greater than one, it asks to dump
+     the binary content of SDB records.  This currently only dumps the
+     top-level SDB array, though.
+
+
+EEPROM dumping avoids repeating lines, since most of the contents is
+usually empty and all bits are one or zero. This is an example of the
+output:
+
+        [ 6625.850480] spec 0000:02:00.0: FPGA programming successful
+        [ 6626.139949] spec 0000:02:00.0: Manufacturer: CERN
+        [ 6626.144666] spec 0000:02:00.0: Product name: FmcDelay1ns4cha
+        [ 6626.150370] FMC: mezzanine 0: 0000:02:00.0 on SPEC
+        [ 6626.155179] FMC: dumping eeprom 0x2000 (8192) bytes
+        [ 6626.160087] 0000: 01 00 00 01  00 0b 00 f3  01 0a 00 a5  85 87 c4 43
+        [ 6626.167069] 0010: 45 52 4e cf  46 6d 63 44  65 6c 61 79  31 6e 73 34
+        [ 6626.174019] 0020: 63 68 61 c7  70 72 6f 74  6f 2d 30 cc  45 44 41 2d
+        [ 6626.180975] 0030: 30 32 32 36  37 2d 56 33  da 32 30 31  32 2d 31 31
+        [...]
+        [ 6626.371366] 0200: 66 64 65 6c  61 79 0a 00  00 00 00 00  00 00 00 00
+        [ 6626.378359] 0210: 00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00
+        [ 6626.385361] [...]
+        [ 6626.387308] 1800: 70 6c 61 63  65 68 6f 6c  64 65 72 ff  ff ff ff ff
+        [ 6626.394259] 1810: ff ff ff ff  ff ff ff ff  ff ff ff ff  ff ff ff ff
+        [ 6626.401250] [...]
+
+The dump of SDB looks like the following; the example shows the simple
+golden gateware for the SPEC card, removing the leading timestamps to
+fit the page:
+
+        spec 0000:02:00.0: SDB: 00000651:e6a542c9 WB4-Crossbar-GSI
+        spec 0000:02:00.0: SDB: 0000ce42:ff07fc47 WR-Periph-Syscon (00000000-000000ff)
+        FMC: mezzanine 0: 0000:02:00.0 on SPEC
+        FMC: poor dump of sdb first level:
+        0000: 53 44 42 2d  00 02 01 00  00 00 00 00  00 00 00 00
+        0010: 00 00 00 00  00 00 01 ff  00 00 00 00  00 00 06 51
+        0020: e6 a5 42 c9  00 00 00 02  20 12 05 11  57 42 34 2d
+        0030: 43 72 6f 73  73 62 61 72  2d 47 53 49  20 20 20 00
+        0040: 00 00 01 01  00 00 00 07  00 00 00 00  00 00 00 00
+        0050: 00 00 00 00  00 00 00 ff  00 00 00 00  00 00 ce 42
+        0060: ff 07 fc 47  00 00 00 01  20 12 03 05  57 52 2d 50
+        0070: 65 72 69 70  68 2d 53 79  73 63 6f 6e  20 20 20 01
-- 
1.7.7.2
