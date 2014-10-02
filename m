Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaJBMpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:45:20 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:33664 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaJBMpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:45:19 -0400
From: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heicars2@linux.vnet.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Hendrik Brueckner <brueckner@de.ibm.com>,
        Harald Freudenberger <freude@de.ibm.com>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: [PATCH] s390/zcrypt: Toleration of new crypto hardware
Date: Thu,  2 Oct 2014 14:45:01 +0200
Message-Id: <1412253901-9938-1-git-send-email-ingo.tuchscherer@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100212-0542-0000-0000-00000108244E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390/zcrypt: Toleration of new crypto hardware

The zcrypt device driver will accept the new crypto adapter
in toleration mode. A new sysfs attribute 'raw_hwtype' will 
expose the raw hardware type.

Signed-off-by: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>

Index: linux/drivers/s390/crypto/ap_bus.h
===================================================================
--- linux.orig/drivers/s390/crypto/ap_bus.h
+++ linux/drivers/s390/crypto/ap_bus.h
@@ -161,6 +161,7 @@ struct ap_device {
 	ap_qid_t qid;			/* AP queue id. */
 	int queue_depth;		/* AP queue depth.*/
 	int device_type;		/* AP device type. */
+	int raw_hwtype;			/* AP raw hardware type. */
 	unsigned int functions;		/* AP device function bitfield. */
 	int unregistered;		/* marks AP device as unregistered */
 	struct timer_list timeout;	/* Timer for request timeouts. */
Index: linux/drivers/s390/crypto/ap_bus.c
===================================================================
--- linux.orig/drivers/s390/crypto/ap_bus.c
+++ linux/drivers/s390/crypto/ap_bus.c
@@ -664,6 +664,17 @@ static ssize_t ap_hwtype_show(struct dev
 }
 
 static DEVICE_ATTR(hwtype, 0444, ap_hwtype_show, NULL);
+
+static ssize_t ap_raw_hwtype_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct ap_device *ap_dev = to_ap_dev(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", ap_dev->raw_hwtype);
+}
+
+static DEVICE_ATTR(raw_hwtype, 0444, ap_raw_hwtype_show, NULL);
+
 static ssize_t ap_depth_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
@@ -734,6 +745,7 @@ static DEVICE_ATTR(ap_functions, 0444, a
 
 static struct attribute *ap_dev_attrs[] = {
 	&dev_attr_hwtype.attr,
+	&dev_attr_raw_hwtype.attr,
 	&dev_attr_depth.attr,
 	&dev_attr_request_count.attr,
 	&dev_attr_requestq_count.attr,
@@ -1417,9 +1429,13 @@ static void ap_scan_bus(struct work_stru
 				continue;
 			}
 			break;
+		case 11:
+			ap_dev->device_type = 10;
+			break;
 		default:
 			ap_dev->device_type = device_type;
 		}
+		ap_dev->raw_hwtype = device_type;
 
 		rc = ap_query_functions(qid, &device_functions);
 		if (!rc)

