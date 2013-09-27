Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3I0OWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:22:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab3I0OWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:22:05 -0400
Date: Fri, 27 Sep 2013 11:21:34 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        libvir-list@redhat.com, Jiri Denemark <jdenemar@redhat.com>
Subject: Re: [PATCH 1/6] kvm: Add KVM_GET_EMULATED_CPUID
Message-ID: <20130927142100.GB2840@otherpad.lan.raisama.net>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <1379861095-628-2-git-send-email-bp@alien8.de>
 <20130923162856.GC7264@otherpad.lan.raisama.net>
 <2f5d83d4d90ba9c5930f099d6f73e61b.squirrel@www.skyhub.de>
 <20130924100414.GE17294@redhat.com>
 <20130926141915.GV2840@otherpad.lan.raisama.net>
 <20130926185524.GA10123@pd.tnic>
 <20130926192059.GD10924@otherpad.lan.raisama.net>
 <20130926203206.GB10123@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926203206.GB10123@pd.tnic>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 10:32:06PM +0200, Borislav Petkov wrote:
> On Thu, Sep 26, 2013 at 04:20:59PM -0300, Eduardo Habkost wrote:
> > Please point me to the code that does this, because I don't see it on
> > patch 6/6.
> 
> @@ -1850,7 +1850,14 @@ static void filter_features_for_kvm(X86CPU *cpu)
>                                                               wi->cpuid_ecx,
>                                                               wi->cpuid_reg);
>          uint32_t requested_features = env->features[w];
> +
> +        uint32_t emul_features = kvm_arch_get_emulated_cpuid(s, wi->cpuid_eax,
> +                                                                wi->cpuid_ecx,
> +                                                                wi->cpuid_reg);
> +
>          env->features[w] &= host_feat;
> +        env->features[w] |= (requested_features & emul_features);
> 
> Basically we give the requested_features a second chance here.
> 
> If we don't request an emulated feature, it won't get enabled.

The problem here is that "requested_features" doesn't include just the
explicit "+flag" flags, but any flag included in the CPU model
definition. See the "-cpu n270" example below.

> 
> > > If you start with "-cpu Haswell", MOVBE
> > > will be already set in the host CPUID.
> > > 
> > > Or am I missing something?
> > 
> > In the Haswell example, it is unlikely but possible in theory: you would
> > need a CPU that supported all features from Haswell except movbe. But
> > what will happen if you are using "-cpu n270,enforce" on a SandyBridge
> > host?
> 
> That's an interesting question: AFAICT, it will fail because MOVBE is
> not available on the host, right?

It should, but your patch will make it stop failing because of MOVBE, as
now it can be emulated[1].

> 
> And if so, then this is correct behavior IMHO, or how exactly is the
> "enforce" thing supposed to work? Enforce host CPUID?

"enforce" makes sure all features are really being enabled. It makes
QEMU abort if there's any feature that can't be enabled on that host.


[1] Maybe one source of confusion is that the existing code have two
feature-filtering functions doing basically the same thing:
filter_features_for_kvm() and kvm_check_features_against_host().  That's
something we must clean up, and they should be unified. "enforce" should
become synonymous to "make sure filtered_features is all zeroes".  This
way, libvirt can emulate what 'enforce" does while being able to collect
detailed error information (which is not easy to do if QEMU simply
aborts).


> 
> > Also, we don't know anything about future CPUs or future features
> > that will end up on EMULATED_CPUID. The current code doesn't have
> > anything to differentiate features that were already included in the
> > CPU definition and ones explicitly enabled in the command-line (and I
> > would like to keep it that way).
> 
> Ok.
> 
> > And just because a feature was explicitly enabled in the command-line,
> > that doesn't mean the user believe it is acceptable to get it running
> > in emulated mode. That's why I propose a new "emulate" flag, to allow
> > features to be enabled in emulated mode.
> 
> And I think, saying "-cpu ...,+movbe" is an explicit statement enough to
> say that yes, I am starting this guest and I want MOVBE emulation.

Not necessarily. libvirt has some code that will translate its own CPU
model definition to a "-cpu Model,+flag,+flag,+flag,-flag" command-line
when necessary. It is by design that there is no difference between
explicit "+flag" options and existing flags from the CPU model
definition. 

> 
> > Well, x2apic is emulated by KVM, and it is on SUPPORTED_CPUID. Ditto
> > for tsc-deadline. Or are you talking specifically about instruction
> > emulation?
> 
> Basically, I'm viewing this from a very practical standpoint - if I
> build a kernel which requires MOVBE support but I cannot boot it in kvm
> because it doesn't emulate MOVBE (TCG does now but it didn't before)
> I'd like to be able to address that shortcoming by emulating that
> instruction, if possible.
> 
> And the whole discussion grew out from the standpoint of being able to
> emulate stuff so that you can do quick and dirty booting of kernels but
> not show that emulation capability to the wide audience since it is slow
> and it shouldn't be used and then migration has issues, etc, etc.
> 
> But hey, I don't really care all that much if I have to also say
> -emulate in order to get my functionality.

OK, I undestand your use case, now. Thanks for your explanation.

-- 
Eduardo
