Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbaE2Mm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:42:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54301 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbaE2Mmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:42:54 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Thu, 29 May 2014 13:42:49 +0100
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "amit.kachhap@gmail.com" <amit.kachhap@gmail.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [PATCH v1 6/6] ACPI: thermal: processor: Use the generic cpufreq
 infrastructure
Message-ID: <20140529124248.GC2593@e104805>
References: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
 <1401351334-11210-7-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
In-Reply-To: <1401351334-11210-7-git-send-email-amit.daniel@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 29 May 2014 12:42:49.0110 (UTC) FILETIME=[7F99B360:01CF7B3B]
X-MC-Unique: 114052913425210701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Thu, May 29, 2014 at 09:15:34AM +0100, Amit Daniel Kachhap wrote:
> This patch upgrades the ACPI cpufreq cooling portions to use the generic
> cpufreq cooling infrastructure. There should not be any functionality
> related changes as the same behaviour is provided by the generic
> cpufreq APIs with the notifier mechanism.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/acpi/processor_driver.c  |    6 +-
>  drivers/acpi/processor_thermal.c |  235 ++++++++++++++++++--------------------
>  include/acpi/processor.h         |    3 +-
>  3 files changed, 115 insertions(+), 129 deletions(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index 7f70f31..10aba4a 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -36,6 +36,7 @@
>  #include <linux/cpuidle.h>
>  #include <linux/slab.h>
>  #include <linux/acpi.h>
> +#include <linux/cpu_cooling.h>
> 
>  #include <acpi/processor.h>
> 
> @@ -178,8 +179,7 @@ static int __acpi_processor_start(struct acpi_device *device)
>         if (!cpuidle_get_driver() || cpuidle_get_driver() == &acpi_idle_driver)
>                 acpi_processor_power_init(pr);
> 
> -       pr->cdev = thermal_cooling_device_register("Processor", device,
> -                                                  &processor_cooling_ops);
> +       pr->cdev = acpi_processor_cooling_register(device);

With this you have removed the only cooling device whose type was
"Processor".  There's special code for dealing with this cooling
device in drivers/thermal/thermal_core.c:passive_store():

		list_for_each_entry(cdev, &thermal_cdev_list, node) {
			if (!strncmp("Processor", cdev->type,
				     sizeof("Processor")))
				thermal_zone_bind_cooling_device(tz,
						THERMAL_TRIPS_NONE, cdev,
						THERMAL_NO_LIMIT,
						THERMAL_NO_LIMIT);
		}
		mutex_unlock(&thermal_list_lock);
		if (!tz->passive_delay)

With your change, that code is now "dead" as it can't do anything.  No
I don't know what should you do with it, either remove it or make it
match the cpufreq cooling device.  But this patch should deal with
that code as well.

Cheers,
Javi


