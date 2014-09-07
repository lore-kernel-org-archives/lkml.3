Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaIGSEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:04:55 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:41380 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIGSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:04:53 -0400
Date: Sun, 7 Sep 2014 20:04:28 +0200
From: Quentin Lambert <lambert.quentin@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Scott Murray <scott@spiteful.org>
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] PCI: remove assignement in non straight forward if
 condition
Message-ID: <20140907180428.GA12424@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The modifications effectively change the value of len_tmp
in the case where the first condition is not met.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/pci/hotplug/ibmphp_res.c | 13 +++++++++----
 drivers/pci/pci.c                |  6 +++++-
 drivers/pci/slot.c               | 12 ++++++++++--
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/hotplug/ibmphp_res.c b/drivers/pci/hotplug/ibmphp_res.c
index e07f34e..7066c34 100644
--- a/drivers/pci/hotplug/ibmphp_res.c
+++ b/drivers/pci/hotplug/ibmphp_res.c
@@ -1044,7 +1044,9 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 		/* found our range */
 		if (!res_prev) {
 			/* first time in the loop */
-			if ((res_cur->start != range->start) && ((len_tmp = res_cur->start - 1 - range->start) >= res->len)) {
+			len_tmp = res_cur->start - 1 - range->start;
+
+			if ((res_cur->start != range->start) && (len_tmp >= res->len)) {
 				debug ("len_tmp = %x\n", len_tmp);
 
 				if ((len_tmp < len_cur) || (len_cur == 0)) {
@@ -1084,7 +1086,9 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 		}
 		if (!res_cur->next) {
 			/* last device on the range */
-			if ((range->end != res_cur->end) && ((len_tmp = range->end - (res_cur->end + 1)) >= res->len)) {
+			len_tmp = range->end - (res_cur->end + 1);
+
+			if ((range->end != res_cur->end) && (len_tmp >= res->len)) {
 				debug ("len_tmp = %x\n", len_tmp);
 				if ((len_tmp < len_cur) || (len_cur == 0)) {
 
@@ -1123,8 +1127,9 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 		if (res_prev) {
 			if (res_prev->rangeno != res_cur->rangeno) {
 				/* 1st device on this range */
-				if ((res_cur->start != range->start) &&
-					((len_tmp = res_cur->start - 1 - range->start) >= res->len)) {
+				len_tmp = res_cur->start - 1 - range->start;
+
+				if ((res_cur->start != range->start) &&	(len_tmp >= res->len)) {
 					if ((len_tmp < len_cur) || (len_cur == 0)) {
 						if ((range->start % tmp_divide) == 0) {
 							/* just perfect, starting address is divisible by length */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8b63a5b..4c3ef21 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4434,9 +4434,13 @@ static int __init pci_setup(char *str)
 {
 	while (str) {
 		char *k = strchr(str, ',');
+		char tmp = *str;
+
 		if (k)
 			*k++ = 0;
-		if (*str && (str = pcibios_setup(str)) && *str) {
+
+		str = pcibios_setup(str);
+		if (tmp && str && *str) {
 			if (!strcmp(str, "nomsi")) {
 				pci_no_msi();
 			} else if (!strcmp(str, "noaer")) {
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 396c200..22d20db 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -265,8 +265,16 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 	slot = get_slot(parent, slot_nr);
 	if (slot) {
 		if (hotplug) {
-			if ((err = slot->hotplug ? -EBUSY : 0)
-			     || (err = rename_slot(slot, name))) {
+			err = slot->hotplug ? -EBUSY : 0;
+			if (err)
+				goto hotplugerror;
+
+			err = rename_slot(slot, name);
+			if (err)
+				goto hotplugerror;
+
+			if (0) {
+hotplugerror:
 				kobject_put(&slot->kobj);
 				slot = NULL;
 				goto err;
-- 
1.9.1

