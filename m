Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaBCTwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:52:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51401 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbaBCTwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:52:15 -0500
Date: Mon, 3 Feb 2014 20:52:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -v2] x86, microcode, AMD: Sanity-check initrd image
Message-ID: <20140203195212.GF4281@pd.tnic>
References: <52E8230F.7080300@oracle.com>
 <52E83903.5040908@oracle.com>
 <20140128232219.GO815@pd.tnic>
 <20140130151321.GC23342@pd.tnic>
 <52EAAAD5.2010301@oracle.com>
 <20140130195413.GH23342@pd.tnic>
 <20140203175526.GB4281@pd.tnic>
 <52EFEA57.4000709@oracle.com>
 <20140203193000.GD4281@pd.tnic>
 <52EFEFFE.6010608@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52EFEFFE.6010608@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 02:37:34PM -0500, Boris Ostrovsky wrote:
> It exploded when 'if (!container)' check was done *after* relocation,
> which made container non-zero. If you do the check *before* then I
> think you will catch the fact that container is empty.

Ah, right, this was it.

Ok, just remove the signature check then and give it a try pls:

--
diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
index 41537ae7c31d..362994511be1 100644
--- a/arch/x86/kernel/cpu/microcode/amd_early.c
+++ b/arch/x86/kernel/cpu/microcode/amd_early.c
@@ -37,12 +37,10 @@ static __initdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
 
 static struct cpio_data __init find_ucode_in_initrd(void)
 {
-	struct cpio_data ret;
 	long offset = 0;
 	char *path;
 	void *start;
 	size_t size;
-	u32 *hdr;
 
 #ifdef CONFIG_X86_32
 	struct boot_params *p;
@@ -60,21 +58,7 @@ static struct cpio_data __init find_ucode_in_initrd(void)
 	start   = (void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET);
 	size    = boot_params.hdr.ramdisk_size;
 #endif
-
-	ret = find_cpio_data(path, start, size, &offset);
-	if (!ret.data)
-		return ret;
-
-	/* Verify we didn't get some garbage from the initrd. */
-	hdr = (u32 *)ret.data;
-
-	if (hdr[0] != UCODE_MAGIC ||
-	    hdr[1] != UCODE_EQUIV_CPU_TABLE_TYPE ||
-	    hdr[2] == 0) {
-		ret.data = NULL;
-		ret.size = 0;
-	}
-	return ret;
+	return find_cpio_data(path, start, size, &offset);
 }
 
 static size_t compute_container_size(u8 *data, u32 total_size)
--

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
