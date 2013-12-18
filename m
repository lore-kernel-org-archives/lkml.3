Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab3LRS0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:26:41 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:50697 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab3LRS0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:26:38 -0500
Date: Wed, 18 Dec 2013 11:26:35 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Mark Lord <kernel@start.ca>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20131218182635.GE15119@google.com>
References: <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <52442975.9000603@start.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52442975.9000603@start.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 08:32:53AM -0400, Mark Lord wrote:
> On 13-09-18 05:48 AM, Alexander Gordeev wrote:
> >
> > The last pattern makes most of sense to me and could be updated with a more
> > clear sequence - a call to (bit modified) pci_msix_table_size() followed
> > by a call to pci_enable_msix(). I think this pattern can effectively
> > supersede the currently recommended "loop" practice.
> 
> The loop is still necessary, because there's a race between those two calls,
> so that pci_enable_msix() can still fail due to lack of MSIX slots.

Hi Mark,

Can you elaborate on this race?  My understanding is that
pci_msix_table_size() depends only on the "Table Size" field in the MSI-X
Message Control register.

So if there's a concurrency problem here, it would have to be something
like "pci_enable_msix() may not be able to configure the requested number
of vectors because it has to allocate from a shared pool."

If that's the case, pci_msix_table_size() wouldn't be involved at all, and
the only question is how to coordinate between several drivers that each
call pci_enable_msix().  I think that would have to be resolved in some
arch hook used by the PCI core.

Maybe this is already taken care of; I just want to make sure we don't
overlook an issue here.

Bjorn
