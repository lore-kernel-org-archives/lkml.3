Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3EJJjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:39:07 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:49164 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab3EJJjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:39:04 -0400
Date: Fri, 10 May 2013 11:42:09 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>
Subject: Re: [RFC/PATCH v2 0/8] Clean up write-combining MTRR addition
Message-ID: <20130510094209.GJ12292@phenom.ffwll.local>
Mail-Followup-To: Andy Lutomirski <luto@amacapital.net>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-fbdev@vger.kernel.org, Jerome Glisse <j.glisse@gmail.com>,
	Alex Deucher <alexdeucher@gmail.com>,
	Dave Airlie <airlied@gmail.com>
References: <cover.1368128020.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1368128020.git.luto@amacapital.net>
X-Operating-System: Linux phenom 3.9.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 12:46:19PM -0700, Andy Lutomirski wrote:
> A fair number of drivers (mostly graphics) add write-combining MTRRs.
> Most ignore errors and most add the MTRR even on PAT systems which don't
> need to use MTRRs.
> 
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

With my two comments addressed, the entire series is

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

My knowledge for the userspace driver created drm maps in drm_vm.c is a
bit shoddy. Otoh most of the code I've seen using that is _horribly_
broken (as in userspace creates a register map that the kernel uses, with
no refcounting at all). Your changes look correct though, so I think this
is about as good as it gets.

Yours, Daniel
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

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
