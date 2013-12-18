Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3LRX5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:57:24 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:49680 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474Ab3LRX5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:57:22 -0500
X-Greylist: delayed 650 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2013 18:57:22 EST
From: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
To: michael.hoefler@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, Christoph Kohl <christoph.kohl@t-online.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chad Williamson <chad@dahc.us>, Randy Dunlap <rdunlap@infradead.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] silicom: fixed checkpatch issues in bypass.c
Date: Thu, 19 Dec 2013 00:45:09 +0100
Message-Id: <1387410312-32301-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up bypass.c of the silicom driver in the staging area. All
errors and most warnings according to checkpatch.pl should be fixed.

There are still two warnings left related to too many leading tabs at nested
blocks. I did not touch this issue because the code needs really some
refactoring and since i don't have the hardware to test the code. So this patch
does not change the business logic in any way.

But we address different types of problems.
For example:
 - missing braces
 - lines over 80 characters
 - unnecessary forward declarations
 - assignment in if condition
 - whitespace stuff
 - a C++ one line comment
 - parenthesis at return statements
 - missing __init and __exit macros

Signed-off-by: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
Signed-off-by: Christoph Kohl <christoph.kohl@t-online.de>
---
 drivers/staging/silicom/bypasslib/bypass.c | 168 +++++++++++++++--------------
 1 file changed, 90 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
index ba0d23a..99c1b50 100644
--- a/drivers/staging/silicom/bypasslib/bypass.c
+++ b/drivers/staging/silicom/bypasslib/bypass.c
@@ -7,11 +7,11 @@
 /* the Free Software Foundation, located in the file LICENSE.                 */
 /*                                                                            */
 /*                                                                            */
-/* bypass.c                                                                    */
+/* bypass.c                                                                   */
 /*                                                                            */
 /******************************************************************************/
 
-#if defined(CONFIG_SMP) && ! defined(__SMP__)
+#if defined(CONFIG_SMP) && !defined(__SMP__)
 #define __SMP__
 #endif
 
@@ -22,7 +22,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 
-#include <linux/netdevice.h>	// struct device, and other headers
+#include <linux/netdevice.h>	/* struct device, and other headers */
 #include <linux/kernel_stat.h>
 #include <linux/pci.h>
 #include <linux/rtnetlink.h>
@@ -40,9 +40,6 @@ MODULE_AUTHOR("www.silicom.co.il");
 
 MODULE_LICENSE("GPL");
 
