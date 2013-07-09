Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3GIKKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:10:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35433 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3GIKKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:10:43 -0400
Date: Tue, 9 Jul 2013 12:10:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, joe.lawrence@stratus.com,
        myron.stowe@redhat.com, bhelgaas@google.com
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130709101039.GA4479@amd.pavel.ucw.cz>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com>
 <20130709094906.GA3870@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709094906.GA3870@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > > My thinkpad has rather high ping latencies... and perhaps it is due to
> > > PCIE ASPM.
> > 
> > Why would that be the problem?  The odds that the PCIE bus is the issue
> > seems strange to me.
> 
> Aha: I guess that's why the file is not writable:
> 
> pavel@amd:~$ dmesg | grep -i aspm 
> ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> e1000e 0000:02:00.0: Disabling ASPM L0s L1
> pavel@amd:~$ cat /sys/module/pcie_aspm/parameters/policy
> [default] performance powersave 
> pavel@amd:~$ 
> root@amd:~# echo -n performance >
> /sys/module/pcie_aspm/parameters/policy
> -su: echo: write error: Operation not permitted
> root@amd:~# 
> 
> But:
> 1) it should not list unavailable options
> 
> 2) operation not permitted seems like wrong error code for
> operation not supported.

So I forcibly enabled ASPM, and now ping latencies are in normal
range... no matter how I set
/sys/module/pcie_aspm/parameters/policy. Strange.

Any ideas what correct solution is?
									Pavel
Signed-off-by: Pavel Machek <pavel@ucw.cz>
(but don't apply)

diff --git a/.config b/.config
index 149f713..d7f5a11 100644
--- a/.config
+++ b/.config
@@ -1,6 +1,6 @@
 #
 # Automatically generated file; DO NOT EDIT.
-# Linux/x86 3.10.0-rc2 Kernel Configuration
+# Linux/x86 3.10.0 Kernel Configuration
 #
 # CONFIG_64BIT is not set
 CONFIG_X86_32=y
@@ -559,9 +559,9 @@ CONFIG_PCIEAER=y
 # CONFIG_PCIEAER_INJECT is not set
 CONFIG_PCIEASPM=y
 CONFIG_PCIEASPM_DEBUG=y
-CONFIG_PCIEASPM_DEFAULT=y
+# CONFIG_PCIEASPM_DEFAULT is not set
 # CONFIG_PCIEASPM_POWERSAVE is not set
-# CONFIG_PCIEASPM_PERFORMANCE is not set
+CONFIG_PCIEASPM_PERFORMANCE=y
 CONFIG_PCIE_PME=y
 CONFIG_ARCH_SUPPORTS_MSI=y
 # CONFIG_PCI_MSI is not set
@@ -1340,7 +1340,10 @@ CONFIG_MD_RAID1=y
 # CONFIG_MD_RAID456 is not set
 # CONFIG_MD_MULTIPATH is not set
 # CONFIG_MD_FAULTY is not set
-# CONFIG_BCACHE is not set
+CONFIG_BCACHE=y
+# CONFIG_BCACHE_DEBUG is not set
+# CONFIG_BCACHE_EDEBUG is not set
+# CONFIG_BCACHE_CLOSURES_DEBUG is not set
 CONFIG_BLK_DEV_DM=y
 # CONFIG_DM_DEBUG is not set
 CONFIG_DM_CRYPT=y
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index e4b1fb2..9a1b63e 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -382,7 +382,7 @@ static int __init acpi_pci_init(void)
 
 	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM) {
 		printk(KERN_INFO"ACPI FADT declares the system doesn't support PCIe ASPM, so disable it\n");
-		pcie_no_aspm();
+//		pcie_no_aspm();
 	}
 
 	ret = register_acpi_bus_type(&acpi_pci_bus);


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
