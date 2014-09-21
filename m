Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaIUQ1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:27:30 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35777 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaIUQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:27:28 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel@axis.com, Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 0/8] cris: Patches needed on top of v3.17-rc5
Date: Sun, 21 Sep 2014 09:27:10 -0700
Message-Id: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series of patches is needed to boot a crisv32 image with qemu
into a serial console.

The resulting image was built with a toolchain built with gcc 4.7.4 (with a
minor fix backported from mainline gcc) and uclibc 0.9.33 using a patched
version of buildroot. Root file system is initramfs built from latest busybox
sources.

The qemu command used to start the image is as follows.

qemu-system-cris -serial stdio -kernel vmlinux -monitor none \
	-nographic -append "console=ttyS0,115200,N,8 rdinit=/sbin/init"

This still causes the following (non-fatal) traceback, but at least it works.

WARNING: CPU: 0 PID: 188 at kernel/softirq.c:146 0xc000ef4e()
Modules linked in:
CPU: 0 PID: 188 Comm: init Not tainted 3.17.0-rc5-00008-g5f5d649 #93

Analysis shows that interupts are disabled when _local_bh_enable() is called.

The patches in this series are not intended for immediate acceptance into the
upstream kernel and should instead be seen as a report on the state of the
architecture in general. Having said this, the following patches should
nevertheless be in acceptable state for upstream integration.
	cris: Add support for early console
	cris: Add dummy free_initrd_mem
	cris: time.c: Add missing include file to fix compile

Patch 6/8 ("tty: crisv32: Coding style cleanup, delete dead code") isn't
really worth much by itself and can be omitted when testing the series.

Patch 7/8 of the series ("resource: Add NULL check in next_resource")
was submitted separately as non-RFC patch.

Patch 8/8 ('Revert "percpu: free percpu allocation info for uniprocessor
system"') is presumably only needed for cris. I have no idea why the call to
pcpu_free_alloc_info() fails; maybe memory is not initialized correctly
by the cris architecture code.

Patch 7/8 and 8/8 are only needed when applying the patch series to the latest
upstream kernel (v3.17-rcX). For v3.16 kernels, Patches 1-6 (or 1-5, strictly
speaking) are sufficient.
