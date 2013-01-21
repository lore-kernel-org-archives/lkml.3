Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab3AUPZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 10:25:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51133 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab3AUPZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 10:25:25 -0500
Date: Mon, 21 Jan 2013 15:24:40 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Sealey <matt@genesi-usa.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: Compilation problem with drivers/staging/zsmalloc when !SMP on
	ARM
Message-ID: <20130121152440.GJ23505@n2100.arm.linux.org.uk>
References: <CAKGA1b=ACTQHo9=B7EAG5nrFCO9u-J+sy7dXtYk3Rk6OUcW3cQ@mail.gmail.com> <20130118210859.GH23505@n2100.arm.linux.org.uk> <20130118214527.GA913@kroah.com> <20130119043725.GB5391@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119043725.GB5391@phenom.dumpdata.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 11:37:25PM -0500, Konrad Rzeszutek Wilk wrote:
> On Fri, Jan 18, 2013 at 01:45:27PM -0800, Greg Kroah-Hartman wrote:
> > On Fri, Jan 18, 2013 at 09:08:59PM +0000, Russell King - ARM Linux wrote:
> > > On Fri, Jan 18, 2013 at 02:24:15PM -0600, Matt Sealey wrote:
> > > > Hello all,
> > > > 
> > > > I wonder if anyone can shed some light on this linking problem I have
> > > > right now. If I configure my kernel without SMP support (it is a very
> > > > lean config for i.MX51 with device tree support only) I hit this error
> > > > on linking:
> > > 
> > > Yes, I looked at this, and I've decided that I will _not_ fix this export,
> > > neither will I accept a patch to add an export.
> > > 
> > > As far as I can see, this code is buggy in a SMP environment.  There's
> > > apparantly no guarantee that:
> > > 
> > > 1. the mapping will be created on a particular CPU.
> > > 2. the mapping will then be used only on this specific CPU.
> > > 3. no guarantee that another CPU won't speculatively prefetch from this
> > >    region.
> 
> I thought the code had per_cpu for it - so that you wouldn't do that unless
> you really went out the way to do it.

Actually, yes, you're right - that negates point (4) and possibly (2),
but (3) is still a concern.  (3) shouldn't be that much of an issue
_provided_ that the virtual addresses aren't explicitly made use of by
other CPUs.  Is that guaranteed by the zsmalloc code?  (IOW, does it
own the virtual region it places these mappings in?)

What is the performance difference between having and not having this
optimization?  Can you provide some measurements please?

Lastly, as you hold per_cpu stuff across this, that means preemption
is disabled - and any kind of scheduling is also a bug.  Is there
any reason the kmap stuff can't be used?  Has this been tried?  How
does it compare numerically with the existing solutions?
