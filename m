Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3KSOml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:42:41 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:38671 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3KSOmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:37 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 06/13] staging/lustre/socklnd: remove ksnd_sysctl
Date: Tue, 19 Nov 2013 22:38:40 +0800
Message-Id: <1384871927-8553-7-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
References: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is dead code because we defined CFS_SYSFS_MODULE_PARM.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    1 -
 .../staging/lustre/lnet/klnds/socklnd/socklnd.h    |    6 -
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.c  |  307 --------------------
 .../lustre/lnet/klnds/socklnd/socklnd_modparams.c  |   12 +-
 4 files changed, 1 insertion(+), 325 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 2ddc3aa..8f74d0b 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -2866,7 +2866,6 @@ void __exit
 ksocknal_module_fini (void)
 {
 	lnet_unregister_lnd(&the_ksocklnd);
-	ksocknal_tunables_fini();
 }
 
 int __init
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
index b483e0c..df2be7a 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
@@ -124,9 +124,6 @@ typedef struct
 	unsigned int     *ksnd_zc_min_payload;  /* minimum zero copy payload size */
 	int	      *ksnd_zc_recv;	 /* enable ZC receive (for Chelsio TOE) */
 	int	      *ksnd_zc_recv_min_nfrags; /* minimum # of fragments to enable ZC receive */
-#if defined(CONFIG_SYSCTL) && !CFS_SYSFS_MODULE_PARM
-	ctl_table_header_t *ksnd_sysctl;   /* sysctl interface */
-#endif
 } ksock_tunables_t;
 
 typedef struct
@@ -592,9 +589,6 @@ extern int ksocknal_lib_get_conn_tunables (ksock_conn_t *conn, int *txmem,
 					   int *rxmem, int *nagle);
 
 extern int ksocknal_tunables_init(void);
-extern void ksocknal_tunables_fini(void);
-extern int ksocknal_lib_tunables_init(void);
-extern void ksocknal_lib_tunables_fini(void);
 
 extern void ksocknal_lib_csum_tx(ksock_tx_t *tx);
 
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
index a1c6a51..80141aa 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
@@ -36,313 +36,6 @@
 
 #include "socklnd.h"
 
