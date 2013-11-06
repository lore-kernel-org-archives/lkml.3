Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab3KFF4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:56:38 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:43197 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3KFF4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:56:37 -0500
Date: Wed, 6 Nov 2013 06:56:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Josh Boyer <jwboyer@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, prarit@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>
Subject: [PATCH v2 2/2] x86: Increase MAXSMP CPU count to 8192
Message-ID: <20131106055634.GA24044@gmail.com>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
 <20131105143728.GJ9944@hansolo.jdub.homelinux.org>
 <20131105143816.GK9944@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105143816.GK9944@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Boyer <jwboyer@redhat.com> wrote:

> The MAXSMP option is intended to enable silly large numbers of CPUs for
> testing purposes.  The current value of 4096 isn't very silly any longer
> as there are actual machines that approach 6096 CPUs when taking HT into
> account.  Increase the value to 8192 to account for this and short term
> future increases.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> ---
>  arch/x86/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f03e428..09f05cd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -828,7 +828,7 @@ config NR_CPUS
>  	range 2 512 if SMP && !MAXSMP && !CPUMASK_OFFSTACK
>  	range 2 4096 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
>  	default "1" if !SMP
> -	default "4096" if MAXSMP
> +	default "8192" if MAXSMP

So I changed the patch to up the regular range to 8192 as well: it's more 
consistent if MAXSMP tracks the normal range, as long as the defaults are 
sane. See the commit below.

Note that 'normal users' won't ever see any max CPU count beyond the 
current 512 (which is already kind of crazy for normal use), because 
CPUMASK_OFFSTACK is turned off on all but MAXSMP configs (unless the
user explicitly enables the option).

So it's not really possible to accidentally wander into that option and 
set it to an insane value - it takes some effort.

[ I've Cc:-ed Linus, who had a strong opinion about these max-cpu limits
  in the past - I hope the changes are fine in this form. ]

Thanks,

	Ingo

=====================>
>From 07bce9fd69e8409740e63db0ab0755b84ee61a0c Mon Sep 17 00:00:00 2001
From: Josh Boyer <jwboyer@redhat.com>
Date: Tue, 5 Nov 2013 09:38:16 -0500
Subject: [PATCH] x86/cpu: Increase max CPU count to 8192

The MAXSMP option is intended to enable silly large numbers of
CPUs for testing purposes.  The current value of 4096 isn't very
silly any longer as there are actual SGI machines that approach
6096 CPUs when taking HT into account.

Increase the value to a nice round 8192 to account for this and
allow for short term future increases.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Cc: prarit@redhat.com
Cc: Russ Anderson <rja@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20131105143816.GK9944@hansolo.jdub.homelinux.org
[ Tweaked it so that MAXSMP simply sets the maximum of the normal range. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f03e428..805469a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -826,9 +826,9 @@ config NR_CPUS
 	int "Maximum number of CPUs" if SMP && !MAXSMP
 	range 2 8 if SMP && X86_32 && !X86_BIGSMP
 	range 2 512 if SMP && !MAXSMP && !CPUMASK_OFFSTACK
-	range 2 4096 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
+	range 2 8192 if SMP && !MAXSMP && CPUMASK_OFFSTACK && X86_64
 	default "1" if !SMP
-	default "4096" if MAXSMP
+	default "8192" if MAXSMP
 	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
 	default "8" if SMP
 	---help---
