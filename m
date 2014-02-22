Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbaBVPUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 10:20:46 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:34075 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750764AbaBVPUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 10:20:45 -0500
Message-ID: <5308C04B.3050205@hurleysoftware.com>
Date: Sat, 22 Feb 2014 10:20:43 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
CC: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 5/9] usb: don't use PREPARE_DELAYED_WORK
References: <Pine.LNX.4.44L0.1402221002440.24585-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1402221002440.24585-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 10:14 AM, Alan Stern wrote:
> On Sat, 22 Feb 2014, Tejun Heo wrote:
>
>> Hello,
>>
>> If this is actually safe, let's do it from the get-go.
>>
>> Thanks!
>> ------- 8< -------
>> PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
>> and a nasty surprise in terms of reentrancy guarantee as workqueue
>> considers work items to be different if they don't have the same work
>> function.
>>
>> usb_hub->init_work is multiplexed with multiple work functions;
>> however, the work item is never queued while in-flight, so we can
>> simply use INIT_DELAYED_WORK() before each queueing.
>>
>> It would probably be best to route this with other related updates
>> through the workqueue tree.
>>
>> Lightly tested.
>>
>> v2: Greg and Alan confirm that the work item is never queued while
>>      in-flight.  Simply use INIT_DELAYED_WORK().
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: linux-usb@vger.kernel.org
>> ---
>>   drivers/usb/core/hub.c |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- a/drivers/usb/core/hub.c
>> +++ b/drivers/usb/core/hub.c
>> @@ -1040,7 +1040,7 @@ static void hub_activate(struct usb_hub
>>   		 */
>>   		if (type == HUB_INIT) {
>>   			delay = hub_power_on(hub, false);
>> -			PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func2);
>> +			INIT_DELAYED_WORK(&hub->init_work, hub_init_func2);
>>   			schedule_delayed_work(&hub->init_work,
>>   					msecs_to_jiffies(delay));
>>
>> @@ -1194,7 +1194,7 @@ static void hub_activate(struct usb_hub
>>
>>   		/* Don't do a long sleep inside a workqueue routine */
>>   		if (type == HUB_INIT2) {
>> -			PREPARE_DELAYED_WORK(&hub->init_work, hub_init_func3);
>> +			INIT_DELAYED_WORK(&hub->init_work, hub_init_func3);
>>   			schedule_delayed_work(&hub->init_work,
>>   					msecs_to_jiffies(delay));
>>   			return;		/* Continues at init3: below */
>>
>
> This should work okay.  But while you're making these changes, you
> should remove the INIT_DELAYED_WORK(&hub->init_work, NULL) call in
> hub_probe().  It is now unnecessary.
>
> Is the cancel_delayed_work_sync(&hub->init_work) call in hub_quiesce()
> going to get confused by all this?
>
> It's worth mentioning that the only reason for the hub_init_func3 stuff
> is, as the comment says, to avoid a long sleep (100 ms) inside a work
> routine.

If a running hub init does not need to be single-threaded wrt
a different running hub init, then a single init work could be queued to
the system_unbound_wq which doesn't care about running times.

>  With all the changes to the work queue infrastructure, maybe
> this doesn't matter so much any more.  If we got rid of it then there
> wouldn't be any multiplexing, and this whole issue would become moot.


