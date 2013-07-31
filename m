Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab3GaQZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:25:33 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:33356 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3GaQZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:25:32 -0400
Date: Wed, 31 Jul 2013 18:25:22 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Stuart Longland <redhatter@gentoo.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC MIPS] Update buildtar for MIPS
Message-ID: <20130731162521.GA10570@linux-mips.org>
References: <1286502337-23882-1-git-send-email-redhatter@gentoo.org>
 <alpine.LFD.2.00.1010160716270.15889@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010160716270.15889@eddie.linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 07:17:45AM +0100, Maciej W. Rozycki wrote:

> > This updates buildtar to support MIPS targets.  MIPS may use 'vmlinux'
> > or 'vmlinux.32' depending on the target system.
> 
>  Or vmlinux.64 -- why don't you handle that too?

Patchwork is patient, nothing gets lost :-)  I've updated Stuart's original
patch http://patchwork.linux-mips.org/patch/1673/ to also handle compressed
kernel images, how about below patch.

Michal, when testing this by building "make targz-pkg" for a particular MIPS
platform I get

  tar: lib/*: Cannot stat: No such file or directory

and I assume that's because CONFIG_MODULES is not enabled for my test
configuration.

  Ralf

kbuild: Add MIPS specific files to generated package.

A lot of 64-bit systems supported by Linux/MIPS have boot firmware or
bootloaders that only understand 32-bit ELF files, and as such, the vmlinux.32
target exists to support these systems.  Therefore, it'd be nice if the tar-pkg
target recognised this, and included the right version when packaging up a
binary of the kernel.

This updates buildtar to support MIPS targets.  MIPS may use 'vmlinux'
or 'vmlinux.32' depending on the target system.  This uses 'vmlinux.32'
in preference to 'vmlinux' where present (although I should check which
is newer), including either file as /boot/vmlinux-${version}.

Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 scripts/package/buildtar | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/scripts/package/buildtar b/scripts/package/buildtar
index cdd9bb9..aa22f94 100644
--- a/scripts/package/buildtar
+++ b/scripts/package/buildtar
@@ -87,6 +87,27 @@ case "${ARCH}" in
 		[ -f "${objtree}/vmlinux.SYS" ] && cp -v -- "${objtree}/vmlinux.SYS" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}.SYS"
 		[ -f "${objtree}/vmlinux.dsk" ] && cp -v -- "${objtree}/vmlinux.dsk" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}.dsk"
 		;;
+	mips)
+		if [ -f "${objtree}/arch/mips/boot/compressed/vmlinux.bin" ]; then
+			cp -v -- "${objtree}/arch/mips/boot/compressed/vmlinux.bin" "${tmpdir}/boot/vmlinuz-${KERNELRELEASE}"
+		elif [ -f "${objtree}/arch/mips/boot/compressed/vmlinux.ecoff" ]; then
+			cp -v -- "${objtree}/arch/mips/boot/compressed/vmlinux.ecoff" "${tmpdir}/boot/vmlinuz-${KERNELRELEASE}"
+		elif [ -f "${objtree}/arch/mips/boot/compressed/vmlinux.srec" ]; then
+			cp -v -- "${objtree}/arch/mips/boot/compressed/vmlinux.srec" "${tmpdir}/boot/vmlinuz-${KERNELRELEASE}"
+		elif [ -f "${objtree}/vmlinux.32" ]; then
+			cp -v -- "${objtree}/vmlinux.32" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}"
+		elif [ -f "${objtree}/vmlinux.64" ]; then
+			cp -v -- "${objtree}/vmlinux.64" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}"
+		elif [ -f "${objtree}/arch/mips/boot/vmlinux.bin" ]; then
+			cp -v -- "${objtree}/arch/mips/boot/vmlinux.bin" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}"
+		elif [ -f "${objtree}/arch/mips/boot/vmlinux.ecoff" ]; then
+			cp -v -- "${objtree}/arch/mips/boot/vmlinux.ecoff" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}"
+		elif [ -f "${objtree}/arch/mips/boot/vmlinux.srec" ]; then
+			cp -v -- "${objtree}/arch/mips/boot/vmlinux.srec" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}"
+		elif [ -f "${objtree}/vmlinux" ]; then
+			cp -v -- "${objtree}/vmlinux" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}"
+		fi
+		;;
 	*)
 		[ -f "${KBUILD_IMAGE}" ] && cp -v -- "${KBUILD_IMAGE}" "${tmpdir}/boot/vmlinux-kbuild-${KERNELRELEASE}"
 		echo "" >&2
