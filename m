Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaHTMlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:41:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbaHTMlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:41:22 -0400
Date: Wed, 20 Aug 2014 14:41:12 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 9/9] KVM: VMX: automatic PLE window maximum
Message-ID: <20140820124112.GC28873@potion.brq.redhat.com>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
 <1408480536-8240-10-git-send-email-rkrcmar@redhat.com>
 <53F44B40.6060806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F44B40.6060806@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-20 09:16+0200, Paolo Bonzini:
> Il 19/08/2014 22:35, Radim Krčmář ha scritto:
> > Every increase of ple_window_grow creates potential overflows.
> > They are not serious, because we clamp ple_window and userspace is
> > expected to fix ple_window_max within a second.
> > ---
> I think avoiding overflows is better.  In fact, I think you should call
> this function for ple_window_max too.

(Ack, I just wanted to avoid the worst userspace error, which is why
 PW_max hasn't changed when PW_grow got smaller and we could overflow.)

> You could keep the ple_window_max variable to the user-set value.
> Whenever ple_window_grow or ple_window_max are changed, you can set an
> internal variable (let's call it ple_window_actual_max, but I'm not wed
> to this name) to the computed value, and then do:
> 
> 	if (ple_window_grow < 1 || ple_window_actual_max < ple_window)
> 		new = ple_window;
> 	else if (ple_window_grow < ple_window)
> 		new = max(ple_window_actual_max, old) * ple_window_grow;
> 	else
> 		new = max(ple_window_actual_max, old) + ple_window_grow;

Oh, I like that this can get rid of all overflows, ple_window_actual_max
(PW_effective_max?) is going to be set to
"ple_window_max [/-] ple_window_grow" in v2.

> (I think the || in the first "if" can be eliminated with some creativity
> in clamp_ple_window_max).

To do it, we'll want to intercept changes to ple_window as well.
(I disliked this patch a lot even before :)
