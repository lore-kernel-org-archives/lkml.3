Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893Ab3JOUzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:55:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52079 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759563Ab3JOUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:55:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Power: Release resource_lock after acpi_power_get_state() return error
Date: Tue, 15 Oct 2013 23:06:58 +0200
Message-ID: <2169851.4V0lKD9xHQ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1381837691-3657-1-git-send-email-tianyu.lan@intel.com>
References: <1381837691-3657-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 15, 2013 07:48:11 PM Lan Tianyu wrote:
> resource_lock should be released when acpi_power_get_state() fails and before
> passing to next power resource on the acpi power resource list.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Yup, good catch!

I'll queue this up as a fix for 3.12.

Thanks!

> ---
>  drivers/acpi/power.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 0dbe5cd..0c1c3ec 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -936,8 +936,10 @@ void acpi_resume_power_resources(void)
>  		mutex_lock(&resource->resource_lock);
>  
>  		result = acpi_power_get_state(resource->device.handle, &state);
> -		if (result)
> +		if (result) {
> +			mutex_unlock(&resource->resource_lock);
>  			continue;
> +		}
>  
>  		if (state == ACPI_POWER_RESOURCE_STATE_OFF
>  		    && resource->ref_count) {
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
