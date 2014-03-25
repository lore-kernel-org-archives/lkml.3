Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbaCYRjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:39:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55902 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbaCYRVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 34/81] ACPI / PCI: Fix memory leak in acpi_pci_irq_enable()
Date: Tue, 25 Mar 2014 10:15:47 -0700
Message-Id: <1395767794-5012-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Nowicki <tomasz.nowicki@linaro.org>

commit b685f3b1744061aa9ad822548ba9c674de5be7c6 upstream.

acpi_pci_link_allocate_irq() can return negative gsi even if
entry != NULL.  For that case we have a memory leak, so free
entry before returning from acpi_pci_irq_enable() for gsi < 0.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
[rjw: Subject and changelog]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/pci_irq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 68a921d..bee8d6d 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -470,6 +470,8 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 			dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
 				 pin_name(pin));
 		}
+
+		kfree(entry);
 		return 0;
 	}
 
-- 
1.8.3.2

