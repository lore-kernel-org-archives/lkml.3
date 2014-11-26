Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaKZQHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:07:21 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:58638 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaKZQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:07:20 -0500
Message-ID: <5475FAB1.1000802@de.ibm.com>
Date: Wed, 26 Nov 2014 17:07:13 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com> <20141126070258.GA25523@redhat.com> <20141126110504.511b733a@thinkpad-w530> <20141126151729.GB9612@redhat.com> <20141126152334.GA9648@redhat.com> <20141126163207.63810fcb@thinkpad-w530> <20141126154717.GB10568@redhat.com>
In-Reply-To: <20141126154717.GB10568@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112616-0017-0000-0000-000001FD5559
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.11.2014 um 16:47 schrieb Michael S. Tsirkin:
> On Wed, Nov 26, 2014 at 04:32:07PM +0100, David Hildenbrand wrote:
>>> On Wed, Nov 26, 2014 at 05:17:29PM +0200, Michael S. Tsirkin wrote:
>>>> On Wed, Nov 26, 2014 at 11:05:04AM +0100, David Hildenbrand wrote:
>>>>>> What's the path you are trying to debug?
>>>>>
>>>>> Well, we had a problem where we held a spin_lock and called
>>>>> copy_(from|to)_user(). We experienced very random deadlocks that took some guy
>>>>> almost a week to debug. The simple might_sleep() check would have showed this
>>>>> error immediately.
>>>>
>>>> This must have been a very old kernel.
>>>> A modern kernel will return an error from copy_to_user.
>>>> Which is really the point of the patch you are trying to revert.
>>>
>>> That's assuming you disabled preemption. If you didn't, and take
>>> a spinlock, you have deadlocks even without userspace access.
>>>
>>
>> (Thanks for your resent, my first email was sent directly to you ... grml)
>>
>> This is what happened on our side (very recent kernel):
>>
>> spin_lock(&lock)
>> copy_to_user(...)
>> spin_unlock(&lock)
> 
> That's a deadlock even without copy_to_user - it's
> enough for the thread to be preempted and another one
> to try taking the lock.

Huh? With CONFIG_PREEMPT spin_lock will disable preemption. (we had preempt = server anyway).

But please: One step back. The problem is not the good path. The problem is that we lost a debugging aid for a known to be broken case. In other words: Our code had a bug. Older kernels detected that kind of bug. With your change we no longer saw the sleeping while atomic. Thats it. See my other mail.

Christian

