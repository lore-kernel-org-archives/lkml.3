Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaIBRBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:01:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbaIBRBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:01:33 -0400
Date: Tue, 2 Sep 2014 19:01:30 +0200
From: Joerg Roedel <jroedel@suse.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, agraf@suse.de,
        valentine.sinitsyn@gmail.com, jan.kiszka@siemens.com,
        gleb@cloudius-systems.com, avi@cloudius-systems.com
Subject: Re: [PATCH 2/4] KVM: nSVM: propagate the NPF EXITINFO to the guest
Message-ID: <20140902170130.GC16722@suse.de>
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
 <1409670830-14544-3-git-send-email-pbonzini@redhat.com>
 <20140902163344.GB16722@suse.de>
 <5405F44E.7090803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5405F44E.7090803@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 06:46:06PM +0200, Paolo Bonzini wrote:
> Il 02/09/2014 18:33, Joerg Roedel ha scritto:
> > Comment is true, but doesn't make the check below obsolete, no?
> 
> No, it doesn't.  I'll rewrite it as
> 
> 	/*
> 	 * This cannot happen unless the guest is playing TOCTTOU games,
> 	 * because we would have gotten a nested page fault on table_gfn
> 	 * instead.  If this happens, the exit qualification / exit info
> 	 * field will incorrectly have "guest page access" as the
> 	 * nested page fault's cause, instead of "guest page structure
> 	 * access".
> 	 */

Sounds good.

> > Its been a while since I looked into this, but is an injected NPF exit
> > always the result of a real NPF exit?
> 
> I think so, but that's why I CCed you. :)
> 
> > How about an io-port emulated on
> > L1 but passed through to L2 by the nested hypervisor. On emulation of
> > INS or OUTS, KVM would need to read/write to an L2 address space,
> 
> It would need to read/write to *L1* (that's where the VMCB's IOIO map
> lies), which could result into a regular page fault injected into L1.

Hmm, INS and OUTS read/write to a virtual memory location, right? So if
we have an io-port intercepted by bare-metal KVM but not by the L1
hypervisor, and the L2 guest accesses this io-port, bare-metal KVM would
get an IOIO exit it has to emulate itself (it can't inject an IOIO exit
to L1 anyway, since L1 does not intercept the io-port).

During emulation the bare-metal KVM would read/write at an L2 virtual
address, because that is the context the instruction is executed in.
And while resolving this L2 virtual address, an NPF fault could be
detected that needs to be injected into the L1 hypervisor, right?



	Joerg

