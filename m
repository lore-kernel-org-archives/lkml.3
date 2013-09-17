Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3IQV6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:58:02 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:36288 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab3IQV6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:58:00 -0400
Date: Tue, 17 Sep 2013 15:57:49 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Commit breaks strace: ARM: entry: allow ARM-private syscalls to be
 restarted
Message-ID: <20130917215749.GA11109@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

I was just testing v3.12-rc1 (on kirkwood) and noticed that strace is
not working:

$ strace /bin/ls
mmap2(0xb6f79000, 9552, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb6f79000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6fad000
set_tls(0xb6fad4c0, 0xb6fadb98, 0xb6fb1050, 0xb6fad4c0, 0xb6fb1050) = -1 ENOSYS (Function not implemented)
writev(2, [{"cannot set up thread-local stora"..., 36}, {"unknown error", 13}, {"\n", 1}], 3cannot set up thread-local storage: unknown error
) = 50
exit_group(127)                         = ?
+++ exited with 127 +++

I determined that reverting your commit below makes strace work again.
I've tested 3.10.12 and it is OK.

This happens with the latest git head for strace, as well as the 4.7
release.

Hopefully you can cook up a fix :)

Regards,
Jason

commit 377747c40657eb35ad98a56439606d96a928425a
Author: Will Deacon <will.deacon@arm.com>
Date:   Mon May 13 19:16:34 2013 +0100

    ARM: entry: allow ARM-private syscalls to be restarted
    
    System calls will only be restarted after signal handling if they (a)
    return an error code indicating that a restart is required and (b) have
    `why' set to a non-zero value, to indicate that the signal interrupted
    them.
    
    This patch leaves `why' set to a non-zero value for ARM-private syscalls
    , and only zeroes it for syscalls that are not implemented.
    
    Signed-off-by: Will Deacon <will.deacon@arm.com>

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 94104bf..74ad15d1 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -442,10 +442,10 @@ local_restart:
        ldrcc   pc, [tbl, scno, lsl #2]         @ call sys_* routine
 
        add     r1, sp, #S_OFF
-2:     mov     why, #0                         @ no longer a real syscall
        cmp     scno, #(__ARM_NR_BASE - __NR_SYSCALL_BASE)
        eor     r0, scno, #__NR_SYSCALL_BASE    @ put OS number back
-       bcs     arm_syscall     
+       bcs     arm_syscall
+2:     mov     why, #0                         @ no longer a real syscall
        b       sys_ni_syscall                  @ not private func
 
 #if defined(CONFIG_OABI_COMPAT) || !defined(CONFIG_AEABI)
