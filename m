Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3FABP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 21:15:26 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:14557
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755177Ab3FABPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 21:15:20 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz98dIbafdM1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MNOWTD-01-9RC-02
X-M-MSG: 
Date: Fri, 31 May 2013 20:15:12 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Borislav Petkov <bp@alien8.de>,
        Joe Perches <joe@perches.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 4/4] microcode/x86/amd: early microcode patch loading
 support for AMD
Message-ID: <20130601011512.GA8532@jshin-Toonie>
References: <1369940959-2077-1-git-send-email-jacob.shin@amd.com>
 <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
 <20130531042649.GA4488@khazad-dum.debian.net>
 <20130531193200.GA8346@alberich>
 <20130531213039.GA13307@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130531213039.GA13307@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 06:30:39PM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 31 May 2013, Andreas Herrmann wrote:
> > On Fri, May 31, 2013 at 01:26:49AM -0300, Henrique de Moraes Holschuh wrote:
> > > On Thu, 30 May 2013, Jacob Shin wrote:
> > > >  mkdir initrd
> > > >  cd initrd
> > > > -mkdir kernel
> > > > -mkdir kernel/x86
> > > > -mkdir kernel/x86/microcode
> > > > -cp ../microcode.bin kernel/x86/microcode/GenuineIntel.bin
> > > > -find .|cpio -oc >../ucode.cpio
> > > > +mkdir -p kernel/x86/microcode
> > > > +cp ../microcode.bin kernel/x86/microcode/GenuineIntel.bin (or AuthenticAMD.bin)
> > > 
> > > Can I just 
> > > 'cat /lib/firmware/amd-ucode/*bin >kernel/x86/microcode/AuthenticAMD.bin' 
> > > to get a valid microcode container for all amd processors?
> > > 
> > > The answer for Intel is "yes".  I sure hope it is the same for AMD...
> > 
> > No, this doesn't work for AMD.
> > 
> > The container file includes a header section with information how to
> > map CPU F/M/S to microcode revisions provided with a container
> > file. Concatenating several container files will not create an
> > all-embracing header section.
> > 
> > More details were available on the amd64.org web pages.  But it seems
> > that the web site is not available anymore ...
> 
> Well, this is a problem for userspace.  Maybe the easier solution would be
> to make kernel/x86/microcode/AuthenticAMD a folder, and look for files there
> with names we can derivate from the ones used by the firmware interface (or
> even the same names)?
> 
> The early-initramfs API easily allows this to be implemented...

Yeah, but since that will break symmetry with Intel's GenuineIntel.bin
file path, so I decided to add some more logic to early loading code
to be able to parse through multiple containers files concatanated
together.

Any thoughts on this Boris?

Patch below:

---8<---

>From 40ba7f578e2abb83897f218e6577396a3852ad00 Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Fri, 31 May 2013 13:57:02 -0500
Subject: [PATCH 1/1] x86/microcode/amd: allow multiple family's bin files
 appended together

Add support for parsing through multiple family's microcode patch
container binary files appended together when early loading. This is
already supported on Intel.

Reported-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/microcode_amd_early.c |   63 +++++++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
index 9618805..2426dab 100644
--- a/arch/x86/kernel/microcode_amd_early.c
+++ b/arch/x86/kernel/microcode_amd_early.c
@@ -16,6 +16,7 @@
 
 static bool ucode_loaded;
 static u32 ucode_new_rev;
