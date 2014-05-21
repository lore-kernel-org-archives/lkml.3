Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaEUIXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:23:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:33795 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaEUIXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:23:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,878,1392192000"; 
   d="scan'208";a="535326349"
Message-ID: <537C6262.5030500@intel.com>
Date: Wed, 21 May 2014 16:22:58 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Kui Zhang <kuizhang@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: rmmod thermal, unable to handle kernel NULL pointer dereference
References: <CAKx2Y1mzLesGFYz30fH8xCZTkvNGPUNYkHptYLYq_hVExoh_8g@mail.gmail.com>
In-Reply-To: <CAKx2Y1mzLesGFYz30fH8xCZTkvNGPUNYkHptYLYq_hVExoh_8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 01:57 PM, Kui Zhang wrote:
> Hello,
> 
> I get following error when rmmod thermal.
> 
> rmmod  thermal
> Killed

Thanks for the report. Here is a fix patch that should solve this
problem.

From: Aaron Lu <aaron.lu@intel.com>
Date: Wed, 21 May 2014 16:00:42 +0800
Subject: [PATCH] ACPI / thermal: fix workqueue destroy order

When the thermal module is to be removed, we should destroy the wq
acpi_thermal_pm_queue after the ACPI driver's remove callback is
executed as we will need to flush the workqueue there, or a NULL pointer
access will be hit.

Reported-by: Kui Zhang <kuizhang@gmail.com>
Reference: http://www.spinics.net/lists/kernel/msg1747251.html
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index c1e31a41f949..25bbc55dca89 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1278,8 +1278,8 @@ static int __init acpi_thermal_init(void)
 
 static void __exit acpi_thermal_exit(void)
 {
-	destroy_workqueue(acpi_thermal_pm_queue);
 	acpi_bus_unregister_driver(&acpi_thermal_driver);
+	destroy_workqueue(acpi_thermal_pm_queue);
 
 	return;
 }
-- 
1.9.0

