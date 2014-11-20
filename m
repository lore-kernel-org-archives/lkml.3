Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbaKTIxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:53:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55437 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbaKTIxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:53:45 -0500
Message-ID: <546DAC16.80704@canonical.com>
Date: Thu, 20 Nov 2014 09:53:42 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michael Marineau <mike@marineau.org>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>
Subject: Re: 3.18-rc regression: drm/nouveau: use shared fences for readable
 objects
References: <CAHW-aUcEipi+NeU3wapLABV41Sud7Qy_=EYXCei9Dmf18SxuZA@mail.gmail.com>	<546C5085.1020300@canonical.com> <CAHW-aUf7zkWbwDSoL62X9A6pWMAHRGwG=YPQ80o_4OicD7EJPQ@mail.gmail.com>
In-Reply-To: <CAHW-aUf7zkWbwDSoL62X9A6pWMAHRGwG=YPQ80o_4OicD7EJPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 20-11-14 om 05:06 schreef Michael Marineau:
> On Wed, Nov 19, 2014 at 12:10 AM, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
>> Hey,
>>
>> On 19-11-14 07:43, Michael Marineau wrote:
>>> On 3.18-rc kernel's I have been intermittently experiencing GPU
>>> lockups shortly after startup, accompanied with one or both of the
>>> following errors:
>>>
>>> nouveau E[   PFIFO][0000:01:00.0] read fault at 0x000734a000 [PTE]
>>> from PBDMA0/HOST_CPU on channel 0x007faa3000 [unknown]
>>> nouveau E[     DRM] GPU lockup - switching to software fbcon
>>>
>>> I was able to trace the issue with bisect to commit
>>> 809e9447b92ffe1346b2d6ec390e212d5307f61c "drm/nouveau: use shared
>>> fences for readable objects". The lockups appear to have cleared up
>>> since reverting that and a few related followup commits:
>>>
>>> 809e9447: "drm/nouveau: use shared fences for readable objects"
>>> 055dffdf: "drm/nouveau: bump driver patchlevel to 1.2.1"
>>> e3be4c23: "drm/nouveau: specify if interruptible wait is desired in
>>> nouveau_fence_sync"
>>> 15a996bb: "drm/nouveau: assign fence_chan->name correctly"
>> Weird. I'm not sure yet what causes it.
>>
>> http://cgit.freedesktop.org/~mlankhorst/linux/commit/?h=fixed-fences-for-bisect&id=86be4f216bbb9ea3339843a5658d4c21162c7ee2
> Building a kernel from that commit gives me an entirely new behavior:
> X hangs for at least 10-20 seconds at a time with brief moments of
> responsiveness before hanging again while gitk on the kernel repo
> loads. Otherwise the system is responsive. The head of that
> fixed-fences-for-bisect branch (1c6aafb5) which is the "use shared
> fences for readable objects" commit I originally bisected to does
> feature the complete lockups I was seeing before.
Ok for the sake of argument lets just assume they're separate bugs, and we should look at xorg
hanging first.

Is there anything in the dmesg when the hanging happens?

And it's probably 15 seconds, if it's called through nouveau_fence_wait.

Try changing else if (!ret) to else if (WARN_ON(!ret)) in that function, and see if you get some dmesg spam. :)


>> On the EDITED patch from fixed-fences-for-bisect, can you do the following:
>>
>> In nouveau/nv84_fence.c function nv84_fence_context_new, remove
>>
>> fctx->base.sequence = nv84_fence_read(chan);
>>
>> and add back
>>
>> nouveau_bo_wr32(priv->bo, chan->chid * 16/4, 0x00000000);
> Making your suggested change on top of each 86be4f21 and 1c6aafb5 made
> no noticeable difference in either of the two behaviors.
>
>> If that fails you should compile your kernel with trace events, to get some debugging info from the fences. I'll post debugging info if this does not fix it.
> Happy to gather whatever debug log or tracing data you need :)
>

