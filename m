Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3I3QN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:13:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab3I3QN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:13:56 -0400
Date: Mon, 30 Sep 2013 13:13:34 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        libvir-list@redhat.com, Jiri Denemark <jdenemar@redhat.com>
Subject: Re: [PATCH 1/6] kvm: Add KVM_GET_EMULATED_CPUID
Message-ID: <20130930161334.GA5831@otherpad.lan.raisama.net>
References: <1379861095-628-2-git-send-email-bp@alien8.de>
 <20130923162856.GC7264@otherpad.lan.raisama.net>
 <2f5d83d4d90ba9c5930f099d6f73e61b.squirrel@www.skyhub.de>
 <20130924100414.GE17294@redhat.com>
 <20130926141915.GV2840@otherpad.lan.raisama.net>
 <20130926185524.GA10123@pd.tnic>
 <20130926192059.GD10924@otherpad.lan.raisama.net>
 <20130926203206.GB10123@pd.tnic>
 <20130927142100.GB2840@otherpad.lan.raisama.net>
 <20130928104903.GB5956@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928104903.GB5956@pd.tnic>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 12:49:04PM +0200, Borislav Petkov wrote:
> On Fri, Sep 27, 2013 at 11:21:34AM -0300, Eduardo Habkost wrote:
> > The problem here is that "requested_features" doesn't include just
> > the explicit "+flag" flags, but any flag included in the CPU model
> > definition. See the "-cpu n270" example below.
> 
> Oh, you mean if requested_features would contain a flag included from
> the CPU model definition - a flag which we haven't requested explicitly
> - and if kvm emulates that flag, then it will get enabled?

Exactly. The code needs to filter/check all feature bits on the CPU, not
just the ones requested explicitly in the command-line.

[...]
> > [1] Maybe one source of confusion is that the existing code have two
> > feature-filtering functions doing basically the same thing:
> > filter_features_for_kvm() and kvm_check_features_against_host().  That's
> 
> Yes, and the first gets executed unconditionally and does the feature
> filtering,  right after the second has run in the kvm_enabled() branch.

This should be fixed, too: eventually "enforce" should work on TCG mode
as well.

> 
> > something we must clean up, and they should be unified. "enforce" should
> > become synonymous to "make sure filtered_features is all zeroes".  This
> > way, libvirt can emulate what 'enforce" does while being able to collect
> > detailed error information (which is not easy to do if QEMU simply
> > aborts).
> 
> Ok, maybe someone who's more knowledgeable with this code should do it -
> not me :)

I have added it to my TODO-list.  :-)

> 
> Also, there's another aspect, while we're here: now that QEMU emulates
> MOVBE with TCG too, how do we specify on the command line, which
> emulation should be used - kvm.ko or QEMU?

You can use accel={tcg,kvm} option on the "-machine" argument, e.g.
"-machine pc,accel=kvm". Or the "-enable-kvm" option.

-- 
Eduardo
