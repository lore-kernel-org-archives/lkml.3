Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbaLHXAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 18:00:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:35200 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbaLHXAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 18:00:17 -0500
Message-ID: <1418079603.13358.12.camel@kernel.crashing.org>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not
 support it
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Marek =?ISO-8859-1?Q?Kord=EDk?= <kordikmarek@gmail.com>,
        zermond@gmail.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Dec 2014 10:00:03 +1100
In-Reply-To: <1418079372.13358.9.camel@kernel.crashing.org>
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
	 <1418079372.13358.9.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 09:56 +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2014-12-08 at 13:52 -0800, Yinghai Lu wrote:
> > 2. or scan the children resource other than ROM to clear bridge MEM_64
> >    for mmio pref.
> > 
> > The patch is using second way so will keep child mmio pref into bridge
> > mmio pref range.
> 
> That means that having a single ROM BAR that is 32-bit and prefetchable
> will downgrade the entire window to 32-bit ? That's not going to work
> either.
> 
> I have GPUs with 16G BARs for example... suddenly they don't fit
> anaymore because we downgraded the window to 32 bit because somewhere
> there's a 32-bit pref resource ?
> 
> That will break more than it fixes...

I think an option would be to keep track of whether the PCI host bridge
can do 64-bit pref above 4G.

If it can't then we know 64-bit pref is always fair game for 32-bit
resources and we can thus downgrade all the bridges 64-pref to 32-perf.

If it can, then we probably do need to leave it there do real 64-bit
pref, and shoot anything that is 32-bit only down the non-pref windows.

We *could* try to be smart and scan first to check if anything under the
bridge actually has large/64-bit BARs but that's going to be a heuristic
at best and isn't going to do any good with hotplug.

I tend to think that treating anything 32-bit pref as non-pref is in
fact the best solution unless we know that the platform doesn't do
>32-bit pref anyway in which case we leave them alone.

Ben.


