Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbaIOU5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:57:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbaIOT1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 094/158] ACPICA: Namespace: Properly null terminate objects detached from a namespace node
Date: Mon, 15 Sep 2014 12:25:33 -0700
Message-Id: <20140915192545.706840839@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David E. Box" <david.e.box@linux.intel.com>

commit e23d9b8297546c6ceb7e70771e4915f2a41733cd upstream.

Fixes a bug exposed by an ACPICA unit test around the
acpi_attach_data()/acpi_detach_data() APIs where the failure to null
terminate a detached object led to the creation of a circular linked list
(and infinite looping) when the object is reattached.

Reported in acpica bugzilla #1063

Link: https://bugs.acpica.org/show_bug.cgi?id=1063
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/nsobject.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/acpi/acpica/nsobject.c
+++ b/drivers/acpi/acpica/nsobject.c
@@ -239,6 +239,17 @@ void acpi_ns_detach_object(struct acpi_n
 		}
 	}
 
+	/*
+	 * Detach the object from any data objects (which are still held by
+	 * the namespace node)
+	 */
+
+	if (obj_desc->common.next_object &&
+	    ((obj_desc->common.next_object)->common.type ==
+	     ACPI_TYPE_LOCAL_DATA)) {
+		obj_desc->common.next_object = NULL;
+	}
+
 	/* Reset the node type to untyped */
 
 	node->type = ACPI_TYPE_ANY;


