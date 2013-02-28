Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3B1KYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:24:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab3B1KYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:24:01 -0500
Message-ID: <512F223B.4080801@redhat.com>
Date: Thu, 28 Feb 2013 10:24:11 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 02/16] virtio_ring: virtqueue_add_sgs, to add multiple
 sgs.
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-3-git-send-email-rusty@rustcorp.com.au> <20130224221255.GA5300@redhat.com> <512C5E0E.5040305@redhat.com> <87obf6dxlm.fsf@rustcorp.com.au> <20130227074920.GA11775@redhat.com> <87fw0idmu2.fsf@rustcorp.com.au>
In-Reply-To: <87fw0idmu2.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 27/02/2013 12:21, Rusty Russell ha scritto:
>>> >> Baseline (before add_sgs):
>>> >>         2.840000-3.040000(2.927292)user
>>> >> 
>>> >> After add_sgs:
>>> >>         2.970000-3.150000(3.053750)user
>>> >> 
>>> >> After simplifying add_buf a little:
>>> >>         2.950000-3.210000(3.081458)user
>>> >> 
>>> >> After inlining virtqueue_add/vring_add_indirect:
>>> >>         2.920000-3.150000(3.026875)user
>>> >> 
>>> >> After passing in iteration functions (chained vs unchained):
>>> >>         2.760000-2.970000(2.883542)user
> Oops.  This result (and the next) is bogus.  I was playing with -O3, and
> accidentally left that in :(

Did you check what actually happened that improved speed so much?  Can
we do it ourselves, or use a GCC attribute to turn it on?  Looking at
the GCC manual and source, there's just a bunch of optimizations enabled
by -O3:

    { OPT_LEVELS_3_PLUS, OPT_ftree_loop_distribute_patterns, NULL, 1 },

`-ftree-loop-distribute-patterns'
     This pass distributes the initialization loops and generates a
     call to memset zero.  For example, the loop

Doesn't matter.

    { OPT_LEVELS_3_PLUS, OPT_fpredictive_commoning, NULL, 1 },

Also doesn't matter.

    { OPT_LEVELS_3_PLUS, OPT_funswitch_loops, NULL, 1 },

Can be done by us at the source level.

    { OPT_LEVELS_3_PLUS, OPT_ftree_vectorize, NULL, 1 },

Probably doesn't matter.

    { OPT_LEVELS_3_PLUS, OPT_fipa_cp_clone, NULL, 1 },

`-fipa-cp-clone'
     Perform function cloning to make interprocedural constant
     propagation stronger.  When enabled, interprocedural constant
     propagation will perform function cloning when externally visible
     function can be called with constant arguments.

Can be done by adding new external APIs or marking functions as
always_inline.

    { OPT_LEVELS_3_PLUS, OPT_fgcse_after_reload, NULL, 1 },

`-fgcse-after-reload'
     When `-fgcse-after-reload' is enabled, a redundant load elimination
     pass is performed after reload.  The purpose of this pass is to
     cleanup redundant spilling.

Never saw it have any substantial effect.

    { OPT_LEVELS_3_PLUS_AND_SIZE, OPT_finline_functions, NULL, 1 },

Can be done by us simply by adding more "inline" keywords.

Plus, -O3 will make *full* loop unrolling a bit more aggressive.  But
full loop unrolling requires compile-time-known loop bounds, so I doubt
this is the case.

Paolo
