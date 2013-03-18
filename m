Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3CRTVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:21:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57632 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3CRTVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:21:40 -0400
Date: Mon, 18 Mar 2013 20:24:24 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Sergio Callegari <sergio.callegari@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: Re: Stable kernel 3.8.3 appears to break displayport on intel gen4
Message-ID: <20130318192424.GU9021@phenom.ffwll.local>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	Sergio Callegari <sergio.callegari@gmail.com>,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <51472956.80209@gmail.com>
 <87sj3s4s2g.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sj3s4s2g.fsf@nemi.mork.no>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 04:59:35PM +0100, Bjørn Mork wrote:
> Sergio Callegari <sergio.callegari@gmail.com> writes:
> 
> > This is just a short note to let you know that after installing 3.8.3,
> > display port stopped working on my laptop. Going back to 3.8.2 brought
> > it back to life.
> > This has been tested with the ubuntu mainline kernels that should be
> > vanilla stable kernels. Hope this is not an incorrect report due to
> > something wrong on their side. Laptop is a DELL E6500 with intel gen4
> > integrated graphics (Intel Corporation Mobile 4 Series Chipset
> > Integrated Graphics Controller (rev 07)).
> > With 3.8.3, xrandr does not report anymore the external monitor when
> > it is actually attached via displayport.
> 
> I can confirm seeing this bug on:
> 
> # lspci -nnvvvs 00:02.0
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller [8086:2a42] (rev 07) (prog-if 00 [VGA controller])
>         Subsystem: Lenovo Device [17aa:20e4]
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 45
>         Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=4M]
>         Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
>         Region 4: I/O ports at 1800 [size=8]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>                 Address: fee0300c  Data: 4152
>         Capabilities: [d0] Power Management version 3
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: i915
> 
> 
> 
> Looking through the changes from v3.8.2 to v3.8.3, there weren't really
> that many suspects.  This partial (to avoid having to change any
> following patches) revert of commit 2a98104 ("drm/i915: reorder setup
> sequence to have irqs for output setup") fixes the problem for me.  I
> have no idea why, so I leave it to Daniel and the other wise men working
> on this driver to explain and cleanup :)

Already taken care of hopefully:

http://lists.freedesktop.org/archives/intel-gfx/2013-March/025767.html

My apologies to everyone who's suffering through this breakage, it looks
like I've managed to serious burn myself with an innocent looking stable
backport :(

Yours, Daniel

> 
> 
> ---
>  drivers/gpu/drm/i915/i915_dma.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 5206f24..b15b65d 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1297,21 +1297,19 @@ static int i915_load_modeset_init(struct drm_device *dev)
>  	if (ret)
>  		goto cleanup_vga_switcheroo;
>  
> -	ret = drm_irq_install(dev);
> -	if (ret)
> -		goto cleanup_gem_stolen;
> -
> -	/* Important: The output setup functions called by modeset_init need
> -	 * working irqs for e.g. gmbus and dp aux transfers. */
>  	intel_modeset_init(dev);
>  
>  	ret = i915_gem_init(dev);
>  	if (ret)
> -		goto cleanup_irq;
> +		goto cleanup_gem_stolen;
> +
> +	intel_modeset_gem_init(dev);
>  
>  	INIT_WORK(&dev_priv->console_resume_work, intel_console_resume);
>  
> -	intel_modeset_gem_init(dev);
> +	ret = drm_irq_install(dev);
> +	if (ret)
> +		goto cleanup_gem;
>  
>  	/* Always safe in the mode setting case. */
>  	/* FIXME: do pre/post-mode set stuff in core KMS code */
> 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
