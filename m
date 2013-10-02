Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3JBDXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 23:23:46 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:43225 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3JBDXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 23:23:43 -0400
Date: Tue, 1 Oct 2013 23:23:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20131002032338.GA2417@htj.dyndns.org>
References: <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20130918142231.GA21650@mtj.dyndns.org>
 <20131001073548.GI17966@concordia>
 <20131001115503.GA23722@mtj.dyndns.org>
 <20131002023337.GB22748@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002023337.GB22748@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 12:33:38PM +1000, Michael Ellerman wrote:
> > It is an interface which forces the driver writers to write
> > complicated fallback code which won't usually be excercised.  
> 
> It does not force anyone to do anything. That's just bull.

Yeah, sure, we don't have shitty code in drivers which don't need any
of that retry logic, right?  What the hell is up with the gratuituous
escalation?  You really wanna go that way?

> Code which is unwilling or unable to cope with the extra complexity
> can simply do:
> 
> if (pci_enable_msix(..))
> 	goto fail;
> 
> It's as simple as that.

You apparently have no clue how people behave.  You give a function
which indicates complex failure mode, driver writers *will* try to
handle that whether they actually understand the implication or not.
That's a natural and correct behavior too because any half-competent
software eng would design API so that it receives and returns
information which is relevant to its users.  If there are special
cases to handle, make the damn interface for it special too so that it
doesn't confuse the common case.

Driver codes already have generally lower quality than core code, if
for nothing else, due to the sheer volume, and there are many driver
writers who aren't too privvy with various kernel subsystems.  They
usually just copy whatever other similar driver is doing, and this one
is a lot worse - this thing affects hardware directly.  If you expect
all the shitty implementations of ahci to handle the different
variations of multiple MSI config cases, you just don't have any
experience dealing with cheap commodity hardware.

Driver APIs should be intuitive, clear in its intentions, and don't
tempt fate with hairy configs for vast majority of cases.

> +int pci_enable_msix_or_fail(struct pci_dev *dev, struct msix_entry *entries,
> +                           int nvec)
> +{
> +       int rc;
> +
> +       rc = pci_enable_msix(dev, entries, nvec);
> +       if (rc > 0)
> +               rc = -ENOSPC;
> +
> +       return rc;
> +}

Make the *default* case simple and give clearly special interface for
the special cases.  What's so hard about that?

> > Are we talking about some limited number of device drivers here?  
> 
> I don't have a list, but yeah there are certain drivers that folks care about.

And here's another problem with the current interface.  Because the
default interface is the unnecessrily complicated one, now we can't
tell which ones actually need the complicated treatment.

> > Also, is the quota still necessary for machines in production today?
> 
> As far as I know yes. The number of MSIs is growing on modern systems, but so
> is the number of cpus and devices.

That's a bummer, but let's please make the default interface simple.
I really don't wanna see partial allocations for ahci.

-- 
tejun
