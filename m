Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbaJ3Ahw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:37:52 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19555 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755207AbaJ3Aht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:37:49 -0400
Date: Wed, 29 Oct 2014 17:38:09 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [RFC 5/7] soc: qcom: Add Shared Memory Driver
Message-ID: <20141030003806.GU28611@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412037291-16880-6-git-send-email-bjorn.andersson@sonymobile.com>
 <CADMYwHxLtAZZMUGX3jo0URAezqGuho5XB=hQJp8k+acBiENrhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CADMYwHxLtAZZMUGX3jo0URAezqGuho5XB=hQJp8k+acBiENrhg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 29 Oct 07:28 PDT 2014, Ohad Ben-Cohen wrote:

> [Thanks Kevin for the heads up on this]
> 
> Hi Bjorn,
> 

Hi Ohad,

> On Tue, Sep 30, 2014 at 3:34 AM, Bjorn Andersson
> <bjorn.andersson@sonymobile.com> wrote:
> > == Codeaurora implementation ==
> > The codeaurora implementation originates from an implementation that was based purely on initcall and global state
> 
> Do you refer to the in-tree arch/arm/mach-msm/smd.c ? it seems similar
> in some ways to the newly proposed smd driver.
> 

Correct, that's how the codeaurora driver looked 7 years ago, but there's so
much that changed since then. Wire format is more or less the same though.

As per Arnd's request I have been looking at ways to migrate mach-msm to this
implementation, but I haven't come to any good conclusion yet.

> > == RPMSG ==
> >
> > The rpmsg_driver fits nicely into what I want to do, so that could be used
> > straight off. Data is transmitted by calling rpmsg_send() and incoming data is
> > delivered through the registered callback on a channel.  It's possible to
> > request additional channels for a rpmsg device, although this is probably never
> > tested as there is no way to send data on this additional endpoint.
> 
> This is inaccurate - rpmsg does have offchannel sending API, some of
> which are being used by the rpmsg core itself. Please check out
> rpmsg_sendto() and rpmsg_send_offchannel().
> 

You're correct, I just found the api so awkward that I couldn't imagine that it
was supposed to be used that way.

  ept = rpmsg_create_ept(..., 42);
  rpmsg_sendto(..., 42);
  rpmsg_destroy_ept(ept);

is not a very clean way of doing things... So if anyone would be using it I
would assume that the rpmsg_send() function would start taking and ept as
argument instead of a channel.

> > Endpoints are sort of equivalent of a smd channel although the life cycle is
> > slightly different, but a major issue with the rpmsg interface is that channels
> > are identified by a single u32, while SMD channels are identified by a u32 and
> > the channel name.
> 
> Honestly this sounds like a small technical difference that can
> probably be fixed with some effort. Rpmsg is designed to satisfy the
> requirements of its current users, and is not set in stone. Not even
> the wire protocol is.
> 

We could turn the address into a union and pass that along. But it does not
change the fact that the entire channel management in virtio_rpmsg_bus.c would
have to be rewritten.

> If another requirement shows up, we can adopt rpmsg so new users could
> use it instead of merging additional frameworks that basically do the
> same thing.
> 

I've only spend 2-3 weeks trying to figure out how to get the two to play along
in the same core. For me there are to many fundamental implementation details
that differs for it to be a fit.

> But new requirements must be well described so we can technically be
> convinced a core change is indeed needed.
> 

For starters, there is no rpmsg core, there is a virtio based bus
implementation of rpmsg. So we would need to get rid of the strong ties to virtio.

Compare rpmsg_recv_done() with qcom_smd_channel_intr() from my patch, those two
functions are (on a powerpoint level) doing exactly the same task - looping
over incoming data and calling rpmsg_recv_single() and
qcom_smd_channel_recv_single() respectively. Also look at qcom_smd_edge_intr(),
that is how we are notified that there might be data in the buffers.

Compare how rpmsg allocates fixed size buffers from a ringbuffer, while smd
have a ringbuffer pair per channel, where the variable size packages are stored
packed and the rx/tx index pointers are updated.