-int init_lib_module(void);
-void cleanup_lib_module(void);
-
 static int do_cmd(struct net_device *dev, struct ifreq *ifr, int cmd, int *data)
 {
 	int ret = -1;
@@ -52,9 +49,12 @@ static int do_cmd(struct net_device *dev, struct ifreq *ifr, int cmd, int *data)
 	bypass_cb = (struct if_bypass *)ifr;
 	bypass_cb->cmd = cmd;
 	bypass_cb->data = *data;
-	if ((dev->netdev_ops) && (ioctl = dev->netdev_ops->ndo_do_ioctl)) {
-		ret = ioctl(dev, ifr, SIOCGIFBYPASS);
-		*data = bypass_cb->data;
+	if (dev->netdev_ops) {
+		ioctl = dev->netdev_ops->ndo_do_ioctl;
+		if (ioctl) {
+			ret = ioctl(dev, ifr, SIOCGIFBYPASS);
+			*data = bypass_cb->data;
+		}
 	}
 
 	return ret;
@@ -66,8 +66,8 @@ static int doit(int cmd, int if_index, int *data)
 	int ret = -1;
 	struct net_device *dev;
 	struct net_device *n;
-	for_each_netdev_safe(&init_net, dev, n) {
 
+	for_each_netdev_safe(&init_net, dev, n) {
 		if (dev->ifindex == if_index) {
 			ret = do_cmd(dev, &ifr, cmd, data);
 			if (ret < 0)
@@ -82,56 +82,65 @@ static int doit(int cmd, int if_index, int *data)
 #define bp_symbol_get(fn_name) symbol_get(fn_name)
 #define bp_symbol_put(fn_name) symbol_put(fn_name)
 
-#define SET_BPLIB_INT_FN(fn_name, arg_type, arg, ret) \
-    ({ int (* fn_ex)(arg_type)=NULL; \
-    fn_ex=bp_symbol_get(fn_name##_sd); \
-       if(fn_ex) {  \
-        ret= fn_ex(arg); \
-       bp_symbol_put(fn_name##_sd); \
-       } else ret=-1; \
-    })
-
-#define  SET_BPLIB_INT_FN2(fn_name, arg_type, arg, arg_type1, arg1, ret) \
-    ({ int (* fn_ex)(arg_type,arg_type1)=NULL; \
-        fn_ex=bp_symbol_get(fn_name##_sd); \
-       if(fn_ex) {  \
-        ret= fn_ex(arg,arg1); \
-        bp_symbol_put(fn_name##_sd); \
-       } else ret=-1; \
-    })
-#define SET_BPLIB_INT_FN3(fn_name, arg_type, arg, arg_type1, arg1,arg_type2, arg2, ret) \
-    ({ int (* fn_ex)(arg_type,arg_type1, arg_type2)=NULL; \
-        fn_ex=bp_symbol_get(fn_name##_sd); \
-       if(fn_ex) {  \
-        ret= fn_ex(arg,arg1,arg2); \
-        bp_symbol_put(fn_name##_sd); \
-       } else ret=-1; \
-    })
-
-#define DO_BPLIB_GET_ARG_FN(fn_name,ioctl_val, if_index) \
-    ({    int data, ret=0; \
-            if(is_dev_sd(if_index)){ \
-            SET_BPLIB_INT_FN(fn_name, int, if_index, ret); \
-            return ret; \
-            }  \
-            return doit(ioctl_val,if_index, &data); \
-    })
-
-#define DO_BPLIB_SET_ARG_FN(fn_name,ioctl_val,if_index,arg) \
-    ({    int data, ret=0; \
-            if(is_dev_sd(if_index)){ \
-            SET_BPLIB_INT_FN2(fn_name, int, if_index, int, arg, ret); \
-            return ret; \
-            }  \
-	    data=arg; \
-            return doit(ioctl_val,if_index, &data); \
-    })
+#define SET_BPLIB_INT_FN(fn_name, arg_type, arg, ret)	\
+({	int (*fn_ex)(arg_type) = NULL;			\
+	fn_ex = bp_symbol_get(fn_name##_sd);		\
+	if (fn_ex) {					\
+		ret = fn_ex(arg);			\
+		bp_symbol_put(fn_name##_sd);		\
+	} else {					\
+		 ret = -1;				\
+	}						\
+})
+
+#define  SET_BPLIB_INT_FN2(fn_name, arg_type, arg, arg_type1, arg1, ret)\
+({	int (*fn_ex)(arg_type, arg_type1) = NULL;			\
+	fn_ex = bp_symbol_get(fn_name##_sd);				\
+	if (fn_ex) {							\
+		ret = fn_ex(arg, arg1);					\
+		bp_symbol_put(fn_name##_sd);				\
+	} else {							\
+		 ret = -1;						\
+	}								\
+})
+
+#define SET_BPLIB_INT_FN3(fn_name, arg_type, arg, arg_type1, arg1,	\
+			  arg_type2, arg2, ret)				\
+({	int (*fn_ex)(arg_type, arg_type1, arg_type2) = NULL;		\
+	fn_ex = bp_symbol_get(fn_name##_sd);				\
+	if (fn_ex) {							\
+		ret = fn_ex(arg, arg1, arg2);				\
+		bp_symbol_put(fn_name##_sd);				\
+	} else {							\
+		ret = -1;						\
+	}								\
+})
+
+#define DO_BPLIB_GET_ARG_FN(fn_name, ioctl_val, if_index)	\
+({	int data, ret = 0;					\
+	if (is_dev_sd(if_index)) {				\
+		SET_BPLIB_INT_FN(fn_name, int, if_index, ret);	\
+		return ret;					\
+	}							\
+	return doit(ioctl_val, if_index, &data);		\
+})
+
+#define DO_BPLIB_SET_ARG_FN(fn_name, ioctl_val, if_index, arg)	\
+({	int data, ret = 0;					\
+	if (is_dev_sd(if_index)) {				\
+		SET_BPLIB_INT_FN2(fn_name, int, if_index, int,	\
+				  arg, ret);			\
+		return ret;					\
+	}							\
+	data = arg;						\
+	return doit(ioctl_val, if_index, &data);		\
+})
 
 static int is_dev_sd(int if_index)
 {
 	int ret = 0;
 	SET_BPLIB_INT_FN(is_bypass, int, if_index, ret);
-	return (ret >= 0 ? 1 : 0);
+	return ret >= 0 ? 1 : 0;
 }
 
 static int is_bypass_dev(int if_index)
@@ -139,16 +148,19 @@ static int is_bypass_dev(int if_index)
 	struct pci_dev *pdev = NULL;
 	struct net_device *dev = NULL;
 	struct ifreq ifr;
-	int ret = 0, data = 0;
+	int ret = 0;
+	int data = 0;
 
 	while ((pdev = pci_get_class(PCI_CLASS_NETWORK_ETHERNET << 8, pdev))) {
-		if ((dev = pci_get_drvdata(pdev)) != NULL)
-			if (((dev = pci_get_drvdata(pdev)) != NULL) &&
-			    (dev->ifindex == if_index)) {
+		dev = pci_get_drvdata(pdev);
+		if (dev != NULL) {
+			dev = pci_get_drvdata(pdev);
+			if ((dev != NULL) && (dev->ifindex == if_index)) {
 				if ((pdev->vendor == SILICOM_VID) &&
 				    (pdev->device >= SILICOM_BP_PID_MIN) &&
-				    (pdev->device <= SILICOM_BP_PID_MAX))
+				    (pdev->device <= SILICOM_BP_PID_MAX)) {
 					goto send_cmd;
+				}
 #if defined(BP_VENDOR_SUPPORT) && defined(ETHTOOL_GDRVINFO)
 				else {
 					struct ethtool_drvinfo info;
@@ -160,23 +172,23 @@ static int is_bypass_dev(int if_index)
 						memset(&info, 0, sizeof(info));
 						info.cmd = ETHTOOL_GDRVINFO;
 						ops->get_drvinfo(dev, &info);
-						for (; bp_desc_array[k]; k++)
+						for (; bp_desc_array[k]; k++) {
 							if (!
 							    (strcmp
 							     (bp_desc_array[k],
 							      info.driver)))
 								goto send_cmd;
-
+						}
 					}
-
 				}
 #endif
 				return -1;
 			}
+		}
 	}
  send_cmd:
 	ret = do_cmd(dev, &ifr, IS_BYPASS, &data);
-	return (ret < 0 ? -1 : ret);
+	return ret < 0 ? -1 : ret;
 }
 
 static int is_bypass(int if_index)
@@ -268,10 +280,10 @@ EXPORT_SYMBOL(get_bypass_pwup);
 static int set_bypass_wd(int if_index, int ms_timeout, int *ms_timeout_set)
 {
 	int data = ms_timeout, ret = 0;
-	if (is_dev_sd(if_index))
+	if (is_dev_sd(if_index)) {
 		SET_BPLIB_INT_FN3(set_bypass_wd, int, if_index, int, ms_timeout,
 				  int *, ms_timeout_set, ret);
-	else {
+	} else {
 		ret = doit(SET_BYPASS_WD, if_index, &data);
 		if (ret > 0) {
 			*ms_timeout_set = ret;
@@ -297,10 +309,10 @@ EXPORT_SYMBOL(get_bypass_wd);
 static int get_wd_expire_time(int if_index, int *ms_time_left)
 {
 	int *data = ms_time_left, ret = 0;
-	if (is_dev_sd(if_index))
+	if (is_dev_sd(if_index)) {
 		SET_BPLIB_INT_FN2(get_wd_expire_time, int, if_index, int *,
 				  ms_time_left, ret);
-	else {
+	} else {
 		ret = doit(GET_WD_EXPIRE_TIME, if_index, data);
 		if ((ret == 0) && (*data != 0))
 			ret = 1;
@@ -493,17 +505,18 @@ static int get_bypass_info(int if_index, struct bp_info *bp_info)
 				bypass_cb = (struct if_bypass_info *)&ifr;
 				bypass_cb->cmd = GET_BYPASS_INFO;
 
-				if ((dev->netdev_ops) &&
-				    (ioctl = dev->netdev_ops->ndo_do_ioctl)) {
-					ret = ioctl(dev, &ifr, SIOCGIFBYPASS);
-				}
-
-				else
+				if (dev->netdev_ops) {
+					ioctl = dev->netdev_ops->ndo_do_ioctl;
+					if (ioctl)
+						ret = ioctl(dev, &ifr,
+							    SIOCGIFBYPASS);
+				} else {
 					ret = -1;
+				}
 				if (ret == 0)
 					memcpy(bp_info, &bypass_cb->bp_info,
 					       sizeof(struct bp_info));
-				ret = (ret < 0 ? -1 : 0);
+				ret = ret < 0 ? -1 : 0;
 				break;
 			}
 		}
@@ -512,14 +525,13 @@ static int get_bypass_info(int if_index, struct bp_info *bp_info)
 }
 EXPORT_SYMBOL(get_bypass_info);
 
-int init_lib_module(void)
+int __init init_lib_module(void)
 {
-
 	printk(VERSION);
 	return 0;
 }
 
-void cleanup_lib_module(void)
+void __exit cleanup_lib_module(void)
 {
 }
 
-- 
1.8.1.2

