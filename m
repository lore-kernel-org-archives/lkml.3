Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbaDJWvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:51:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:37006 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbaDJWvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:51:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,837,1389772800"; 
   d="scan'208";a="511188647"
Message-ID: <5347206E.5050701@intel.com>
Date: Fri, 11 Apr 2014 06:51:26 +0800
From: Xiao Jin <jin.xiao@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: jhovold@gmail.com, gnomes@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
References: <53436770.9090008@intel.com> <53455FC6.7080009@intel.com> <1397116923.4802.10.camel@linux-fkkt.site>
In-Reply-To: <1397116923.4802.10.camel@linux-fkkt.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Oliver,

On 04/10/2014 04:02 PM, Oliver Neukum wrote:
> On Wed, 2014-04-09 at 22:57 +0800, Xiao Jin wrote:
>> Thanks all for the review. We meet with the problems when developing
>> product. I would like to explain my understanding.
>>
>> On 04/08/2014 11:05 AM, Xiao Jin wrote:
>>>
>>> We find two problems on acm tty write delayed mechanism.
>>> (1) When acm resume, the delayed wb will be started. But now
>>> only one write can be saved during acm suspend. More acm write
>>> may be abandoned.
>>
>> The scenario usually happened when user space write series AT after acm
>> suspend. If acm accept the first AT, what's the reason for acm to refuse
>> the second AT? If write return 0, user space will try repeatedly until
>> resume. It looks simpler that acm accept all the data and sent out urb
>> when resume.
>
> No. We cannot accept an arbitrary amount of data. It would let any
> user OOM the system. There will have to be an arbitrary limit.
> The simplest limit is 1 urb. And that is because we said that we
> are ready to accept data.
>

We apply cdc-acm for modem AT data. I can find other usb modem driver 
usb_wwan_write use list to accept more data when suspend, maybe usbnet 
is the same. Do you have any more reason for me to understand why 
cdc-acm accept only one?

>>> (2) acm tty port ASYNCB_INITIALIZED flag will be cleared when
>>> close. If acm resume callback run after ASYNCB_INITIALIZED flag
>>> cleared, there will have no chance for delayed write to start.
>>> That lead to acm_wb.use can't be cleared. If user space open
>>> acm tty again and try to setd, tty will be blocked in
>>> tty_wait_until_sent for ever.
>>>
>>
>> We see tty write and close concurrently after acm suspend in this case.
>> It looks no method to avoid it from tty layer. acm_tty_write and
>
> There is a delay user space can set.
>
>> acm_resume call after acm_port_shutdown. It looks any action in
>> acm_port_shutdown can't solve the problem. As acm has accepted the user
>> space data, we can only find a way to send out urb. I feel anyway to
>> discard the data looks like a lie to user space.
>>
>> In my understanding acm should accept data as much as possible, and send
>> out urb as soon as possible. What do you think of?
>
> There's certainly no problem with sending out the data. Yet
> simply resuming the device in shutdown() should do the job.
>

We see tty write and close concurrently, we have debug log to show that 
acm_tty_write and acm_resume is called after acm_port_shutdown, I don't 
understand "resuming the device in shutdown() should do the job".

> 	Regards
> 		Oliver
>
>

My understanding may be superficial, please correct me if anything 
wrong. Thanks.

Br, Jin