+static int family_offset;
 
 /*
  * Microcode patch container file is prepended to the initrd in cpio format.
@@ -27,6 +28,7 @@ static struct cpio_data __cpuinit find_ucode_in_initrd(void)
 {
 	long offset = 0;
 	struct cpio_data cd;
+	int *fam_offset = &family_offset;
 
 #ifdef CONFIG_X86_32
 	/*
@@ -39,12 +41,18 @@ static struct cpio_data __cpuinit find_ucode_in_initrd(void)
 		cd = find_cpio_data((char *)__pa_nodebug(ucode_path),
 			(void *)p->hdr.ramdisk_image, p->hdr.ramdisk_size,
 			&offset);
+		fam_offset = (int *)__pa_nodebug(&family_offset);
 	} else
 #endif
 		cd = find_cpio_data(ucode_path,
 			(void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET),
 			boot_params.hdr.ramdisk_size, &offset);
 
+	if (*fam_offset) {
+		cd.data = (u8 *)cd.data + *fam_offset;
+		cd.size -= *fam_offset;
+	}
+
 	if (*(u32 *)cd.data != UCODE_MAGIC) {
 		cd.data = NULL;
 		cd.size = 0;
@@ -68,15 +76,18 @@ static void __cpuinit apply_ucode_in_initrd(void)
 	struct equiv_cpu_entry *eq;
 	u32 *header;
 	u8  *data;
-	u16 eq_id;
+	u16 eq_id = 0;
 	int offset, left;
-	u32 rev, dummy;
+	u32 rev, eax;
 	u32 *new_rev;
+	int *fam_off;
 
 #ifdef CONFIG_X86_32
 	new_rev = (u32 *)__pa_nodebug(&ucode_new_rev);
+	fam_off = (int *)__pa_nodebug(&family_offset);
 #else
 	new_rev = &ucode_new_rev;
+	fam_off = &family_offset;
 #endif
 	cd = find_ucode_in_initrd();
 	if (!cd.data)
@@ -92,18 +103,44 @@ static void __cpuinit apply_ucode_in_initrd(void)
 	    header[2] == 0)                            /* size */
 		return;
 
-	eq     = (struct equiv_cpu_entry *)(data + CONTAINER_HDR_SZ);
-	offset = header[2] + CONTAINER_HDR_SZ;
-	data  += offset;
-	left  -= offset;
+	eax = cpuid_eax(0x00000001);
+
+	while (left > 0) {
+		eq = (struct equiv_cpu_entry *)(data + CONTAINER_HDR_SZ);
+
+		offset = header[2] + CONTAINER_HDR_SZ;
+		data  += offset;
+		left  -= offset;
+
+		eq_id = find_equiv_id(eq, eax);
+		if (eq_id)
+			break;
+
+		/*
+		 * support multiple container files appended together. if this
+		 * one does not have a matching equivalent cpu entry, we fast
+		 * forward to the next container file.
+		 */
+		while (left > 0) {
+			header = (u32 *)data;
+			if (header[0] == UCODE_MAGIC &&
+			    header[1] == UCODE_EQUIV_CPU_TABLE_TYPE)
+				break;
+
+			offset = header[1] + SECTION_HDR_SIZE;
+			data  += offset;
+			left  -= offset;
+		}
+
+		*fam_off = data - (u8 *)cd.data;
+	}
 
-	eq_id  = find_equiv_id(eq, cpuid_eax(0x00000001));
 	if (!eq_id)
 		return;
 
 	/* find ucode and update if needed */
 
-	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, eax);
 
 	while (left > 0) {
 		struct microcode_amd *mc;
@@ -116,8 +153,11 @@ static void __cpuinit apply_ucode_in_initrd(void)
 		mc = (struct microcode_amd *)(data + SECTION_HDR_SIZE);
 		if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)
 			if (__apply_microcode_amd(mc) == 0) {
-				if (!(*new_rev))
-					*new_rev = mc->hdr.patch_id;
+#ifdef CONFIG_X86_32
+				u8 *mpb = (u8  *)__pa_nodebug(&amd_bsp_mpb);
+				memcpy(mpb, mc, header[1]);
+#endif
+				*new_rev = mc->hdr.patch_id;
 				break;
 			}
 
@@ -182,6 +222,9 @@ void __cpuinit load_ucode_amd_ap(void)
 
 	if (cpu && !ucode_loaded) {
 		struct cpio_data cd = find_ucode_in_initrd();
+		if (!cd.data)
+			return;
+
 		if (load_microcode_amd(0, cd.data, cd.size) != UCODE_OK)
 			return;
 		ucode_loaded = true;
-- 
1.7.9.5


