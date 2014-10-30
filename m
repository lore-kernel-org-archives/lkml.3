Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427AbaJ3R4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:56:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760772AbaJ3R4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:56:44 -0400
Subject: [PATCH 0/3] PCI: Fix detection of read-only BARs
From: Myron Stowe <myron.stowe@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: willy@linux.intel.com, unruh@physics.ubc.ca, linux-kernel@vger.kernel.org,
        martin@lucina.net
Date: Thu, 30 Oct 2014 11:54:31 -0600
Message-ID: <20141030175430.22238.47671.stgit@amt.stowe>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While non-conformant, PCI devices having read-only (r/o) BARs - registers
that when read return fixed, non-zero, values regardless of whether or
not their being sized - occasionally turn up.  Pre-git commit 1307ef662199
[1] was the initial attempt to detect such BARs.  The detection mechanism
used however ended up exposing further unexpected behaviors on enough
devices that it had to be reverted [2].

A subsequent solution, which is still currently in use, was put in place
with pre-git commit 2c79a80ab7b7 ("[PCI] Correctly size hardwired empty
BARs").  This solution's logic detects r/o BARs via the following (see
'pci_size()'):
        /* base == maxbase can be valid only if the BAR has
           already been programmed with all 1s.  */
        if (base == maxbase && ((base | size) & mask) != mask)
                return 0;

Later, commit 6ac665c63dca ("PCI: rewrite PCI BAR reading code") was
introduced, re-factoring PCI's core BAR sizing logic.  The commit altered
__pci_read_base's local variable 'l', stripping off its lower,
non-addressing related bits, prior to being passed in as the 'base'
parameter to pci_size().  This masking broke the r/o BAR detection logic's
first comparison check for r/o BARs that have any of their lower order
bits, bits that are not part of a BARs "base address" field, set.  For
such cases, the 'base == maxbase' comparison check will no longer ever be
"true".

This series restores the r/o BAR detection logic so that it will once
again catch, and ignore, such occurrences as have been encountered to
date:
  - AGP aperture BAR of AMD-7xx host bridges; if the AGP window
    disabled, this BAR is read-only and read as 0x00000008 [1]
  - BAR0-4 of ALi IDE controllers can be non-zero and read-only [1]
  - Intel Sandy Bridge - Thermal Management Controller [8086:0103];
    BAR 0 returning 0xfed98004 [3]
  - Intel Xeon E5 v3/Core i7 Power Control Unit [8086:2fc0];
    Bar 0 returning 0x00001a [4]


[1] From Thomas Gleixner's "Linux kernel history" repository:
    https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/drivers/pci/probe.c?id=1307ef6621991f1c4bc3cec1b5a4ebd6fd3d66b9
    pre-git commit 1307ef662199  "PCI: probing read-only Bars"
[2] Pre-git commit 182d090b9dfe  "Undo due to weird behaviour on various
    boxes"
[3] https://bugzilla.kernel.org/show_bug.cgi?id=43331
[4] https://bugzilla.kernel.org/show_bug.cgi?id=85991


Myron Stowe (3):
      PCI: Restore detection of read-only BARs
      PCI: Re-factor __pci_read_base
      PCI: Add a informational printk for invalid BARs


 drivers/pci/probe.c |   75 +++++++++++++++++++++++----------------------------
 1 file changed, 34 insertions(+), 41 deletions(-)

-- 
