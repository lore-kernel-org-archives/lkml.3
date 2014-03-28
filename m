Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaC1PgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 11:36:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:46167 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaC1PgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 11:36:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,751,1389772800"; 
   d="scan'208";a="501741177"
From: "Chen, Jet" <jet.chen@intel.com>
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: RE: [PATCH linux-next v2] ufs: sb mutex merge + mutex_destroy: fix
Thread-Topic: [PATCH linux-next v2] ufs: sb mutex merge + mutex_destroy: fix
Thread-Index: AQHPSg1K2ZP8VT1O+kaJDN0GuiT0g5r2oX5w
Date: Fri, 28 Mar 2014 15:35:24 +0000
Message-ID: <EFD6DBD752D5C44BAF4AE4BE140985E010D4C92D@SHSMSX104.ccr.corp.intel.com>
References: <20140327233831.c32f99a8fbabb31a5e37e598@skynet.be>
In-Reply-To: <20140327233831.c32f99a8fbabb31a5e37e598@skynet.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabian,

I helped to test your patch on our LKP system. Your patch fixes the boot failure issue. Thank you for your work.

Thanks,
-Jet 

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Fabian Frederick
Sent: Friday, March 28, 2014 6:39 AM
To: linux-kernel
Cc: akpm; Wu, Fengguang
Subject: [PATCH linux-next v2] ufs: sb mutex merge + mutex_destroy: fix

mutex_destroy was also called when trying to mount volume in read/write without write support enabled.

Reported by Fengguang Wu.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
v2: failed_noreadwrite is only used with CONFIG_UFS_FS_WRITE
    -> add ifndef

 fs/ufs/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c index d05cf89..432baa1 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -798,7 +798,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!(sb->s_flags & MS_RDONLY)) {
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
-		goto failed;
+		goto failed_noreadwrite;
 	}
 #endif
 	mutex_init(&sbi->mutex);
@@ -1255,10 +1255,14 @@ magic_found:
 	return 0;
 
 failed:
+	mutex_destroy(&sbi->mutex);
+
+#ifndef CONFIG_UFS_FS_WRITE
+failed_noreadwrite:
+#endif
 	if (ubh)
 		ubh_brelse_uspi (uspi);
 	kfree (uspi);
-	mutex_destroy(&sbi->mutex);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT (FAILED)\n");
--
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
