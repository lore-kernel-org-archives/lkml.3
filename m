Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaHURIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:08:16 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:46580 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaHURIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:08:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-pwm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Clark <robdclark@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Bo Shen <voice.shen@atmel.com>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 00/11] drm: add support for Atmel HLCDC Display Controller
Date: Thu, 21 Aug 2014 19:08:53 +0200
Message-ID: <2138720.5GSxsvjVxS@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20140821150600.37788d82@bbrezillon>
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com> <20140821095202.GA21848@ulmo> <20140821150600.37788d82@bbrezillon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Thursday 21 August 2014 15:06:00 Boris BREZILLON wrote:
> On Thu, 21 Aug 2014 11:52:03 +0200 Thierry Reding wrote:
> > On Thu, Aug 21, 2014 at 11:41:59AM +0200, Boris BREZILLON wrote:
> >> On Thu, 21 Aug 2014 11:04:07 +0200 Thierry Reding wrote:
> >>> On Thu, Aug 21, 2014 at 10:37:06AM +0200, Boris BREZILLON wrote:
> >>>> On Thu, 21 Aug 2014 10:16:19 +0200 Ludovic Desroches wrote:
> >>>>> Hi Boris,
> >>>>> 
> >>>>> You can add
> >>>>> 
> >>>>> Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> >>>> 
> >>>> Thanks for testing this driver.
> >>>> 
> >>>>> Only one issue but not related to your patches, you can't display
> >>>>> quickly the bootup logo since the panel detection takes too much
> >>>>> time.
> >>>> 
> >>>> Yes, actually this is related to the device probe order: the
> >>>> hlcdc-display-controller device is probed before the simple-panel,
> >>>> thus nothing is detected on the RGB connector (I use
> >>>> of_drm_find_panel to check for panel availability) when the display
> >>>> controller is instantiated. I rely on the default polling
> >>>> infrastructure provided by the DRM/KMS framework which polls for a
> >>>> new connector every 10s, and this is far more than you kernel boot
> >>>> time.
> >>>> 
> >>>> Do anyone see a solution to reduce this delay (without changing the
> >>>> polling interval). I thought we could add a notifier infrastructure
> >>>> to the DRM panel framework, but I'm not sure this is how you want
> >>>> things done...
> >>> 
> >>> Other drivers return -EPROBE_DEFER when a panel hasn't been registered
> >>> yet. This will automatically take care of ordering things in a way
> >>> that DRM/KMS will only be initialized after the panel has been probed.
> >> 
> >> Actually I'd like to avoid doing this with a deferred probe, because,
> >> AFAIU, the remote endpoint is not tightly linked with the display
> >> controller driver (I mean the display controller can still be
> >> initialized without having a display connected on it).
> >> Moreover the atmel dev kit I'm using has an HDMI bridge connected on
> >> the same RGB connector and I'd like to use it in a near future.
> >> Returning -EPROBE_DEFER in case of several devices connected on the
> >> same connector implies that I'll have to wait for all the remote
> >> end-points to be available before my display controller could be
> >> instantiated.
> >> 
> >> While this could be acceptable when all drivers are statically linked
> >> in the kernel, it might be problematic when you're using modules,
> >> meaning that you won't be able to display anything on your LCD panel
> >> until your HDMI bridge module has been loaded.
> > 
> > No. HDMI should be using proper hotplugging anyway, hence it should be
> > always be loaded anyway. You're in for a world of pain if you think you
> > can run DRM with a driver that's composed of separate kernel modules.
> 
> I was talking about the external RGB to HDMI encoder, should the driver
> for this encoder (which is not on On Chip block) be compiled
> statically too ?

Given the move to multiplatform kernels we need to aim for as few modules 
compiled in as possible. I'd say this includes HDMI encoders, panels and 
display controllers.

> > Also if you don't want to use deferred probe, then you're in for the
> > full hotplugging panel dance and that implies that you need to fix a
> > bunch of things in DRM (one being the framebuffer console instantiation
> > that I referred to in the other thread).
> 
> For now, I wait until there is a device connected on the RGB connector
> (connector status set to connector_status_connected) before creating an
> fbdev. It might not be the cleanest way to solve this issue, but it
> works :-).

Do you create a new drm_encoder at runtime for the HDMI encoder when it 
appears ? I thought the DRM core and API were not able to correctly cope with 
that.

> > You also can't be using the current device tree bindings because they all
> > assume a dependency from the display controller/output to the panel. For
> > hotplugging you'd need the dependency the other way around (the panel
> > needs to refer to the output by phandle).
> 
> Here [1] is a proposal for notification support in the drm_panel
> infrastructure (which is not that complicated), and here [2] is how
> I use it in my atmel-hlcdc driver to generate hotplug events.

Is there a way we could use the component framework for that ? I know that 
partial notification isn't supported at the moment, but Russell agreed it was 
a real use case that should be implemented at some point.

> Let me know if you want me to submit a proper patch series...
> 
> Best Regards,
> 
> Boris
> 
> [1]http://code.bulix.org/scq4g3-86804
> [2]http://code.bulix.org/7dg501-86805

-- 
Regards,

Laurent Pinchart

