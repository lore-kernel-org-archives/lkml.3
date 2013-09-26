Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3IZTVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:21:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab3IZTVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:21:22 -0400
Date: Thu, 26 Sep 2013 16:20:59 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        libvir-list@redhat.com, Jiri Denemark <jdenemar@redhat.com>
Subject: Re: [PATCH 1/6] kvm: Add KVM_GET_EMULATED_CPUID
Message-ID: <20130926192059.GD10924@otherpad.lan.raisama.net>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <1379861095-628-2-git-send-email-bp@alien8.de>
 <20130923162856.GC7264@otherpad.lan.raisama.net>
 <2f5d83d4d90ba9c5930f099d6f73e61b.squirrel@www.skyhub.de>
 <20130924100414.GE17294@redhat.com>
 <20130926141915.GV2840@otherpad.lan.raisama.net>
 <20130926185524.GA10123@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926185524.GA10123@pd.tnic>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 08:55:24PM +0200, Borislav Petkov wrote:
> On Thu, Sep 26, 2013 at 11:19:15AM -0300, Eduardo Habkost wrote:
> > Then we may have a problem: some CPU models already have "movbe"
> > included (e.g. Haswell), and patch 6/6 will make "-cpu Haswell" get
> > movbe enabled even if it is being emulated.
> 
> Huh? HSW has MOVBE so we won't #UD on it and MOVBE will get executed in
> hardware when executing the guest. IOW, we'll never get to the emulation
> path of piggybacking on the #UD.
> 
> > So if we really want to avoid enabling emulated features by mistake,
> > we may need a new CPU flag in addition to "enforce" to tell QEMU that
> > it is OK to enable emulated features (maybe "-cpu ...,emulate"?).
> 
> EMULATED_CPUID are off by default and only if you request them
> specifically, they get enabled.

Please point me to the code that does this, because I don't see it on
patch 6/6.

> If you start with "-cpu Haswell", MOVBE
> will be already set in the host CPUID.
> 
> Or am I missing something?

In the Haswell example, it is unlikely but possible in theory: you would
need a CPU that supported all features from Haswell except movbe. But
what will happen if you are using "-cpu n270,enforce" on a SandyBridge
host?

Also, we don't know anything about future CPUs or future features that
will end up on EMULATED_CPUID. The current code doesn't have anything to
differentiate features that were already included in the CPU definition
and ones explicitly enabled in the command-line (and I would like to
keep it that way).

And just because a feature was explicitly enabled in the command-line,
that doesn't mean the user believe it is acceptable to get it running in
emulated mode. That's why I propose a new "emulate" flag, to allow
features to be enabled in emulated mode.

> 
> > But my question still stands: suppose we had x2apic emulation
> > implemented but for some reason it was painfully slow, we wouldn't
> > want to enable it by mistake. In this case, it would end up on
> > EMULATED_CPUID and not on SUPPORTED_CPUID, right?
> 
> IMHO we want to enable emulation only when explicitly requested...
> regardless of the emulation performance.

Well, x2apic is emulated by KVM, and it is on SUPPORTED_CPUID. Ditto for
tsc-deadline. Or are you talking specifically about instruction
emulation?

-- 
Eduardo
