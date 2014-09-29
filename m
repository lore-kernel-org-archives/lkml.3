Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaI2Mr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:47:57 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49954 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaI2Mr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:47:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Simmons <uja.ornl@gmail.com>,
        Mikhail Pershin <mike.pershin@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Jian Yu <jian.yu@intel.com>, Bob Glossman <bob.glossman@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] staging/lustre/lvfs: fix building without CONFIG_PROC_FS
Date: Mon, 29 Sep 2014 14:47:45 +0200
Message-ID: <2146246.DTeNN9Vm3N@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dzvSchYW0yERIxadpnvPstP+gSh5Pmp2TGZ9GkSKeHz
 Ct26mFmEkCJP1m2vrDiEeTDiBwZaKH1RUvqAbZVYsSOGN+4rmv
 FU0xn2VoACDrkXaUQG9rb0QQxd0RMAtDcd2r4MGQaCPhfN3rwD
 eOhpAb6Re4OUix+IHNI7ABeRb3JgysNdz2NZr46rvsJ+mvKr7E
 sT4We5KekD7xY5j6dDivo0IREuySskl/wxFvrwSSHNLqL3rV9a
 gUK9W0/etDqbY4jhLLpERpowZvq3wnFAAtapGk3u5YswHK2fz8
 3T+QXf2fI65pOJjqJ+juQkRyI8im8ex8iANHk2Co5zPU3z3aDZ
 pTojcEwUzfo8Yemw/9f8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch "staging/lustre/lvfs: remove the lvfs layer" moved some code around
that was previously only built when CONFIG_PROC_FS was set, which now
causes an invalid access to the obd_memory variable:

ERROR: "obd_memory" [drivers/staging/lustre/lustre/obdclass/obdclass.ko] undefined!

This fixes it by using adding a compile-time check around the access.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: fdedd94509fd ("staging/lustre/lvfs: remove the lvfs layer")
Cc: James Simmons <uja.ornl@gmail.com>
Cc: Mikhail Pershin <mike.pershin@intel.com>
Cc: John L. Hammond <john.hammond@intel.com>
Cc: Jian Yu <jian.yu@intel.com>
Cc: Bob Glossman <bob.glossman@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 8b8d338e41e8..7265ecbc6f9d 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -534,20 +534,23 @@ static int __init init_obdclass(void)
 	spin_lock_init(&obd_types_lock);
 	obd_zombie_impexp_init();
 
-	obd_memory = lprocfs_alloc_stats(OBD_STATS_NUM,
-					 LPROCFS_STATS_FLAG_NONE |
-					 LPROCFS_STATS_FLAG_IRQ_SAFE);
-	if (obd_memory == NULL) {
-		CERROR("kmalloc of 'obd_memory' failed\n");
-		return -ENOMEM;
-	}
-
-	lprocfs_counter_init(obd_memory, OBD_MEMORY_STAT,
-			     LPROCFS_CNTR_AVGMINMAX,
-			     "memused", "bytes");
-	lprocfs_counter_init(obd_memory, OBD_MEMORY_PAGES_STAT,
-			     LPROCFS_CNTR_AVGMINMAX,
-			     "pagesused", "pages");
+	if (IS_ENABLED(CONFIG_PROC_FS)) {
+		obd_memory = lprocfs_alloc_stats(OBD_STATS_NUM,
+						 LPROCFS_STATS_FLAG_NONE |
+						 LPROCFS_STATS_FLAG_IRQ_SAFE);
+
+		if (obd_memory == NULL) {
+			CERROR("kmalloc of 'obd_memory' failed\n");
+			return -ENOMEM;
+		}
+
+		lprocfs_counter_init(obd_memory, OBD_MEMORY_STAT,
+				     LPROCFS_CNTR_AVGMINMAX,
+				     "memused", "bytes");
+		lprocfs_counter_init(obd_memory, OBD_MEMORY_PAGES_STAT,
+				     LPROCFS_CNTR_AVGMINMAX,
+				     "pagesused", "pages");
+	}
 
 	err = obd_init_checks();
 	if (err == -EOVERFLOW)

