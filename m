Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab3D3V0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:26:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19386 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969Ab3D3V0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:26:05 -0400
Date: Tue, 30 Apr 2013 17:25:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/paravirt] x86-64, gdt: Store/ load GDT for ACPI S3 or
 hibernate/resume path is not needed.
Message-ID: <20130430212542.GA19753@phenom.dumpdata.com>
References: <1365194544-14648-2-git-send-email-konrad.wilk@oracle.com>
 <tip-e7a5cd063c7b4c58417f674821d63f5eb6747e37@git.kernel.org>
 <4054620.GA2vTd0F6g@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4054620.GA2vTd0F6g@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > After the 'restore_registers' it returns and we end up called
> > restore_processor_state() - where we reload the GDT. The reload of
> > the GDT is not needed as bootup kernel has already loaded the GDT which
> > is at the same physical location as the the restored kernel.
> 
> I'm not sure if this particular statement is actually correct.  It is correct
> on 32-bit, but here it is not necessary for the bootup kernel to be the same
> as the image one.  Different kernel version may be used for that even (at
> least theoretically).  So the question is, and I'm quite unsure about the
> answer, if the GDT of from the bootup kernel is really *guaranteed* to be
> at the same location (given that those kernels may be really different).

A bit of testing with different bootup kernel provided me with this error:
PM: Image mismatch: version

which after a bit of digging pointed me to 'check_image_kernel'. The criteria
there imply that the different kernel versions or releases cannot be used with
hibernation.

For "fun" I subverted the checks and tried resuming a differently compiled
kernel (CONFIG_KALLSYMS_ALL=y) vs the one that was booting
(# CONFIG_KALLSYMS_ALL is not set) and found out that it does not work on a vanilla
v3.9 kernel.

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 0de2857..8589e05 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1633,10 +1633,16 @@ static char *check_image_kernel(struct swsusp_info *info)
 		return "kernel version";
 	if (strcmp(info->uts.sysname,init_utsname()->sysname))
 		return "system type";
-	if (strcmp(info->uts.release,init_utsname()->release))
-		return "kernel release";
-	if (strcmp(info->uts.version,init_utsname()->version))
-		return "version";
+	if (strcmp(info->uts.release,init_utsname()->release)) {
+		printk(KERN_ERR "%s != %s .. continuing on.\n", info->uts.release,
+			init_utsname()->release);
+		return NULL;
+	}
+	if (strcmp(info->uts.version,init_utsname()->version)) {
+		printk(KERN_ERR "%s != %s .. continuing on.\n", info->uts.version,
+			init_utsname()->version);
+		return NULL;
+	}
 	if (strcmp(info->uts.machine,init_utsname()->machine))
 		return "machine";
 	return NULL;

Meaning without these patches we do crash when trying to load a different kernel.

Here is the log:

# echo "8:1" > /sys/power/resume
[   18.881169] PM: Starting manual resume from disk
[   18.884164] PM: Hibernation image partition 8:1 present
[   18.885418] PM: Looking for hibernation image.
[   18.888344] PM: Image signature found, resuming
[   18.895387] PM: Marking nosave pages: [mem 0x0009f000-0x000fffff]
[   18.896892] PM: Basic memory bitmaps created
[   18.897937] PM: Preparing processes for restore.
[   18.900102] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   18.914402] PM: Loading hibernation image.
[   19.201178] PM: Using 2 thread(s) for decompression.
[   19.201178] PM: Loading and decompressing image data (53823 pages)...
[   19.210490] 3.9.0upstream != 3.9.0upstream-dirty .. continuing on.
[   19.874986] PM: Image loading progress:   0%
[   20.027158] PM: Image loading progress:  10%
[   20.177723] PM: Image loading progress:  20%
[   20.335267] PM: Image loading progress:  30%
[   20.491458] PM: Image loading progress:  40%
[   20.578486] PM: Image loading progress:  50%
[   20.663751] PM: Image loading progress:  60%
[   20.985474] PM: Image loading progress:  70%
[   21.112780] PM: Image loading progress:  80%
[   21.219476] PM: Image loading progress:  90%
[   21.336482] PM: Image loading progress: 100%
[   21.340302] PM: Image loading done.
[   21.342830] PM: Read 215292 kbytes in 2.12 seconds (101.55 MB/s)
[   21.350612] PM: Image successfully loaded
[   21.353913] Suspending console(s) (use no_console_suspend to debug)

.. and the machine either reboots or just hangs

So I think the assumptions I made are OK?
