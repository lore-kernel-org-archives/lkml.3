Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbaDBNwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:52:39 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:41876 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758595AbaDBNwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:52:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140324223444.GF17218@mithrandir>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-7-git-send-email-acourbot@nvidia.com> <20140324223444.GF17218@mithrandir>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 2 Apr 2014 22:52:16 +0900
Message-ID: <CAAVeFuKezGqPnmi=XJW1FrL-3e8hyqdjuY83VEh496SLm+0mFQ@mail.gmail.com>
Subject: Re: [PATCH 06/12] drm/nouveau/ibus: add GK20A support
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 7:34 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Mar 24, 2014 at 05:42:28PM +0900, Alexandre Courbot wrote:
> [...]
>> diff --git a/drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c b/drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c
> [...]
>> +#include <subdev/ibus.h>
>> +
>> +struct nvea_ibus_priv {
>> +     struct nouveau_ibus base;
>> +};
>> +
>> +static void
>> +nvea_ibus_init_priv_ring(struct nvea_ibus_priv *priv)
>> +{
>> +     nv_mask(priv, 0x137250, 0x3f, 0);
>> +
>> +     nv_mask(priv, 0x000200, 0x20, 0);
>> +     udelay(20);
>
> usleep_range()?

Sure.

>
>> +static void
>> +nvea_ibus_intr(struct nouveau_subdev *subdev)
>> +{
> [...]
>> +     /* Acknowledge interrupt */
>> +     nv_mask(priv, 0x12004c, 0x2, 0x2);
>> +
>> +     while (--retry >= 0) {
>> +             command = nv_rd32(priv, 0x12004c) & 0x3f;
>> +             if (command == 0)
>> +                     break;
>> +     }
>> +
>> +     if (retry < 0)
>> +             nv_warn(priv, "timeout waiting for ringmaster ack\n");
>> +}
>
> Perhaps I'm being paranoid, but this loop now depends on the frequency
> of the various clocks involved and therefore might break at some point
> if the frequencies get sufficiently high.
>
> So a slightly safer implementation would use a proper timeout using a
> combination of msecs_to_jiffies(), time_before() and usleep_range(),
> like so:
>
>         timeout = jiffies + msecs_to_jiffies(...);
>
>         while (time_before(jiffies, timeout)) {
>                 command = nv_rd32(...) & 0x3f;
>                 if (command == 0)
>                         break;
>
>                 usleep_range(...);
>         }
>
>         if (time_after(jiffies, timeout))
>                 nv_warn(...);

Right, now that I look at this code again I don't even understand why
I left it this way. Maybe I left some early test code slip into the
final patch, sorry about that.

> This assumes that there's some known timeout after which the ringmaster
> is expected to have acked the interrupt. On that note, I wonder if the
> warning is accurate here: it's my understanding that writing 0x2 to the
> register does acknowledge the interrupt, so the ringmaster does in fact
> "clear" it rather than "acknowledge" it, doesn't it?
>
> Although now that I mention it I seem to remember that this write is
> actually sending a command to the ring master and perhaps waiting for
> the register to return to 0 is indeed waiting for an ACK of sorts. Maybe
> adding a comment or so describing what this sequence does would be
> appropriate here?

Can we from an IP point of view? AFAIK this sequence has never been
publicly documented.
