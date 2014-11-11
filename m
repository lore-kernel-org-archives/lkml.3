Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaKKDcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:32:01 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42852 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaKKDb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:31:59 -0500
Date: Mon, 10 Nov 2014 20:31:54 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, willy@linux.intel.com, unruh@physics.ubc.ca,
        linux-kernel@vger.kernel.org, martin@lucina.net
Subject: Re: [PATCH 0/3] PCI: Fix detection of read-only BARs
Message-ID: <20141111033154.GA28161@google.com>
References: <20141030175430.22238.47671.stgit@amt.stowe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030175430.22238.47671.stgit@amt.stowe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 11:54:31AM -0600, Myron Stowe wrote:
> While non-conformant, PCI devices having read-only (r/o) BARs - registers
> that when read return fixed, non-zero, values regardless of whether or
> not their being sized - occasionally turn up.  Pre-git commit 1307ef662199
> [1] was the initial attempt to detect such BARs.  The detection mechanism
> used however ended up exposing further unexpected behaviors on enough
> devices that it had to be reverted [2].
> 
> A subsequent solution, which is still currently in use, was put in place
> with pre-git commit 2c79a80ab7b7 ("[PCI] Correctly size hardwired empty
> BARs").  This solution's logic detects r/o BARs via the following (see
> 'pci_size()'):
>         /* base == maxbase can be valid only if the BAR has
>            already been programmed with all 1s.  */
>         if (base == maxbase && ((base | size) & mask) != mask)
>                 return 0;
> 
> Later, commit 6ac665c63dca ("PCI: rewrite PCI BAR reading code") was
> introduced, re-factoring PCI's core BAR sizing logic.  The commit altered
> __pci_read_base's local variable 'l', stripping off its lower,
> non-addressing related bits, prior to being passed in as the 'base'
> parameter to pci_size().  This masking broke the r/o BAR detection logic's
> first comparison check for r/o BARs that have any of their lower order
> bits, bits that are not part of a BARs "base address" field, set.  For
> such cases, the 'base == maxbase' comparison check will no longer ever be
> "true".
> 
> This series restores the r/o BAR detection logic so that it will once
> again catch, and ignore, such occurrences as have been encountered to
> date:
>   - AGP aperture BAR of AMD-7xx host bridges; if the AGP window
>     disabled, this BAR is read-only and read as 0x00000008 [1]
>   - BAR0-4 of ALi IDE controllers can be non-zero and read-only [1]
>   - Intel Sandy Bridge - Thermal Management Controller [8086:0103];
>     BAR 0 returning 0xfed98004 [3]
>   - Intel Xeon E5 v3/Core i7 Power Control Unit [8086:2fc0];
>     Bar 0 returning 0x00001a [4]
> 
> 
> [1] From Thomas Gleixner's "Linux kernel history" repository:
>     https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/drivers/pci/probe.c?id=1307ef6621991f1c4bc3cec1b5a4ebd6fd3d66b9
>     pre-git commit 1307ef662199  "PCI: probing read-only Bars"
> [2] Pre-git commit 182d090b9dfe  "Undo due to weird behaviour on various
>     boxes"
> [3] https://bugzilla.kernel.org/show_bug.cgi?id=43331
> [4] https://bugzilla.kernel.org/show_bug.cgi?id=85991
> 
> 
> Myron Stowe (3):
>       PCI: Restore detection of read-only BARs
>       PCI: Re-factor __pci_read_base
>       PCI: Add a informational printk for invalid BARs

I applied all three of these to pci/enumeration for v3.19.  It's great to
get this long-standing problem fixed and the code cleaned up a bit.

Bjorn
