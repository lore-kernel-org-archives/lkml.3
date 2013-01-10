Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3AJXjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:39:17 -0500
Received: from ozlabs.org ([203.10.76.45]:50406 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab3AJXjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:39:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
In-Reply-To: <CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com>
References: <871ug75vp1.fsf@rustcorp.com.au> <1354718230-4486-1-git-send-email-sjur@brendeland.net> <20121206102750.GF10837@redhat.com> <877goc0wac.fsf@rustcorp.com.au> <CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com> <87pq1f2rj0.fsf@rustcorp.com.au> <87wqvl1g9s.fsf@rustcorp.com.au> <CAJK669Z-bGTeQe8qJpTJP7simbSvQ8cgFZefs5QRMkmxtFYY4g@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 11 Jan 2013 10:05:11 +1030
Message-ID: <87pq1c1uj4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sjur Brændeland <sjurbren@gmail.com> writes:
> Hi Rusty,
>
> On Thu, Jan 10, 2013 at 11:30 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> ...
>>I now have some lightly-tested code (via a userspace harness).
>
> Great - thank you for looking into this. I will start integrating this
> with my patches
> when you send out a proper patch.

Hi Sjur!

        OK, the Internet was no help here, how do you pronounce Sjur?
I'm guessing "shoor" rhyming with tour until I know better.

>> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
>> index 8d5bddb..fd95d3e 100644
>> --- a/drivers/virtio/Kconfig
>> +++ b/drivers/virtio/Kconfig
>> @@ -5,6 +5,12 @@ config VIRTIO
>>           bus, such as CONFIG_VIRTIO_PCI, CONFIG_VIRTIO_MMIO, CONFIG_LGUEST,
>>           CONFIG_RPMSG or CONFIG_S390_GUEST.
>>
>> +config VHOST
>> +       tristate
>
> Inclusion of drivers/virtio from drivers/Makefile depends on VIRTIO.
> So I guess VHOST should select VIRTIO to ensure that
> drivers/virtio/virtio_host.c
> is part of the build.

Maybe I should move drivers/virtio/virtio_host.c to
drivers/vhost/vringh.c; I'll look at it.

It makes sense for vhost/ to contain the host-side stuff, since it
already exists.

>> +       if (*last_avail_idx == avail_idx)
>> +               return vrh->vring.num;
>> +
>> +       /* Only get avail ring entries after they have been exposed by guest. */
>> +       smp_rmb();
>
> We are accessing memory shared with a remote device (modem), so we probably
> need mandatory barriers here, e.g. something like the virtio_rmb
> defined in virtio_ring.c.

Fair enough, we can put those in a header.

>> +               /* Append the pages into the sg. */
>> +               err = add_to_sg(&vsg, (void *)(long)acc->desc.addr,
>> +                               acc->desc.len, gfp);
>
> I would prefer not to split into pages at this point, but rather provide an
> iterator or the original list found in the descriptor to the client.
>
> In our case we use virtio rings to talk to a LTE-modem over shared memory.
> The IP traffic is received over the air, interleaved and arrives in
> the virtio driver in
> large bursts. So virtio driver on the modem receives multiple datagrams
> held in large contiguous buffers. Our current approach is to handle each
> buffer as a chained descriptor list, where each datagram is kept in
> separate chained descriptors. When the buffers are consumed on the linux
> host, the modem will read the chained descriptors from the used-ring and
> free the entire contiguous buffer in one operation.

In other words, boundaries matter?

While the sg-in-place hack is close to optimal for TCM_VHOST, neither
net not you can use it directly.  I'll switch to an iovec (with a
similar use-caller-supplied-if-it-fits trick); they're smaller anyway.

More code coming...

Thanks,
Rusty.
