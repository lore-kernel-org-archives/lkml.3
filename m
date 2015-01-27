Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbbA0UmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:42:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225AbbA0UmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:42:17 -0500
Message-ID: <54C7F821.1020609@redhat.com>
Date: Tue, 27 Jan 2015 15:42:09 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Torez Smith <torez@redhat.com>
Subject: Re: inverse mapping from a struct console to device
References: <54C6984A.20501@redhat.com> <20150126205056.GA17169@leverpostej> <54C700BB.5030200@redhat.com> <20150127101440.GA17721@leverpostej> <54C77C6A.8000508@redhat.com> <20150127123002.GE17721@leverpostej>
In-Reply-To: <20150127123002.GE17721@leverpostej>
Content-Type: multipart/mixed;
 boundary="------------080802040001090407090008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080802040001090407090008
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 01/27/2015 07:30 AM, Mark Rutland wrote:
> On Tue, Jan 27, 2015 at 11:54:18AM +0000, Jon Masters wrote:

>> Here's an example of the data we get in the SPCR for reference:
>>
>> [0012]               Serial Port Register : [Generic Address Structure]
>> [0001]                           Space ID : 00 [SystemMemory]
>> [0001]                          Bit Width : 08
>> [0001]                         Bit Offset : 00
>> [0001]               Encoded Access Width : 01 [Byte Access:8]
>> [0008]                            Address : 000000001c020000
>>
>> [0001]                     Interrupt Type : 08
>> [0001]                PCAT-compatible IRQ : 00
>> [0004]                          Interrupt : 0000006C
>> [0001]                          Baud Rate : 07
>> [0001]                             Parity : 00
>> [0001]                          Stop Bits : 01
>> [0001]                       Flow Control : 00
>> [0001]                      Terminal Type : 00
>> [0001]                           Reserved : 00
>>
>> The actual structure is longer, but you get the idea. I first map this
>> to the correct Device in the DSDT with a device_initcall that will find
>> the table then walk the ACPI namespace to find the corresponding device.
>> This is stashed so that later we can perform the same kind of comparison
>> that you do with DT today. I also populate options, though so far have
>> only bothered to implement baud rate.
> 
> I would recommend that you set up as many of these ASAP. Otherwise
> someone's certain to mess up a table and we can never add them later.

So this is why I'm doing this (and other annoying things) right now - to
make sure that vendors shipping platforms have valid data we can also
use. If we wait until later, we'll have systems that potentially do the
wrong thing. The table above is an example of one for the Mustang. I had
the revision bumped to 2 and the IRQ information added to the reference
one, and I've also verified the tables for Seattle, as well as "other"
hardware that is in the pipeline from other vendors.

> Otherwise, sounds good!

So I'm handing this to Torez Smith to followup on (please keep her
copied on replies to this thread). I'm attaching a *hack* patch I put
together to proof of concept and then Torez will make this into
something actually useable/upstreamable (without hard coded static baud
strings and the like that I used to hack it up).

Jon.


--------------080802040001090407090008
Content-Type: text/x-patch;
 name="spcr_wip2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="spcr_wip2.patch"

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 6e692f4..13688c0 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -21,6 +21,13 @@ extern int acpi_disabled;
 extern int acpi_noirq;
 extern int acpi_pci_disabled;
 
