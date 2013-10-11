Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab3JKLHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:07:31 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49853 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757995Ab3JKLH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:07:26 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: tianyu.lan@intel.com
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Power: Check physical device's runtime pm status before requesting to resume it
Date: Fri, 11 Oct 2013 13:19:11 +0200
Message-ID: <1761658.DWcBvZSdOl@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1381479385-1614-1-git-send-email-tianyu.lan@intel.com>
References: <1381479385-1614-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 11, 2013 04:16:25 PM tianyu.lan@intel.com wrote:
> From: Lan Tianyu <tianyu.lan@intel.com>
> 
> Currently, when one power resource is turned on, devices owning it
> will be requested to resume regardless of their runtime pm status.
> ACPI power resource maybe turn on in some devices' runtime pm
> resume callback(E.G, usb port) while turning on the power resource
> will trigger one new resume request of the device. It causes
> infinite loop between resume and suspend. This has happened on
> clearing usb port's PM Qos NO_POWER_OFF flag twice. This patch is
> to add check of physical device's runtime pm status and request resume
> if the device is suspended.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/acpi/power.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 0dbe5cd..228c138 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -250,8 +250,10 @@ static void acpi_power_resume_dependent(struct work_struct *work)
>  
>  	mutex_lock(&adev->physical_node_lock);
>  
> -	list_for_each_entry(pn, &adev->physical_node_list, node)
> -		pm_request_resume(pn->dev);
> +	list_for_each_entry(pn, &adev->physical_node_list, node) {
> +		if (pm_runtime_suspended(pn->dev))
> +			pm_request_resume(pn->dev);
> +	}

This is racy, because the status may change right after you check it and before
you call pm_request_resume().

Besides, pm_request_resume() checks the status of the device and won't
try to resume it if it is not suspended.

>  
>  	list_for_each_entry(pn, &adev->power_dependent, node)
>  		pm_request_resume(pn->dev);

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
