Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaBLQ07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:26:59 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:60943 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBLQ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:26:57 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CANq1E4RACz+bZmBGFtVGNKZhcJtC6iQtCpsCTTjEXrGUDP6C+A@mail.gmail.com>
References: <1391004120-687-1-git-send-email-dh.herrmann@gmail.com>
	<1391004120-687-6-git-send-email-dh.herrmann@gmail.com>
	<20140212132541.GU17001@phenom.ffwll.local>
	<CANq1E4RACz+bZmBGFtVGNKZhcJtC6iQtCpsCTTjEXrGUDP6C+A@mail.gmail.com>
Date: Wed, 12 Feb 2014 17:26:57 +0100
X-Google-Sender-Auth: BFPOFnCyvh-QzeqIcXiXPv3Sdgs
Message-ID: <CAKMK7uEbHUL5=CiRqcCh7nBRAirOB4tdSwiz6YPHNiThVujA8A@mail.gmail.com>
Subject: Re: [PATCH 05/13] drm: provide device-refcount
From: Daniel Vetter <daniel@ffwll.ch>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 3:44 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
>>> +/**
>>> + * drm_dev_ref - Take reference of a DRM device
>>> + * @dev: device to take reference of or NULL
>>> + *
>>> + * This increases the ref-count of @dev by one. You *must* already own a
>>> + * reference when calling this. Use drm_dev_unref() to drop this reference
>>> + * again.
>>> + *
>>> + * This function never fails. However, this function does not provide *any*
>>> + * guarantee whether the device is alive or running. It only provides a
>>> + * reference to the object and the memory associated with it.
>>> + */
>>> +void drm_dev_ref(struct drm_device *dev)
>>> +{
>>> +     if (dev)
>>
>> This check here (and below in the unref code) look funny. What's the
>> reason for it? Trying to grab/drop a ref on a NULL pointer sounds like a
>> pretty serious bug to me. This is in contrast to kfree(NULL) which imo
>> makes sense - freeing nothing is a legitimate operation imo.
>
> I added it mainly to simplify cleanup-code paths. You can then just
> call unref() and set it to NULL regardless whether you actually hold a
> reference or not. For ref() I don't really care but I think the
> NULL-test doesn't hurt either.
>
> I copied this behavior from get_device() and put_device(), btw.
> Similar to these functions, I think a lot more will go wrong if the
> NULL pointer is not intentional. Imo, ref-counting on a NULL object
> just means "no object", so it shouldn't do anything.

My fear with this kind of magic is that someone accidentally exchanges
the pointer clearing to NULL (or assignement when grabbing a ref) with
the unref/ref call and then we have a very subtle bug at hand. If we
don't accept NULL objects the failure will be much more obvious.

The entire kernel kobject stuff is very consistent about this, but I
couldn't find a reason for it - all the NULL checks predate git
history. Greg can you please shed some lights on best practice here
and whether my fears are justified given your experience with shoddy
drivers in general?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
