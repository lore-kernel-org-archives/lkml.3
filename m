Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbaLIQnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:43:14 -0500
Received: from mail-bl2on0062.outbound.protection.outlook.com ([65.55.169.62]:24810
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754278AbaLIQnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:43:12 -0500
From: <atull@opensource.altera.com>
To: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v3 3/3] fpga manager: device tree overlay support
Date: Tue, 9 Dec 2014 10:28:01 -0600
Message-ID: <1418142481-6167-4-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418142481-6167-1-git-send-email-atull@opensource.altera.com>
References: <1418142481-6167-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0015.namprd00.prod.outlook.com (25.160.102.25) To
 DM2PR0301MB1248.namprd03.prod.outlook.com (25.160.219.25)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1248;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:DM2PR0301MB1248;
X-Forefront-PRVS: 0420213CCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6009001)(189002)(199003)(229853001)(107046002)(33646002)(122386002)(99396003)(62966003)(77156002)(46102003)(68736005)(105586002)(15975445007)(81156004)(106356001)(4396001)(50226001)(101416001)(40100003)(120916001)(31966008)(97736003)(19580395003)(87976001)(19580405001)(50466002)(48376002)(66066001)(86362001)(21056001)(92566001)(2201001)(20776003)(86152002)(47776003)(64706001)(50986999)(42186005)(89996001)(69596002)(76176999)(53416004)(7059030)(2101003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1248;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1248;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Support programming the fpga from device tree overlays.

This patch adds two exported functions to the core
(fpga-mgr.c):
  of_fpga_mgr_dev_lookup
    Get pointer to fpga manager struct given a phandle.

  of_find_fpga_mgr_by_node
    Get pointer to fpga manager given device node

This code is dependent on Pantelis Antoniou's current work
on Device Tree overlays, a method of dynamically altering
the kernel's live Device Tree.  The rest of the patchset was
tested with recent for-next, but this 'bus driver' patch was
tested with Pantelis's and Grant Likely's stuff that is in git
(his git repo https://github.com/pantoniou/linux-beagle-track-mainline
 v3.17-rc2-115-gbc778b8 == dt-ng/bbb) plus some dtc fixups
for compiling overlays.

TODO: Integrate bridge support

General flow is:
1. Load a DT overlay
2. This causes the FPGA to get programmed
3. TODO - enable FPGA bridges
4. Drivers get probed

The reverse flow is also supported:
1. Remove the DT overlay
2. Drivers get removed
3. TODO - disable FPGA bridges
4. FPGA gets reset

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 drivers/fpga/Kconfig     |    7 ++++
 drivers/fpga/fpga-mgr.c  |  104 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/fpga-mgr.h |    3 ++
 3 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index e775b17..2bd6c83 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -18,4 +18,11 @@ config FPGA_MGR_SYSFS
 	help
 	  FPGA Manager SysFS interface.
 
+config FPGA_MGR_BUS
+	bool "FPGA Manager Bus"
+	depends on FPGA
+	help
+	  FPGA Manager Bus interface.  Allows loading FPGA images
+	  from Device Tree or from other drivers.
+
 endmenu
diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
index d08cb82..6f9c196 100644
--- a/drivers/fpga/fpga-mgr.c
+++ b/drivers/fpga/fpga-mgr.c
@@ -36,6 +36,7 @@ static DEFINE_IDA(fpga_mgr_ida);
 static struct class *fpga_mgr_class;
 
 static LIST_HEAD(fpga_manager_list);
+static struct notifier_block fpga_mgr_of_notifier_block;
 
 /*
  * Get FPGA state from low level driver
@@ -186,12 +187,17 @@ int fpga_mgr_firmware_write(struct fpga_manager *mgr, const char *image_name)
 	ret = request_firmware(&fw, image_name, &mgr->dev);
 	if (ret) {
 		mgr->state = FPGA_MGR_STATE_FIRMWARE_REQ_ERR;
+		dev_dbg(&mgr->dev, "Error requesting firmware %s\n",
+			image_name);
 		goto fw_wr_exit;
 	}
 
 	ret = __fpga_mgr_write(mgr, fw->data, fw->size);
-	if (ret)
+	if (ret) {
+		dev_dbg(&mgr->dev, "Error writing %s to %s\n",
+			image_name, mgr->name);
 		goto fw_wr_exit;
+	}
 
 	strcpy(mgr->image_name, image_name);
 
@@ -367,6 +373,87 @@ const struct dev_pm_ops fpga_mgr_dev_pm_ops = {
 	.resume		= fpga_mgr_resume,
 };
 
+#if IS_ENABLED(CONFIG_OF)
+/* Find the fpga manager that is pointed to by a phandle */
+struct fpga_manager *of_fpga_mgr_dev_lookup(struct device_node *node,
+					    const char *mgr_property)
+{
+	struct fpga_manager *mgr;
+	struct device_node *mgr_node;
+
+	if (node == NULL)
+		return NULL;
+
+	mgr_node = of_parse_phandle(node, mgr_property, 0);
+	if (!mgr_node)
+		return NULL;
+
+	list_for_each_entry(mgr, &fpga_manager_list, list)
+		if (mgr_node == mgr->dev.of_node) {
+			of_node_put(mgr_node);
+			return mgr;
+		}
+
+	of_node_put(mgr_node);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(of_fpga_mgr_dev_lookup);
+
+struct fpga_manager *of_find_fpga_mgr_by_node(struct device_node *node)
+{
+	struct fpga_manager *mgr;
+
+	if (node == NULL)
+		return NULL;
+
+	list_for_each_entry(mgr, &fpga_manager_list, list)
+		if (node == mgr->dev.of_node)
+			return mgr;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(of_find_fpga_mgr_by_node);
+#endif	/* CONFIG_OF */
+
+static int of_fpga_mgr_notify(struct notifier_block *nb, unsigned long action,
+			      void *arg)
+{
+	struct device_node *dn;
+	const char *path;
+	struct fpga_manager *mgr;
+	int state;
+
+	state = of_reconfig_get_state_change(action, arg);
+	if (state == -1)
+		return NOTIFY_OK;
+
+	switch (action) {
+	case OF_RECONFIG_ATTACH_NODE:
+	case OF_RECONFIG_DETACH_NODE:
+		dn = arg;
+		break;
+	case OF_RECONFIG_ADD_PROPERTY:
+	case OF_RECONFIG_REMOVE_PROPERTY:
+	case OF_RECONFIG_UPDATE_PROPERTY:
+	default:
+		return NOTIFY_OK;
+	}
+
+	mgr = of_find_fpga_mgr_by_node(dn->parent);
+	if (!mgr)
+		return NOTIFY_OK;	/* not for us */
+
+	if (state) {
+		if (!of_property_read_string(dn, "fpga-firmware", &path))
+			fpga_mgr_firmware_write(mgr, path);
+	} else {
+		fpga_mgr_reset(mgr);
+	}
+
+	return NOTIFY_OK;
+}
+
 static void fpga_mgr_dev_release(struct device *dev)
 {
 	struct fpga_manager *mgr = to_fpga_manager(dev);
@@ -459,6 +546,8 @@ EXPORT_SYMBOL_GPL(fpga_mgr_remove);
 
 static int __init fpga_mgr_dev_init(void)
 {
+	int ret;
+
 	pr_info("FPGA Manager framework driver\n");
 
 	fpga_mgr_class = class_create(THIS_MODULE, "fpga_manager");
@@ -468,11 +557,24 @@ static int __init fpga_mgr_dev_init(void)
 	fpga_mgr_class->dev_groups = fpga_mgr_groups;
 	fpga_mgr_class->pm = &fpga_mgr_dev_pm_ops;
 
+#if IS_ENABLED(CONFIG_OF)
+	fpga_mgr_of_notifier_block.notifier_call = of_fpga_mgr_notify;
+	ret = of_reconfig_notifier_register(&fpga_mgr_of_notifier_block);
+	if (ret) {
+		class_destroy(fpga_mgr_class);
+		ida_destroy(&fpga_mgr_ida);
+		return ret;
+	}
+#endif
+
 	return 0;
 }
 
 static void __exit fpga_mgr_dev_exit(void)
 {
+#if IS_ENABLED(CONFIG_OF)
+	of_reconfig_notifier_unregister(&fpga_mgr_of_notifier_block);
+#endif
 	class_destroy(fpga_mgr_class);
 	ida_destroy(&fpga_mgr_ida);
 }
diff --git a/include/linux/fpga-mgr.h b/include/linux/fpga-mgr.h
index 7ac762c..414d949 100644
--- a/include/linux/fpga-mgr.h
+++ b/include/linux/fpga-mgr.h
@@ -99,6 +99,9 @@ int fpga_mgr_reset(struct fpga_manager *mgr);
 int fpga_mgr_register(struct device *pdev, const char *name,
 		      struct fpga_manager_ops *mops, void *priv);
 void fpga_mgr_remove(struct device *dev);
+struct fpga_manager *of_fpga_mgr_dev_lookup(struct device_node *node,
+					    const char *mgr_property);
+struct fpga_manager *of_find_fpga_mgr_by_node(struct device_node *node);
 
 #endif /* CONFIG_FPGA */
 #endif /*_LINUX_FPGA_MGR_H */
-- 
1.7.9.5

