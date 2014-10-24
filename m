Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaJXCdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:33:37 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44586 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaJXCdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:33:35 -0400
MIME-Version: 1.0
In-Reply-To: <20141023074739.GH13512@nuc-i3427.alporthouse.com>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
 <1413991731-20628-4-git-send-email-robert@sixbynine.org> <20141023074739.GH13512@nuc-i3427.alporthouse.com>
From: Robert Bragg <robert@sixbynine.org>
Date: Fri, 24 Oct 2014 03:33:14 +0100
X-Google-Sender-Auth: I8RaR_En1VzQ7rFOezKUAXV0I0A
Message-ID: <CAMou1-3n5pC4C_7x_5oxz0WG3sOifKvG-wCER_5g6VeniEJ=6A@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] i915: Expose PMU for Observation Architecture
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 8:47 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, Oct 22, 2014 at 04:28:51PM +0100, Robert Bragg wrote:
>> +     /* XXX: Not sure that this is really acceptable...
>> +      *
>> +      * i915_gem_context.c currently owns pinning/unpinning legacy
>> +      * context buffers and although that code has a
>> +      * get_context_alignment() func to handle a different
>> +      * constraint for gen6 we are assuming it's fixed for gen7
>> +      * here. Another option besides pinning here would be to
>> +      * instead hook into context switching and update the
>> +      * OACONTROL configuration on the fly.
>> +      */
>> +     if (dev_priv->oa_pmu.specific_ctx) {
>> +             struct intel_context *ctx = dev_priv->oa_pmu.specific_ctx;
>> +             int ret;
>> +
>> +             ret = i915_gem_obj_ggtt_pin(ctx->legacy_hw_ctx.rcs_state,
>> +                                         4096, 0);
>
> Right if you pin it here with a different alignment, when we try to  pin
> it with the required hw ctx alignment it will fail. Easiest way is to
> record the ctx->legacy_hw_ctx.alignment and reuse that here.

Ok I can look into that a bit more. I'm not currently sure I can assume the
ctx will have been pinned before, to be able to record the alignment.
Skimming i915_gem_context.c, it looks like we only pin the default context
on creation and a user could open a perf even before we first switch to that
context.

I wonder if it would be ok to expose an i915_get_context_alignment() api to
deal with this?

>
>> +             if (ret) {
>> +                     DRM_DEBUG_DRIVER("Couldn't pin %d\n", ret);
>> +                     ret = -EBUSY;
>
> As an exercise, think of all the possible error values from pin() and
> tell me why overriding that here is a bad, bad idea.

Hmm, I'm not quite sure why I decided to squash the error code there, it
looks pretty arbitrary. My take on your comment a.t.m is essentially that
some of the pin() errors don't really represent a busy state where it would
make sense for userspace to try again later; such as -ENODEV. Sorry if you
saw a very specific case that offended you :-) I have removed the override
locally.

Thanks for taking a look.

- Robert

> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
