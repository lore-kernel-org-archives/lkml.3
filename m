Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbaKTIlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:41:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55362 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbaKTIlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:41:19 -0500
Message-ID: <546DA92B.9080501@canonical.com>
Date: Thu, 20 Nov 2014 09:41:15 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>,
        Michael Marineau <mike@marineau.org>, dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>
Subject: Re: 3.18-rc regression: drm/nouveau: use shared fences for readable
 objects
References: <CAHW-aUcEipi+NeU3wapLABV41Sud7Qy_=EYXCei9Dmf18SxuZA@mail.gmail.com> <546C5085.1020300@canonical.com> <546D2309.90201@mni.thm.de>
In-Reply-To: <546D2309.90201@mni.thm.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 20-11-14 om 00:08 schreef Tobias Klausmann:
> On 19.11.2014 09:10, Maarten Lankhorst wrote:
>> ...
>> On the EDITED patch from fixed-fences-for-bisect, can you do the following:
>>
>> In nouveau/nv84_fence.c function nv84_fence_context_new, remove
>>
>> fctx->base.sequence = nv84_fence_read(chan);
>>
>> and add back
>>
>> nouveau_bo_wr32(priv->bo, chan->chid * 16/4, 0x00000000);
>>
>> ...
>
> Added the above on top of your "fixed-fences-for-bisect" branch and guessed it would work, but did not :/
> Anyway, as this "initializes" the fence to a known state, maybe you should consider pushing that.
Hey,

There is a reason I don't set it to a known state on nv84+.

Channel 2 is created, fence seqno ends up being 100, other channel waits on seqno reaching 100.
Channel 2 is destroyed, and immediately recreated. Seqno is reset to 0.
Other channel waits for channel 2's seqno being 100.

The other channel can keep waiting indefinitely.

I guess it might be useful to reset the contents of the bo to zero on allocation, but it should not be done in fence_context_new.

~Maarten

