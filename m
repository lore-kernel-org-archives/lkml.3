Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039Ab3JPWlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:41:12 -0400
Received: from smtp.infotech.no ([82.134.31.41]:56550 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761959Ab3JPWlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:41:09 -0400
Message-ID: <525F1601.8080906@interlog.com>
Date: Wed, 16 Oct 2013 18:41:05 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: vaughan <vaughan.cao@oracle.com>, Madper Xie <cxie@redhat.com>,
        linux-kernel@vger.kernel.org,
        SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [Bug] 12.864681  BUG: lock held when returning to user space!
References: <8761tilrl0.fsf@redhat.com> <874n8s2tjz.fsf@redhat.com>	 <5253A9E7.5030707@oracle.com> <52540C7F.8050207@interlog.com> <1381929897.1864.0.camel@dabdike>
In-Reply-To: <1381929897.1864.0.camel@dabdike>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-10-16 09:24 AM, James Bottomley wrote:
> On Tue, 2013-10-08 at 09:45 -0400, Douglas Gilbert wrote:
>> On 13-10-08 02:44 AM, vaughan wrote:
>>> Hi Madper,
>>>
>>> CC to Douglas to get comments.
>>> I use the rw_semaphore o_sem to protect excl open, introduced in commit
>>> 15b06f9a02406e5460001db6d5af5c738cd3d4e7 since v3.12-rc1.
>>> Is it forbidden to do like that in kernel?...
>>
>> It appears you can not (allow sg_open() to hold a semaphore
>> then return to the user space). So you will need to do some
>> rework on that patch or revert it.
>
> OK, there being no reply on this, I'll do the revert ... that's all four
> patches, correct?

That seems to be the case. Vaughan acknowledged the
problem and forwarded it to me 8 days ago. Yes, it
seems to be a "no-no" to hold a any kernel semaphore
when returning to the user space; in this case from
sg_open(). I was hoping a revised patch might
appear from Vaughan but to date that has not been
the case. So with only a few weeks to go before
lk 3.12 is released, reverting the whole 4 patches
in that series seems to be the safest course.

Also without a new patch from Vaughan in the next few
weeks he may also miss the opportunity of getting
his improved O_EXCL logic into the lk 3.13 series.


Thinking about how to solve this problem: a field could
be added to 'struct sg_device' with one of three states:
no_opens, non_excl_opens and excl_open. It could be
manipulated by sg_open() and sg_release() like a
read-write semaphore. And the faulty 'struct
rw_semaphore o_sem' in sg_device could be replaced by a
normal semaphore to protect the manipulation of the new
three-state field.

Doug Gilbert


