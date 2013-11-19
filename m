Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab3KSOqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:46:04 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35768 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3KSOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:33 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 05/13] staging/lustre/o2iblnd: remove kib_sysctl
Date: Tue, 19 Nov 2013 22:38:39 +0800
Message-Id: <1384871927-8553-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
References: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we have #define CFS_SYSFS_MODULE_PARM  1
so it is indeed dead code.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    1 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |    3 -
 .../lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c  |  262 --------------------
 3 files changed, 266 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 86397f9..644a000 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -3230,7 +3230,6 @@ void __exit
 kiblnd_module_fini (void)
 {
 	lnet_unregister_lnd(&the_o2iblnd);
-	kiblnd_tunables_fini();
 }
 
 int __init
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
index 938df0c..3f83ce4 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
@@ -106,9 +106,6 @@ typedef struct
 	int	      *kib_fmr_pool_size;    /* # FMRs in pool */
 	int	      *kib_fmr_flush_trigger; /* When to trigger FMR flush */
 	int	      *kib_fmr_cache;	/* enable FMR pool cache? */
-#if defined(CONFIG_SYSCTL) && !CFS_SYSFS_MODULE_PARM
-	ctl_table_header_t *kib_sysctl;  /* sysctl interface */
-#endif
 	int	      *kib_require_priv_port;/* accept only privileged ports */
 	int	      *kib_use_priv_port;    /* use privileged port for active connect */
 	/* # threads on each CPT */
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c
index 92dc567..cc291d0 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c
@@ -176,261 +176,6 @@ kib_tunables_t kiblnd_tunables = {
 	.kib_nscheds		    = &nscheds
 };
 
-#if defined(CONFIG_SYSCTL) && !CFS_SYSFS_MODULE_PARM
-
-static char ipif_basename_space[32];
-
-
-enum {
-	O2IBLND_SERVICE  = 1,
-	O2IBLND_CKSUM,
-	O2IBLND_TIMEOUT,
-	O2IBLND_NTX,
-	O2IBLND_CREDITS,
-	O2IBLND_PEER_TXCREDITS,
-	O2IBLND_PEER_CREDITS_HIW,
-	O2IBLND_PEER_RTRCREDITS,
-	O2IBLND_PEER_TIMEOUT,
-	O2IBLND_IPIF_BASENAME,
-	O2IBLND_RETRY_COUNT,
-	O2IBLND_RNR_RETRY_COUNT,
-	O2IBLND_KEEPALIVE,
-	O2IBLND_CONCURRENT_SENDS,
-	O2IBLND_IB_MTU,
-	O2IBLND_MAP_ON_DEMAND,
-	O2IBLND_FMR_POOL_SIZE,
-	O2IBLND_FMR_FLUSH_TRIGGER,
-	O2IBLND_FMR_CACHE,
-	O2IBLND_PMR_POOL_SIZE,
-	O2IBLND_DEV_FAILOVER
-};
-
-static ctl_table_t kiblnd_ctl_table[] = {
-	{
-		.ctl_name = O2IBLND_SERVICE,
-		.procname = "service",
-		.data     = &service,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_CKSUM,
-		.procname = "cksum",
-		.data     = &cksum,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_TIMEOUT,
-		.procname = "timeout",
-		.data     = &timeout,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_NTX,
-		.procname = "ntx",
-		.data     = &ntx,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_CREDITS,
-		.procname = "credits",
-		.data     = &credits,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_PEER_TXCREDITS,
-		.procname = "peer_credits",
-		.data     = &peer_credits,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_PEER_CREDITS_HIW,
-		.procname = "peer_credits_hiw",
-		.data     = &peer_credits_hiw,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_PEER_RTRCREDITS,
-		.procname = "peer_buffer_credits",
-		.data     = &peer_buffer_credits,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_PEER_TIMEOUT,
-		.procname = "peer_timeout",
-		.data     = &peer_timeout,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_IPIF_BASENAME,
-		.procname = "ipif_name",
-		.data     = ipif_basename_space,
-		.maxlen   = sizeof(ipif_basename_space),
-		.mode     = 0444,
-		.proc_handler = &proc_dostring
-	},
-	{
-		.ctl_name = O2IBLND_RETRY_COUNT,
-		.procname = "retry_count",
-		.data     = &retry_count,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_RNR_RETRY_COUNT,
-		.procname = "rnr_retry_count",
-		.data     = &rnr_retry_count,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_KEEPALIVE,
-		.procname = "keepalive",
-		.data     = &keepalive,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_CONCURRENT_SENDS,
-		.procname = "concurrent_sends",
-		.data     = &concurrent_sends,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_IB_MTU,
-		.procname = "ib_mtu",
-		.data     = &ib_mtu,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_MAP_ON_DEMAND,
-		.procname = "map_on_demand",
-		.data     = &map_on_demand,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-
-	{
-		.ctl_name = O2IBLND_FMR_POOL_SIZE,
-		.procname = "fmr_pool_size",
-		.data     = &fmr_pool_size,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_FMR_FLUSH_TRIGGER,
-		.procname = "fmr_flush_trigger",
-		.data     = &fmr_flush_trigger,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_FMR_CACHE,
-		.procname = "fmr_cache",
-		.data     = &fmr_cache,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_PMR_POOL_SIZE,
-		.procname = "pmr_pool_size",
-		.data     = &pmr_pool_size,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{
-		.ctl_name = O2IBLND_DEV_FAILOVER,
-		.procname = "dev_failover",
-		.data     = &dev_failover,
-		.maxlen   = sizeof(int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-	},
-	{0}
-};
-
-static ctl_table_t kiblnd_top_ctl_table[] = {
-	{
-		.ctl_name = CTL_O2IBLND,
-		.procname = "o2iblnd",
-		.data     = NULL,
-		.maxlen   = 0,
-		.mode     = 0555,
-		.child    = kiblnd_ctl_table
-	},
-	{0}
-};
-
-void
-kiblnd_initstrtunable(char *space, char *str, int size)
-{
-	strncpy(space, str, size);
-	space[size-1] = 0;
-}
-
-void
-kiblnd_sysctl_init (void)
-{
-	kiblnd_initstrtunable(ipif_basename_space, ipif_name,
-			      sizeof(ipif_basename_space));
-
-	kiblnd_tunables.kib_sysctl =
-		register_sysctl_table(kiblnd_top_ctl_table);
-
-	if (kiblnd_tunables.kib_sysctl == NULL)
-		CWARN("Can't setup /proc tunables\n");
-}
-
-void
-kiblnd_sysctl_fini (void)
-{
-	if (kiblnd_tunables.kib_sysctl != NULL)
-		unregister_sysctl_table(kiblnd_tunables.kib_sysctl);
-}
-
-#else
-
-void
-kiblnd_sysctl_init (void)
-{
-}
-
-void
-kiblnd_sysctl_fini (void)
-{
-}
-
-#endif
-
 int
 kiblnd_tunables_init (void)
 {
@@ -482,12 +227,5 @@ kiblnd_tunables_init (void)
 		      *kiblnd_tunables.kib_concurrent_sends, *kiblnd_tunables.kib_peertxcredits);
 	}
 
-	kiblnd_sysctl_init();
 	return 0;
 }
-
-void
-kiblnd_tunables_fini (void)
-{
-	kiblnd_sysctl_fini();
-}
-- 
1.7.9.5

