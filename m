Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaDQPyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:54:01 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34833 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaDQPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:53:39 -0400
From: Semen Protsenko <semen.protsenko@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
Cc: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi: respect const qualifier
Date: Thu, 17 Apr 2014 18:53:26 +0300
Message-Id: <1397750006-17463-1-git-send-email-semen.protsenko@linaro.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes next warning:

<------------------------------- cut here --------------------------------->
drivers/acpi/property.c: In function ‘acpi_free_properties’:
drivers/acpi/property.c:35:2: warning: passing argument 1 of ‘acpi_os_free’
                              discards ‘const’ qualifier from pointer
                              target type [enabled by default]

  ACPI_FREE(adev->properties);
<------------------------------- cut here --------------------------------->

The problem is next:

 - acpi_free_properties() calls ACPI_FREE(), passing "const *"
   parameter to it
 - ACPI_FREE() is macro for acpi_os_free()
 - acpi_os_free() takes "void *" parameter
 - acpi_os_free() calls kfree()
 - but kfree() requires "const void *" parameter

So acpi_os_free() should require "const void *" parameter as well.

Signed-off-by: Semen Protsenko <semen.protsenko@linaro.org>
---
 include/acpi/platform/aclinux.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 93c55ed..c6fa763 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -174,7 +174,7 @@ static inline void *acpi_os_allocate_zeroed(acpi_size size)
 #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_allocate_zeroed
 #define USE_NATIVE_ALLOCATE_ZEROED
 
-static inline void acpi_os_free(void *memory)
+static inline void acpi_os_free(const void *memory)
 {
 	kfree(memory);
 }
-- 
1.9.1

