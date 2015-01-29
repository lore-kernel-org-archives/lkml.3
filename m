Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbbA2KJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:09:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbbA2KJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:09:42 -0500
Date: Thu, 29 Jan 2015 10:17:18 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: RE: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and Rescind
 offer
To: Dexuan Cui <decui@microsoft.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Radim =?iso-8859-2?b?S3LobeH4?= <rkrcmar@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Message-Id: <1422526158.14137.2@smtp.corp.redhat.com>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C61EA9510B@SIXPRD3002MB028.064d.mgd.msft.net
	>
References: <1421768706-5363-1-git-send-email-vkuznets@redhat.com>
	<1421768706-5363-4-git-send-email-vkuznets@redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C61EA94FB7@SIXPRD3002MB028.064d.mgd.msft.net>
	<8761br9kfd.fsf@vitty.brq.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C61EA9510B@SIXPRD3002MB028.064d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, Jan 28, 2015 at 8:51 PM, Dexuan Cui <decui@microsoft.com> wrote:
>>  -----Original Message-----
>>  From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>>  Sent: Wednesday, January 28, 2015 20:09 PM
>>  To: Dexuan Cui
>>  Cc: KY Srinivasan; devel@linuxdriverproject.org; Haiyang Zhang; 
>> linux-
>>  kernel@vger.kernel.org; Jason Wang; Radim Krčmář; Dan Carpenter
>>  Subject: Re: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and 
>> Rescind
>>  offer
>>  
>>  Dexuan Cui <decui@microsoft.com> writes:
>>  
>>  >> -----Original Message-----
>>  >> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>>  >> Sent: Tuesday, January 20, 2015 23:45 PM
>>  >> To: KY Srinivasan; devel@linuxdriverproject.org
>>  >> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org; Dexuan Cui; 
>> Jason Wang;
>>  >> Radim Krčmář; Dan Carpenter
>>  >> Subject: [PATCH v3 3/3] Drivers: hv: vmbus: serialize Offer and 
>> Rescind
>>  offer
>>  ...
>>  >
>>  > Hi Vitaly and all,
>>  > I have 2 questions:
>>  > In vmbus_process_offer(),  in the cases of "goto err_free_chan",
>>  > should we consider the possibility a rescind message could be 
>> pending for
>>  > the new channel?
>>  > In the cases,  because we don't run
>>  > "INIT_WORK(&newchannel->work, vmbus_process_rescind_offer); ",
>>  > vmbus_onoffer_rescind() will do nothing and as a result,
>>  > vmbus_process_rescind_offer() won't be invoked.
>>  
>>  Yes, but processing the rescind offer results in freeing the channel
>>  (and this processing supposes the channel wasn't freed before) so
>>  there is no difference... or is it?
>>  
>>  >
>>  > Question 2: in vmbus_process_offer(), in the case
>>  > vmbus_device_register() fails, we'll run
>>  > "list_del(&newchannel->listentry);" -- just after this line,
>>  >  what will happen at this time if relid2channel() returns NULL
>>  > in vmbus_onoffer_rescind()?
>>  >
>>  > I think we'll lose the rescind message.
>>  >
>>  
>>  Yes, but same logic applies - we already freed the channes so no 
>> rescind
>>  proccessing required.
> free_channel() and vmbus_process_rescind_offer() are different, 
> because
>  the latter does more work, e.g., sending the host a message 
> CHANNELMSG_RELID_RELEASED.
> 
> In the cases of "goto err_free_chan" + "a pending rescind message",
> the host may expect the message CHANNELMSG_RELID_RELEASED and
> could reoffer the channel once the message is received.
> 
> It would be better if the VM doesn't lose the rescind message here. 
> :-)

It's interesting that rescind needs a ack from guest. But looks like 
the offer does not need it? Is there a spec for this for us for 
reference?

Thanks
> 
> 
>>   If we still need to do something we need to
>>  add support for already freed channel to the rescind offer 
>> processing path.
>>  
> 
> Thanks,
> -- Dexuan

