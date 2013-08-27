Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3H0Fvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 01:51:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:19478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab3H0Fvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 01:51:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,966,1367996400"; 
   d="scan'208";a="393900418"
Message-ID: <521C3E89.3090905@intel.com>
Date: Tue, 27 Aug 2013 13:52:09 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the libata tree
References: <20130827125049.62d12bba371fe8d9df85a227@canb.auug.org.au>
In-Reply-To: <20130827125049.62d12bba371fe8d9df85a227@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 10:50 AM, Stephen Rothwell wrote:
> Hi Tejun,
> 
> After merging the libata tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from drivers/ata/libata-pmp.c:14:0:
> drivers/ata/libata.h:136:1: error: unknown type name 'acpi_handle'
>  static inline acpi_handle ata_dev_acpi_handle(struct ata_device *dev) { return NULL; }
>  ^
> 
> And several others.
> 
> Caused by commit f1bc1e4c44b1 ("ata: acpi: rework the ata acpi bind
> support").  All the world does not have the ACPI include files
> included via some other path ... nor wants them, I suspect.

Sorry for the trouble, my bad.
Does the below patch fix the problem?

From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH] ata: acpi: Remove ata_dev_acpi_handle stub in libata.h

The ata_dev_acpi_handle is defined in libata-acpi.c and the only
external user is libata-zpodd.c, which is built when CONFIG_ATA_ACPI
is set, so there is no need to make an empty stub function for
!CONFIG_ATA_ACPI case in libata.h. It also causes compile errors due to
acpi_handle is not defined when !CONFIG_ACPI. This patch fixes this
problem by removing the empty stub.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 3e9cc95..eeeb778 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -133,7 +133,6 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
 				      pm_message_t state) { }
 static inline void ata_acpi_bind_port(struct ata_port *ap) {}
 static inline void ata_acpi_bind_dev(struct ata_device *dev) {}
-static inline acpi_handle ata_dev_acpi_handle(struct ata_device *dev) { return NULL; }
 static inline void ata_scsi_acpi_bind(struct ata_device *dev) {}
 static inline void ata_scsi_acpi_unbind(struct ata_device *dev) {}
 #endif
-- 
1.8.3.2.10.g43d11f4

Thanks,
Aaron

> 
> I have used the libata tree from next-20130822 for today.
> 
> P.S. drivers/ata/libata.h seems to assume that a lot of other stuff is
> included that it does not include explicitly ...
> 

