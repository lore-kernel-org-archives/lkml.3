Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384AbaJ2O2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:28:53 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59919 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbaJ2O2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:28:51 -0400
MIME-Version: 1.0
In-Reply-To: <1412037291-16880-6-git-send-email-bjorn.andersson@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com> <1412037291-16880-6-git-send-email-bjorn.andersson@sonymobile.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Oct 2014 16:28:29 +0200
X-Google-Sender-Auth: tu9kKb_CAlG3fKWO6PJ8avSJNFo
Message-ID: <CADMYwHxLtAZZMUGX3jo0URAezqGuho5XB=hQJp8k+acBiENrhg@mail.gmail.com>
Subject: Re: [RFC 5/7] soc: qcom: Add Shared Memory Driver
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Thanks Kevin for the heads up on this]

Hi Bjorn,

On Tue, Sep 30, 2014 at 3:34 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
> == Codeaurora implementation ==
> The codeaurora implementation originates from an implementation that was based purely on initcall and global state

Do you refer to the in-tree arch/arm/mach-msm/smd.c ? it seems similar
in some ways to the newly proposed smd driver.

> == RPMSG ==
>
> The rpmsg_driver fits nicely into what I want to do, so that could be used
> straight off. Data is transmitted by calling rpmsg_send() and incoming data is
> delivered through the registered callback on a channel.  It's possible to
> request additional channels for a rpmsg device, although this is probably never
> tested as there is no way to send data on this additional endpoint.

This is inaccurate - rpmsg does have offchannel sending API, some of
which are being used by the rpmsg core itself. Please check out
rpmsg_sendto() and rpmsg_send_offchannel().

> Endpoints are sort of equivalent of a smd channel although the life cycle is
> slightly different, but a major issue with the rpmsg interface is that channels
> are identified by a single u32, while SMD channels are identified by a u32 and
> the channel name.

Honestly this sounds like a small technical difference that can
probably be fixed with some effort. Rpmsg is designed to satisfy the
requirements of its current users, and is not set in stone. Not even
the wire protocol is.

If another requirement shows up, we can adopt rpmsg so new users could
use it instead of merging additional frameworks that basically do the
same thing.

But new requirements must be well described so we can technically be
convinced a core change is indeed needed.

> So to be able to use the rpmsg api we would need to create additional apis that
> handles the custom address format of the smd channels. Furthermore all the "off
> channel" functions would be invalid.
> Furthermore most of the channel and endpoint structures would be "invalid".

Not sure I'm following this one. Can you please explain the smd
addressing? what part of it is set in stone and what part of it can
still be changed?

> But these are the problems with the actual api, rpmsg is not only the api. It's
> a direct implementation of these functions, defining how services are
> discovered, how channels are represented as well as the actual "wire" protocol.
>
> Or to put it in another way: rpmsg is an implementation of a packet protocol
> on-top of virtio, it is not a framework or api for abstracting packet transport
> logic.

This is inaccurate. If there's justification for another wire
protocol, it can be added. Even virtio itself was once only an
abstraction over the virtqueue wire protocol:

commit 7c5e9ed0c84e7d70d887878574590638d5572659
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Mon Apr 12 16:19:07 2010 +0300

    virtio_ring: remove a level of indirection

    We have a single virtqueue_ops implementation,
    and it seems unlikely we'll get another one
    at this point. So let's remove an unnecessary
    level of indirection: it would be very easy to
    re-add it if another implementation surfaces.

    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

> As there are discussions regarding replacing SMD with a new wire protocol, it
> would probably be convenient to create a generic version of my proposed "api"
> that can be re-used between different implementations and hopefully provide
> re-use of parts of the code. Maybe we can make rpmsg an implementation under
> such a generic api.

If the SMD wire protocol can still be changed that's great. Why don't
you pick up the vrings structures and play with it? You then get rpmsg
for free. If some of the APIs aren't exactly what you need, please
explain and we could change it to fit your requirements.

It's always easier to merge new code rather than understand the
existing one and change it to fit all users, but usually it just means
more work later.

Thanks,
Ohad.
