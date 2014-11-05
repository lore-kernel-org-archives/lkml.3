Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaKESTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:19:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50814 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaKESTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:19:04 -0500
Message-ID: <545A6A0A.70806@canonical.com>
Date: Wed, 05 Nov 2014 13:18:50 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Pratyush Anand <pratyush.anand@st.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "pmladek@suse.cz" <pmladek@suse.cz>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "peter.chen@freescale.com" <peter.chen@freescale.com>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Regression][v3.17][v3.18]   USB: Fix persist resume of some
 SS USB devices
References: <54595116.1050802@canonical.com> <20141105052335.GB2517@pratyush-vbox> <20141105084832.GC2517@pratyush-vbox>
In-Reply-To: <20141105084832.GC2517@pratyush-vbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 03:48 AM, Pratyush Anand wrote:
> On Wed, Nov 05, 2014 at 10:53:35AM +0530, Pratyush Anand wrote:
>> Hello Joe,
>>
>> On Wed, Nov 05, 2014 at 06:20:06AM +0800, Joseph Salisbury wrote:
>>> Hello Pratyush,
>>>
>>> A kernel bug report was opened against Ubuntu [0].  After a kernel
>>> bisect, it was found that reverting the following commit resolved this bug:
>>>
>>> commit a40178b2fa6ad87670fb1e5fa4024db00c149629
>>> Author: Pratyush Anand <pratyush.anand@st.com>
>>> Date:   Fri Jul 18 12:37:10 2014 +0530
>>>
>>>     USB: Fix persist resume of some SS USB devices
>>>
>>> The regression was introduced as of v3.17-rc1.  The regression still
>>> exists in the 3.18-rc3 mainline kernel, and has made it's way into the
>>> stable kernels.
>> Its strange, as per my understanding patch does not introduce any side
>> effect for devices whose resume time is normal. So, if a device is
>> connected to the SS port and it was working after resume from
>> suspend to ram without this patch, then that device should still work
>> with this patch.
>>
>> Infact this has resolved another bug reported to bugzilla
>> https://bugzilla.kernel.org/show_bug.cgi?id=53211
>>
>>
>>> I was hoping to get your feedback, since you are the patch author.  Do
>>> you think gathering any additional data will help diagnose this issue,
>> Yaa, sure additional info will help to understand the issue.
>> -- dmesg log of suspend resume when this patch is not applied and also
>> when applied.
> I see that you have already provided both log to the buglink. I had a
> look on that. 
>
>
> When it fails (with this patch):
> Oct 22 15:38:59 mana kernel: [   59.825122] PM: resume of devices
> complete after 22223.878 msecs
>
> When it passed (without this patch):
> Oct 22 15:37:19 mana kernel: [   53.495109] PM: resume of devices
> complete after 3641.933 msecs
> However, even when patch was not present(and it passed), there is a logical
> disconnection of devices, so you would face the issue mentioned in
> https://bugzilla.kernel.org/show_bug.cgi?id=53211.
>
> Looking to the timeout, it seems that wait loop went for full length
> (2S) for all the devices, still could not find a connected device. So,
> basically SS link between root hub and hub was not up in 2 sec. Not
> sure why, but reading further hub port status caused some fatal issue
> with xhci host and so it is not able to get new device connection
> after logical disconnection.
>
> Increasing the timeout value may help. But with this long timeout I see a
> possibility of sync issue between port_event and usb_port_resume. It
> might happen that port_event reads hub port status before
> usb_port_resume handles reset_resume.
>
> Can you try following patch with step increasing varied value of
> PORT_ENABLE_WAIT, and then let me know which value of
> PORT_ENABLE_WAIT works for you (if it works ;)).
>
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 11e80ac31324..6eaf481d3d53 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -3311,13 +3311,14 @@ static int finish_port_resume(struct usb_device *udev)
>   * This routine should only be called when persist is enabled for a SS
>   * device.
>   */
> +#define PORT_ENABLE_WAIT	2000
>  static int wait_for_ss_port_enable(struct usb_device *udev,
>  		struct usb_hub *hub, int *port1,
>  		u16 *portchange, u16 *portstatus)
>  {
>  	int status = 0, delay_ms = 0;
>  
> -	while (delay_ms < 2000) {
> +	while (delay_ms < PORT_ENABLE_WAIT) {
>  		if (status || *portstatus & USB_PORT_STAT_CONNECTION)
>  			break;
>  		msleep(20);
> @@ -4881,6 +4882,22 @@ static void hub_port_connect_change(struct usb_hub *hub, int port1,
>  	usb_lock_port(port_dev);
>  }
>  
> +static void wait_for_reset_resume(struct usb_hub *hub, int port)
> +{
> +	struct usb_device *udev;
> +	int delay_ms = 0;
> +
> +	udev = hub->ports[port -1]->child;
> +	if (udev && udev->reset_resume) {
> +		while (delay_ms < PORT_ENABLE_WAIT) {
> +			if (!udev->reset_resume)
> +				break;
> +			msleep(20);
> +			delay_ms += 20;
> +		}
> +	}
> +}
> +
>  static void port_event(struct usb_hub *hub, int port1)
>  		__must_hold(&port_dev->status_lock)
>  {
> @@ -4894,6 +4911,8 @@ static void port_event(struct usb_hub *hub, int port1)
>  	clear_bit(port1, hub->event_bits);
>  	clear_bit(port1, hub->wakeup_bits);
>  
> +	wait_for_reset_resume(hub, port1);
> +
>  	if (hub_port_status(hub, port1, &portstatus, &portchange) < 0)
>  		return;
>  
> Regards
> Pratyush

Thanks for the feedback, Pratyush.  We'll test your patch and get back
to you.


>
>> -- dmesg log with following additional debug print.
>> @@ -3318,6 +3318,7 @@ static int wait_for_ss_port_enable(struct usb_device *udev,
>>         int status = 0, delay_ms = 0;
>>          
>>         while (delay_ms < 2000) {
>> +               printk("%s:portstatus is %x and portchange is %x\n", __func__, *portstatus, *portchange);
>>                if (status || *portstatus & USB_PORT_STAT_CONNECTION)
>>                         break;
>>
>>> or would it be best to submit a revert request?
>> Let me see what is the portstatus value and why didn't it break loop in first
>> iteration if device was OK.
>>
>> Regards
>> Pratyush
>>
>>>    
>>>
>>> Thanks,
>>>    
>>> Joe
>>>
>>> [0] http://pad.lv/1384041

