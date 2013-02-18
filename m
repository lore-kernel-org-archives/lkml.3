Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab3BRDUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 22:20:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12366 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3BRDUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 22:20:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 17 Feb 2013 19:16:09 -0800
Message-ID: <51219DFA.6070902@nvidia.com>
Date: Mon, 18 Feb 2013 12:20:26 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: USB list <linux-usb@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: usb_wwan_write() called while device still being resumed
References: <511CBCE8.9070204@nvidia.com> <87ehgivlmg.fsf@nemi.mork.no> <511DF09F.3070401@nvidia.com> <87r4khu9az.fsf@nemi.mork.no>
In-Reply-To: <87r4khu9az.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 08:05 PM, Bjørn Mork wrote:
> Maybe something like the completely untested:
>
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 3148b10..38e19ba 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -512,6 +512,9 @@ static int rpm_resume(struct device *dev, int rpmflags)
>   	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
>   	    && dev->power.runtime_status == RPM_ACTIVE)
>   		retval = 1;
> +	else if (rpmflags & RPM_ASYNC && dev->power.request_pending &&
> +		 dev->power.request == RPM_REQ_RESUME)
> +		retval = -EINPROGRESS;
>   	else if (dev->power.disable_depth > 0)
>   		retval = -EACCES;
>   	if (retval)

Second thought: not sure this will work since power.request_pending and 
power.request are set to these values later in the same rpm_resume() 
function. However, the three lines before yours caught my attention. 
They are not in my 3.1 source tree and the conditions are very close 
from the ones I am seeing when the issue happens: disable_depth == 1, 
is_suspended == 1. Only runtime_status is not equal to RPM_ACTIVE.

Nonetheless, I have looked at the patch that introduced these 
(http://pastebin.com/PmHUjiAE ) and it details a problem that is very 
similar to mine. It also mentions a workaround to be implemented in the 
driver by saving the suspend status into a variable that is checked when 
pm_runtime_get() return -EACCES. This variable already exists in 
usb_wwan, actually it is the very variable that is checked a bit later 
in that other chunk of code you mentioned:

spin_lock_irqsave(&intfdata->susp_lock, flags);
if (intfdata->suspended) {
	usb_anchor_urb(this_urb, &portdata->delayed);
	spin_unlock_irqrestore(&intfdata->susp_lock, flags);
} else {

So it looks like this code is here for exactly that purpose. However in 
my current condition I do not see how this block could be run since 
runtime PM is disabled when intfdata->suspended is set to true.

I will try implementing the workaround suggested (checking if 
intfdata->suspended is set when -EACCES is returned and go on if it is 
the case) and see if it works (and I bet it will). In the upstream 
kernel the issue seems to have been addressed already, so this might 
just be a source-out-of-date issue.

Thanks,
Alex.

