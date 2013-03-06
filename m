Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3CFBMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:12:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:28679 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab3CFBMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:12:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="294310042"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [3.9-rc1 x86] Bug in ioremap code?
Thread-Topic: [3.9-rc1 x86] Bug in ioremap code?
Thread-Index: AQHOGf1OIHQkEDynbE+CmdhsV+IBtZiX2OGQ
Date: Wed, 6 Mar 2013 01:12:17 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220528C08AE@ORSMSX105.amr.corp.intel.com>
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp>
 <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp>
 <201303052031.JFG81705.FSOOFQHJMVFOLt@I-love.SAKURA.ne.jp>
 <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp>
 <20130305180650.GD4914@pd.tnic>
 <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp>
 <51366E6F.1050409@linux.intel.com> <513683DC.3070405@linux.vnet.ibm.com>
 <51368692.4090204@linux.intel.com>
In-Reply-To: <51368692.4090204@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
> 
> Fenghua,
> 
> Could you look at this thread and see if you can see what the problem
> is?
> 
> 	-hpa
> 
> On 03/05/2013 03:46 PM, Dave Hansen wrote:
> > Not sure if it's related by 3.9-rc1 gets in to a reboot loop for me.
> I
> > assume it's triple-faulting.  The last line on the console I see is:
> >
> > [    0.085702] SMP alternatives: lockdep: fixing up alternatives
> > [    0.086859] smpboot: Booting Node   0, Processors [    0.086859]
> > smpboot: Booting Node   0, Processors  #1 OK
> >  #1 OK
> >
> > I bisected it down to the neighborhood of c47f39e.  After that, I get
> > some compile errors:
> >
> >> arch/x86/built-in.o: In function `generic_load_microcode':
> >> microcode_intel.c:(.text+0x28195): undefined reference to
> `microcode_sanity_check'
> >> microcode_intel.c:(.text+0x281ab): undefined reference to
> `get_matching_microcode'
> >
> > Turning off CONFIG_MICROCODE:
> >
> > -CONFIG_MICROCODE=y
> > -CONFIG_MICROCODE_INTEL=y
> > -# CONFIG_MICROCODE_AMD is not set
> > -CONFIG_MICROCODE_OLD_INTERFACE=y
> > -CONFIG_MICROCODE_INTEL_LIB=y
> > -CONFIG_MICROCODE_INTEL_EARLY=y
> > -CONFIG_MICROCODE_EARLY=y
> > +# CONFIG_MICROCODE is not set
> >
> > lets it boot again and fixes those compile errors.  This is with this
> > config:
> >
> > 	http://i-love.sakura.ne.jp/tmp/config-3.9-rc1
> >
> > running under a kvm guest:
> >
> > qemu-system-x86_64 -append 'earlyprintk=ttyS0,115200,keep
> > console=ttyS0,115200 nmi_watchdog=0 root=/dev/sda1 bootmem_debug'
> > -kernel vmlinuz -usbdevice tablet  -vnc :1 -net user -net
> > nic,model=e1000  -hda sarge-amd64-runme-1G.img -m 10240 -smp 2
> >

Before setting page in 32-bit kernel boot, we load microcode. To access global variables in linear addr,  we use __pa_symbol(). There is no problem in native. Is this a problem in 32-bit guest kernel boot?

Related code is as follows:

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S index 8e7f655..2f70530 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -144,6 +144,11 @@ ENTRY(startup_32)
 	movl %eax, pa(olpc_ofw_pgd)
 #endif
 
+#ifdef CONFIG_MICROCODE_EARLY
+	/* Early load ucode on BSP. */
+	call load_ucode_bsp
+#endif
+
 /*
  * Initialize page tables.  This creates a PDE and a set of page
  * tables, which are located immediately beyond __brk_base.  The variable @@ -299,6 +304,12 @@ ENTRY(startup_32_smp)
+void __init
+load_ucode_intel_bsp(void)
+{
+	u64 ramdisk_image, ramdisk_size;
+	unsigned long initrd_start_early, initrd_end_early;
+	struct ucode_cpu_info uci;
+#ifdef CONFIG_X86_32
+	struct boot_params *boot_params_p;
+
+	boot_params_p = (struct boot_params *)__pa_symbol(&boot_params);
+	ramdisk_image = boot_params_p->hdr.ramdisk_image;
+	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
+	initrd_start_early = ramdisk_image;
+	initrd_end_early = initrd_start_early + ramdisk_size;
+
+	_load_ucode_intel_bsp(
+		(struct mc_saved_data *)__pa_symbol(&mc_saved_data),
+		(unsigned long *)__pa_symbol(&mc_saved_in_initrd),
+		initrd_start_early, initrd_end_early, &uci);
+ #else
