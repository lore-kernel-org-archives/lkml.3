Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaHUJmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:42:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42169 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750989AbaHUJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:42:04 -0400
Date: Thu, 21 Aug 2014 11:41:59 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-pwm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Bo Shen <voice.shen@atmel.com>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 00/11] drm: add support for Atmel HLCDC Display
 Controller
Message-ID: <20140821114159.319e741b@bbrezillon>
In-Reply-To: <20140821090406.GA13733@ulmo>
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140821081619.GZ2452@ldesroches-Latitude-E6320>
	<20140821103706.2349915d@bbrezillon>
	<20140821090406.GA13733@ulmo>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014 11:04:07 +0200
Thierry Reding <thierry.reding@gmail.com> wrote:

> On Thu, Aug 21, 2014 at 10:37:06AM +0200, Boris BREZILLON wrote:
> > Hi Ludovic,
> > 
> > On Thu, 21 Aug 2014 10:16:19 +0200
> > Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
> > 
> > > Hi Boris,
> > > 
> > > You can add
> > > 
> > > Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> > 
> > Thanks for testing this driver.
> > 
> > > 
> > > Only one issue but not related to your patches, you can't display
> > > quickly the bootup logo since the panel detection takes too much
> > > time.
> > 
> > Yes, actually this is related to the device probe order: the
> > hlcdc-display-controller device is probed before the simple-panel, thus
> > nothing is detected on the RGB connector (I use of_drm_find_panel to
> > check for panel availability) when the display controller is
> > instantiated. I rely on the default polling infrastructure provided by
> > the DRM/KMS framework which polls for a new connector every 10s, and
> > this is far more than you kernel boot time.
> > 
> > Do anyone see a solution to reduce this delay (without changing the
> > polling interval). I thought we could add a notifier infrastructure to
> > the DRM panel framework, but I'm not sure this is how you want things
> > done...
> 
> Other drivers return -EPROBE_DEFER when a panel hasn't been registered
> yet. This will automatically take care of ordering things in a way that
> DRM/KMS will only be initialized after the panel has been probed.

Actually I'd like to avoid doing this with a deferred probe, because,
AFAIU, the remote endpoint is not tightly linked with the display
controller driver (I mean the display controller can still be
initialized without having a display connected on it).
Moreover the atmel dev kit I'm using has an HDMI bridge connected on
the same RGB connector and I'd like to use it in a near future.
Returning -EPROBE_DEFER in case of several devices connected on the
same connector implies that I'll have to wait for all the remote
end-points to be available before my display controller could be
instantiated.

While this could be acceptable when all drivers are statically linked
in the kernel, it might be problematic when you're using modules,
meaning that you won't be able to display anything on your LCD panel
until your HDMI bridge module has been loaded.

> That
> will still cause some delay before everything gets set up, but hopefully
> less than what you're seeing now. There's also another thread where this
> is being discussed because deferred probing is causing "unacceptable"
> delays as well.

Could you point this thread out to me please ?

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
