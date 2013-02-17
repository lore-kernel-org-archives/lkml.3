Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3BQL3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 06:29:15 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2704 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3BQL3N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 06:29:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 17 Feb 2013 03:28:34 -0800
Message-ID: <5120BFA8.2000506@nvidia.com>
Date: Sun, 17 Feb 2013 20:31:52 +0900
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
> Alex Courbot <acourbot@nvidia.com> writes:
>
>> Unfortunately it does not, and fails the same way. On the other hand,
>> I do not see the issue when doing the following:
>>
>> diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
>> index e4fad5e..1490029 100644
>> --- a/drivers/usb/serial/usb_wwan.c
>> +++ b/drivers/usb/serial/usb_wwan.c
>> @@ -238,8 +238,6 @@ int usb_wwan_write(struct tty_struct *tty, struct
>> usb_serial_port *port,
>>                      usb_pipeendpoint(this_urb->pipe), i);
>>
>>                  err =
>> usb_autopm_get_interface_async(port->serial->interface);
>> -               if (err < 0)
>> -                       break;
>>
>>                  /* send the data */
>>                  memcpy(this_urb->transfer_buffer, buf, todo);
>>
>> After doing this I don't see this issue anymore. It looks wrong
>> though. But it seems to work despite the obvious unbalance in autopm
>> calls that results.
>>
>> If I understand you correctly, usb_wwan_write() failing here is not a
>> problem in itself, and the ack should just be sent again later?
>
> That was what I thought looking (obviously too) briefly through this.
>
> Most errors from usb_autopm_get_interface_async will be translated to
> EIO before being returned by serial_write.  I believe the userspace
> application should deal with that.  But maybe it just gives up?  Should
> we return EAGAIN or something instead?
>
> I don't know.  I am pretty clueless about these things...

Obviously not as much as I am. :) Checking what userspace is doing could 
indeed be another trail.

> But looking again, trying to guess why it works fine if you just ignore
> the error. I believe that is because you then end up hitting this until
> the interface is fully resumed:
>
> 		if (intfdata->suspended) {
> 			usb_anchor_urb(this_urb, &portdata->delayed);
> 			spin_unlock_irqrestore(&intfdata->susp_lock, flags);
>                  }

Yes, this seems to be exactly what is happening.

> I am way out of my league here, but I wonder if pm_runtime_get()
> shouldn't return -EINPROGRESS instead if there is a queued resume
> request or an ongoing resume, regardless of disable_depth?
>
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
> ---
> usb_autopm_get_interface_async() will interprete EINPROGRESS as success,
> so that would prevent this problem.

That sounds sensefull indeed. If the interface is soon to be resumed, 
there should be no reason for usb_autopm_get_interface_async() to fail. 
Let's give this a try and bring the idea to the PM people if it works.

In any case thanks a lot for the help, it is extremely useful.
Alex.
