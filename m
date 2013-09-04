Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796Ab3IDSGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:06:19 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:45114 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759643Ab3IDSGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:06:16 -0400
Date: Wed, 4 Sep 2013 14:06:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130904180607.GD26609@mtj.dyndns.org>
References: <cover.1378111919.git.agordeev@redhat.com>
 <3bb1b4375655ecfde5017cc70973d078f2434d5d.1378111919.git.agordeev@redhat.com>
 <20130903141824.GD10522@htj.dyndns.org>
 <20130903161906.GC14221@dhcp-26-207.brq.redhat.com>
 <20130903182731.GA27092@mtj.dyndns.org>
 <20130904072256.GA8726@dhcp-26-207.brq.redhat.com>
 <20130904145559.GB25788@mtj.dyndns.org>
 <20130904161442.GE8726@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904161442.GE8726@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 04, 2013 at 06:14:43PM +0200, Alexander Gordeev wrote:
> 1. We do not support sharing MSI messages since there is no appropriate
> interrupt handling for it. I am not sure if any hardware supports it at
> all. This assumption is just for clarity here.

I don't think it even matters.  If we can configure all MSIs, good.
If not, using single interrupt is good enough.  Being able to allocate
only some of the interrupts is highly unlikely to begin with and
there's no reason to meddle with extra complexity.

> 2. We can not just read out MMC value and try to write it to MME, because
> we are not sure the hardware honours the specification.  I.e. in case of 6
> ports and MMC value of 16 the value of 8 in MME could enable multiple MSIs
> while the value of 16 could enforce MRSM. Contradicts to the AHCI
> specification, but look how weird ICH is [4].
> 
> 3. Enabling more MSIs than needed (MME == MMC instead of MME < MMC) could
> lead to unnecessary allocation of internal device resources. Bit lame, but
> still true.
> 
> 4. We can not derive the value of MME needed from the number of ports, at
> least in case of ICH. I.e. with 6 ports and MMC value of 16 the value of 8
> in MME is what would be expected according to the AHCI specification. But
> the ICH reserves it and MRSMs in case 8 is written to MME.
> 
> So to cover all the above assumptions we need to scan from lowest possible
> and watch the MRSM bit is unset.

I don't think it's necessary / a good idea to try to support
everything.  Just following the spec would be fine.  If that doesn't
work for too many devices, maybe just do one fallback?

Thanks.

-- 
tejun
