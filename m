Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3IGOIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 10:08:55 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:64313 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3IGOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 10:08:54 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org
Subject: [PATCH] Bug-fixes to enable PV ticketlock to work under Xen PVHVM with Linux v3.12. (v1)
Date: Sat,  7 Sep 2013 09:46:40 -0400
Message-Id: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Please take a look at the patches. If you are interested in testing them
out I will post a git tree on Monday based on v3.11 and v3.12-rc0. 

Note that I had not run any performance tests and I am not sure when I will
be able to (got other bugs to squash now). I've asked our internal performance
engineer to do some benchmarking - but those results won't be available for
some time as it takes time to do good benchmarking.

 arch/x86/xen/enlighten.c |    1 -
 arch/x86/xen/smp.c       |   17 +++++++++++++++++
 arch/x86/xen/spinlock.c  |   45 ++++++++-------------------------------------
 3 files changed, 25 insertions(+), 38 deletions(-)

(oh neat, more deletions!) 

Konrad Rzeszutek Wilk (5):
      xen/spinlock: Fix locking path engaging too soon under PVHVM.
      xen/spinlock: We don't need the old structure anymore
      xen/smp: Update pv_lock_ops functions before alternative code starts under PVHVM
      xen/spinlock: Don't setup xen spinlock IPI kicker if disabled.
      Revert "xen/spinlock: Disable IRQ spinlock (PV) allocation on PVHVM"

