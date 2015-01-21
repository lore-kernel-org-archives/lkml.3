Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbbAUDhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:37:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbbAUDhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:37:37 -0500
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        keescook@chromium.org, vgoyal@redhat.com, whissi@whissi.de,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH 0/6] randomize kernel physical address and virtual address separately
Date: Wed, 21 Jan 2015 11:37:11 +0800
Message-Id: <1421811437-2787-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kaslr only randomize physical address of kernel loading, then add the delta
to virtual address of kernel text mapping. Because kernel virtual address can only be
from __START_KERNEL_map to LOAD_PHYSICAL_ADDR+CONFIG_RANDOMIZE_BASE_MAX_OFFSET, namely
[0xffffffff80000000, 0xffffffffc0000000], so physical address can only be randomized
in region [LOAD_PHYSICAL_ADDR, CONFIG_RANDOMIZE_BASE_MAX_OFFSET], namely [16M, 1G].

So hpa and Vivek suggested the randomization should be done separately for both physical
and virtual address. In this patchset I tried it. And after randomization, relocation
handling only depends on virtual address changing, means I only check whether virtual
address is randomized to other position, if yes relocation need be handled, if no just
skip the relocation handling though physical address is randomized to different place.
Now physical address can be randomized from 16M to 4G, virtual address offset can be
from 16M to 1G.

Leftover problem:
    hpa want to see the physical randomization can cover the whole physical memory. I
checked code and found it's hard to do. Because in arch/x86/boot/compressed/head_64.S
an identity mapping of 4G is built and then kaslr and decompressing are done. The #PF
handler solution which he suggested is only available after jump into decompressed
kernel, namely in arch/x86/kernel/head_64.S. I didn't think of a way to do the whole
memory covering for physical address randomization, any suggestion or idea?

Baoquan He (6):
  remove a unused function parameter
  a bug that relocation can not be handled when kernel is loaded above
    2G
  Introduce a function to randomize the kernel text mapping address
  adapt choose_kernel_location to add the kernel virtual address
    randomzation
  change the relocations behavior for kaslr on x86_64
  extend the upper limit of kernel physical address randomization to 4G

 arch/x86/boot/compressed/aslr.c | 69 ++++++++++++++++++++++++++++-------------
 arch/x86/boot/compressed/misc.c | 34 +++++++++++++-------
 arch/x86/boot/compressed/misc.h | 20 ++++++------
 3 files changed, 82 insertions(+), 41 deletions(-)

-- 
1.9.3

