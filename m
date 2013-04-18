Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967131Ab3DROm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 10:42:58 -0400
Received: from ihemail2.lucent.com ([135.245.0.35]:47126 "EHLO
	ihemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966753Ab3DROm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 10:42:56 -0400
Date: Thu, 18 Apr 2013 09:42:46 -0500 (CDT)
From: Ilija Hadzic <ihadzic@research.bell-labs.com>
X-X-Sender: ihadzic@umail
To: David Herrmann <dh.herrmann@gmail.com>
cc: Byron Stanoszek <gandalf@winds.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: Standalone DRM application
In-Reply-To: <CANq1E4RGD+8QNAin+A-MZWAiqhLLvH+zG+gfhi7Vd6bYOuV75A@mail.gmail.com>
Message-ID: <Pine.GSO.4.64.1304180853530.9152@umail>
References: <alpine.LNX.2.00.1304171605010.19898@winds.org>
 <CANq1E4RGD+8QNAin+A-MZWAiqhLLvH+zG+gfhi7Vd6bYOuV75A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Apr 2013, David Herrmann wrote:

> Hi
>
> On Wed, Apr 17, 2013 at 11:05 PM, Byron Stanoszek <gandalf@winds.org> wrote:
>> David,
>>
>> I'm developing a small application that uses libdrm (DRM ioctls) to change
>> the
>> resolution of a single graphics display and show a framebuffer. I've run
>> into
>> two problems with this implementation that I'm hoping you can address.
>>
>>
>> 1. Each application is its own process, which is designed to control 1
>> graphics
>> display. This is unlike X, for instance, which could be configured to grab
>> all
>> of the displays in the system at once.
>>
>> Depending on our stackup, there can be as many as 4 displays connected to a
>> single graphics card. One process could open /dev/dri/card0 and call
>> drmModeSetCrtc() to initialize one of its displays to the requested
>> resolution.
>> However, whenever a second process calls drmModeSetCrtc() to control a
>> second
>> display on the same card, it gets -EPERM back from the ioctl.
>>
>> I've traced this down to the following line in
>> linux/drivers/gpu/drm/drm_drv.c:
>>
>> DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETCRTC, drm_mode_setcrtc,
>> DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
>>
>> If I remove the DRM_MASTER flag, then my application behaves correctly, and
>> 4
>> separate processes can then control each individual display on the card
>> without
>> issue.
>>
>> My question is, is there any real benefit to restricting drm_mode_setcrtc()
>> with DRM_MASTER, or can we lose this flag in order to support
>> one-process-per-
>> display programs like the above?
>
> Only one open-file can be DRM-Master. And only DRM-Master is allowed
> to perform mode-setting. This is to prevent render-clients (like
> OpenGL clients) to perform mode-setting, which should be restricted to
> the compositor/...
>
> In your scenario, you should share a single open-file between the
> processes by passing the FDs to each. Or do all of that in a single
> process. There is no way to split CRTCs/connectors between different
> nodes or have multiple DRM-Masters on a single node at once. (There is
> work going on to allow this, but it will take a while...)
>

If running a custom-patched kernel is acceptable (i.e. custom-built, 
embedded system or the like), then a set of patches that I sent about a 
year ago [1] will probably do the job. The problem is that these patches 
are apparently not going upstream because there was little interest and 
there were a couple of arguments against them [2]. Originally, it's the 
work that Dave Airlie started but abandoned. I finished it off and tried 
to have it included upstream but it didn't happen.

I have an application that is similar to what is described here and I am 
using these patches to make it work. Essentially, what you do is call a 
small userspace utility (also included with the patches for libdrm) and 
specify which CRTCs/encoders/connectors/planes do you want included in the 
node and you get a new /dev/dri/render<N> node that your application can 
use and be the master on these resources only. Then for the next node you 
call the utility again and specify a new set of display resources and then 
you run the other application on the top of that node.

The patches that are on the mailing list archive [1] are now a year old, 
but I have a rebased version for newer kernels, which I can send to 
whoever is interested in having them (I am just hesitating to pollute the 
mailing list with patches to which the maintainers have already said 
"no").

[1] http://lists.freedesktop.org/archives/dri-devel/2012-April/021326.html
[2] http://lists.freedesktop.org/archives/dri-devel/2012-September/028348.html

-- Ilija
