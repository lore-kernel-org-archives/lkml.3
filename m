Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760531Ab3D3MR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 08:17:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58170 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760419Ab3D3MR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 08:17:28 -0400
Date: Tue, 30 Apr 2013 14:17:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH/RFC 0/4] dmaengine: add DT support for DMA multiplexers
In-Reply-To: <20130430104354.GF1960@intel.com>
Message-ID: <Pine.LNX.4.64.1304301405510.1489@axis700.grange>
References: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
 <20130430104354.GF1960@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:umUJaACZNUXihdmpaVIGJdIB7/hSpTtruO9RgL/7xxD
 Apk0EV1HMqieLMtrY2LVcnK7SeilAapT6p33lU/vnQfWJvSqa/
 ZURVpL4WmAygRSfQJh/UzcYa571/nVsFwXDxak61BlaHKMrgo5
 YYgTZAQxZi2yuslL7zPBGzc/muyfXjplD/mX1pcug1cwHHloNg
 J5JrY6N3j6iZkDz7QHVJZ/QjI+g8Wnt4rXmeJBq92q13Z3yWmZ
 xn1d+qHttEFoYq7hlIzf+Pi9gd2Y5nnTibqCRNQ08XLA1rSR1+
 tNqsH+ydSIg/4UYLpqidGQoFfgVJMhNlTFRQhW+/WLSagN+KrO
 mFSSKOlCX3iT/PgY53xhut5U+QnlWH4lQWpbmcV6btlv/fMh3F
 v4dBB0OLfPAbQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(added Russell to CC, sorry for not including initially)

Hi Vinod

On Tue, 30 Apr 2013, Vinod Koul wrote:

> On Tue, Apr 30, 2013 at 09:11:19AM +0200, Guennadi Liakhovetski wrote:
> > Previously an issue has been discussed, arising on sh-/r-mobile ARM-based 
> > systems. There we typically have multiple DMA controller instances with 
> > exactly equal or very similar capabilities. Each of them can serve the same 
> > slaves, using the same slave identifiers (request line IDs). With the 
> > present DMA DT implementation _each_ such DMA slave would have to reference 
> > _each_ of those DMA controllers in its DMA bindings, e.g.
> But why... if that is the case then we havent define DT-bindings clearly enough

Sorry, what do you mean "why?" Why each slave has to reference each DMA 
controller? We have discussed this A LOT before... My understanding is, 
that we decided, that the sh-/r-mobile case of multiple equal DMA 
controllers is an exception and that we don't want to punish everyone for 
it. So, the design includes only explicit requesting of specific DMA 
request lines on specific DMA controllers, no wild-cards. If a slave DMA 
channel can be provided by several DMA controllers we decided to list them 
all explicitly too. And for the sh-/r-mobile case a DMA-mux DT node has 
been proposed. This is exactly what this patch series is implementing. Is 
my understanding wrong?

> And we havent merged that yet, so why not fix that in first set itself

Sorry, don't understand. The series isn't merged yet, that's right. That's 
why I explicitly mention this dependency here. But this isn't a fix. This 
is a new feature. The first patch-series only touches a specific DMA 
controller driver and relevant platforms. No core changes, so, it's not 
that intrusive and can be applied quickly. Whereas this series affects the 
core and might need a more careful consideration, discussion, etc.

Thanks
Guennadi

> --
> ~Vinod
> > 
> > 	mmc0: mmc@10000000 {
> > 		...
> > 		dmas = <&dma0 0x10
> > 			&dma1 0x10
> > 			&dma2 0x10
> > 			&dma3 0x10
> > 			&dma0 0x11
> > 			&dma1 0x11
> > 			&dma2 0x11
> > 			&dma3 0x11>;
> > 		dma-names = "tx", "tx", "tx", "tx",
> > 			"rx", "rx", "rx", "rx";
> > 	};
> > 
> > Which certainly isn't pretty. To avoid such redundancy it has been proposed 
> > to implement a DMA multiplexer DT node. That way slaves would just 
> > reference the multiplexer and one of DMA controller instances in it would 
> > be picked up automatically to provide DMA channels to slaves. Patches 1-3 
> > in this series propose such an implementation. Patch 4 is just a minor 
> > clean up, can be applied independently.
> > 
> > Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > 
> > Guennadi Liakhovetski (4):
> >   OF: add a new phandle parsing function for grouped nodes
> >   dmaengine: add support for DMA multiplexer DT nodes
> >   ARM: shmobile: move r8a7740 DMA controller DT node under a "dma-mux"
> >     node
> >   OF: modify function stubs to match proper function declarations.
> > 
> >  Documentation/devicetree/bindings/dma/dma.txt      |   44 ++++++++++++++++++++
> >  .../boot/dts/r8a7740-armadillo800eva-reference.dts |   12 +++---
> >  arch/arm/boot/dts/r8a7740.dtsi                     |   43 +++++++++++--------
> >  drivers/dma/of-dma.c                               |   39 +++++++++++++----
> >  drivers/of/base.c                                  |   28 +++++++++++-
> >  include/linux/of.h                                 |   20 ++++++++-
> >  6 files changed, 147 insertions(+), 39 deletions(-)
> > 
> > -- 
> > 1.7.2.5
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
