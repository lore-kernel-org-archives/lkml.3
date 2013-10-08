Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3JHQ6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:58:17 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:38766 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439Ab3JHQ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:58:16 -0400
Message-ID: <525439A3.4050201@vmware.com>
Date: Tue, 08 Oct 2013 18:58:11 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH] drm/radeon: fixup locking inversion between mmap_sem
 and reservations
References: <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <5231E18D.7070306@canonical.com> <5231EF5A.7010901@vmware.com> <52323734.4070908@canonical.com> <5232A39B.5040205@vmware.com> <52541350.5060807@canonical.com> <20131008143354.GA2355@gmail.com> <52541A7E.6050807@vodafone.de> <20131008145540.GB2355@gmail.com> <525432EF.3050005@vmware.com> <20131008164737.GA2782@gmail.com>
In-Reply-To: <20131008164737.GA2782@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 06:47 PM, Jerome Glisse wrote:
> On Tue, Oct 08, 2013 at 06:29:35PM +0200, Thomas Hellstrom wrote:
>> On 10/08/2013 04:55 PM, Jerome Glisse wrote:
>>> On Tue, Oct 08, 2013 at 04:45:18PM +0200, Christian König wrote:
>>>> Am 08.10.2013 16:33, schrieb Jerome Glisse:
>>>>> On Tue, Oct 08, 2013 at 04:14:40PM +0200, Maarten Lankhorst wrote:
>>>>>> Allocate and copy all kernel memory before doing reservations. This prevents a locking
>>>>>> inversion between mmap_sem and reservation_class, and allows us to drop the trylocking
>>>>>> in ttm_bo_vm_fault without upsetting lockdep.
>>>>>>
>>>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>>> I would say NAK. Current code only allocate temporary page in AGP case.
>>>>> So AGP case is userspace -> temp page -> cs checker -> radeon ib.
>>>>>
>>>>> Non AGP is directly memcpy to radeon IB.
>>>>>
>>>>> Your patch allocate memory memcpy userspace to it and it will then be
>>>>> memcpy to IB. Which means you introduce an extra memcpy in the process
>>>>> not something we want.
>>>> Totally agree. Additional to that there is no good reason to provide
>>>> anything else than anonymous system memory to the CS ioctl, so the
>>>> dependency between the mmap_sem and reservations are not really
>>>> clear to me.
>>>>
>>>> Christian.
>>> I think is that in other code path you take mmap_sem first then reserve
>>> bo. But here we reserve bo and then we take mmap_sem because of copy
>> >from user.
>>> Cheers,
>>> Jerome
>>>
>> Actually the log message is a little confusing. I think the mmap_sem
>> locking inversion problem is orthogonal to what's being fixed here.
>>
>> This patch fixes the possible recursive bo::reserve caused by
>> malicious user-space handing a pointer to ttm memory so that the ttm
>> fault handler is called when bos are already reserved. That may
>> cause a (possibly interruptible) livelock.
>>
>> Once that is fixed, we are free to choose the mmap_sem ->
>> bo::reserve locking order. Currently it's bo::reserve->mmap_sem(),
>> but the hack required in the ttm fault handler is admittedly a bit
>> ugly.  The plan is to change the locking order to
>> mmap_sem->bo::reserve
>>
>> I'm not sure if it applies to this particular case, but it should be
>> possible to make sure that copy_from_user_inatomic() will always
>> succeed, by making sure the pages are present using
>> get_user_pages(), and release the pages after
>> copy_from_user_inatomic() is done. That way there's no need for a
>> double memcpy slowpath, but if the copied data is very fragmented I
>> guess the resulting code may look ugly. The get_user_pages()
>> function will return an error if it hits TTM pages.
>>
>> /Thomas
> get_user_pages + copy_from_user_inatomic is overkill. We should just
> do get_user_pages which fails with ttm memory and then use copy_highpage
> helper.
>
> Cheers,
> Jerome
Yeah, it may well be that that's the preferred solution.

/Thomas
