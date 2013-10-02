Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3JBRak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:30:40 -0400
Received: from mout.gmx.net ([212.227.17.22]:49642 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab3JBRah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:30:37 -0400
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>,
        "cancan\,feng" <cancan.feng@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [ 005/117] drm/i915: make user mode sync polarity setting explicit
References: <20130925001740.833541979@linuxfoundation.org>
	<20130925001741.446963782@linuxfoundation.org>
Date: Wed, 02 Oct 2013 19:30:32 +0200
In-Reply-To: <20130925001741.446963782@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Tue, 24 Sep 2013 17:17:51 -0700")
Message-ID: <87r4c3vavb.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K0:9L/mvIoyByZUE6wND75fYGFsDRm8VHnjdzheZprufmPKxFhXHp9
 fJEMv1vC4f5wj8A/Ywmdwit/pRnTZpVItRY9AUneoL6G8/65kv4OGhBJs2XljqNWRe4w7KY
 /caC7e048IJMjwAdwpZX0oOAhdApnvyobPCTjMadPFQE2urJGMJ/YOYI01n2DzJqDZ7os7M
 h83S8GQecZsoLGF8NOeKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-09-25 02:17 +0200, Greg Kroah-Hartman wrote:

> 3.11-stable review patch.  If anyone has any objections, please let me know.

Sorry for being a bit late, I was traveling last week and only upgraded
my kernel yesterday.

> From: Imre Deak <imre.deak@intel.com>
>
> commit 2960bc9cceecb5d556ce1c07656a6609e2f7e8b0 upstream.
>
> Userspace can pass a mode with an unspecified vsync/hsync polarity
> setting. All encoders in the Intel driver take this to mean a negative
> polarity setting. The HW readout/state checker code on the other hand
> needs these flags to be explicitly set, otherwise the state checker will
> WARN about the mismatch.
>
> Get rid of the WARN by making the polarity setting explicit in the
> adjusted mode flags based on the requested mode flags. This will keep
> the existing behavior otherwise.
>
> Note that we could guess from the other timing parameters whether the
> user wanted a VESA or other standard mode and set the polarity
> accordingly. This is what the NV driver does
> (drivers/gpu/drm/nouveau/dispnv04/crtc.c), but I think that's not very
> exact and would change the existing behavior of the Intel driver.
>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=65442
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> Tested-by: cancan,feng <cancan.feng@intel.com>
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/gpu/drm/i915/intel_display.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -7809,6 +7809,19 @@ intel_modeset_pipe_config(struct drm_crt
>  	pipe_config->cpu_transcoder = to_intel_crtc(crtc)->pipe;
>  	pipe_config->shared_dpll = DPLL_ID_PRIVATE;
>  
> +	/*
> +	 * Sanitize sync polarity flags based on requested ones. If neither
> +	 * positive or negative polarity is requested, treat this as meaning
> +	 * negative polarity.
> +	 */
> +	if (!(pipe_config->adjusted_mode.flags &
> +	      (DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_NHSYNC)))
> +		pipe_config->adjusted_mode.flags |= DRM_MODE_FLAG_NHSYNC;
> +
> +	if (!(pipe_config->adjusted_mode.flags &
> +	      (DRM_MODE_FLAG_PVSYNC | DRM_MODE_FLAG_NVSYNC)))
> +		pipe_config->adjusted_mode.flags |= DRM_MODE_FLAG_NVSYNC;
> +
>  	/* Compute a starting value for pipe_config->pipe_bpp taking the source
>  	 * plane pixel format and any sink constraints into account. Returns the
>  	 * source plane bpp so that dithering can be selected on mismatches

After this patch I'm getting a drm error message on my laptop:

,----
| [    0.840472] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags (expected 2, found 0)
| [    0.840533] ------------[ cut here ]------------
| [    0.840583] WARNING: CPU: 0 PID: 66 at drivers/gpu/drm/i915/intel_display.c:8292 check_crtc_state+0x5f4/0x64a [i915]()
| [    0.840585] pipe state doesn't match!
| [    0.840587] Modules linked in: b44(+) mii sg sr_mod cdrom ssb ehci_pci(+) uhci_hcd ehci_hcd usbcore i915(+) cfbfillrect cfbimgblt video backlight usb_common thermal i2c_algo_bit cfbcopyarea drm_kms_helper drm button i2c_core
| [    0.840610] CPU: 0 PID: 66 Comm: modprobe Not tainted 3.11.3-kms #1
| [    0.840613] Hardware name: Acer             TravelMate 2490 /Grapevine, BIOS V3.00 10/17/2006
| [    0.840616]  00000000 ddabb884 c101d20e 00002064 e011e074 ddbcc000 dd9ca400 ddacc000
| [    0.840622]  ddabb89c c101d249 00000009 ddabb894 e01553ed ddabb8b0 ddabbaf0 e011e074
| [    0.840627]  e0154612 00002064 e01553ed dd9ca66c ddbcc640 ddacc000 0000000a c1340bfc
| [    0.840633] Call Trace:
| [    0.840643]  [<c101d20e>] ? warn_slowpath_common+0x5e/0x73
| [    0.840680]  [<e011e074>] ? check_crtc_state+0x5f4/0x64a [i915]
| [    0.840685]  [<c101d249>] ? warn_slowpath_fmt+0x26/0x2a
| [    0.840721]  [<e011e074>] ? check_crtc_state+0x5f4/0x64a [i915]
| [    0.840765]  [<e0126d2a>] ? intel_modeset_check_state+0x305/0x54d [i915]
| [    0.840803]  [<e0126fe0>] ? intel_set_mode+0x21/0x2a [i915]
| [    0.840841]  [<e0127d13>] ? intel_get_load_detect_pipe+0x295/0x2e9 [i915]
| [    0.840884]  [<e013ef89>] ? intel_tv_detect+0xc6/0x3b1 [i915]
| [    0.840893]  [<dfef84c4>] ? drm_helper_probe_single_connector_modes+0x97/0x265 [drm_kms_helper]
| [    0.840900]  [<dfef6260>] ? drm_fb_helper_probe_connector_modes+0x32/0x40 [drm_kms_helper]
| [    0.840907]  [<dfef76b9>] ? drm_fb_helper_initial_config+0x148/0x3a9 [drm_kms_helper]
| [    0.840940]  [<e010b6e1>] ? i915_driver_load+0x912/0xa60 [i915]
| [    0.840959]  [<dff890b9>] ? drm_get_pci_dev+0x12e/0x20e [drm]
| [    0.840966]  [<c1129620>] ? pci_device_probe+0x4c/0x83
| [    0.840974]  [<c118bdf1>] ? driver_probe_device+0x7b/0x16d
| [    0.840979]  [<c118bf4f>] ? __driver_attach+0x44/0x5f
| [    0.840984]  [<c118ac13>] ? bus_for_each_dev+0x50/0x5a
| [    0.840988]  [<c118ba8a>] ? driver_attach+0x14/0x17
| [    0.840993]  [<c118bf0b>] ? __device_attach+0x28/0x28
| [    0.840997]  [<c118b785>] ? bus_add_driver+0xc1/0x1b6
| [    0.841002]  [<c118c300>] ? driver_register+0x70/0xc9
| [    0.841006]  [<e0169000>] ? 0xe0168fff
| [    0.841011]  [<c100039e>] ? do_one_initcall+0x6a/0xdf
| [    0.841018]  [<c104688f>] ? load_module+0x1241/0x172d
| [    0.841023]  [<c101884d>] ? vmalloc_sync_all+0xa8/0xa8
| [    0.841028]  [<c1046ded>] ? SyS_init_module+0x72/0x88
| [    0.841037]  [<c124c220>] ? syscall_call+0x7/0xb
| [    0.841040] ---[ end trace ad1362eaaa8201e6 ]---
`----

See also https://bugs.freedesktop.org/show_bug.cgi?id=65442#c16.

Cheers,
       Sven
