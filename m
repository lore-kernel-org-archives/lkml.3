Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaFGAGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 20:06:49 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47034 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaFGAGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 20:06:48 -0400
MIME-Version: 1.0
From: Nikolay Amiantov <nikoamia@gmail.com>
Date: Sat, 7 Jun 2014 04:06:27 +0400
Message-ID: <CA+waHKUfu0Mxy_J9qWwayxZVDBA_RDYrpsL100Mr1sUBQRchVw@mail.gmail.com>
Subject: What can change in ways Linux handles memory when all memory >4G is
 disabled? (x86)
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm trying to resolve a cryptic problem with Lenovo T440p (and with
Dell XPS 15z, as it appears) and nvidia in my spare time. You can read
more at [1]. Basically: when the user disables and then re-enables
nvidia card (via ACPI, bbswitch or nouveau's dynpm) on new BIOS
versions, something becomes really wrong. User sees fs, usb devices
and network controllers faults of all kinds, system renders unusable
and user can observe filesystem corruption after reboot. Nvidia
drivers (or nouveau, or i915) can not even be loaded -- all that is
needed to trigger a bug is to call several ACPI methods to disable and
re-enable the card (e.g., via acpi-call module).

I've attached a debugger to Windows kernel to catch ACPI calls for
disabling and re-enabling NVIDIA card -- they don't really differ with
what bbswitch and others use. Furthermore, the difference between ACPI
DSDT tables in 1.14 (last good) and 1.16 (first broken) BIOSes are
minimal, and loading table from 1.14 into system running 1.16 does not
help. But -- all those devices are using memory I/O, so my current
theory is that memory is somehow corrupted. There are also some
changes in lspci output for nvidia [2].

I've played a bit with this theory in mind and found a very
interesting thing -- when I reserve all memory upper than 4G with
"memmap" kernel option ("memmap=99G$0x100000000"), everything works!
Also, I've written a small utility that fills memory with zeros using
/dev/mem and then checks it. I've checked reserved memory with it, and
it appears that no memory in that region is corrupted at all, which is
even more strange. I suspect that somehow when nvidia is enabled
I/O-mapped memory regions are corrupted, and only when upper memory is
not enabled. Also, memory map does not differ apart from missing last
big chunk of memory with and without "memmap", and with Windows, too.
If I enable even small chunk of "upper" memory (e.g.,
0x270000000-0x280000000), there are usual crashes.

Long story short: I'm interested how memory management can differ when
this "upper" memory regions are enabled?

P.S.: This is my first time posting to LKML, if I've done something
wrong, please tell!

[1]: https://github.com/Bumblebee-Project/bbswitch/issues/78
[2]: http://bpaste.net/show/350758/

--
Nikolay Amiantov.
