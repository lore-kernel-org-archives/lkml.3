Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbaH1OVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:21:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59318 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750858AbaH1OVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:21:03 -0400
Date: Thu, 28 Aug 2014 16:21:00 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
Subject: Re: [PATCH v4 00/11] drm: add support for Atmel HLCDC Display
 Controller
Message-ID: <20140828162100.71543859@bbrezillon>
In-Reply-To: <1805054.en0m884lPo@avalon>
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com>
	<1997793.CWhjU3F32E@avalon>
	<20140827095235.20334e2d@bbrezillon>
	<1805054.en0m884lPo@avalon>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Thu, 28 Aug 2014 14:19:22 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Boris,

[...]

> >
> > I don't have any VGA connector (or I'm missing something :-)),
> 
> My bad.

No problem.

> 
> > but I have an LCD panel and an RGB to HDMI encoder connected on the same RGB
> > connector.
> 
> There's no such thing as an RGB connector in DRM. Your SoC has a parallel RGB 
> video output (I assume it's a DPI bus). From a DRM point of view, that bus 
> corresponds to the output of the CRTC.

Okay, this mean I'll have to dispatch some of the code I've put in
atmel_hlcdc_output.c into atmel_hlcdc_crtc.c (BTW, any chance you could
take a look at this files ?).

> 
> > > As DRM hardcodes the pipeline model to CRTC -> encoder -> connector, you
> > > will also need a DRM encoder in the VGA path. I suppose your board has a
> > > VGA DAC, that's the component you should expose as a DRM encoder (even if
> > > it can't be controlled and doesn't limit the valid modes).
> > 
> > Actually, my problem is that both devices are connected on the same RGB
> > connector, and thus share the same display mode (resolution, HSYNC,
> > VSYNC, RGB output mode, ...).
> > This means that all remote devices have to agree on a specific mode if
> > we want to mirror the display on several output devices, otherwise we
> > must disable one of the output devices.
> 
> That's not really a problem. From a DRM perspective you need to model your 
> device as
> 
> ,------.       ,---------------.       ,-----------------.
> | CRTC | -+--> | Dummy Encoder | ----> | Panel Connector |
> `------´  |    `---------------´       `-----------------´
>           |    ,---------------.       ,-----------------.
>           \--> | HDMI Encoder  | ----> | HDMI Connector  |
>                `---------------´       `-----------------´
> 
> The HDMI pipeline is pretty straightforward.
> 
> You have told me that the panel has a parallel RGB input without any encoder 
> in the panel pipeline (by the way, which panel model are you using ?). 
> However, DRM requires an encoder in every pipeline. You will thus need to 
> instantiate a dummy encoder. One option would be to set the encoder and 
> connector types to DRM_MODE_ENCODER_LVDS and DRM_MODE_CONNECTOR_LVDS 
> respectively, as that's what userspace usually expects for panels. That 
> doesn't reflect the reality in your case though, so creating a new 
> DRM_MODE_CONNECTOR_DPI type might be needed, possibly to be used with 
> DRM_MODE_ENCODER_NONE.
> 
> As neither encoder can modify the mode, the same mode will be output on the 
> two connectors.

There are still several things to I'd like to understand:
 1) who's gonna configure the RGB bus output format (RGB444, RGB666,
    RGB888) which directly depends on the device connected on this bus:
    the CRTC or the dummy and HDMI encoders.
 2) Where should the HDMI encoder/connector support be implemented:
    in drivers/gpu/drm/atmel-hlcdc, drivers/gpu/drm/bridge or somewhere
    else. My point is that I don't want to add specific support for the
    Sil902x transmitter chip in the hlcdc driver.

Sorry if these are silly questions, but I'm still trying to understand
how my case should be modeled :-).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
