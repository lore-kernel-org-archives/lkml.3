Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763098Ab3IDQMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:12:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762995Ab3IDQMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:12:48 -0400
Date: Wed, 4 Sep 2013 18:14:43 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130904161442.GE8726@dhcp-26-207.brq.redhat.com>
References: <cover.1378111919.git.agordeev@redhat.com>
 <3bb1b4375655ecfde5017cc70973d078f2434d5d.1378111919.git.agordeev@redhat.com>
 <20130903141824.GD10522@htj.dyndns.org>
 <20130903161906.GC14221@dhcp-26-207.brq.redhat.com>
 <20130903182731.GA27092@mtj.dyndns.org>
 <20130904072256.GA8726@dhcp-26-207.brq.redhat.com>
 <20130904145559.GB25788@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904145559.GB25788@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 10:55:59AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 04, 2013 at 09:22:57AM +0200, Alexander Gordeev wrote:
> > I think a general approach that will cover it all (including ICH and undesired
> > sharing of interrupt vectors) - start MME from roundup_pow_of_two(n_ports) and
> > ensure MRSM bit is unset. If not - double MME and retry. If still not and the
> > limit is reached - fall back to single MSI.
> > 
> > Makes sense?
> 
> Ugh... I really don't want this sort of retry loop.  I'm still a bit
> lost on why this is necessary.  Can you please elaborate?

Sure.

1. We do not support sharing MSI messages since there is no appropriate
interrupt handling for it. I am not sure if any hardware supports it at
all. This assumption is just for clarity here.

2. We can not just read out MMC value and try to write it to MME, because
we are not sure the hardware honours the specification.  I.e. in case of 6
ports and MMC value of 16 the value of 8 in MME could enable multiple MSIs
while the value of 16 could enforce MRSM. Contradicts to the AHCI
specification, but look how weird ICH is [4].

3. Enabling more MSIs than needed (MME == MMC instead of MME < MMC) could
lead to unnecessary allocation of internal device resources. Bit lame, but
still true.

4. We can not derive the value of MME needed from the number of ports, at
least in case of ICH. I.e. with 6 ports and MMC value of 16 the value of 8
in MME is what would be expected according to the AHCI specification. But
the ICH reserves it and MRSMs in case 8 is written to MME.

So to cover all the above assumptions we need to scan from lowest possible
and watch the MRSM bit is unset.

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
