Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3LMLdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:33:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab3LMLdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:33:38 -0500
Date: Fri, 13 Dec 2013 11:29:25 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 04/11] PCI/MSI/pSeries: Make quota traversing and
 requesting race-safe
Message-ID: <20131213102924.GA14728@dhcp-26-207.brq.redhat.com>
References: <cover.1385399393.git.agordeev@redhat.com>
 <97749db3e9562eb05fb3ee22a0be0ed7a93a0615.1385399393.git.agordeev@redhat.com>
 <20131210223020.GF4699@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210223020.GF4699@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 03:30:20PM -0700, Bjorn Helgaas wrote:
> Can you outline the race and the scenario that leads to incorrect results
> or a crash?  I looked through rtas_setup_msi_irqs() (briefly) and I didn't
> see the way that concurrent calls for different devices could interfere
> with each other.
> 
> I was looking for some place that modifies state, where concurrent calls
> might trample on each other, but it looks like msi_quota_for_device() is
> pretty safe: it traverses a tree, but everything it computes is on the
> stack and it doesn't seem to save results anywhere.  Maybe I'm barking up
> the wrong tree?

Hmm. I've assumed the number of MSIs for a device is cached, and therefore
concurrent calls to msi_quota_for_device() and rtas_change_msi() could race.
But it seems msi_quota_for_device() indeed computes a quota while reading
only device's properties and gains constant result (well, assuming the device
tree is not updated, but this is a different story). Which makes me confused
about this note from a earlier thread:

[quote]
On Sat, 2013-10-05 at 16:20 +0200, Alexander Gordeev wrote:
> So my point is - drivers should first obtain a number of MSIs they *can*
> get, then *derive* a number of MSIs the device is fine with and only then
> request that number. Not terribly different from memory or any other type
> of resource allocation ;)

What if the limit is for a group of devices ? Your interface is racy in
that case, another driver could have eaten into the limit in between the
calls.

Ben.
[/quote]

Some comment from Ben would be nice, but I think the patch could be dropped
for now.

Thanks, Bjorn!

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
