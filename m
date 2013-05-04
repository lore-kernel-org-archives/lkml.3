Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761871Ab3EDRs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 13:48:56 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:45169 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761756Ab3EDRsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 13:48:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130504174555.GT5763@phenom.ffwll.local>
References: <cover.1367621038.git.luto@amacapital.net> <4615b8566e9530e2169a36a5870f1b2eb7e621cd.1367621039.git.luto@amacapital.net>
 <20130504174555.GT5763@phenom.ffwll.local>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 4 May 2013 10:48:33 -0700
Message-ID: <CALCETrXVN_b2T93kMc=342h+1++mjucHS0btir1UZOa3CS+R-g@mail.gmail.com>
Subject: Re: [PATCH 2/7] drm (ast, cirrus, mgag200, nouveau, savage, vmwgfx):
 Rework drm_mtrr_{add, del}
To: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 4, 2013 at 10:45 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Fri, May 03, 2013 at 04:00:30PM -0700, Andy Lutomirski wrote:
>> This replaces drm_mtrr_{add,del} with drm_mtrr_{add,del}_wc.  The
>> interface is simplified (because the base and size parameters to
>> drm_mtrr_del never did anything) and it uses
>> mtrr_{add,del}_wc_if_needed to avoid allocating MTRRs on systems
>> that don't need them.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>
>
> Tbh I'm not a big fan of the drm_ indirection. Historically that was
> useful as an OS abstraction layer so that the same drivers could be used
> unchanged on Linux and the *BSD. But those days are long gone and drm
> drivers are now proper Linux drivers, and generally OS HALs seem to be
> frowned upon.
>
> Is there another reason than just being consistent with the historic stuff
> here? If we need dummy functions for !CONFIG_MTRR I think those should
> simply be in the core.


I admit to a bit of cargo-culting.  There was a layer of indirection,
so I kept it.  I'll just call mtrr_add/del_wc_if_needed directly in v2
(I added those functions in patch 1 of this series).

I'd assume you're okay with skipping mtrr addition if PAT is available
since i915 already does it :)  (Although the current logic is buggy --
cpu_has_pat is the wrong flag to check -- I think pat_enabled is
better.)

Note to self: I should remove #include <asm/pat.h> in i915_dma.c in v2.

--Andy
