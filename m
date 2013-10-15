Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab3JOPMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:12:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:38478 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab3JOPMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:12:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,499,1378882800"; 
   d="scan'208";a="375031023"
Message-ID: <525D5B64.3090206@intel.com>
Date: Tue, 15 Oct 2013 23:12:36 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: lenb@kernel.org, rjw@rjwysocki.net
CC: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] ACPI/POWER: Call acpi_power_resume_dependent()
 directly in the acpi_power_on_unlocked()
References: <1381849493-7977-1-git-send-email-tianyu.lan@intel.com> <1381849493-7977-4-git-send-email-tianyu.lan@intel.com>
In-Reply-To: <1381849493-7977-4-git-send-email-tianyu.lan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 11:04 PM, Lan Tianyu wrote:
> acpi_power_resume_dependent() purposes to resume power resource's dependent
> physical devices after turning on the related power resource. But current
> it runs in the workqueue, pm_request_resume() can't check the right
> runtime pm state just after turning on power resource. This will cause
> infinite loop between resume and suspend in some cases that turn on power
> resource in the pm runtime resume callback(e,g usb port). This patch is to
> fix the issue via calling acpi_power_resume_dependent() directly instead
> of running it in a workqueue.
>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>   drivers/acpi/power.c | 15 ++-------------
>   1 file changed, 2 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 3fc2873..5e4991b 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -62,7 +62,6 @@ ACPI_MODULE_NAME("power");
>   struct acpi_power_dependent_device {
>   	struct list_head node;
>   	struct acpi_device *adev;
> -	struct work_struct work;
>   };
>
>   struct acpi_power_resource {
> @@ -235,14 +234,12 @@ static int acpi_power_get_list_state(struct list_head *list, int *state)
>   	return 0;
>   }
>
> -static void acpi_power_resume_dependent(struct work_struct *work)
> +static void acpi_power_resume_dependent(struct acpi_power_dependent_device *dep)
>   {
> -	struct acpi_power_dependent_device *dep;
>   	struct acpi_device_physical_node *pn;
>   	struct acpi_device *adev;
>   	int state;
>
> -	dep = container_of(work, struct acpi_power_dependent_device, work);
>   	adev = dep->adev;
>   	if (acpi_power_get_inferred_state(adev, &state))
>   		return;
> @@ -294,7 +291,7 @@ static int acpi_power_on_unlocked(struct acpi_power_resource *resource)
>   			struct acpi_power_dependent_device *dep;
>
>   			list_for_each_entry(dep, &resource->dependent, node)
> -				schedule_work(&dep->work);
> +				acpi_power_resume_dependent(dep);
>   		}
>   	}
>   	return result;
> @@ -414,7 +411,6 @@ static void acpi_power_add_dependent(struct acpi_power_resource *resource,
>   		goto out;
>
>   	dep->adev = adev;
> -	INIT_WORK(&dep->work, acpi_power_resume_dependent);
>   	list_add_tail(&dep->node, &resource->dependent);
>
>    out:
> @@ -425,23 +421,16 @@ static void acpi_power_remove_dependent(struct acpi_power_resource *resource,
>   					struct acpi_device *adev)
>   {
>   	struct acpi_power_dependent_device *dep;
> -	struct work_struct *work = NULL;
>
>   	mutex_lock(&resource->resource_lock);
>
>   	list_for_each_entry(dep, &resource->dependent, node)
>   		if (dep->adev == adev) {
>   			list_del(&dep->node);
> -			work = &dep->work;

Sorry, Just find forget to free dep Here. Will update if this patchset 
is acceptable.

>   			break;
>   		}
>
>   	mutex_unlock(&resource->resource_lock);
> -
> -	if (work) {
> -		cancel_work_sync(work);
> -		kfree(dep);
> -	}
>   }
>
>   static struct attribute *attrs[] = {
>

