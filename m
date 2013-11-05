Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3KEOho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:37:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab3KEOhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:37:43 -0500
Date: Tue, 5 Nov 2013 09:37:29 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: prarit@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Russ Anderson <rja@sgi.com>
Subject: [PATCH 1/2 v2] x86: Allow higher NR_CPUS values
Message-ID: <20131105143728.GJ9944@hansolo.jdub.homelinux.org>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current range for SMP configs is 2 - 512 CPUs, or a full 4096 in the
case of MAXSMP.  There are machines that have 1024 CPUs in them today and
configuring a kernel for that means you are forced to set MAXSMP.  This
adds additional unnecessary overhead.  While that overhead might be
considered tiny for large machines, it isn't necessarily so if you are
building a kernel that runs across a wide variety of machines.

To cover the range of more common machines today, we allow NR_CPUS to be
up to 4096 when CPUMASK_OFFSTACK is enabled.  Relatedly, we no longer make
that option depend on DEBUG_PER_CPU_MASKS.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 arch/x86/Kconfig | 6 ++++--
 lib/Kconfig      | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

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
diff --git a/lib/Kconfig b/lib/Kconfig
index b3c8be0..0ea738e 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -342,7 +342,7 @@ config CHECK_SIGNATURE
 	bool
 
 config CPUMASK_OFFSTACK
-	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
+	bool "Force CPU masks off stack"
 	help
 	  Use dynamic allocation for cpumask_var_t, instead of putting
 	  them on the stack.  This is a bit more expensive, but avoids
-- 
1.8.3.1

