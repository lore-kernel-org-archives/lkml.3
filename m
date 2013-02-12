Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3BLGSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 01:18:24 -0500
Received: from ozlabs.org ([203.10.76.45]:40183 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab3BLGSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 01:18:23 -0500
Date: Tue, 12 Feb 2013 17:18:22 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Baruch Siach <baruch@tkos.co.il>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] irq_dispose_mapping after irq request failure
Message-ID: <20130212061822.GA8977@concordia>
References: <20130211053100.GB18462@sapphire.tkos.co.il>
 <20130211061949.GA5561@concordia>
 <20130211205255.72B513E3530@localhost>
 <1360630273.2035.2.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360630273.2035.2.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 11:51:13AM +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2013-02-11 at 20:52 +0000, Grant Likely wrote:
> > Really the irq mappings should be using reference counting. The existing
> > code is naive on this count and just releases the irq on the first call
> > to irq_dispose_mapping().  I've not gotten around to fixing that. Anyone
> > want to take that task on?
> 
> Is this the best approach ?
> 
> The original idea was that there was no point disposing of mappings in most
> cases and keeping the mapping around would provide a bit of stability of
> interrupt numbers which might come in handy for debugging etc...
> 
> The few cases where disposing of a mapping might be useful is if the underlying
> physical interrupts completely disappear, as in a cascaded controller gets
> removed or that sort of thing, which is a very rare case... And even then...

That may have been the intent, but we forgot to tell driver writers, ourselves
included.

> Could you just make irq_dispose_mapping() check if the irq desc is
> active and fail/WARN/BUG if it is ? I don't see the point of adding a refcount,
> that feels overkill.

I don't think you can, "active" is not well defined. Other code may have
done nothing other than create the mapping and remembered the virq,
which will break if you destroy the mapping. Or?

I agree refcounting is not fun. It'll end up with the same mess as
of_node_get/put() where practically every 2nd piece of code leaks
references.

I guess we can't go the other way, and say that mapping the same hwirq
twice is an error.

cheers
