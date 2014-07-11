Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaGKJzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:55:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40638 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaGKJzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:55:04 -0400
Message-ID: <1405072386.4630.9.camel@weser.hi.pengutronix.de>
Subject: Re: [Nouveau] [PATCH v4 2/6] drm/nouveau: map pages using DMA API
 on platform devices
From: Lucas Stach <l.stach@pengutronix.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <skeggsb@gmail.com>, Alexandre Courbot <gnurou@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 11 Jul 2014 11:53:06 +0200
In-Reply-To: <53BF52A0.4070907@nvidia.com>
References: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
		<1404807961-30530-3-git-send-email-acourbot@nvidia.com>
		<20140710125849.GF17271@phenom.ffwll.local>	<53BF4D6B.70904@nvidia.com>
	 <CACAvsv7eER4VmbR81Ym=YE7fQZ9cNuJsb5372SAuSX+PQfYyrQ@mail.gmail.com>
	 <53BF52A0.4070907@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 11.07.2014, 11:57 +0900 schrieb Alexandre Courbot:
[...]
> >> Yeah, I am not familiar with i915 but it seems like we are on a similar boat
> >> here (excepted ARM is more constrained as to its memory mappings). The
> >> strategy in this series is, map buffers used by user-space cached and
> >> explicitly synchronize them (since the ownership transition from user to GPU
> >> is always clearly performed by syscalls), and use coherent mappings for
> >> buffers used by the kernel which are accessed more randomly. This has solved
> >> all our coherency issues and resulted in the best performance so far.
> > I wonder if we might want to use unsnooped cached mappings of pages on
> > non-ARM platforms also, to avoid the overhead of the cache snooping?
> 
> You might want to indeed, now that coherency is guaranteed by the sync 
> functions originally introduced by Lucas. The only issue I could see is 
> that they always invalidate the full buffer whereas bus snooping only 
> affects pages that are actually touched. Someone would need to try this 
> on a desktop machine and see how it affects performance.
> 
> I'd be all for it though, since it would also allow us to get rid of 
> this ungraceful nv_device_is_cpu_coherent() function and result in 
> simplifying nouveau_bo.c a bit.

This will need some testing to get hard numbers, but I suspect that
invalidating the whole buffer isn't to bad as the prefetch machinery
works very well with the access patterns we see in graphics drivers.

Flushing out the whole buffer should be even less problematic, as it
will only flush out dirty lines that would need to be flushed on GPU
read snooping anyways.

In the long run we might want a separate cpu prepare/finish ioctl where
we can indicate the area of interest. This might help to avoid some of
the invalidate overhead especially for userspace suballocated buffers.

Regards,
Lucas

-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

