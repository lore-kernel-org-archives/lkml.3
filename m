Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbaHUOUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:20:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:47123 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042AbaHUOUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:20:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="375293432"
Date: Thu, 21 Aug 2014 08:19:52 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: Keith Busch <keith.busch@intel.com>, willy@linux.intel.com,
        sbradshaw@micron.com, axboe@fb.com, tom.leiming@gmail.com,
        hch@infradead.org, rlnelson@google.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v12] NVMe: Convert to blk-mq
In-Reply-To: <53F5E0F1.20808@bjorling.me>
Message-ID: <alpine.LRH.2.03.1408210752180.4696@AMR>
References: <1408126604-10611-1-git-send-email-m@bjorling.me> <1408126604-10611-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1408181643280.4696@AMR> <53F5E0F1.20808@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1181568359-1408630793=:4696"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1181568359-1408630793=:4696
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 21 Aug 2014, Matias Bjørling wrote:
> On 08/19/2014 12:49 AM, Keith Busch wrote:
>> I see the driver's queue suspend logic is removed, but I didn't mean to
>> imply it was safe to do so without replacing it with something else. I
>> thought maybe we could use the blk_stop/start_queue() functions if I'm
>> correctly understanding what they're for.
>
> They're usually only used for the previous request model.
>
> Please correct me if I'm wrong. The flow of suspend is as following 
> (roughly):
>
> 1. Freeze user threads
> 2. Perform sys_sync
> 3. Freeze freezable kernel threads
> 4. Freeze devices
> 5. ...
>
> On nvme suspend, we process all outstanding request and cancels any 
> outstanding IOs, before going suspending.
>
> From what I found, is it still possible for IOs to be submitted and lost in 
> the process?

For suspend/resume, I think we're okay. There are three other ways the
drive can be reset where we'd want to quiesce IO:

  I/O timeout
  Controller Failure Status (CSTS.CFS) set
  User initiated reset via sysfs

>>   * After a reset, we are not guaranteed that we even have the same number
>>   of h/w queues. The driver frees ones beyond the device's capabilities,
>>   so blk-mq may have references to freed memory. The driver may also
>>   allocate more queues if it is capable, but blk-mq won't be able to take
>>   advantage of that.
>
> Ok. Out of curiosity, why can the number of exposed nvme queues change from 
> the hw perspective on suspend/resume?

The only time you might expect something like that is if a f/w upgrade
occured prior to the device reset and it supports different queues. The
number of queues supported could be more or less than previous. I wouldn't
normally expect different f/w to support different queue count, but it's
certainly allowed.

Otherwise the spec allows the controller to return errors even though
the queue count feature was succesful. This could be for a variety of
reasons from resource limits or other internal device errors.
--8323328-1181568359-1408630793=:4696--
