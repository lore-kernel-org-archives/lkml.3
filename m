Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab3HAAtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:49:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:52972 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab3HAAs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:48:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,791,1367996400"; 
   d="scan'208";a="379222353"
Message-ID: <51F9B0A9.8000207@intel.com>
Date: Thu, 01 Aug 2013 08:49:45 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH updated] ACPI / PM: Add state information in error message
 for acpi_device_set_power
References: <10433383.dueoNg39qi@vostro.rjw.lan> <4285597.UpTJrMA8Fu@vostro.rjw.lan> <51F8B445.1070000@intel.com> <1858303.iaJrUSpF87@vostro.rjw.lan>
In-Reply-To: <1858303.iaJrUSpF87@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 06:27 PM, Rafael J. Wysocki wrote:
>> Patch to add state information in error message, apply on top of this
>> > one.
>> > 
>> > From: Aaron Lu <aaron.lu@intel.com>
>> > Subject: [PATCH] ACPI / PM: Add state information in error message for
>> >  acpi_device_set_power
>> > 
>> > The state information can be useful to know what the problem is when it
>> > appeared in an error message about a device can not being set to a higher
>> > power state than its parent, so this patch adds such state information
>> > for both the target state of the device failed to be set and the current
>> > parent's state.
>> > 
>> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> > ---
>> >  drivers/acpi/device_pm.c | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> > 
>> > diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
>> > index beb9625..707258b 100644
>> > --- a/drivers/acpi/device_pm.c
>> > +++ b/drivers/acpi/device_pm.c
>> > @@ -179,7 +179,8 @@ int acpi_device_set_power(struct acpi_device *device, int state)
>> >  	}
>> >  	if (device->parent && (state < device->parent->power.state)) {
>> >  		dev_warn(&device->dev,
>> > -			 "Cannot transition to a higher-powered state than parent\n");
>> > +			 "Cannot transition to a higher-powered state %d than parent's state %d\n",
> This message will look a little odd I think ->
> 
>> > +			 state, device->parent->power.state);
> -> and please don't use raw numbers in such messages.
> 
> What about
> 
> 	"Cannot transition to power state %s for parent in %s\n",
> 	acpi_power_state_string(state),
> 	acpi_power_state_string(device->parent->power.state)


Thanks for the suggestion, updated patch here:

From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH] ACPI / PM: Add state information in error message for
 acpi_device_set_power

The state information can be useful to know what the problem is when an
error message about a device can not being set to a higher power state
than its parent appeared, so this patch adds such state information
for both the target state of the device and the current state of its
parent.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/device_pm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index beb9625..59d3202 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -179,7 +179,9 @@ int acpi_device_set_power(struct acpi_device *device, int state)
 	}
 	if (device->parent && (state < device->parent->power.state)) {
 		dev_warn(&device->dev,
-			 "Cannot transition to a higher-powered state than parent\n");
+			 "Cannot transition to power state %s for parent in %s\n",
+			 acpi_power_state_string(state),
+			 acpi_power_state_string(device->parent->power.state));
 		return -ENODEV;
 	}
 
-- 
1.8.3.2.10.g43d11f4
