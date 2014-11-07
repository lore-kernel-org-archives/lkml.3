Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaKGJLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:11:03 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18503 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaKGJKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:10:48 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-41-545c8c940c81
Message-id: <545C8C91.3000703@samsung.com>
Date: Fri, 07 Nov 2014 10:10:41 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
Newsgroups: gmane.comp.video.dri.devel,gmane.linux.kernel
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [RFC 1/2] core: Add generic object registry implementation
References: <1415118568-18771-1-git-send-email-thierry.reding@gmail.com>
 <545A19C8.6090508@samsung.com> <20141105140418.GA18067@ulmo>
 <545A49AF.9080901@samsung.com> <20141106094820.GH26297@ulmo>
In-reply-to: <20141106094820.GH26297@ulmo>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xq7pTemJCDE42WVksfHiX2eLK1/ds
	Fs2L17NZXN41h83i5655LA6sHnu/LWDx2DnrLrvH/rlr2D3udx9n8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY8OiD8wFr6Urds/7w9TAuEGsi5GTQ0LARGLv/V3MELaYxIV769m6GLk4hASWMkr0
	HWtjhHA+MUr8+beNFaSKV0BLYuaCBUAdHBwsAqoSi7cWgYTZBDQl/m6+yQZiiwpESFxZM4cR
	olxQ4sfkeywgNp+ApcSxJZ3sILaIgK7E/9NvWEDmMwvMY5TYd/gBWJGwgLvEvZXXoBYfY5SY
	eXsdWIITaPGC1QdYQBYzC6hLTJmSCxJmFpCX2LzmLfMERsFZSPbNQqiahaRqASPzKkbR1NLk
	guKk9FxDveLE3OLSvHS95PzcTYyQQP+yg3HxMatDjAIcjEo8vJ1CMSFCrIllxZW5hxglOJiV
	RHhTG4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGGepRYpUSVbc3CB48/LrSpOgeZ9yli5/nKfi
	0BBjEF7BqRW4Ia7kcX3Kh2/Ou9lq7I7yl//hZq2q2b1tQd+NbT+uZyx+avrDRj3izsWnVVE5
	X22Xtk80vmg881eC7Fv1iNAf5etVFH/e9xC2v9a1ZZfd8eMVTs0BzTEZ/4pO+wlXvy/kC+ff
	pcRSnJFoqMVcVJwIAIeRx39SAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 10:48 AM, Thierry Reding wrote:
> On Wed, Nov 05, 2014 at 05:00:47PM +0100, Andrzej Hajda wrote:
>> On 11/05/2014 03:04 PM, Thierry Reding wrote:
>>> On Wed, Nov 05, 2014 at 01:36:24PM +0100, Andrzej Hajda wrote:
>>>> On 11/04/2014 05:29 PM, Thierry Reding wrote:
>>>>> From: Thierry Reding <treding@nvidia.com>
>>>>>
>>>>> Add a generic implementation of an object registry. This targets drivers
>>>>> and subsystems that provide auxiliary objects that other drivers need to
>>>>> look up. The goal is to put the difficult parts (keep object references,
>>>>> module usage count, ...) into core code so that individual subsystems do
>>>>> not have to deal with them.
>>>>>
>>>>> The intention is for subsystems to instantiate a struct registry and use
>>>>> a struct registry_record embedded into a subsystem-specific structure to
>>>>> provide a subsystem-specific API around that.
>>>>
>>>>
>>>> As I understand you want to use this registry for panels and bridges.
>>>> Could you explain the idea and describe example scenario when these
>>>> refcountings are useful. I guess it should be when panel attached to
>>>> drmdrv want to disappear.
>>>
>>> Correct. When a panel driver is unloaded it frees memory associated with
>>> the panel. The goal of this registry is for the panel object to stay
>>> around until all references are gone.
>>>
>>>> Real lifetime of panel is limited by probe/remove callbacks of panel
>>>> driver, do you want to prolong it behind these limits?
>>>
>>> Yes.
>>>
>>>> Do you want to have zombie panels, without hardware they abstract? For
>>>> what purpose?
>>>
>>> So that display drivers don't try to access objects that have been
>>> freed.
>>
>> Why do not just release panel references from drm_dev, I have
>> successfully implemented dsi panels this way, thanks to dsi bus specific
>> attach/detach callbacks and drm hotplug mechansim.
> 
> Like you say yourself, that's something that work only for DSI. Any
> other type of panel can't do this.

But it means that if we want to make panels safe we just need add
registration/deregistration notifications to panels, nothing more.


> 
>> My point is we do not need to make the whole tricky double refcounting,
> 
> There's no double refcounting. We have no refcounting at all at the
> moment.

For me registry_record.kref and try_module_get sounds like refcounting.

> 
>> with total redesign of panels, revoke, zombies, etc.... It is enough to
> 
> It's not a total redesign. It just makes it more mature and implements
> features that I think are useful (and needed) but that were left out for
> the sake of simplicity. Now it turns out that this is actually quite
> fragile and easy to get wrong.

And I try to convince you we can still keep simplicity and make it safe.

> 
>> have just hot plug/unplug callbacks. This is why I have proposed few
>> months ago interface_tracker framework. It can add hot(un)plug
>> capability in a generic way to any framework.
> 
> That's something that this object registry could easily implement as
> well. But instead of passing around void * and type IDs as in the
> interface tracker it could deal with real objects for proper type-
> safety.

It is not a problem to add type-safe helpers to interface tracker.

Regards
Andrzej

> 
> Thierry
> 
> 
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

