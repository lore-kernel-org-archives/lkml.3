Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaLPQRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:17:49 -0500
Received: from mga03.intel.com ([134.134.136.65]:2905 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaLPQRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:17:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,587,1413270000"; 
   d="scan'208";a="624666145"
From: Octavian Purdila <octavian.purdila@intel.com>
To: linus.walleij@linaro.org, lee.jones@linaro.org, rjw@rjwysocki.net
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, heikki.krogerus@intel.com,
        mika.westerberg@linux.intel.com, linux-acpi@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH 2/4] ACPICA: don't release ACPI_MTX_TABLES in acpi_tb_install_standard_table
Date: Tue, 16 Dec 2014 18:12:31 +0200
Message-Id: <1418746353-3481-3-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418746353-3481-1-git-send-email-octavian.purdila@intel.com>
References: <1418746353-3481-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI_MTX_TABLES is taken and released by the callers of
acpi_tb_install_standard_table so releasing it in the function itself
is causing the following error if the table is reloaded:

ACPI Error: Mutex [0x2] is not acquired, cannot release (20141107/utmutex-321)
Call Trace:
  [<ffffffff81b0bd48>] dump_stack+0x4f/0x7b
  [<ffffffff81546bf5>] acpi_ut_release_mutex+0x47/0x67
  [<ffffffff81544357>] acpi_load_table+0x73/0xcb

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/acpi/acpica/tbinstal.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c
index 755b90c..c0b39f3 100644
--- a/drivers/acpi/acpica/tbinstal.c
+++ b/drivers/acpi/acpica/tbinstal.c
@@ -346,7 +346,6 @@ acpi_tb_install_standard_table(acpi_physical_address address,
 				 */
 				acpi_tb_uninstall_table(&new_table_desc);
 				*table_index = i;
-				(void)acpi_ut_release_mutex(ACPI_MTX_TABLES);
 				return_ACPI_STATUS(AE_OK);
 			}
 		}
-- 
1.9.1

