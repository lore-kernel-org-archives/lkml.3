Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaAXQVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:21:11 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53471 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaAXQVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:21:08 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        devel@acpica.org, patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 2/2] ACPI / ACPICA: Fix potential memory leak in acpi_evaluate_object()
Date: Sat, 25 Jan 2014 00:20:07 +0800
Message-Id: <1390580407-14525-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390580407-14525-1-git-send-email-hanjun.guo@linaro.org>
References: <1390580407-14525-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential memory leak when acpi_ut_copy_iobject_to_eobject()
failed, because return_buffer was allocated in acpi_ut_initialize_buffer()
when buffer type is ACPI_ALLOCATE_BUFFER or ACPI_ALLOCATE_LOCAL_BUFFER,
and will not be freed outside when the return value is not AE_OK for
acpi_evaluate_object(), fix it.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/acpi/acpica/nsxfeval.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/acpica/nsxfeval.c b/drivers/acpi/acpica/nsxfeval.c
index a1b0b88..8ad792b 100644
--- a/drivers/acpi/acpica/nsxfeval.c
+++ b/drivers/acpi/acpica/nsxfeval.c
@@ -424,6 +424,11 @@ acpi_evaluate_object(acpi_handle handle,
 
 			status = acpi_ut_copy_iobject_to_eobject(
 					info->return_object, return_buffer);
+			if (ACPI_FAILURE(status) &&
+				(buffer_space_needed == ACPI_ALLOCATE_BUFFER ||
+				buffer_space_needed == ACPI_ALLOCATE_LOCAL_BUFFER)) {
+				ACPI_FREE(return_buffer);
+			}
 		}
 	}
 
-- 
1.7.9.5

