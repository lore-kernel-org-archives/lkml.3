Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3IQKB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:01:59 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:50842 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3IQKBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:01:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Preliminary kexec support for Linux/m68k
Date: Tue, 17 Sep 2013 12:01:30 +0200
Message-Id: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preliminary set of patches to add kexec support for m68k.

  - Kexec only, no kdump support yet (do you have enough RAM to keep a
    crashdump kernel in memory at all times? ;-)

  - Tested on ARAnyM only. No support for other CPU/MMUs than 68040.

  - Although the code contains some phys/virt conversions, it will probably
    fail miserably on platforms where kernel virtual addresses are different
    from physical address.

  - To have automatic "kexec -e" on reboot, copy /etc/rc6.d/S85kexec from
    another system, and fix it up for kexec living in /usr/local/sbin instead
    of /sbin.

  - Sample invocation:

	kexec -d -l vmlinux --reuse-cmdline


KERNEL:

Patches:
  - [PATCH 1/3] m68k: Add preliminary kexec support
  - [PATCH 2/3] m68k: Add support to export bootinfo in procfs
  - [PATCH 3/3] [RFC] m68k: Add System RAM to /proc/iomem

Notes:
  - The bootinfo is now saved and exported to /proc/bootinfo, so kexec-tools
    can read it and pass it (possibly after modification) to the new kernel.
    This is similar to /proc/atags on ARM.

  - We should create arch/m68k/include/uapi/asm/bootinfo.h (and probably a few
    more, e.g. machine-specific model IDs), as this is needed by both m68kboot
    and kexec-tools.

  - I based [PATCH 3/3] on the PowerPC version, but it's no longer needed as we
    now get this information from the bootinfo.
    Does anyone think this is nice to have anyway?


KEXEC-TOOLS:

Patches:
  - [PATCH 1/2] kexec: Let slurp_file_len() return the number of bytes
  - [PATCH 2/2] kexec: Add preliminary m68k support

Notes:
  - Based on git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git

  - Tagged bootinfo is read from /proc/bootinfo by default, but this can be
    overridden using --bootinfo. No bootinfo editor is provided.
    The kexec command will replace/delete command line and ramdisk tags in the
    bootinfo.

  - The ramdisk is loaded at the top of memory minus 4096, unlike with
    m68boot (ataboot/amiboot), as locate_hole() seems to have a bug that it
    cannot reserve a block at the real top of memory.

  - The first unused page of the kernel image (at address zero) is
    automatically removed, just like m68kboot does.
    If I don't do this, relocate_new_kernel() fails with a "cannot handle
    kernel paging request at address NULL" exception, although the MMU is
    disabled at that point.
    As m68kboot does this too, I guess this is OK?

  - Do we want to check the struct bootversion at the start of the kernel,
    like m68kboot does?
    Kexec may be used to load ELF files that are not Linux kernel images,
    and thus don't have a Linux-specific struct bootversion.

  - Do we want to check the size of the kernel image + bootinfo, and warn the
    user if it's larger than 4 MiB?
    This is a limitation of the current Linux/m68k kernel only.

All comments are welcome!
Have fun! ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

