Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaHULyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:54:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbaHULyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:54:19 -0400
Date: Thu, 21 Aug 2014 13:54:05 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 4/6] KVM: VMX: dynamise PLE window
Message-ID: <20140821115405.GD20546@potion.brq.redhat.com>
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
 <1408567997-21222-5-git-send-email-rkrcmar@redhat.com>
 <53F5AD3E.3050800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F5AD3E.3050800@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-21 10:26+0200, Paolo Bonzini:
> Il 20/08/2014 22:53, Radim Krčmář ha scritto:
> > +static int __shrink_ple_window(int val, int shrinker, int minimum)
> 
> s/shrinker/factor/ or s/shrinker/param/ (shrinker has another meaning in
> the kernel).

True, thanks.

> > +{
> > +	if (shrinker < 1)
> > +		return ple_window;
> > +
> > +	if (shrinker < ple_window)
> > +		val /= shrinker;
> > +	else
> > +		val -= shrinker;
> > +
> > +	return max(val, minimum);
> 
> Any reason to use anything but ple_window as the minimum, even in
> update_ple_window_actual_max?

ple_window_actual_max needs to be one grow below the ple_window_max, so
it can be lower than ple_window.

> > +}
> > +
> > +static void modify_ple_window(struct kvm_vcpu *vcpu, int grow)
> > +{
> > +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +	int new;
> > +
> > +	if (grow)
> > +		new = __grow_ple_window(vmx->ple_window);
> > +	else
> > +		new = __shrink_ple_window(vmx->ple_window, ple_window_shrink,
> > +		                          ple_window);
> > +
> > +	vmx->ple_window = max(new, ple_window);
> > +}
> > +#define grow_ple_window(vcpu)   modify_ple_window(vcpu, 1)
> > +#define shrink_ple_window(vcpu) modify_ple_window(vcpu, 0)
> 
> No macros please. :)

Guity as charged.
Using 0/1 or true/false in this context directly would be pretty bad ...
Is enum fine? (SHIRINK_PLE_WINDOW, GROW_PLE_WINDOW?)

(I can always make it into function pointers ;)
