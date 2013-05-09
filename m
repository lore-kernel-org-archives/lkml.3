Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3EIXoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:44:11 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:36975 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3EIXoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 19:44:08 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1368128020.git.luto@amacapital.net>
References: <cover.1368128020.git.luto@amacapital.net>
Date: Thu, 9 May 2013 19:44:07 -0400
Message-ID: <CAH3drwa_ypKKqZ8eayeR4fA4Ounj55R3R9y0_b5crp99YMFQ=w@mail.gmail.com>
Subject: Re: [RFC/PATCH v2 0/8] Clean up write-combining MTRR addition
From: Jerome Glisse <j.glisse@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 3:46 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> A fair number of drivers (mostly graphics) add write-combining MTRRs.
> Most ignore errors and most add the MTRR even on PAT systems which don't
> need to use MTRRs.

This comment is wrong, as i said we need MTRR on PAT system for VRAM.

Cheers,
Jerome

> This series adds new functions arch_phys_wc_{add,del} that, on PAT-less
> x86 systems with MTRRs, add MTRRs and report errors, and that do nothing
> otherwise.  (Other architectures, if any, with a similar mechanism could
> implement them.)
>
> I've only tested the radeon driver, since I don't have test hardware
> easily available for the other drivers.
>
> Benefits include:
>  - Simpler code
>  - No more complaints about MTRR conflict warnings on PAT systems
>  - Eventual unexporting of the MTRR API?
>
> This series eliminates about half of the mtrr_add calls in drivers/.
>
> Changes from v1:
>  - Helpers renamed
>  - Lots of bugs fixed
>
> The series is also at:
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=mtrr_cleanup/rfc_v2
>
> Andy Lutomirski (8):
>   Add arch_phys_wc_{add,del} to manipulate WC MTRRs if needed
>   drm (ast,cirrus,mgag200,nouveau,savage,vmwgfx): Remove
>     drm_mtrr_{add,del}
>   drm: Update drm_addmap and drm_mmap to use PAT WC instead of MTRRs
>   drm,agpgart: Use pgprot_writecombine for AGP maps and make the MTRR
>     optional
>   i915: Use arch_phys_wc_{add,del}
>   radeon: Switch to arch_phys_wc_add and add a missing ..._del
>   uvesafb: Clean up MTRR code
>   drm: Remove mtrr_add and mtrr_del fallback hack for non-MTRR systems
>
>  Documentation/fb/uvesafb.txt           | 16 +++-----
>  arch/x86/include/asm/io.h              |  7 ++++
>  arch/x86/include/asm/mtrr.h            |  5 ++-
>  arch/x86/kernel/cpu/mtrr/main.c        | 48 +++++++++++++++++++++++
>  drivers/char/agp/frontend.c            |  8 ++--
>  drivers/gpu/drm/ast/ast_ttm.c          | 13 ++-----
>  drivers/gpu/drm/cirrus/cirrus_ttm.c    | 15 ++------
>  drivers/gpu/drm/drm_bufs.c             | 17 +++++----
>  drivers/gpu/drm/drm_pci.c              |  8 ++--
>  drivers/gpu/drm/drm_stub.c             | 10 +----
>  drivers/gpu/drm/drm_vm.c               | 22 +++++------
>  drivers/gpu/drm/i915/i915_dma.c        | 44 +++------------------
>  drivers/gpu/drm/mgag200/mgag200_ttm.c  | 14 ++-----
>  drivers/gpu/drm/nouveau/nouveau_ttm.c  | 13 ++-----
>  drivers/gpu/drm/radeon/radeon_object.c |  5 ++-
>  drivers/gpu/drm/savage/savage_bci.c    | 43 ++++++++-------------
>  drivers/gpu/drm/savage/savage_drv.h    |  5 +--
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c    | 10 ++---
>  drivers/video/uvesafb.c                | 70 +++++++++-------------------------
>  include/drm/drmP.h                     | 34 +----------------
>  include/drm/drm_os_linux.h             | 16 --------
>  include/linux/io.h                     | 25 ++++++++++++
>  include/video/uvesafb.h                |  1 +
>  23 files changed, 181 insertions(+), 268 deletions(-)
>
> --
> 1.8.1.4
>
