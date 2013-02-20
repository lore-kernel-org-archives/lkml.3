Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3BTXB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:01:58 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52372 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3BTXB5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:01:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAK=Wgbb0EeiCh504jsoX+izzi+ZogfEDttz2cHRd4pVXvQunQw@mail.gmail.com>
References: <1360669793-6921-1-git-send-email-sjur.brandeland@stericsson.com>
	<1360669793-6921-2-git-send-email-sjur.brandeland@stericsson.com>
	<CAK=Wgbb0EeiCh504jsoX+izzi+ZogfEDttz2cHRd4pVXvQunQw@mail.gmail.com>
Date: Thu, 21 Feb 2013 00:01:56 +0100
X-Google-Sender-Auth: fIkfMKEdHLqQuJFLMBbes1Jr11U
Message-ID: <CAJK669bDu3SphxmEtA+h+v=btsN91t0S9Mn6ik-OKr=8gtducw@mail.gmail.com>
Subject: Re: [PATCHv2 vringh 1/3] remoteproc: Add support for vringh (Host vrings)
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, Ido Yariv <ido@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 5:05 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Hi Sjur,
>
> On Tue, Feb 12, 2013 at 1:49 PM,  <sjur.brandeland@stericsson.com> wrote:
>> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>>
>> Add functions for creating, deleting and kicking host-side virtio rings.
>>
>> The host ring is not integrated with virtiqueues and cannot be managed
>> through virtio-config.
>
> Is that an inherent design/issue of vringh or just a description of
> the current vringh code ?
>
>> Remoteproc must export functions for handling the host-side virtio rings.
>
> Have you considered exporting this via virtio instead ?

Rusty should comment on this...
I asked Rusty the same question a while a go, see
http://lkml.org/lkml/2013/1/11/559
AFAIK, using the vringh API directly is a deliberate design choice.

[Sjur:]
>> How do you see the in-kernel API for this? I would like to see
>> something similar to my previous patches, where we extend
>> the virtqueue API. E.g. something like this:
>> struct virtqueue *vring_new_virtqueueh(...)...

[Rusty:]
>I was just going to create _kernel variants of all the _user helpers,
>and let you drive it directly like that.
>
>If we get a second in-kernel user, we create wrappers (I'd prefer not to
>overload struct virtqueue though).


>> The functions rproc_virtio_get_vringh(), rproc_virtio_del_vringh(),
>> rproc_virtio_kick_vringh() are added to remoteproc_virtio.c.
>
> I wonder if this is the way we want things to work.
>
> Following this design, virtio drivers that use these rproc_* functions
> will be coupled with the remoteproc framework.
>
> One issue with this is what happens if, e.g., a VIRTIO_ID_CAIF vdev is
> added by other than remoteproc (e.g. by virtio_pci or virtio_mmio).
> Not sure how probable this really is, and whether there's anything
> that prevents this, but things will go awry if this happens.

Yes, if you insert a "malicious device" like that you can make it crash,
but wouldn't most drivers do if you try to register a malicious device...?

If we really want to protect from this, we could perhaps validate the vdev
pointer in function rproc_virtio_new_vringh() by looking through the vdevs
of the registered rprocs.

> But maybe the important aspect to consider is whether we really want
> to couple virtio drivers (such as the upcoming caif one) with the
> remoteproc framework.

I'm not sure this is an issue for the CAIF driver. It would be very nice
if someone else could make use of it, but right now cannot see the CAIF
driver being used outside the remoteproc framework. This driver is
designed specifically to work with the STE-modem using the CAIF
protocol over a shared memory interface.

> If you'll take a look at the rpmsg virtio driver, there's nothing
> there which couples it with remoteproc. It's just a standard virtio
> driver, that can be easily used with traditional virtio hosts as well.
>
> This is possible of course thanks to the abstraction provided by
> virtio: remoteproc only implements a set of callbacks which virtio
> invokes when needed.

Yes, and generalizing the use of virtio devices in remoteproc
has been useful. It has enabled me to let remoteproc manage both
virtio_serial and virtio_caif devices :-)

>
> Do we not want to follow a similar design scheme with vringh ?

I know some of my colleagues has been working on symmetric vring
for rpmsg. Last I heard from them they were going to use the same
approach I've done for CAIF, by "reversing" the direction of the rings.
AFAIK this means that the current API I have proposed will work for
them as well.

If some other driver is showing up using the vringh kernel API where
the current API don't fit, I guess it's time to create some abstractions
and wrappers... But I hope the current approach will do for now?

> I have some other questions as well but maybe it's better to discuss
> first the bigger picture.

OK, but please don't hesitate to address this. I'm still aiming for this
to go into 3.9.

Regards,
Sjur
