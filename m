Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaESOZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:25:35 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:42265 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaESOZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:25:34 -0400
X-Spam-Flag: NO
X-Spam-Score: -0.045
Authentication-Results: rohrpostix1.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de 24999261444
X-DKIM: OpenDKIM Filter v2.0.2 smtp-05.vodafone.de B3E4EE4C12
Message-ID: <537A144F.1070909@vodafone.de>
Date: Mon, 19 May 2014 16:25:19 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>, airlied@linux.ie
CC: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v1 08/16] drm/radeon: use common fence implementation
 for fences
References: <20140514145134.21163.32350.stgit@patser> <20140514145809.21163.64947.stgit@patser> <53738BCC.2070809@vodafone.de> <5374131D.4010906@canonical.com> <53748702.6070606@vodafone.de> <53748AFA.8010109@canonical.com> <53748BFD.1050608@vodafone.de> <5374BB4A.6070102@canonical.com> <5374BEE2.4060608@vodafone.de> <5374CC9A.9090905@canonical.com> <5374E1B5.2020408@vodafone.de> <5374E410.1080203@canonical.com> <5374E792.4070607@vodafone.de> <5379BA04.8000901@canonical.com> <5379C06D.3050507@vodafone.de> <5379D8AD.1000904@canonical.com> <5379F96C.1060806@vodafone.de> <537A08BC.7060501@canonical.com>
In-Reply-To: <537A08BC.7060501@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.05.2014 15:35, schrieb Maarten Lankhorst:
> op 19-05-14 14:30, Christian König schreef:
>> Am 19.05.2014 12:10, schrieb Maarten Lankhorst:
>>> op 19-05-14 10:27, Christian König schreef:
>>>> Am 19.05.2014 10:00, schrieb Maarten Lankhorst:
>>>> [SNIP]
>>>> The problem here is that the whole approach collides with the way 
>>>> we do reset handling from a conceptual point of view. Every IOCTL 
>>>> or other call chain into the driver is protected by the read side 
>>>> of the exclusive_lock semaphore. So in the case of a GPU lockup we 
>>>> can take the write side of the semaphore and so make sure that we 
>>>> have nobody else accessing the hardware or internal driver 
>>>> structures only changed at init time.
>>>>
>>>> Leaking a drivers IRQ context into another driver as well as 
>>>> calling into a driver in atomic context is just a quite uncommon 
>>>> approach and should be considered very carefully.
>>>>
>>>> I would rather vote for a completely synchronous interface only 
>>>> allowing blocking waits and checks if a fence is signaled from not 
>>>> atomic context.
>>>>
>>>> If a driver needs to avoid blocking it should just use a workqueue 
>>>> and checking a fence outside your own driver is probably be better 
>>>> done in a bottom halve handler anyway.
>>>
>>> Except that you might want to do something like
>>> fence_is_signaled() in another driver to check whether you need to
>>> defer, or can submit the batch buffer immediately, saving a bunch of
>>> context switches. Running the is_signaled atomic is really useful here
>>> because it means you can't do too many scary things in your is_signaled
>>> handler.
>>
>> This is indeed a nice optimization, but nothing more. If you want to 
>> provide a is_signalled interface for atomic context then this should 
>> be optional, not mandatory.
> See below.
>>> In case of enable_signaling it was the only sane solution, because
>>> fence_signal can be called from irq context, and any calls after 
>>> that to
>>> fence_add_callback and fence_wait aren't allowed to do anything, so
>>> fence_enable_sw_signaling and the default wait implementation must be
>>> atomic. fence_wait itself doesn't have to be, so it's easy to grab
>>> exclusive_lock there.
>>
>> I don't think you understood my point here: Completely drop 
>> enable_signaling, it's unnecessary and only complicates the interface.
>>
>> We purposely avoided exactly this paradigm in the past and I haven't 
>> seen any good argument to start with it now.
>
> In the common case a lot more fences will be emitted than will be 
> waited on.
> This means it makes sense to delay signaling a fence with fence_signal 
> for
> as long as possible. But when a fence user wants to work with a fence
> some way is needed to ensure that the fence will complete. This is the 
> idea
> behind .enable_signaling, it tells the fence driver to call 
> fence_signal on
> the fence 'soon' because there are now waiters for it.
>
> The atomic .signaled is optional, and can be set to NULL, but there is
> no guarantee that fence_is_signaled will ever return true in that case,
> unless fence_enable_sw_signaling is called (which calls 
> .enable_signaling).
>
> Providing a custom wait function is optional in the interface, if the 
> default wait
> function is used all waiters are signaled when fence_signal is called.
>
> Removing enable_signaling would only make sense if fence_signal was 
> removed too,
> but that would mean that fence_is_signaled could no longer exist in 
> the core fence
> code, and would mean completely rewriting the interface.
>
And this is what I'm suggesting here.

We have avoided quite hard adding any form of those callbacks in the 
past and I don't really see a reason why that would have changed. For 
example see the discussion here: 
http://lists.freedesktop.org/archives/dri-devel/2012-May/022388.html

Jerome and Dave rejected my approach for handling the sub allocator 
through a callback for exactly the same reason. And that was even for 
call chains inside the same driver, you're suggesting this for cross 
driver synchronization.

Christian.
