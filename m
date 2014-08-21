Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaHUU76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbaHUU74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:59:56 -0400
Date: Thu, 21 Aug 2014 22:59:43 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 4/7] KVM: VMX: dynamise PLE window
Message-ID: <20140821205942.GG20546@potion.brq.redhat.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
 <1408637291-18533-5-git-send-email-rkrcmar@redhat.com>
 <53F6440B.8010709@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F6440B.8010709@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-22 00:40+0530, Raghavendra K T:
> On 08/21/2014 09:38 PM, Radim Krčmář wrote:
> Thanks for the nice patch.
> default of grow = 2 and shrink = 0 is very good, which aids fast
> clamping in overcommit and less ple_exits in undercommit.
> with a small concern over modifier (shrinker) value in patch 6,
> 
> Reviewed-by: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>

Thank you for the review and testing.

> >-#define KVM_VMX_DEFAULT_PLE_GAP    128
> >-#define KVM_VMX_DEFAULT_PLE_WINDOW 4096
> >+#define KVM_VMX_DEFAULT_PLE_GAP           128
> >+#define KVM_VMX_DEFAULT_PLE_WINDOW        4096
> >+#define KVM_VMX_DEFAULT_PLE_WINDOW_GROW   2
> >+#define KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK 0
> >+#define KVM_VMX_DEFAULT_PLE_WINDOW_MAX    \
> >+		INT_MAX / KVM_VMX_DEFAULT_PLE_WINDOW_GROW
> 
> Some observations:
> 
> 1. I think a large ple_window for e.g.,  16MB itself
> would be very large value after which the ple_window change would not
> have much effect.

Agreed, 16M is around 4ms@4GHz, holding a spinlock for that long is
closer to a bug.

> So could KVM_VMX_DEFAULT_PLE_WINDOW_MAX be just
> KVM_VMX_DEFAULT_PLE_WINDOW^2 or something ? or otherwise..

I'd be perfectly content with a high default maximum like this, yet
there isn't much point in having that default at all if we can't reach
it in practice, so with the current default, we are at least ready for
THz+ x86 intels :)

I though about deafaulting it to some guessed fraction of the scheduler
tick, but then, I wanted to merge at least something :)

> How about ..
> define KVM_VMX_DEFAULT_PLE_WINDOW_MAX  = INT_MAX
> /KVM_VMX_DEFAULT_PLE_WINDOW.

= 524288 (2^19), too low IMO,
no-overcommit scenarios seem to go higher quite often.

> (considering we don't allow default grow to be greater than default ple
> window).
> 
> 2. can we consider min_ple_window value of 2k. tracing showed that in
> overcommit there were several occations of 4k <- 4k situations.

Low values are more affected by KVM's overhead on every PLE exit, but
benchmarks really decide this ...

Having a separate ple_window_min would allow more tuning, so I can do
that if there are benefits of lower windows.
On the other hand, I thought that increasing the default window would be
a good default, which would make separate minimum even better.

> 3. Do you think using ( << and >> ) instead of (*, /) saves some cycles
> considering we could have potentially have grow,shrink numbers != power of 2

* takes one or two cycles more than <<, so I wouldn't replace it,
because it limits available grows a lot.
(I don't expect we would set values above 5.)

/ is slow (around ten times slower than *), which the reason why we
avoid it by default, but I still prefer more options.

> >+static int __grow_ple_window(int val)
> >+{
> >+	if (ple_window_grow < 1)
> 
> why not ple_window_grow <= 1 ?

Emergent mini-feature: have different static levels of ple_window, in
combination with dynamic knobs.
(set grow and shrink to 1, choose ple_window before starting a guest)

And because you have to willingly set 1, I'm not aware of any advantage
of '<= 1'.

> >+static int __shrink_ple_window(int val, int modifier, int minimum)
> >+{
> >+	if (modifier < 1)
> 
> why not modifier < 1. May be this would address a concern in patch 6.

"/= 1" gives no shrinking, which I considered as a feature -- you can
easily search for the maximal achievable ple_window that way.
