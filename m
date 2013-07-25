Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3GYJVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:21:30 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:53372 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3GYJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:21:28 -0400
Date: Thu, 25 Jul 2013 11:21:23 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Zhouping Liu <zliu@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [s390x] build error: undefined reference to `sie_exit'
Message-ID: <20130725092123.GD4288@osiris>
References: <209887675.5191065.1374718087774.JavaMail.root@redhat.com>
 <1999182864.5191140.1374718153443.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1999182864.5191140.1374718153443.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072509-8372-0000-0000-000006ABCB8C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:09:13PM -0400, Zhouping Liu wrote:
> Hello All,
> 
> I met the below error on b3a3a9c441 with s390x arch:
> arch/s390/built-in.o: In function `sys_call_table_emu':
> (.rodata+0x2b98): undefined reference to `sie_exit'
> arch/s390/built-in.o: In function `sys_call_table_emu':
> (.rodata+0x2ba0): undefined reference to `sie_exit'
> make: *** [vmlinux] Error 1

Thanks for reporting, I just committed the patch below to our
local branch:

>From c073dc1f474094b5610739e752d83bcb547b1d7d Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Thu, 25 Jul 2013 11:16:48 +0200
Subject: [PATCH] s390/perf: fix compile error (undefined reference sie_exit)

The perf_event code references sie_exit even if KVM is not available.
So add proper ifdefs to fix this one:

arch/s390/built-in.o: In function `sys_call_table_emu':
(.rodata+0x2b98): undefined reference to `sie_exit'
arch/s390/built-in.o: In function `sys_call_table_emu':
(.rodata+0x2ba0): undefined reference to `sie_exit'
make: *** [vmlinux] Error 1

Reported-by: Zhouping Liu <zliu@redhat.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/perf_event.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/perf_event.c b/arch/s390/kernel/perf_event.c
index a6fc037..500aa10 100644
--- a/arch/s390/kernel/perf_event.c
+++ b/arch/s390/kernel/perf_event.c
@@ -52,12 +52,13 @@ static struct kvm_s390_sie_block *sie_block(struct pt_regs *regs)
 
 static bool is_in_guest(struct pt_regs *regs)
 {
-	unsigned long ip = instruction_pointer(regs);
-
 	if (user_mode(regs))
 		return false;
-
-	return ip == (unsigned long) &sie_exit;
+#if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
+	return instruction_pointer(regs) == (unsigned long) &sie_exit;
+#else
+	return false;
+#endif
 }
 
 static unsigned long guest_is_user_mode(struct pt_regs *regs)
-- 
1.8.2.3