+extern u64 spcr_serial_addr;
+extern int acpi_setup_spcr(void);
+extern struct acpi_device *acpi_spcr_serial_device;
+extern char *acpi_spcr_serial_options;
+extern bool acpi_spcr_console_check(struct acpi_device *adev,
+				    char *name, int index);
+
 /* 1 to indicate PSCI 0.2+ is implemented */
 static inline bool acpi_psci_present(void)
 {
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index d109b2f..90ae187 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -28,6 +28,9 @@
 #include <asm/cputype.h>
 #include <asm/cpu_ops.h>
 
+#include <linux/console.h>
+#include <linux/tty.h>
+
 int acpi_noirq;			/* skip ACPI IRQ initialization */
 int acpi_disabled;
 EXPORT_SYMBOL(acpi_disabled);
@@ -40,6 +43,12 @@ static int enabled_cpus;	/* Processors (GICC) with enabled flag in MADT */
 static char *boot_method;
 static u64 parked_address[NR_CPUS];
 
+u64 spcr_serial_addr;
+struct acpi_device *acpi_spcr_serial_device;
+EXPORT_SYMBOL(acpi_spcr_serial_device);
+char *acpi_spcr_serial_options;
+EXPORT_SYMBOL(acpi_spcr_serial_options);
+
 /*
  * Since we're on ARM, the default interrupt routing model
  * clearly has to be GIC.
@@ -376,3 +385,106 @@ static int __init parse_acpi(char *arg)
 	return 0;
 }
 early_param("acpi", parse_acpi);
+
+bool acpi_spcr_console_check(struct acpi_device *adev, char *name, int index)
+{
+	printk("JCM: acpi_spcr_console_check: enter\n");
+	if (!adev || adev != acpi_spcr_serial_device || console_set_on_cmdline)
+	{
+		printk("JCM: conditional test failed\n");
+		return false;
+	}
+	printk("JCM: would set up preferred console\n");
+	printk("JCM: return !add_preferred_console(%s, %d, %s)\n",
+	       name, index, acpi_spcr_serial_options);
+
+	return !add_preferred_console(name, index,
+				      kstrdup(acpi_spcr_serial_options,
+					      GFP_KERNEL));
+}
+
+static int __init acpi_parse_spcr(struct acpi_table_header *table)
+{
+	struct acpi_table_spcr *spcr = (struct acpi_table_spcr *)table;
+
+	/* Handle possible alignment issues */
+	memcpy(&spcr_serial_addr,
+	       &spcr->serial_port.address, sizeof(spcr_serial_addr));
+
+	switch(spcr->baud_rate) {
+	case 3:
+		acpi_spcr_serial_options = "9600";
+		break;
+	case 4:
+		acpi_spcr_serial_options = "19200";
+		break;
+	case 6:
+		acpi_spcr_serial_options = "57600";
+		break;
+	case 7:
+		acpi_spcr_serial_options = "115200";
+		break;
+	default:
+		acpi_spcr_serial_options = "";
+		break;
+	}
+
+	printk("SPCR serial device: 0x%llx (options: %s)\n",
+	       spcr_serial_addr, acpi_spcr_serial_options);
+
+	return -EOPNOTSUPP; /* value not used yet */
+}	
+
+static acpi_status acpi_spcr_device_scan(acpi_handle handle,
+					 u32 level, void *context, void **retv)
+{
+	unsigned long long adr;
+	struct acpi_buffer name_buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	acpi_status status = AE_OK;
+	struct acpi_device *adev;
+
+	status = acpi_get_name(handle, ACPI_FULL_PATHNAME, &name_buffer);
+	if (ACPI_FAILURE(status)) {
+		return status;
+	}
+
+	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
+	if (ACPI_FAILURE(status)) {
+		return AE_OK; /* continue */
+	}
+
+	if (adr == spcr_serial_addr) {
+
+		adev = acpi_bus_get_acpi_device(handle);
+
+		if (!adev) {
+			printk("Error locating SPCR device from ACPI handle\n");
+			return AE_OK; /* skip this one */
+		}
+
+		acpi_spcr_serial_device = adev;
+
+		printk("SPCR serial console: %s (0x%llx)\n",
+		       (char *)(name_buffer.pointer), adr);
+
+		return AE_OK; /* harmless to continue */
+	}
+
+	/* continue */
+	return AE_OK; /* continue */
+}
+
+int __init acpi_setup_spcr()
+{
+	if (0 != acpi_table_parse(ACPI_SIG_SPCR, acpi_parse_spcr)) {
+		printk("SPCR table not found - automatic console disabled\n");
+		return -ENODEV;
+	}
+
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+			    ACPI_UINT32_MAX, acpi_spcr_device_scan,
+			    NULL, NULL, NULL);
+
+	return 0;
+}
+
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 053a9b4..f66109e 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -605,6 +605,7 @@ const struct seq_operations cpuinfo_op = {
  */
 static int __init arm64_console_setup(void)
 {
+
 	/* Allow cmdline to override our assumed preferences */
 	if (console_set_on_cmdline)
 		return 0;
@@ -621,3 +622,12 @@ static int __init arm64_console_setup(void)
 	return 0;
 }
 early_initcall(arm64_console_setup);
+
+static int __init arm64_spcr_setup(void)
+{
+	/* scan the ACPI tables for automatic console configuration */
+	acpi_setup_spcr();
+
+	return 0;
+}
+device_initcall(arm64_spcr_setup);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 57ca61b..143adad 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -34,6 +34,7 @@
 #include <linux/serial_core.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -2664,8 +2665,12 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 		spin_lock_init(&uport->lock);
 		lockdep_set_class(&uport->lock, &port_lock_key);
 	}
-	if (uport->cons && uport->dev)
+	if (uport->cons && uport->dev) {
+		printk("JCM: serial_core: checking for console\n");
 		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
+		acpi_spcr_console_check(ACPI_COMPANION(uport->dev),
+					uport->cons->name, uport->line);
+	}
 
 	uart_configure_port(drv, state, uport);
 

--------------080802040001090407090008--
