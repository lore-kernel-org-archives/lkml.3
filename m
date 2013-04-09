Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140Ab3DIUDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:03:50 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:41038 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab3DIUDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:03:48 -0400
Date: Tue, 9 Apr 2013 16:03:45 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        rob.herring@calxeda.com, Jon Medhurst <tixy@linaro.org>
Subject: Re: [PATCH v6 3/4] ARM: Enable selection of SMP operations at boot
 time
In-Reply-To: <1365167495-18508-3-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.LFD.2.03.1304091600330.17375@syhkavp.arg>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Apr 2013, Stefano Stabellini wrote:

> From: Jon Medhurst <tixy@linaro.org>
> 
> Add a new 'smp_init' hook to machine_desc so platforms can specify a
> function to be used to setup smp ops instead of having a statically
> defined value.
> 
> If smp_init is set, use it instead of psci_smp_ops or mdesc->smp.
> 
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  arch/arm/include/asm/mach/arch.h |    3 +++
>  arch/arm/kernel/setup.c          |    4 +++-
>  2 files changed, 6 insertions(+), 1 deletions(-)

Please use this version instead.  The runtime hook may now indicate if 
it did initialize smp_ops or not.

----- >8
From: Jon Medhurst <tixy@linaro.org>
Date: Thu, 13 Dec 2012 13:23:13 +0000
Subject: [PATCH] ARM: Enable selection of SMP operations at boot time

Add a new 'smp_init' hook to machine_desc so platforms can specify a
function to be used to setup smp ops instead of having a statically
defined value.  The hook must return true when smp_ops are initialized.
If false the static mdesc->smp_ops will be used by default.

Signed-off-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 308ad7d6f9..af8c54c6c6 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -16,8 +16,10 @@ struct pt_regs;
 struct smp_operations;
 #ifdef CONFIG_SMP
 #define smp_ops(ops) (&(ops))
+#define smp_init_ops(ops) (&(ops))
 #else
 #define smp_ops(ops) (struct smp_operations *)NULL
+#define smp_init_ops(ops) (bool (*)(void))NULL
 #endif
 
 struct machine_desc {
@@ -41,6 +43,7 @@ struct machine_desc {
 	unsigned char		reserve_lp2 :1;	/* never has lp2	*/
 	char			restart_mode;	/* default restart mode	*/
 	struct smp_operations	*smp;		/* SMP operations	*/
+	bool			(*smp_init)(void);
 	void			(*fixup)(struct tag *, char **,
 					 struct meminfo *);
 	void			(*reserve)(void);/* reserve mem blocks	*/
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2e3e..cf4b08c0f9 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -768,7 +768,8 @@ void __init setup_arch(char **cmdline_p)
 	arm_dt_init_cpu_maps();
 #ifdef CONFIG_SMP
 	if (is_smp()) {
-		smp_set_ops(mdesc->smp);
+		if (!mdesc->smp_init || !mdesc->smp_init())
+			smp_set_ops(mdesc->smp);
 		smp_init_cpus();
 	}
 #endif
