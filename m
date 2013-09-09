Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3IIPL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:11:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28878 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3IIPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:11:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org
Subject: [PATCH]  Bug-fixes to enable PV ticketlock to work under Xen PVHVM with Linux v3.12. (v2)
Date: Mon,  9 Sep 2013 11:11:31 -0400
Message-Id: <1378739496-17468-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since v1 (see https://lkml.org/lkml/2013/9/7/78)
 - Added Reviewed-by tag.
 - Fleshed out description of patches
 - Ran some perf
 - Used xen_smp_prepare_boot_cpu instead of xen_hvm_smp_init

After a bit of false starts, lots of debugging, and tons of help from Stefano and
David on how event mechanism is suppose to work I am happy to present a set
of bug-fixes that make PV ticketlocks work under Xen PVHVM with Linux v3.12.

v3.12 has now thanks to commit 816434ec4a674fcdb3c2221a6dffdc8f34020550
(Merge branch 'x86-spinlocks-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
PV ticketlocks. That means:
 - Xen PV bytelock has been replaced by Xen PV ticketlock.
 - Xen PVHVM is using ticketlock (not PV variant) - this patch makes it PV.
 - baremetal is still using ticketlocks.

In other words everything in the kernel is ticketlock based with the virtualizations
having the 'PV' part to aid.

Please take a look at the patches. They are also available as a git tree
under:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/pvticketlock.v7.1

I had run some light performance tests with two guests - each over subscribed by
2:1 and running a spinlock_hog wherein each CPU tries to get a lock. The machine
is a 4 CPU Intel, and each guest is running with 8 VCPUs.

It is not a perfect test-case - for that I have asked our internal performance
engineer to test it out with various workloads and guests.

However it does demonstrate that these patches do work and they do not
incur any performance regressions (and yes, they do show a performance
improvement).

 arch/x86/xen/enlighten.c |  1 -
 arch/x86/xen/smp.c       | 28 +++++++++++++++++++++++-----
 arch/x86/xen/spinlock.c  | 45 ++++++++-------------------------------------
 3 files changed, 31 insertions(+), 43 deletions(-)

Konrad Rzeszutek Wilk (5):
      xen/spinlock: Fix locking path engaging too soon under PVHVM.
      xen/spinlock: We don't need the old structure anymore
      xen/smp: Update pv_lock_ops functions before alternative code starts under PVHVM
      xen/spinlock: Don't setup xen spinlock IPI kicker if disabled.
      Revert "xen/spinlock: Disable IRQ spinlock (PV) allocation on PVHVM"

