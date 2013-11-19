Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab3KSJCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:02:40 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:41054 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3KSJCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:02:36 -0500
Date: Tue, 19 Nov 2013 10:02:11 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jason Baron <jbaron@akamai.com>
Cc: mingo@kernel.org, benh@kernel.crashing.org, paulus@samba.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Florian Fainelli <florian@openwrt.org>,
        Shinya Kuribayashi <skuribay@ruby.dti.ne.jp>,
        Jayachandran C <jchandra@broadcom.com>,
        Ganesan Ramalingam <ganesanr@broadcom.com>
Subject: Re: [PATCH v2] panic: Make panic_timeout configurable
Message-ID: <20131119090211.GN10382@linux-mips.org>
References: <20131118210436.233B5202A@prod-mail-relay06.akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118210436.233B5202A@prod-mail-relay06.akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 09:04:36PM +0000, Jason Baron wrote:

> The panic_timeout value can be set via the command line option 'panic=x', or via
> /proc/sys/kernel/panic, however that is not sufficient when the panic occurs
> before we are able to set up these values. Thus, add a CONFIG_PANIC_TIMEOUT
> so that we can set the desired value from the .config.
> 
> The default panic_timeout value continues to be 0 - wait forever, except for
> powerpc and mips, which have been defaulted to 180 and 5 respectively. This
> is in keeping with the fact that these arches already set panic_timeout in
> their arch init code. However, I found three exceptions- two in mips and one in
> powerpc where the settings didn't match these default values. In those cases, I
> left the arch code so it continues to override, in case the user has not changed
> from the default. It would nice if these arches had one default value, or if we
> could determine the correct setting at compile-time.

It's more complicated - MIPS was using the global default with five MIPS
platforms overriding the default.

I propose to kill these overrides for sanity unless somebody comes up
with a good argument.  Patch below.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/ar7/setup.c           | 1 -
 arch/mips/emma/markeins/setup.c | 3 ---
 arch/mips/netlogic/xlp/setup.c  | 1 -
 arch/mips/netlogic/xlr/setup.c  | 1 -
 arch/mips/sibyte/swarm/setup.c  | 2 --
 5 files changed, 8 deletions(-)

diff --git a/arch/mips/ar7/setup.c b/arch/mips/ar7/setup.c
index 9a357ff..820b7a3 100644
--- a/arch/mips/ar7/setup.c
+++ b/arch/mips/ar7/setup.c
@@ -92,7 +92,6 @@ void __init plat_mem_setup(void)
 	_machine_restart = ar7_machine_restart;
 	_machine_halt = ar7_machine_halt;
 	pm_power_off = ar7_machine_power_off;
-	panic_timeout = 3;
 
 	io_base = (unsigned long)ioremap(AR7_REGS_BASE, 0x10000);
 	if (!io_base)
diff --git a/arch/mips/emma/markeins/setup.c b/arch/mips/emma/markeins/setup.c
index d710058..9100122 100644
--- a/arch/mips/emma/markeins/setup.c
+++ b/arch/mips/emma/markeins/setup.c
@@ -111,9 +111,6 @@ void __init plat_mem_setup(void)
 	iomem_resource.start = EMMA2RH_IO_BASE;
 	iomem_resource.end = EMMA2RH_ROM_BASE - 1;
 
-	/* Reboot on panic */
-	panic_timeout = 180;
-
 	markeins_sio_setup();
 }
 
diff --git a/arch/mips/netlogic/xlp/setup.c b/arch/mips/netlogic/xlp/setup.c
index 6d981bb..54e75c7 100644
--- a/arch/mips/netlogic/xlp/setup.c
+++ b/arch/mips/netlogic/xlp/setup.c
@@ -92,7 +92,6 @@ static void __init xlp_init_mem_from_bars(void)
 
 void __init plat_mem_setup(void)
 {
-	panic_timeout	= 5;
 	_machine_restart = (void (*)(char *))nlm_linux_exit;
 	_machine_halt	= nlm_linux_exit;
 	pm_power_off	= nlm_linux_exit;
diff --git a/arch/mips/netlogic/xlr/setup.c b/arch/mips/netlogic/xlr/setup.c
index 214d123..921be5f 100644
--- a/arch/mips/netlogic/xlr/setup.c
+++ b/arch/mips/netlogic/xlr/setup.c
@@ -92,7 +92,6 @@ static void nlm_linux_exit(void)
 
 void __init plat_mem_setup(void)
 {
-	panic_timeout	= 5;
 	_machine_restart = (void (*)(char *))nlm_linux_exit;
 	_machine_halt	= nlm_linux_exit;
 	pm_power_off	= nlm_linux_exit;
diff --git a/arch/mips/sibyte/swarm/setup.c b/arch/mips/sibyte/swarm/setup.c
index 41707a2..3462c83 100644
--- a/arch/mips/sibyte/swarm/setup.c
+++ b/arch/mips/sibyte/swarm/setup.c
@@ -134,8 +134,6 @@ void __init plat_mem_setup(void)
 #error invalid SiByte board configuration
 #endif
 
-	panic_timeout = 5;  /* For debug.  */
-
 	board_be_handler = swarm_be_handler;
 
 	if (xicor_probe())
