Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab3CYPlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:41:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:30765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758422Ab3CYPlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:41:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,905,1355126400"; 
   d="scan'208";a="284269603"
Message-ID: <51507136.4020308@linux.intel.com>
Date: Mon, 25 Mar 2013 08:45:58 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: daniel.leung@linux.intel.com
CC: jkosina@suse.cz, srinivas.pandruvada@intel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-sensor-hub: do not process feature reports in
 raw_event
References: <1363886546-6517-1-git-send-email-daniel.leung@linux.intel.com>
In-Reply-To: <1363886546-6517-1-git-send-email-daniel.leung@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

I am looking at 3.9.rc1.
The only place I see the raw_event callback is called from 
hid/hid_input_report(). hid_input_report is called with type 
HID_INPUT_REPORT in all cases, except hid_ctrl(), where it can be 
different depending on xx.report->type. But here, the return value is 
not checked.

Do you know the call chain for HID_FETURE_REPORT, where this is creating 
problem?

Thanks,
Srinivas

On 03/21/2013 10:22 AM, daniel.leung@linux.intel.com wrote:
> From: Daniel Leung <daniel.leung@linux.intel.com>
>
> In sensor_hub_raw_event(), HID feature reports are ignored but are
> still marked as processed. This causes the in-kernel struct not to be
> updated. Any non-updated fields in the feature reports are zero, and
> they are being sent to the device. This causes confusion in the
> sensor hub firmware, and some sensors are not powered up as a result.
>
> This changes the raw_event rountine to only process input reports,
> and let the hid core handle the incoming feature reports.
>
> The issue has been observed on Acer Iconia W700.
>
> Signed-off-by: Daniel Leung <daniel.leung@linux.intel.com>
> ---
>   drivers/hid/hid-sensor-hub.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
> index ca749810..3f7df68 100644
> --- a/drivers/hid/hid-sensor-hub.c
> +++ b/drivers/hid/hid-sensor-hub.c
> @@ -413,7 +413,7 @@ static int sensor_hub_raw_event(struct hid_device *hdev,
>   			 report->id, size, report->type);
>   	hid_dbg(hdev, "maxfield:%d\n", report->maxfield);
>   	if (report->type != HID_INPUT_REPORT)
> -		return 1;
> +		return 0;
>   
>   	ptr = raw_data;
>   	ptr++; /*Skip report id*/

