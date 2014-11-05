Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaKEQA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:00:56 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48807 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaKEQAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:00:53 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-8d-545a49b2891a
Message-id: <545A49AF.9080901@samsung.com>
Date: Wed, 05 Nov 2014 17:00:47 +0100
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
In-reply-to: <20141105140418.GA18067@ulmo>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xK7qbPKNCDE43GVssfHiX2eLK1/ds
	Fs2L17NZXN41h83i5655LA6sHnu/LWDx2DnrLrvH/rlr2D3udx9n8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY9vP58wF2+Qqnn/uYm5g7JDoYuTgkBAwkbjaa9HFyAlkiklcuLeerYuRi0NIYCmj
	xIPmRmaQhJDAJ0aJWZssQWxeAS2Jth+P2EFsFgFVie3nN7OA2GwCmhJ/N99kA7FFBSIkrqyZ
	wwhRLyjxY/I9sBo+AUuJY0s6wXpFBHQl/p9+wwKyjFlgHqPEvsMPwIqEBdwl7q28xghxRTuj
	xLmvcxlBLuUE2jy9JQLEZBZQl5gyJReknFlAXmLzmrfMExgFZyFZNwuhahaSqgWMzKsYRVNL
	kwuKk9JzjfSKE3OLS/PS9ZLzczcxQoL86w7GpcesDjEKcDAq8fB6NEWGCLEmlhVX5h5ilOBg
	VhLh5XSOChHiTUmsrEotyo8vKs1JLT7EyMTBKdXAuEOlWIy94P7tdu/Vu/YKS2969H35wU6d
	oKbqy7OUYzbVpdjXMRT6X82sm80+79vXgG2WE7YuWqASmzHb8oXqthObVU5N9dGKe/KkIKP2
	hpL91MZH787+3rXMZPnq00Usx1p/znurbGU6Zfuf0psT73/8xrXezvJg7L7mq+tVSotf7rz0
	Zaek4yElluKMREMt5qLiRAAFqbVVUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 03:04 PM, Thierry Reding wrote:
> On Wed, Nov 05, 2014 at 01:36:24PM +0100, Andrzej Hajda wrote:
>> On 11/04/2014 05:29 PM, Thierry Reding wrote:
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> Add a generic implementation of an object registry. This targets drivers
>>> and subsystems that provide auxiliary objects that other drivers need to
>>> look up. The goal is to put the difficult parts (keep object references,
>>> module usage count, ...) into core code so that individual subsystems do
>>> not have to deal with them.
>>>
>>> The intention is for subsystems to instantiate a struct registry and use
>>> a struct registry_record embedded into a subsystem-specific structure to
>>> provide a subsystem-specific API around that.
>>
>>
>> As I understand you want to use this registry for panels and bridges.
>> Could you explain the idea and describe example scenario when these
>> refcountings are useful. I guess it should be when panel attached to
>> drmdrv want to disappear.
> 
> Correct. When a panel driver is unloaded it frees memory associated with
> the panel. The goal of this registry is for the panel object to stay
> around until all references are gone.
> 
>> Real lifetime of panel is limited by probe/remove callbacks of panel
>> driver, do you want to prolong it behind these limits?
> 
> Yes.
> 
>> Do you want to have zombie panels, without hardware they abstract? For
>> what purpose?
> 
> So that display drivers don't try to access objects that have been
> freed.

Why do not just release panel references from drm_dev, I have
successfully implemented dsi panels this way, thanks to dsi bus specific
attach/detach callbacks and drm hotplug mechansim.

My point is we do not need to make the whole tricky double refcounting,
with total redesign of panels, revoke, zombies, etc.... It is enough to
have just hot plug/unplug callbacks. This is why I have proposed few
months ago interface_tracker framework. It can add hot(un)plug
capability in a generic way to any framework.

Regards
Andrzej


> 
>> What do you want to do with panel ops? Do they need support both life
>> states?
> 
> That's a slightly separate issue for which David Herrmann had a solution
> in mind. As I understand it, the idea would be for these objects to gain
> revoke support. The goal is that once the underlying object disappears,
> calling any of the operations involved would fail (with something like a
> -ENODEV). It's a little more complicated than that because the device
> could disappear right in the middle of such an operation, but that's
> precisely what revoke should allow us to do. Readding David for
> visibility.
> 
>> Anyway implementation currently seems to be broken,
> 
> DRM panels are currently completely broken. If you remove the driver for
> a panel the display driver that uses this panel will simply crash the
> next time it tries to do anything with the panel. This type of registry
> is the first step in trying to fix this.
> 
>>                                                     you try to refcount
>> objects which are usually embedded in driver priv data, which disappears
>> during remove callback of the driver.
> 
> A second step in fixing this will be to convert drivers to no longer
> free the panel but rather drop their reference to the panel that they've
> registered. This will make sure that memory doesn't get freed until all
> references are gone.
> 
> Note that this means that drivers will also need to be converted not to
> use devm_* helpers since that conflicts with the reference counted life-
> times of these record objects.
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

