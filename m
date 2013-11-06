Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab3KFLUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:20:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47545 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3KFLUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:20:46 -0500
Date: Wed, 6 Nov 2013 03:20:30 -0800
From: tip-bot for Josh Boyer <tipbot@zytor.com>
Message-ID: <tip-bb61ccc7dbcbc1ed4600bef5610d99ec91fd7032@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, rja@sgi.com, jwboyer@fedoraproject.org,
        jwboyer@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rja@sgi.com, jwboyer@fedoraproject.org,
        jwboyer@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20131105143728.GJ9944@hansolo.jdub.homelinux.org>
References: <20131105143728.GJ9944@hansolo.jdub.homelinux.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86/cpu: Allow higher NR_CPUS values
Git-Commit-ID: bb61ccc7dbcbc1ed4600bef5610d99ec91fd7032
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:20:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb61ccc7dbcbc1ed4600bef5610d99ec91fd7032
Gitweb:     http://git.kernel.org/tip/bb61ccc7dbcbc1ed4600bef5610d99ec91fd7032
Author:     Josh Boyer <jwboyer@redhat.com>
AuthorDate: Tue, 5 Nov 2013 09:37:29 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 08:16:28 +0100

x86/cpu: Allow higher NR_CPUS values

The current range for SMP configs is 2 - 512 CPUs, or a full
4096 in the case of MAXSMP.  There are machines that have 1024
CPUs in them today and configuring a kernel for that means you
are forced to set MAXSMP.  This adds additional unnecessary
overhead.  While that overhead might be considered tiny for
large machines, it isn't necessarily so if you are building a
kernel that runs across a wide variety of machines.

To cover the range of more common machines today, we allow
NR_CPUS to be up to 4096 when CPUMASK_OFFSTACK is enabled.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Cc: prarit@redhat.com
Cc: Russ Anderson <rja@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131105143728.GJ9944@hansolo.jdub.homelinux.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f67e839..f03e428 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -825,14 +825,16 @@ config MAXSMP
 config NR_CPUS
 	int "Maximum number of CPUs" if SMP && !MAXSMP
 	range 2 8 if SMP && X86_32 && !X86_BIGSMP
-	range 2 512 if SMP && !MAXSMP
+	range 2 512 if SMP && !MAXSMP && !CPUMASK_OFFSTACK
+	range 2 4096 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
 	default "1" if !SMP
 	default "4096" if MAXSMP
 	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
 	default "8" if SMP
 	---help---
 	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  The maximum supported value is 512 and the
+	  kernel will support.  If CPUMASK_OFFSTACK is enabled, the maximum
+	  supported value is 4096, otherwise the maximum value is 512.  The
 	  minimum value which makes sense is 2.
 
 	  This is purely to save memory - each supported CPU adds
