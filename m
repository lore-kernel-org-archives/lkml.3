Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791Ab3K0B5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:57:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3K0A5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.10 04/80] ACPICA: Return error if DerefOf resolves to a null package element.
Date: Tue, 26 Nov 2013 16:56:33 -0800
Message-Id: <20131127005641.245533647@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Moore <robert.moore@intel.com>

commit a50abf4842dd7d603a2ad6dcc7f1467fd2a66f03 upstream.

Disallow the dereference of a reference (via index) to an uninitialized
package element. Provides compatibility with other ACPI
implementations. ACPICA BZ 1003.

References: https://bugs.acpica.org/show_bug.cgi?id=431
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/exoparg1.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/acpi/acpica/exoparg1.c
+++ b/drivers/acpi/acpica/exoparg1.c
@@ -963,10 +963,17 @@ acpi_status acpi_ex_opcode_1A_0T_1R(stru
 					 */
 					return_desc =
 					    *(operand[0]->reference.where);
-					if (return_desc) {
-						acpi_ut_add_reference
-						    (return_desc);
+					if (!return_desc) {
+						/*
+						 * Element is NULL, do not allow the dereference.
+						 * This provides compatibility with other ACPI
+						 * implementations.
+						 */
+						return_ACPI_STATUS
+						    (AE_AML_UNINITIALIZED_ELEMENT);
 					}
+
+					acpi_ut_add_reference(return_desc);
 					break;
 
 				default:


