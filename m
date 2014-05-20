Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaETPNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:13:43 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:40230 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125AbaETPNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:13:42 -0400
Message-ID: <537B7122.3000508@vmware.com>
Date: Tue, 20 May 2014 16:13:38 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        ccross@google.com, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 2/2 with seqcount v3] reservation: add suppport for
 read-only access using rcu
References: <20140409144239.26648.57918.stgit@patser> <20140409144831.26648.79163.stgit@patser> <53465A53.1090500@vmware.com> <53466D63.8080808@canonical.com> <53467B93.3000402@vmware.com> <5346B212.8050202@canonical.com> <5347A9FD.2070706@vmware.com> <5347B4E5.6090901@canonical.com> <5347BFC9.3020503@vmware.com> <53482FF1.1090406@canonical.com> <534843EA.6060602@vmware.com> <534B9165.4000101@canonical.com> <534B921B.4080504@vmware.com> <5357A0DE.7030305@canonical.com> <537A0A5D.6090909@vmware.com> <537A1180.2010109@canonical.com>
In-Reply-To: <537A1180.2010109@canonical.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 03:13 PM, Maarten Lankhorst wrote:
> op 19-05-14 15:42, Thomas Hellstrom schreef:
>> Hi, Maarten!
>>
>> Some nitpicks, and that krealloc within rcu lock still worries me.
>> Otherwise looks good.
>>
>> /Thomas
>>
>>
>>
>> On 04/23/2014 12:15 PM, Maarten Lankhorst wrote:
>>> @@ -55,8 +60,8 @@ int reservation_object_reserve_shared(struct
>>> reservation_object *obj)
>>>               kfree(obj->staged);
>>>               obj->staged = NULL;
>>>               return 0;
>>> -        }
>>> -        max = old->shared_max * 2;
>>> +        } else
>>> +            max = old->shared_max * 2;
>> Perhaps as a separate reformatting patch?
> I'll fold it in to the patch that added
> reservation_object_reserve_shared.
>>> +
>>> +int reservation_object_get_fences_rcu(struct reservation_object *obj,
>>> +                      struct fence **pfence_excl,
>>> +                      unsigned *pshared_count,
>>> +                      struct fence ***pshared)
>>> +{
>>> +    unsigned shared_count = 0;
>>> +    unsigned retry = 1;
>>> +    struct fence **shared = NULL, *fence_excl = NULL;
>>> +    int ret = 0;
>>> +
>>> +    while (retry) {
>>> +        struct reservation_object_list *fobj;
>>> +        unsigned seq;
>>> +
>>> +        seq = read_seqcount_begin(&obj->seq);
>>> +
>>> +        rcu_read_lock();
>>> +
>>> +        fobj = rcu_dereference(obj->fence);
>>> +        if (fobj) {
>>> +            struct fence **nshared;
>>> +
>>> +            shared_count = ACCESS_ONCE(fobj->shared_count);
>> ACCESS_ONCE() shouldn't be needed inside the seqlock?
> Yes it is, shared_count may be increased, leading to potential
> different sizes for krealloc and memcpy
> if the ACCESS_ONCE is removed. I could use shared_max here instead,
> which stays the same,
> but it would waste more memory.

Maarten, Another perhaps ignorant question WRT this,
Does ACCESS_ONCE() guarantee that the value accessed is read atomically?

/Thomas
