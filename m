Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbaLBTes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:34:48 -0500
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45911 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933152AbaLBTeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:34:46 -0500
Message-ID: <547E143E.5010902@xs4all.nl>
Date: Tue, 02 Dec 2014 20:34:22 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] media: v4l2-subdev.h: drop the guard CONFIG_VIDEO_V4L2_SUBDEV_API
 for v4l2_subdev_get_try_*()
References: <1416220913-5047-1-git-send-email-prabhakar.csengg@gmail.com> <547D6E20.7040406@xs4all.nl> <547DB631.3060309@xs4all.nl> <6626165.z9d655UICS@avalon>
In-Reply-To: <6626165.z9d655UICS@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On 12/02/2014 01:59 PM, Laurent Pinchart wrote:
>>>> Basically,
>>>>
>>>> 1. Create a subdev pad configuration store structure to store the formats
>>>> and selection rectangles for each pad.
>>>
>>> I wouldn't call it a 'store'. Just call it fmt_config or pad_config
>>> something like that.
> 
> Sure, the name doesn't matter too much.
> 
>>>> 2. Embed an instance of that structure in v4l2_subdev_fh.
>>>>
>>>> 3. Modify the subdev pad ops to take a configuration store pointer
>>>> instead of a file handle pointer.
>>>>
>>>> The userspace API implementation (v4l2-subdev.c) would then pass
>>>> &fh->store to the pad operations instead of fh.
>>>>
>>>> Bridge drivers that need to implement TRY_FMT on top of pad ops would
>>>> create a temporary store (or temporary stores when multiple subsdevs are
>>>> involved), call the pad ops with a pointer to the temporary store to
>>>> propagate TRY formats, destroy the store(s) and return the resulting
>>>> format.
>>>
>>> That will work. I think this is a good approach and it shouldn't be too
>>> difficult.
>>
>> Laurent, just so I understand this correctly: does this mean that all
>> occurrences of 'struct v4l2_subdev_fh *fh' will be replaced by 'struct
>> v4l2_subdev_pad_config *cfg'?
> 
> That's the plan, yes.
> 
>> Is there any reason why the 'fh' should still be passed on?
> 
> We might find out reasons to still pass the fh, but in that case I think they 
> should be addressed and the fh just dropped from the pad ops arguments.
> 
>> Personally I am in favor of this since the 'fh' always made it hard for
>> bridge drivers to use these pad ops. So if we can replace it by something
>> that can be used by bridge drivers as well, then that will make it easier
>> to move all drivers over to the pad ops.
> 
> Good, looks like we have a plan for world domination :-)
> 

OK, so I couldn't help myself and I did this conversion. The code is here:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=remcrop

And it introduces a new struct:

struct v4l2_subdev_pad_config {
        struct v4l2_mbus_framefmt try_fmt;
        struct v4l2_rect try_crop;
        struct v4l2_rect try_compose;
};

And subdev_fh now looks like this:

struct v4l2_subdev_fh {
        struct v4l2_fh vfh;
        struct v4l2_subdev_pad_config *pad;
};

But I realized that it could be simplified: right now we pass a pointer to
the pad config array to the pad ops and the v4l2_subdev_get_try_* functions
pick the right entry based on the pad index.

Wouldn't it be easier to pass the right pad config directly?

So instead of passing fh->pad in v4l2-subdev.c you pass e.g. 'fh->pad + sel->pad'.
That way the pad_config pointer points straight to the configuration of the
requested pad.

This also simplifies things in a bridge driver: it doesn't need to allocate
a pad config array, it only has to create pad config structs for those pads that
it actually uses.

And the v4l2_subdev_get_try_* functions can effectively be removed, since you
would just access cfg->try_fmt directly. I never liked those helper functions,
so I'm not sorry to see them go.

The only reason why this would fail is if drivers need to access the pad_config
of other pads than the one currently requested. I have not seen any code that
does that, though. And I don't think that is something we want anyway since
that would make things extremely complex.

Let me know what you think,

	Hans
