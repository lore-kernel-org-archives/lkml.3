Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaA1Vao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:30:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40972 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbaA1Vam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:30:42 -0500
Date: Tue, 28 Jan 2014 22:30:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
Message-ID: <20140128213030.GM815@pd.tnic>
References: <20140121161438.GD9004@pd.tnic>
 <52DEB4A9.4070707@oracle.com>
 <20140121182554.GE9004@pd.tnic>
 <52E15AAE.4090106@oracle.com>
 <20140123192939.GB11190@pd.tnic>
 <52E17087.2060301@oracle.com>
 <20140128162431.GH815@pd.tnic>
 <52E8168D.9060805@oracle.com>
 <20140128205246.GL815@pd.tnic>
 <52E81B90.8040604@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52E81B90.8040604@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 04:05:20PM -0500, Boris Ostrovsky wrote:
> Yes. This was a bug in our build environment. It is fixed now but I
> put this bug back when I was testing your patch.

Right, that was the deal. Oh well, we'd need to verify the container
too, I guess:

---
diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 8384c0fa206f..c568b6c9af95 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -37,10 +37,12 @@ static __initdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
 
 static struct cpio_data __init find_ucode_in_initrd(void)
 {
+	struct cpio_data ret;
 	long offset = 0;
 	char *path;
 	void *start;
 	size_t size;
+	u32 *hdr;
 
 #ifdef CONFIG_X86_32
 	struct boot_params *p;
@@ -59,7 +61,18 @@ static struct cpio_data __init find_ucode_in_initrd(void)
 	size    = boot_params.hdr.ramdisk_size;
 #endif
 
-	return find_cpio_data(path, start, size, &offset);
+	ret = find_cpio_data(path, start, size, &offset);
+
+	/* Verify we didn't get some garbage from the initrd. */
+	hdr = (u32 *)ret.data;
+
+	if (hdr[0] != UCODE_MAGIC ||
+	    hdr[1] != UCODE_EQUIV_CPU_TABLE_TYPE ||
+	    hdr[2] == 0) {
+		ret.data = NULL;
+		ret.size = 0;
+	}
+	return ret;
 }
 
 static size_t compute_container_size(u8 *data, u32 total_size)
@@ -359,7 +372,7 @@ int __init save_microcode_in_initrd_amd(void)
 		pr_info("microcode: updated early to new patch_level=0x%08x\n",
 			ucode_new_rev);
 
-	if (!container)
+	if (!container || !ucode_cpio.data)
 		return -EINVAL;
 
 	eax   = cpuid_eax(0x00000001);
--

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