Compare how the life cycle of a channel in rpmsg is compared to smd. In rpmsg
we get a call to rpmsg_ns_cb() telling us that a channel was registered or went
away. In smd this is first handled by someone allocating memory for the
channel, which qcom_channel_scan_worker() picks up; when this channel changes
state because the remote side is opening it this is detected in
qcom_channel_state_worker(). If the other side closed the channel simply the
state of the channel changes (to closed) and qcom_channel_state_worker() picks
this up - there are no notification events related to this.

> > So to be able to use the rpmsg api we would need to create additional apis that
> > handles the custom address format of the smd channels. Furthermore all the "off
> > channel" functions would be invalid.
> > Furthermore most of the channel and endpoint structures would be "invalid".
> 
> Not sure I'm following this one. Can you please explain the smd
> addressing? what part of it is set in stone and what part of it can
> still be changed?
> 

A SMD channel consists of one pair of control structures smd_channel_info or
smd_channel_info_word and one pair of ring buffers - one for tx, one for rx.
The channel info structures are used to indicate to the other side of the
channel:
*) what the local state is (closed/opening/open/closing)
*) where write and read pointers are within each ringbuffer
*) flow control bits

Channels are allocated on first use and stay allocated until you reboot the
platform, the both sides uses the state to indicate if there's an
implementation available to communicate with.

References to the channels are kept in a lookup table - consisting of
qcom_smd_alloc_entry - and are identified by remote processor identifier (u32)
and a channel name (char[]).


Each of these listed "items" are represented as smem items - a item heap shared
among all the processors in a Qualcomm platform.

> > But these are the problems with the actual api, rpmsg is not only the api. It's
> > a direct implementation of these functions, defining how services are
> > discovered, how channels are represented as well as the actual "wire" protocol.
> >
> > Or to put it in another way: rpmsg is an implementation of a packet protocol
> > on-top of virtio, it is not a framework or api for abstracting packet transport
> > logic.
> 
> This is inaccurate. If there's justification for another wire
> protocol, it can be added. Even virtio itself was once only an
> abstraction over the virtqueue wire protocol:
> 

Correct, what I'm saying is that we need to add another wire protocol, we need
to add another memory management model, we need to add another channel life
cycle model and we need to make modifications to the api.

Or in other words, we need to change everything that defines rpmsg today.
That's why I don't think it's a wise path to take.

> commit 7c5e9ed0c84e7d70d887878574590638d5572659
> Author: Michael S. Tsirkin <mst@redhat.com>
> Date:   Mon Apr 12 16:19:07 2010 +0300
> 
>     virtio_ring: remove a level of indirection
> 
>     We have a single virtqueue_ops implementation,
>     and it seems unlikely we'll get another one
>     at this point. So let's remove an unnecessary
>     level of indirection: it would be very easy to
>     re-add it if another implementation surfaces.
> 
>     Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 

Upon sending a packet to a remote processor in SMD we get some sort of pointer
and size from a client, the work to be done is to write that into the tx
ringbuffer at the index specified in the channel info struct, increment that
index and then kick the other side.

As far as I can see this is not a good fit for virtio or virtqueue, so I was
hoping that we won't complicate either of those implementations for the sake of
fitting into a framework.

> > As there are discussions regarding replacing SMD with a new wire protocol, it
> > would probably be convenient to create a generic version of my proposed "api"
> > that can be re-used between different implementations and hopefully provide
> > re-use of parts of the code. Maybe we can make rpmsg an implementation under
> > such a generic api.
> 
> If the SMD wire protocol can still be changed that's great. Why don't
> you pick up the vrings structures and play with it? You then get rpmsg
> for free. If some of the APIs aren't exactly what you need, please
> explain and we could change it to fit your requirements.
> 

Qualcomm recently announced that they now shipped 1 billion Snapdragon based
Android phones - they are all using the SMD wire protocol and they will never
support anything else.

I've of course poked Qualcomm engineers regarding using rpmsg for future
platforms and althought there are work ongoing to replace SMD I would be
surprised if they picked rpmsg as their next solution...

> It's always easier to merge new code rather than understand the
> existing one and change it to fit all users, but usually it just means
> more work later.
> 

My concern is that merging SMD into rpmsg will still give us two different
solutions, except that they will be deeply tangled.

Thanks for your feedback Ohad!

Regards,
Bjorn
