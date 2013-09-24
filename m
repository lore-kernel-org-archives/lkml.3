Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3IXKEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:04:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab3IXKEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:04:32 -0400
Date: Tue, 24 Sep 2013 13:04:14 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Eduardo Habkost <ehabkost@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCH 1/6] kvm: Add KVM_GET_EMULATED_CPUID
Message-ID: <20130924100414.GE17294@redhat.com>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <1379861095-628-2-git-send-email-bp@alien8.de>
 <20130923162856.GC7264@otherpad.lan.raisama.net>
 <2f5d83d4d90ba9c5930f099d6f73e61b.squirrel@www.skyhub.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f5d83d4d90ba9c5930f099d6f73e61b.squirrel@www.skyhub.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 11:57:00AM +0200, Borislav Petkov wrote:
> On Mon, September 23, 2013 6:28 pm, Eduardo Habkost wrote:
> > On Sun, Sep 22, 2013 at 04:44:50PM +0200, Borislav Petkov wrote:
> >> From: Borislav Petkov <bp@suse.de>
> >>
> >> Add a kvm ioctl which states which system functionality kvm emulates.
> >> The format used is that of CPUID and we return the corresponding CPUID
> >> bits set for which we do emulate functionality.
> >
> > Let me check if I understood the purpose of the new ioctl correctly: the
> > only reason for GET_EMULATED_CPUID to exist is to allow userspace to
> > differentiate features that are native or that are emulated efficiently
> > (GET_SUPPORTED_CPUID) and features that are emulated not very
> > efficiently (GET_EMULATED_CPUID)?
> 
> Not only that - emulated features are not reported in CPUID so they
> can be enabled only when specifically and explicitly requested, i.e.
> "+movbe". Basically, you want to emulate that feature for the guest but
> only for this specific guest - the others shouldn't see it.
> 
> > If that's the case, how do we decide how efficient emulation should be,
> > to deserve inclusion in GET_SUPPORTED_CPUID? I am guessing that the
> > criterion will be: if enabling it doesn't risk making performance worse,
> > it can get in GET_SUPPORTED_CPUID.
> 
> Well, in the MOVBE case, supported means, the host can execute this
> instruction natively. Now, you guys say you can emulate x2apic very
> efficiently and I'm guessing emulating x2apic doesn't bring any
> emulation overhead, thus SUPPORTED_CPUID.
x2apic emulation has nothing to do with x2apic in a host. It is emulated
same way no matter if host has it or not. x2apic is not really cpu
feature, but apic one and apic is fully emulated by KVM anyway.

> 
> But for single instructions or group of instructions, the distinction
> should be very clear.
> 
> At least this is how I see it but Gleb probably can comment too.
> 
That's how I see it two. Basically you want to use movbe emulation (as
opposite of virtualization) only if you have binary kernel that compiled
for CPU with movbe (Borislav's use case), or you want to migrate
temporarily from movbe enabled host to non movbe host because downtime
is not an option. We should avoid enabling it "by mistake".

--
			Gleb.