-# if defined(CONFIG_SYSCTL) && !CFS_SYSFS_MODULE_PARM
-
-
-enum {
-	SOCKLND_TIMEOUT = 1,
-	SOCKLND_CREDITS,
-	SOCKLND_PEER_TXCREDITS,
-	SOCKLND_PEER_RTRCREDITS,
-	SOCKLND_PEER_TIMEOUT,
-	SOCKLND_NCONNDS,
-	SOCKLND_RECONNECTS_MIN,
-	SOCKLND_RECONNECTS_MAX,
-	SOCKLND_EAGER_ACK,
-	SOCKLND_ZERO_COPY,
-	SOCKLND_TYPED,
-	SOCKLND_BULK_MIN,
-	SOCKLND_RX_BUFFER_SIZE,
-	SOCKLND_TX_BUFFER_SIZE,
-	SOCKLND_NAGLE,
-	SOCKLND_IRQ_AFFINITY,
-	SOCKLND_ROUND_ROBIN,
-	SOCKLND_KEEPALIVE,
-	SOCKLND_KEEPALIVE_IDLE,
-	SOCKLND_KEEPALIVE_COUNT,
-	SOCKLND_KEEPALIVE_INTVL,
-	SOCKLND_BACKOFF_INIT,
-	SOCKLND_BACKOFF_MAX,
-	SOCKLND_PROTOCOL,
-	SOCKLND_ZERO_COPY_RECV,
-	SOCKLND_ZERO_COPY_RECV_MIN_NFRAGS
-};
-
-static ctl_table_t ksocknal_ctl_table[] = {
-	{
-		.ctl_name = SOCKLND_TIMEOUT,
-		.procname = "timeout",
-		.data     = &ksocknal_tunables.ksnd_timeout,
-		.maxlen   = sizeof (int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_CREDITS,
-		.procname = "credits",
-		.data     = &ksocknal_tunables.ksnd_credits,
-		.maxlen   = sizeof (int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	 {
-		.ctl_name = SOCKLND_PEER_TXCREDITS,
-		.procname = "peer_credits",
-		.data     = &ksocknal_tunables.ksnd_peertxcredits,
-		.maxlen   = sizeof (int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	 {
-		.ctl_name = SOCKLND_PEER_RTRCREDITS,
-		.procname = "peer_buffer_credits",
-		.data     = &ksocknal_tunables.ksnd_peerrtrcredits,
-		.maxlen   = sizeof (int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_PEER_TIMEOUT,
-		.procname = "peer_timeout",
-		.data     = &ksocknal_tunables.ksnd_peertimeout,
-		.maxlen   = sizeof (int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_NCONNDS,
-		.procname = "nconnds",
-		.data     = &ksocknal_tunables.ksnd_nconnds,
-		.maxlen   = sizeof (int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_RECONNECTS_MIN,
-		.procname = "min_reconnectms",
-		.data     = &ksocknal_tunables.ksnd_min_reconnectms,
-		.maxlen   = sizeof (int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_RECONNECTS_MAX,
-		.procname = "max_reconnectms",
-		.data     = &ksocknal_tunables.ksnd_max_reconnectms,
-		.maxlen   = sizeof (int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_EAGER_ACK,
-		.procname = "eager_ack",
-		.data     = &ksocknal_tunables.ksnd_eager_ack,
-		.maxlen   = sizeof (int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_ZERO_COPY,
-		.procname = "zero_copy",
-		.data     = &ksocknal_tunables.ksnd_zc_min_payload,
-		.maxlen   = sizeof (int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_ZERO_COPY_RECV,
-		.procname = "zero_copy_recv",
-		.data     = &ksocknal_tunables.ksnd_zc_recv,
-		.maxlen   = sizeof (int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-
-	{
-		.ctl_name = SOCKLND_ZERO_COPY_RECV_MIN_NFRAGS,
-		.procname = "zero_copy_recv",
-		.data     = &ksocknal_tunables.ksnd_zc_recv_min_nfrags,
-		.maxlen   = sizeof (int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_TYPED,
-		.procname = "typed",
-		.data     = &ksocknal_tunables.ksnd_typed_conns,
-		.maxlen   = sizeof (int),
-		.mode     = 0444,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_BULK_MIN,
-		.procname = "min_bulk",
-		.data     = &ksocknal_tunables.ksnd_min_bulk,
-		.maxlen   = sizeof (int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_RX_BUFFER_SIZE,
-		.procname = "rx_buffer_size",
-		.data     = &ksocknal_tunables.ksnd_rx_buffer_size,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_TX_BUFFER_SIZE,
-		.procname = "tx_buffer_size",
-		.data     = &ksocknal_tunables.ksnd_tx_buffer_size,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_NAGLE,
-		.procname = "nagle",
-		.data     = &ksocknal_tunables.ksnd_nagle,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_ROUND_ROBIN,
-		.procname = "round_robin",
-		.data     = &ksocknal_tunables.ksnd_round_robin,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_KEEPALIVE,
-		.procname = "keepalive",
-		.data     = &ksocknal_tunables.ksnd_keepalive,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_KEEPALIVE_IDLE,
-		.procname = "keepalive_idle",
-		.data     = &ksocknal_tunables.ksnd_keepalive_idle,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_KEEPALIVE_COUNT,
-		.procname = "keepalive_count",
-		.data     = &ksocknal_tunables.ksnd_keepalive_count,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-	{
-		.ctl_name = SOCKLND_KEEPALIVE_INTVL,
-		.procname = "keepalive_intvl",
-		.data     = &ksocknal_tunables.ksnd_keepalive_intvl,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-#if SOCKNAL_VERSION_DEBUG
-	{
-		.ctl_name = SOCKLND_PROTOCOL,
-		.procname = "protocol",
-		.data     = &ksocknal_tunables.ksnd_protocol,
-		.maxlen   = sizeof(int),
-		.mode     = 0644,
-		.proc_handler = &proc_dointvec,
-		.strategy = &sysctl_intvec,
-	},
-#endif
-	{0}
-};
-
-
-ctl_table_t ksocknal_top_ctl_table[] = {
-	{
-		.ctl_name = CTL_SOCKLND,
-		.procname = "socknal",
-		.data     = NULL,
-		.maxlen   = 0,
-		.mode     = 0555,
-		.child    = ksocknal_ctl_table
-	},
-	{ 0 }
-};
-
-int
-ksocknal_lib_tunables_init ()
-{
-	if (!*ksocknal_tunables.ksnd_typed_conns) {
-		int rc = -EINVAL;
-#if SOCKNAL_VERSION_DEBUG
-		if (*ksocknal_tunables.ksnd_protocol < 3)
-			rc = 0;
-#endif
-		if (rc != 0) {
-			CERROR("Protocol V3.x MUST have typed connections\n");
-			return rc;
-		}
-	}
-
-	if (*ksocknal_tunables.ksnd_zc_recv_min_nfrags < 2)
-		*ksocknal_tunables.ksnd_zc_recv_min_nfrags = 2;
-	if (*ksocknal_tunables.ksnd_zc_recv_min_nfrags > LNET_MAX_IOV)
-		*ksocknal_tunables.ksnd_zc_recv_min_nfrags = LNET_MAX_IOV;
-
-	ksocknal_tunables.ksnd_sysctl =
-		register_sysctl_table(ksocknal_top_ctl_table);
-
-	if (ksocknal_tunables.ksnd_sysctl == NULL)
-		CWARN("Can't setup /proc tunables\n");
-
-	return 0;
-}
-
-void
-ksocknal_lib_tunables_fini(void)
-{
-	if (ksocknal_tunables.ksnd_sysctl != NULL)
-		unregister_sysctl_table(ksocknal_tunables.ksnd_sysctl);
-}
-#else
-int
-ksocknal_lib_tunables_init(void)
-{
-	return 0;
-}
-
-void
-ksocknal_lib_tunables_fini(void)
-{
-}
-#endif /* # if CONFIG_SYSCTL && !CFS_SYSFS_MODULE_PARM */
-
 int
 ksocknal_lib_get_conn_addrs (ksock_conn_t *conn)
 {
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_modparams.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_modparams.c
index 8a474f6..9f4c64e 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_modparams.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_modparams.c
@@ -181,18 +181,8 @@ int ksocknal_tunables_init(void)
 	ksocknal_tunables.ksnd_protocol	   = &protocol;
 #endif
 
-#if defined(CONFIG_SYSCTL) && !CFS_SYSFS_MODULE_PARM
-	ksocknal_tunables.ksnd_sysctl	     =  NULL;
-#endif
-
 	if (*ksocknal_tunables.ksnd_zc_min_payload < (2 << 10))
 		*ksocknal_tunables.ksnd_zc_min_payload = (2 << 10);
 
-	/* initialize platform-sepcific tunables */
-	return ksocknal_lib_tunables_init();
+	return 0;
 };
-
-void ksocknal_tunables_fini(void)
-{
-	ksocknal_lib_tunables_fini();
-}
-- 
1.7.9.5

