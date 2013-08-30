Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab3H3XHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 19:07:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42381 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757062Ab3H3XG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 19:06:58 -0400
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] i40e: Convert pf_<level> macros to functions
Date: Fri, 30 Aug 2013 16:06:10 -0700
Message-Id: <daa992875a6f542adc41069daeb81246e46b7f80.1377903831.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1377903831.git.joe@perches.com>
References: <cover.1377903831.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduces object size ~10KB by removing "%s: ", __func__
and using the %pf extension and __builtin_return_address(0)
to emit the function name.

$ size drivers/net/ethernet/intel/i40e/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 166271	  36043	  50032	 252346	  3d9ba	drivers/net/ethernet/intel/i40e/built-in.o.new
 177030	  35867	  49936	 262833	  402b1	drivers/net/ethernet/intel/i40e/built-in.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 12 ++++----
 drivers/net/ethernet/intel/i40e/i40e_main.c | 45 +++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index a39d1c6..9e61ce90 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -565,11 +565,11 @@ void i40e_vlan_stripping_enable(struct i40e_vsi *vsi);
 
 /* i40e_pf message logging */
 
-#define pf_err(pf, fmt, ...)						\
-	dev_err(&(pf)->pdev->dev, "%s: " fmt, __func__, ##__VA_ARGS__)
-#define pf_warn(pf, fmt, ...)						\
-	dev_warn(&(pf)->pdev->dev, "%s: " fmt, __func__, ##__VA_ARGS__)
-#define pf_info(pf, fmt, ...)						\
-	dev_info(&(pf)->pdev->dev, "%s: " fmt, __func__, ##__VA_ARGS__)
+__printf(2, 3)
+void pf_err(const struct i40e_pf *pf, const char *fmt, ...);
+__printf(2, 3)
+void pf_warn(const struct i40e_pf *pf, const char *fmt, ...);
+__printf(2, 3)
+void pf_info(const struct i40e_pf *pf, const char *fmt, ...);
 
 #endif /* _I40E_H_ */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index d1f6744..4366de3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7340,3 +7340,48 @@ static void __exit i40e_exit_module(void)
 	i40e_dbg_exit();
 }
 module_exit(i40e_exit_module);
+
+__printf(2, 3)
+void pf_err(const struct i40e_pf *pf, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	dev_err(&pf->pdev->dev, "%pf: %pV",
+		__builtin_return_address(0), &vaf);
+
+	va_end(args);
+}
+
+__printf(2, 3)
+void pf_warn(const struct i40e_pf *pf, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	dev_warn(&pf->pdev->dev, "%pf: %pV",
+		 __builtin_return_address(0), &vaf);
+
+	va_end(args);
+}
+
+__printf(2, 3)
+void pf_info(const struct i40e_pf *pf, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	dev_info(&pf->pdev->dev, "%pf: %pV",
+		 __builtin_return_address(0), &vaf);
+
+	va_end(args);
+}
-- 
1.8.1.2.459.gbcd45b4.dirty

