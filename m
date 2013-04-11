Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934Ab3DKNdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:33:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933494Ab3DKN2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:28:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 08/26] wlags49_h2: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: Henk de Groot <pe1dnn@amsat.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, viro@ZenIV.linux.org.uk,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Thu, 11 Apr 2013 14:28:46 +0100
Message-ID: <20130411132846.32763.65190.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Henk de Groot <pe1dnn@amsat.org>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-wireless@vger.kernel.org
---

 drivers/staging/wlags49_h2/wl_main.c |  320 +++++++++++++++++-----------------
 1 file changed, 161 insertions(+), 159 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index 174c41a..31cfa64 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -73,6 +73,7 @@
 
 #include <linux/module.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 // #include <linux/sched.h>
@@ -144,10 +145,24 @@
 void wl_isr_handler( unsigned long p );
 
 #if 0 //SCULL_USE_PROC /* don't waste space if unused */
-//int scull_read_procmem(char *buf, char **start, off_t offset, int len, int unused);
-int scull_read_procmem(char *buf, char **start, off_t offset, int len, int *eof, void *data );
+static int scull_read_procmem(struct seq_file *m, void *v);
 static int write_int(struct file *file, const char *buffer, unsigned long count, void *data);
 
+/*
+ * seq_file wrappers for procfile show routines.
+ */
+static int scull_read_procmem_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, scull_read_procmem, PDE(inode)->data);
+}
+
+static const struct file_operations scull_read_procmem_fops = {
+	.open		= scull_read_procmem_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 #endif /* SCULL_USE_PROC */
 
 /*******************************************************************************
@@ -907,7 +922,7 @@ int wl_insert( struct net_device *dev )
 	}
 
 #if 0 //SCULL_USE_PROC /* don't waste space if unused */
-	create_proc_read_entry( "wlags", 0, NULL, scull_read_procmem, dev );
+	proc_create_data( "wlags", 0, NULL, &scull_read_procmem_fops, dev );
 	proc_mkdir("driver/wlags49", 0);
 #endif /* SCULL_USE_PROC */
 
@@ -2095,7 +2110,7 @@ static void __exit wl_module_exit( void )
 
 	wl_adapter_cleanup_module( );
 #if 0 //SCULL_USE_PROC /* don't waste space if unused */
-	remove_proc_entry( "wlags", NULL );		//;?why so a-symmetric compared to location of create_proc_read_entry
+	remove_proc_entry( "wlags", NULL );		//;?why so a-symmetric compared to location of proc_create_data
 #endif
 
 	DBG_LEAVE( DbgInfo );
@@ -3529,229 +3544,215 @@ void wl_wds_netdev_deregister( struct wl_private *lp )
 /*
  * The proc filesystem: function to read and entry
  */
-int printf_hcf_16( char *s, char *buf, hcf_16* p, int n );
-int printf_hcf_16( char *s, char *buf, hcf_16* p, int n ) {
+static void printf_hcf_16(struct seq_file *m, const char *s, hcf_16 *p, int n)
+{
+	int i, len;
 
-int i, len;
+	seq_printf(m, "%-20.20s: ", s);
+	len = 22;
 
-	len = sprintf(buf, "%s", s );
-	while ( len < 20 ) len += sprintf(buf+len, " " );
-	len += sprintf(buf+len,": " );
-	for ( i = 0; i < n; i++ ) {
-		if ( len % 80 > 75 ) {
-			len += sprintf(buf+len,"\n" );
-		}
-		len += sprintf(buf+len,"%04X ", p[i] );
+	for (i = 0; i < n; i++) {
+		if (len % 80 > 75)
+			seq_putc(m, '\n');
+		seq_printf(m, "%04X ", p[i]);
 	}
-	len += sprintf(buf+len,"\n" );
-	return len;
-} // printf_hcf_16
+	seq_putc(m, '\n');
+}
 
-int printf_hcf_8( char *s, char *buf, hcf_8* p, int n );
-int printf_hcf_8( char *s, char *buf, hcf_8* p, int n ) {
+static void printf_hcf_8(struct seq_file *m, const char *s, hcf_8 *p, int n)
+{
+	int i, len;
 
-int i, len;
+	seq_printf(m, "%-20.20s: ", s);
+	len = 22;
 
-	len = sprintf(buf, "%s", s );
-	while ( len < 20 ) len += sprintf(buf+len, " " );
-	len += sprintf(buf+len,": " );
-	for ( i = 0; i <= n; i++ ) {
-		if ( len % 80 > 77 ) {
-			len += sprintf(buf+len,"\n" );
-		}
-		len += sprintf(buf+len,"%02X ", p[i] );
+	for (i = 0; i <= n; i++) {
+		if (len % 80 > 77)
+			seq_putc(m, '\n');
+		seq_printf(m, "%02X ", p[i]);
 	}
-	len += sprintf(buf+len,"\n" );
-	return len;
-} // printf_hcf8
+	seq_putc(m, '\n');
+}
 
-int printf_strct( char *s, char *buf, hcf_16* p );
-int printf_strct( char *s, char *buf, hcf_16* p ) {
+static void printf_strct(struct seq_file *m, const char *s, hcf_16 *p)
+{
+	int i, len;
 
-int i, len;
+	seq_printf(m, "%-20.20s: ", s);
+	len = 22;
 
-	len = sprintf(buf, "%s", s );
-	while ( len < 20 ) len += sprintf(buf+len, " " );
-	len += sprintf(buf+len,": " );
 	for ( i = 0; i <= *p; i++ ) {
-		if ( len % 80 > 75 ) {
-			len += sprintf(buf+len,"\n" );
-		}
-		len += sprintf(buf+len,"%04X ", p[i] );
+		if (len % 80 > 75)
+			seq_putc(m, '\n');
+		seq_printf(m,"%04X ", p[i]);
 	}
-	len += sprintf(buf+len,"\n" );
-	return len;
-} // printf_strct
+	seq_putc(m, '\n');
+}
 
-int scull_read_procmem(char *buf, char **start, off_t offset, int len, int *eof, void *data )
+int scull_read_procmem(struct seq_file *m, void *v)
 {
-	struct wl_private	*lp = NULL;
+	struct wl_private	*lp = m->private;
 	IFBP				ifbp;
    	CFG_HERMES_TALLIES_STRCT *p;
 
-    #define LIMIT (PAGE_SIZE-80) /* don't print any more after this size */
-
-    len=0;
-
-	lp = ((struct net_device *)data)->priv;
 	if (lp == NULL) {
-        len += sprintf(buf+len,"No wl_private in scull_read_procmem\n" );
+		seq_puts(m, "No wl_private in scull_read_procmem\n" );
 	} else if ( lp->wlags49_type == 0 ){
-   	    ifbp = &lp->hcfCtx;
-   	    len += sprintf(buf+len,"Magic:               0x%04X\n", ifbp->IFB_Magic );
-   	    len += sprintf(buf+len,"IOBase:              0x%04X\n", ifbp->IFB_IOBase );
-   	    len += sprintf(buf+len,"LinkStat:            0x%04X\n", ifbp->IFB_LinkStat );
-   	    len += sprintf(buf+len,"DSLinkStat:          0x%04X\n", ifbp->IFB_DSLinkStat );
-   	    len += sprintf(buf+len,"TickIni:         0x%08lX\n", ifbp->IFB_TickIni );
-   	    len += sprintf(buf+len,"TickCnt:             0x%04X\n", ifbp->IFB_TickCnt );
-   	    len += sprintf(buf+len,"IntOffCnt:           0x%04X\n", ifbp->IFB_IntOffCnt );
-		len += printf_hcf_16( "IFB_FWIdentity", &buf[len],
-							  &ifbp->IFB_FWIdentity.len, ifbp->IFB_FWIdentity.len + 1 );
+		ifbp = &lp->hcfCtx;
+		seq_printf(m, "Magic:               0x%04X\n", ifbp->IFB_Magic );
+		seq_printf(m, "IOBase:              0x%04X\n", ifbp->IFB_IOBase );
+		seq_printf(m, "LinkStat:            0x%04X\n", ifbp->IFB_LinkStat );
+		seq_printf(m, "DSLinkStat:          0x%04X\n", ifbp->IFB_DSLinkStat );
+		seq_printf(m, "TickIni:         0x%08lX\n", ifbp->IFB_TickIni );
+		seq_printf(m, "TickCnt:             0x%04X\n", ifbp->IFB_TickCnt );
+		seq_printf(m, "IntOffCnt:           0x%04X\n", ifbp->IFB_IntOffCnt );
+		printf_hcf_16(m, "IFB_FWIdentity",
+			      &ifbp->IFB_FWIdentity.len, ifbp->IFB_FWIdentity.len + 1 );
 	} else if ( lp->wlags49_type == 1 ) {
-   	    len += sprintf(buf+len,"Channel:              0x%04X\n", lp->Channel );
-/****** len += sprintf(buf+len,"slock:                  %d\n", lp->slock );		*/
+		seq_printf(m, "Channel:              0x%04X\n", lp->Channel );
+/****** seq_printf(m, "slock:                  %d\n", lp->slock );		*/
 //x		struct tq_struct            "task:               0x%04X\n", lp->task );
 //x		struct net_device_stats     "stats:              0x%04X\n", lp->stats );
 #ifdef WIRELESS_EXT
 //x		struct iw_statistics        "wstats:             0x%04X\n", lp->wstats );
-//x   	    len += sprintf(buf+len,"spy_number:           0x%04X\n", lp->spy_number );
+//x   	    seq_printf(m, "spy_number:           0x%04X\n", lp->spy_number );
 //x		u_char                      spy_address[IW_MAX_SPY][ETH_ALEN];
 //x		struct iw_quality           spy_stat[IW_MAX_SPY];
 #endif // WIRELESS_EXT
-   	    len += sprintf(buf+len,"IFB:                  0x%p\n", &lp->hcfCtx );
-   	    len += sprintf(buf+len,"flags:                %#.8lX\n", lp->flags );  //;?use this format from now on
-   	    len += sprintf(buf+len,"DebugFlag(wl_private) 0x%04X\n", lp->DebugFlag );
+		seq_printf(m, "IFB:                  0x%p\n", &lp->hcfCtx );
+		seq_printf(m, "flags:                %#.8lX\n", lp->flags );  //;?use this format from now on
+		seq_printf(m, "DebugFlag(wl_private) 0x%04X\n", lp->DebugFlag );
 #if DBG
-   	    len += sprintf(buf+len,"DebugFlag (DbgInfo):   0x%08lX\n", DbgInfo->DebugFlag );
+		seq_printf(m, "DebugFlag (DbgInfo):   0x%08lX\n", DbgInfo->DebugFlag );
 #endif // DBG
-   	    len += sprintf(buf+len,"is_registered:        0x%04X\n", lp->is_registered );
+		seq_printf(m, "is_registered:        0x%04X\n", lp->is_registered );
 //x		CFG_DRV_INFO_STRCT          "driverInfo:         0x%04X\n", lp->driverInfo );
-		len += printf_strct( "driverInfo", &buf[len], (hcf_16*)&lp->driverInfo );
+		printf_strct( m, "driverInfo", (hcf_16*)&lp->driverInfo );
 //x		CFG_IDENTITY_STRCT          "driverIdentity:     0x%04X\n", lp->driverIdentity );
-		len += printf_strct( "driverIdentity", &buf[len], (hcf_16*)&lp->driverIdentity );
+		printf_strct( m, "driverIdentity", (hcf_16*)&lp->driverIdentity );
 //x		CFG_FW_IDENTITY_STRCT       "StationIdentity:    0x%04X\n", lp->StationIdentity );
-		len += printf_strct( "StationIdentity", &buf[len], (hcf_16*)&lp->StationIdentity );
+		printf_strct( m, "StationIdentity", (hcf_16*)&lp->StationIdentity );
 //x		CFG_PRI_IDENTITY_STRCT      "PrimaryIdentity:    0x%04X\n", lp->PrimaryIdentity );
-		len += printf_strct( "PrimaryIdentity", &buf[len], (hcf_16*)&lp->hcfCtx.IFB_PRIIdentity );
-		len += printf_strct( "PrimarySupplier", &buf[len], (hcf_16*)&lp->hcfCtx.IFB_PRISup );
+		printf_strct( m, "PrimaryIdentity", (hcf_16*)&lp->hcfCtx.IFB_PRIIdentity );
+		printf_strct( m, "PrimarySupplier", (hcf_16*)&lp->hcfCtx.IFB_PRISup );
 //x		CFG_PRI_IDENTITY_STRCT      "NICIdentity:        0x%04X\n", lp->NICIdentity );
-		len += printf_strct( "NICIdentity", &buf[len], (hcf_16*)&lp->NICIdentity );
+		printf_strct( m, "NICIdentity", (hcf_16*)&lp->NICIdentity );
 //x		ltv_t                       "ltvRecord:          0x%04X\n", lp->ltvRecord );
-   	    len += sprintf(buf+len,"txBytes:              0x%08lX\n", lp->txBytes );
-   	    len += sprintf(buf+len,"maxPort:              0x%04X\n", lp->maxPort );        /* 0 for STA, 6 for AP */
-	/* Elements used for async notification from hardware */
+		seq_printf(m, "txBytes:              0x%08lX\n", lp->txBytes );
+		seq_printf(m, "maxPort:              0x%04X\n", lp->maxPort );        /* 0 for STA, 6 for AP */
+		/* Elements used for async notification from hardware */
 //x		RID_LOG_STRCT				RidList[10];
 //x		ltv_t                       "updatedRecord:      0x%04X\n", lp->updatedRecord );
 //x		PROBE_RESP				    "ProbeResp:                    0x%04X\n", lp->ProbeResp );
 //x		ASSOC_STATUS_STRCT          "assoc_stat:         0x%04X\n", lp->assoc_stat );
 //x		SECURITY_STATUS_STRCT       "sec_stat:           0x%04X\n", lp->sec_stat );
 //x		u_char                      lookAheadBuf[WVLAN_MAX_LOOKAHEAD];
-   	    len += sprintf(buf+len,"PortType:             0x%04X\n", lp->PortType );           // 1 - 3 (1 [Normal] | 3 [AdHoc])
-   	    len += sprintf(buf+len,"Channel:              0x%04X\n", lp->Channel );            // 0 - 14 (0)
+		seq_printf(m, "PortType:             0x%04X\n", lp->PortType );           // 1 - 3 (1 [Normal] | 3 [AdHoc])
+		seq_printf(m, "Channel:              0x%04X\n", lp->Channel );            // 0 - 14 (0)
 //x		hcf_16                      TxRateControl[2];
-   	    len += sprintf(buf+len,"TxRateControl[2]:     0x%04X 0x%04X\n",
-						lp->TxRateControl[0], lp->TxRateControl[1] );
-   	    len += sprintf(buf+len,"DistanceBetweenAPs:   0x%04X\n", lp->DistanceBetweenAPs ); // 1 - 3 (1)
-   	    len += sprintf(buf+len,"RTSThreshold:         0x%04X\n", lp->RTSThreshold );       // 0 - 2347 (2347)
-   	    len += sprintf(buf+len,"PMEnabled:            0x%04X\n", lp->PMEnabled );          // 0 - 2, 8001 - 8002 (0)
-   	    len += sprintf(buf+len,"MicrowaveRobustness:  0x%04X\n", lp->MicrowaveRobustness );// 0 - 1 (0)
-   	    len += sprintf(buf+len,"CreateIBSS:           0x%04X\n", lp->CreateIBSS );         // 0 - 1 (0)
-   	    len += sprintf(buf+len,"MulticastReceive:     0x%04X\n", lp->MulticastReceive );   // 0 - 1 (1)
-   	    len += sprintf(buf+len,"MaxSleepDuration:     0x%04X\n", lp->MaxSleepDuration );   // 0 - 65535 (100)
+		seq_printf(m, "TxRateControl[2]:     0x%04X 0x%04X\n",
+			       lp->TxRateControl[0], lp->TxRateControl[1] );
+		seq_printf(m, "DistanceBetweenAPs:   0x%04X\n", lp->DistanceBetweenAPs ); // 1 - 3 (1)
+		seq_printf(m, "RTSThreshold:         0x%04X\n", lp->RTSThreshold );       // 0 - 2347 (2347)
+		seq_printf(m, "PMEnabled:            0x%04X\n", lp->PMEnabled );          // 0 - 2, 8001 - 8002 (0)
+		seq_printf(m, "MicrowaveRobustness:  0x%04X\n", lp->MicrowaveRobustness );// 0 - 1 (0)
+		seq_printf(m, "CreateIBSS:           0x%04X\n", lp->CreateIBSS );         // 0 - 1 (0)
+		seq_printf(m, "MulticastReceive:     0x%04X\n", lp->MulticastReceive );   // 0 - 1 (1)
+		seq_printf(m, "MaxSleepDuration:     0x%04X\n", lp->MaxSleepDuration );   // 0 - 65535 (100)
 //x		hcf_8                       MACAddress[ETH_ALEN];
-		len += printf_hcf_8( "MACAddress", &buf[len], lp->MACAddress, ETH_ALEN );
+		printf_hcf_8(m, "MACAddress", lp->MACAddress, ETH_ALEN );
 //x		char                        NetworkName[HCF_MAX_NAME_LEN+1];
-   	    len += sprintf(buf+len,"NetworkName:          %.32s\n", lp->NetworkName );
+		seq_printf(m, "NetworkName:          %.32s\n", lp->NetworkName );
 //x		char                        StationName[HCF_MAX_NAME_LEN+1];
-   	    len += sprintf(buf+len,"EnableEncryption:     0x%04X\n", lp->EnableEncryption );   // 0 - 1 (0)
+		seq_printf(m, "EnableEncryption:     0x%04X\n", lp->EnableEncryption );   // 0 - 1 (0)
 //x		char                        Key1[MAX_KEY_LEN+1];
-		len += printf_hcf_8( "Key1", &buf[len], lp->Key1, MAX_KEY_LEN );
+		printf_hcf_8( m, "Key1", lp->Key1, MAX_KEY_LEN );
 //x		char                        Key2[MAX_KEY_LEN+1];
 //x		char                        Key3[MAX_KEY_LEN+1];
 //x		char                        Key4[MAX_KEY_LEN+1];
-   	    len += sprintf(buf+len,"TransmitKeyID:        0x%04X\n", lp->TransmitKeyID );      // 1 - 4 (1)
+		seq_printf(m, "TransmitKeyID:        0x%04X\n", lp->TransmitKeyID );      // 1 - 4 (1)
 //x		CFG_DEFAULT_KEYS_STRCT	    "DefaultKeys:         0x%04X\n", lp->DefaultKeys );
 //x		u_char                      mailbox[MB_SIZE];
 //x		char                        szEncryption[MAX_ENC_LEN];
-   	    len += sprintf(buf+len,"driverEnable:         0x%04X\n", lp->driverEnable );
-   	    len += sprintf(buf+len,"wolasEnable:          0x%04X\n", lp->wolasEnable );
-   	    len += sprintf(buf+len,"atimWindow:           0x%04X\n", lp->atimWindow );
-   	    len += sprintf(buf+len,"holdoverDuration:     0x%04X\n", lp->holdoverDuration );
+		seq_printf(m, "driverEnable:         0x%04X\n", lp->driverEnable );
+		seq_printf(m, "wolasEnable:          0x%04X\n", lp->wolasEnable );
+		seq_printf(m, "atimWindow:           0x%04X\n", lp->atimWindow );
+		seq_printf(m, "holdoverDuration:     0x%04X\n", lp->holdoverDuration );
 //x		hcf_16                      MulticastRate[2];
-   	    len += sprintf(buf+len,"authentication:       0x%04X\n", lp->authentication ); // is this AP specific?
-   	    len += sprintf(buf+len,"promiscuousMode:      0x%04X\n", lp->promiscuousMode );
-   	    len += sprintf(buf+len,"DownloadFirmware:     0x%04X\n", lp->DownloadFirmware );   // 0 - 2 (0 [None] | 1 [STA] | 2 [AP])
-   	    len += sprintf(buf+len,"AuthKeyMgmtSuite:     0x%04X\n", lp->AuthKeyMgmtSuite );
-   	    len += sprintf(buf+len,"loadBalancing:        0x%04X\n", lp->loadBalancing );
-   	    len += sprintf(buf+len,"mediumDistribution:   0x%04X\n", lp->mediumDistribution );
-   	    len += sprintf(buf+len,"txPowLevel:           0x%04X\n", lp->txPowLevel );
-//   	    len += sprintf(buf+len,"shortRetryLimit:    0x%04X\n", lp->shortRetryLimit );
-//   	    len += sprintf(buf+len,"longRetryLimit:     0x%04X\n", lp->longRetryLimit );
+		seq_printf(m, "authentication:       0x%04X\n", lp->authentication ); // is this AP specific?
+		seq_printf(m, "promiscuousMode:      0x%04X\n", lp->promiscuousMode );
+		seq_printf(m, "DownloadFirmware:     0x%04X\n", lp->DownloadFirmware );   // 0 - 2 (0 [None] | 1 [STA] | 2 [AP])
+		seq_printf(m, "AuthKeyMgmtSuite:     0x%04X\n", lp->AuthKeyMgmtSuite );
+		seq_printf(m, "loadBalancing:        0x%04X\n", lp->loadBalancing );
+		seq_printf(m, "mediumDistribution:   0x%04X\n", lp->mediumDistribution );
+		seq_printf(m, "txPowLevel:           0x%04X\n", lp->txPowLevel );
+//   	    seq_printf(m, "shortRetryLimit:    0x%04X\n", lp->shortRetryLimit );
+//   	    seq_printf(m, "longRetryLimit:     0x%04X\n", lp->longRetryLimit );
 //x		hcf_16                      srsc[2];
 //x		hcf_16                      brsc[2];
-   	    len += sprintf(buf+len,"connectionControl:    0x%04X\n", lp->connectionControl );
+		seq_printf(m, "connectionControl:    0x%04X\n", lp->connectionControl );
 //x		//hcf_16                      probeDataRates[2];
-   	    len += sprintf(buf+len,"ownBeaconInterval:    0x%04X\n", lp->ownBeaconInterval );
-   	    len += sprintf(buf+len,"coexistence:          0x%04X\n", lp->coexistence );
+		seq_printf(m, "ownBeaconInterval:    0x%04X\n", lp->ownBeaconInterval );
+		seq_printf(m, "coexistence:          0x%04X\n", lp->coexistence );
 //x		WVLAN_FRAME                 "txF:                0x%04X\n", lp->txF );
 //x		WVLAN_LFRAME                txList[DEFAULT_NUM_TX_FRAMES];
 //x		struct list_head            "txFree:             0x%04X\n", lp->txFree );
 //x		struct list_head            txQ[WVLAN_MAX_TX_QUEUES];
-   	    len += sprintf(buf+len,"netif_queue_on:       0x%04X\n", lp->netif_queue_on );
-   	    len += sprintf(buf+len,"txQ_count:            0x%04X\n", lp->txQ_count );
+		seq_printf(m, "netif_queue_on:       0x%04X\n", lp->netif_queue_on );
+		seq_printf(m, "txQ_count:            0x%04X\n", lp->txQ_count );
 //x		DESC_STRCT                  "desc_rx:            0x%04X\n", lp->desc_rx );
 //x		DESC_STRCT                  "desc_tx:            0x%04X\n", lp->desc_tx );
 //x		WVLAN_PORT_STATE            "portState:          0x%04X\n", lp->portState );
 //x		ScanResult                  "scan_results:       0x%04X\n", lp->scan_results );
 //x		ProbeResult                 "probe_results:      0x%04X\n", lp->probe_results );
-   	    len += sprintf(buf+len,"probe_num_aps:        0x%04X\n", lp->probe_num_aps );
-   	    len += sprintf(buf+len,"use_dma:              0x%04X\n", lp->use_dma );
+		seq_printf(m, "probe_num_aps:        0x%04X\n", lp->probe_num_aps );
+		seq_printf(m, "use_dma:              0x%04X\n", lp->use_dma );
 //x		DMA_STRCT                   "dma:                0x%04X\n", lp->dma );
 #ifdef USE_RTS
-   	    len += sprintf(buf+len,"useRTS:               0x%04X\n", lp->useRTS );
+		seq_printf(m, "useRTS:               0x%04X\n", lp->useRTS );
 #endif  // USE_RTS
 #if 1 //;? (HCF_TYPE) & HCF_TYPE_AP
 		//;?should we restore this to allow smaller memory footprint
 		//;?I guess not. This should be brought under Debug mode only
-   	    len += sprintf(buf+len,"DTIMPeriod:           0x%04X\n", lp->DTIMPeriod );         // 1 - 255 (1)
-   	    len += sprintf(buf+len,"multicastPMBuffering: 0x%04X\n", lp->multicastPMBuffering );
-   	    len += sprintf(buf+len,"RejectAny:            0x%04X\n", lp->RejectAny );          // 0 - 1 (0)
-   	    len += sprintf(buf+len,"ExcludeUnencrypted:   0x%04X\n", lp->ExcludeUnencrypted ); // 0 - 1 (1)
-   	    len += sprintf(buf+len,"intraBSSRelay:        0x%04X\n", lp->intraBSSRelay );
-   	    len += sprintf(buf+len,"wlags49_type:             0x%08lX\n", lp->wlags49_type );
+		seq_printf(m, "DTIMPeriod:           0x%04X\n", lp->DTIMPeriod );         // 1 - 255 (1)
+		seq_printf(m, "multicastPMBuffering: 0x%04X\n", lp->multicastPMBuffering );
+		seq_printf(m, "RejectAny:            0x%04X\n", lp->RejectAny );          // 0 - 1 (0)
+		seq_printf(m, "ExcludeUnencrypted:   0x%04X\n", lp->ExcludeUnencrypted ); // 0 - 1 (1)
+		seq_printf(m, "intraBSSRelay:        0x%04X\n", lp->intraBSSRelay );
+		seq_printf(m, "wlags49_type:             0x%08lX\n", lp->wlags49_type );
 #ifdef USE_WDS
 //x		WVLAN_WDS_IF                wds_port[NUM_WDS_PORTS];
 #endif // USE_WDS
 #endif // HCF_AP
 	} else if ( lp->wlags49_type == 2 ){
-        len += sprintf(buf+len,"tallies to be added\n" );
+		seq_printf(m, "tallies to be added\n" );
 //Hermes Tallies (IFB substructure) {
-   	    p = &lp->hcfCtx.IFB_NIC_Tallies;
-        len += sprintf(buf+len,"TxUnicastFrames:          %08lX\n", p->TxUnicastFrames );
-        len += sprintf(buf+len,"TxMulticastFrames:        %08lX\n", p->TxMulticastFrames );
-        len += sprintf(buf+len,"TxFragments:              %08lX\n", p->TxFragments );
-        len += sprintf(buf+len,"TxUnicastOctets:          %08lX\n", p->TxUnicastOctets );
-        len += sprintf(buf+len,"TxMulticastOctets:        %08lX\n", p->TxMulticastOctets );
-        len += sprintf(buf+len,"TxDeferredTransmissions:  %08lX\n", p->TxDeferredTransmissions );
-        len += sprintf(buf+len,"TxSingleRetryFrames:      %08lX\n", p->TxSingleRetryFrames );
-        len += sprintf(buf+len,"TxMultipleRetryFrames:    %08lX\n", p->TxMultipleRetryFrames );
-        len += sprintf(buf+len,"TxRetryLimitExceeded:     %08lX\n", p->TxRetryLimitExceeded );
-        len += sprintf(buf+len,"TxDiscards:               %08lX\n", p->TxDiscards );
-        len += sprintf(buf+len,"RxUnicastFrames:          %08lX\n", p->RxUnicastFrames );
-        len += sprintf(buf+len,"RxMulticastFrames:        %08lX\n", p->RxMulticastFrames );
-        len += sprintf(buf+len,"RxFragments:              %08lX\n", p->RxFragments );
-        len += sprintf(buf+len,"RxUnicastOctets:          %08lX\n", p->RxUnicastOctets );
-        len += sprintf(buf+len,"RxMulticastOctets:        %08lX\n", p->RxMulticastOctets );
-        len += sprintf(buf+len,"RxFCSErrors:              %08lX\n", p->RxFCSErrors );
-        len += sprintf(buf+len,"RxDiscardsNoBuffer:       %08lX\n", p->RxDiscardsNoBuffer );
-        len += sprintf(buf+len,"TxDiscardsWrongSA:        %08lX\n", p->TxDiscardsWrongSA );
-        len += sprintf(buf+len,"RxWEPUndecryptable:       %08lX\n", p->RxWEPUndecryptable );
-        len += sprintf(buf+len,"RxMsgInMsgFragments:      %08lX\n", p->RxMsgInMsgFragments );
-        len += sprintf(buf+len,"RxMsgInBadMsgFragments:   %08lX\n", p->RxMsgInBadMsgFragments );
-        len += sprintf(buf+len,"RxDiscardsWEPICVError:    %08lX\n", p->RxDiscardsWEPICVError );
-        len += sprintf(buf+len,"RxDiscardsWEPExcluded:    %08lX\n", p->RxDiscardsWEPExcluded );
+		p = &lp->hcfCtx.IFB_NIC_Tallies;
+		seq_printf(m, "TxUnicastFrames:          %08lX\n", p->TxUnicastFrames );
+		seq_printf(m, "TxMulticastFrames:        %08lX\n", p->TxMulticastFrames );
+		seq_printf(m, "TxFragments:              %08lX\n", p->TxFragments );
+		seq_printf(m, "TxUnicastOctets:          %08lX\n", p->TxUnicastOctets );
+		seq_printf(m, "TxMulticastOctets:        %08lX\n", p->TxMulticastOctets );
+		seq_printf(m, "TxDeferredTransmissions:  %08lX\n", p->TxDeferredTransmissions );
+		seq_printf(m, "TxSingleRetryFrames:      %08lX\n", p->TxSingleRetryFrames );
+		seq_printf(m, "TxMultipleRetryFrames:    %08lX\n", p->TxMultipleRetryFrames );
+		seq_printf(m, "TxRetryLimitExceeded:     %08lX\n", p->TxRetryLimitExceeded );
+		seq_printf(m, "TxDiscards:               %08lX\n", p->TxDiscards );
+		seq_printf(m, "RxUnicastFrames:          %08lX\n", p->RxUnicastFrames );
+		seq_printf(m, "RxMulticastFrames:        %08lX\n", p->RxMulticastFrames );
+		seq_printf(m, "RxFragments:              %08lX\n", p->RxFragments );
+		seq_printf(m, "RxUnicastOctets:          %08lX\n", p->RxUnicastOctets );
+		seq_printf(m, "RxMulticastOctets:        %08lX\n", p->RxMulticastOctets );
+		seq_printf(m, "RxFCSErrors:              %08lX\n", p->RxFCSErrors );
+		seq_printf(m, "RxDiscardsNoBuffer:       %08lX\n", p->RxDiscardsNoBuffer );
+		seq_printf(m, "TxDiscardsWrongSA:        %08lX\n", p->TxDiscardsWrongSA );
+		seq_printf(m, "RxWEPUndecryptable:       %08lX\n", p->RxWEPUndecryptable );
+		seq_printf(m, "RxMsgInMsgFragments:      %08lX\n", p->RxMsgInMsgFragments );
+		seq_printf(m, "RxMsgInBadMsgFragments:   %08lX\n", p->RxMsgInBadMsgFragments );
+		seq_printf(m, "RxDiscardsWEPICVError:    %08lX\n", p->RxDiscardsWEPICVError );
+		seq_printf(m, "RxDiscardsWEPExcluded:    %08lX\n", p->RxDiscardsWEPExcluded );
 #if (HCF_EXT) & HCF_EXT_TALLIES_FW
-        //to be added ;?
+		//to be added ;?
 #endif // HCF_EXT_TALLIES_FW
 	} else if ( lp->wlags49_type & 0x8000 ) {	//;?kludgy but it is unclear to me were else to place this
 #if DBG
@@ -3759,16 +3760,17 @@ int scull_read_procmem(char *buf, char **start, off_t offset, int len, int *eof,
 #endif // DBG
 		lp->wlags49_type = 0;				//default to IFB again ;?
 	} else {
-        len += sprintf(buf+len,"unknown value for wlags49_type: 0x%08lX\n", lp->wlags49_type );
-        len += sprintf(buf+len,"0x0000 - IFB\n" );
-        len += sprintf(buf+len,"0x0001 - wl_private\n" );
-        len += sprintf(buf+len,"0x0002 - Tallies\n" );
-        len += sprintf(buf+len,"0x8xxx - Change debufflag\n" );
-        len += sprintf(buf+len,"ERROR    0001\nWARNING  0002\nNOTICE   0004\nTRACE    0008\n" );
-        len += sprintf(buf+len,"VERBOSE  0010\nPARAM    0020\nBREAK    0040\nRX       0100\n" );
-        len += sprintf(buf+len,"TX       0200\nDS       0400\n" );
-	}
-    return len;
+		seq_printf(m, "unknown value for wlags49_type: 0x%08lX\n", lp->wlags49_type );
+		seq_puts(m,
+			 "0x0000 - IFB\n"
+			 "0x0001 - wl_private\n"
+			 "0x0002 - Tallies\n"
+			 "0x8xxx - Change debufflag\n"
+			 "ERROR    0001\nWARNING  0002\nNOTICE   0004\nTRACE    0008\n"
+			 "VERBOSE  0010\nPARAM    0020\nBREAK    0040\nRX       0100\n"
+			 "TX       0200\nDS       0400\n");
+	}
+	return 0;
 } // scull_read_procmem
 
 static int write_int(struct file *file, const char *buffer, unsigned long count, void *data)

