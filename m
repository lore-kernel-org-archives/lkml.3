Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaBEUIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:08:34 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48635 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbaBEUIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:14 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Greg Pearson <greg.pearson@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 199/213] pcdp: use early_ioremap/early_iounmap to access pcdp table
Date: Wed, 5 Feb 2014 15:02:34 -0500
Message-ID: <1391630568-49251-200-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Pearson <greg.pearson@hp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6c4088ac3a4d82779903433bcd5f048c58fb1aca upstream.

efi_setup_pcdp_console() is called during boot to parse the HCDP/PCDP
EFI system table and setup an early console for printk output.  The
routine uses ioremap/iounmap to setup access to the HCDP/PCDP table
information.

The call to ioremap is happening early in the boot process which leads
to a panic on x86_64 systems:

    panic+0x01ca
    do_exit+0x043c
    oops_end+0x00a7
    no_context+0x0119
    __bad_area_nosemaphore+0x0138
    bad_area_nosemaphore+0x000e
    do_page_fault+0x0321
    page_fault+0x0020
    reserve_memtype+0x02a1
    __ioremap_caller+0x0123
    ioremap_nocache+0x0012
    efi_setup_pcdp_console+0x002b
    setup_arch+0x03a9
    start_kernel+0x00d4
    x86_64_start_reservations+0x012c
    x86_64_start_kernel+0x00fe

This replaces the calls to ioremap/iounmap in efi_setup_pcdp_console()
with calls to early_ioremap/early_iounmap which can be called during
early boot.

This patch was tested on an x86_64 prototype system which uses the
HCDP/PCDP table for early console setup.

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
Acked-by: Khalid Aziz <khalid.aziz@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/firmware/pcdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/pcdp.c b/drivers/firmware/pcdp.c
index 51e0e2d8fac6..a330492e06f9 100644
--- a/drivers/firmware/pcdp.c
+++ b/drivers/firmware/pcdp.c
@@ -95,7 +95,7 @@ efi_setup_pcdp_console(char *cmdline)
 	if (efi.hcdp == EFI_INVALID_TABLE_ADDR)
 		return -ENODEV;
 
-	pcdp = ioremap(efi.hcdp, 4096);
+	pcdp = early_ioremap(efi.hcdp, 4096);
 	printk(KERN_INFO "PCDP: v%d at 0x%lx\n", pcdp->rev, efi.hcdp);
 
 	if (strstr(cmdline, "console=hcdp")) {
@@ -131,6 +131,6 @@ efi_setup_pcdp_console(char *cmdline)
 	}
 
 out:
-	iounmap(pcdp);
+	early_iounmap(pcdp, 4096);
 	return rc;
 }
-- 
1.8.5.2

