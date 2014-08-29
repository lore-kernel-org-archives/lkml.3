Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaH2WbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:31:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50911 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbaH2WbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:31:04 -0400
X-Sasl-enc: Ggwvm7Lyx5p4vM8XnJAl5Hbq/KfZMCoPN0B7jxZIvuz4 1409351462
Date: Fri, 29 Aug 2014 15:31:01 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, msalter@redhat.com, dyoung@redhat.com, riel@redhat.com,
        peterz@infradead.org, mgorman@suse.de, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, Alex Thorlton <athorlton@sgi.com>,
        Cliff Wickman <cpw@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 0/2] x86: Speed up ioremap operations
Message-ID: <20140829223101.GA13583@kroah.com>
References: <20140829195328.511550688@asylum.americas.sgi.com>
 <20140829131602.72c422ebd2fd3fba426379e8@linux-foundation.org>
 <5400E62F.8000405@sgi.com>
 <20140829135200.636dec4a64e2668c2072d787@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829135200.636dec4a64e2668c2072d787@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 01:52:00PM -0700, Andrew Morton wrote:
> On Fri, 29 Aug 2014 13:44:31 -0700 Mike Travis <travis@sgi.com> wrote:
> 
> > 
> > 
> > On 8/29/2014 1:16 PM, Andrew Morton wrote:
> > > On Fri, 29 Aug 2014 14:53:28 -0500 Mike Travis <travis@sgi.com> wrote:
> > > 
> > >>
> > >> We have a large university system in the UK that is experiencing
> > >> very long delays modprobing the driver for a specific I/O device.
> > >> The delay is from 8-10 minutes per device and there are 31 devices
> > >> in the system.  This 4 to 5 hour delay in starting up those I/O
> > >> devices is very much a burden on the customer.
> > >>
> > >> There are two causes for requiring a restart/reload of the drivers.
> > >> First is periodic preventive maintenance (PM) and the second is if
> > >> any of the devices experience a fatal error.  Both of these trigger
> > >> this excessively long delay in bringing the system back up to full
> > >> capability.
> > >>
> > >> The problem was tracked down to a very slow IOREMAP operation and
> > >> the excessively long ioresource lookup to insure that the user is
> > >> not attempting to ioremap RAM.  These patches provide a speed up
> > >> to that function.
> > >>
> > > 
> > > Really would prefer to have some quantitative testing results in here,
> > > as that is the entire point of the patchset.  And it leaves the reader
> > > wondering "how much of this severe problem remains?".
> > 
> > Okay, I have some results from testing.  The modprobe time appears to
> > be affected quite a bit by previous activity on the ioresource list,
> > which I suspect is due to cache preloading.  While the overall
> > improvement is impacted by other overhead of starting the devices,
> > this drastically improves the modprobe time.
> > 
> > Also our system is considerably smaller so the percentages gained
> > will not be the same.  Best case improvement with the modprobe
> > on our 20 device smallish system was from 'real    5m51.913s' to
> > 'real    0m18.275s'.
> 
> Thanks, I slurped that into the changelog.
> 
> > > Also, the -stable backport is a big ask, isn't it?  It's arguably
> > > notabug and the affected number of machines is small.
> > > 
> > 
> > Ingo had suggested this.  We are definitely pushing it to our distro
> > suppliers for our customers.  Whether it's a big deal for smaller
> > systems is up in the air.  Note that the customer system has 31 devices
> > on an SSI that includes a large number of other IB and SAS devices
> > as well as a number of nodes which all which have discontiguous memory
> > segments.  I'm envisioning an ioresource list that numbers at least
> > several hundred entries.  While that's somewhat indicative of typical
> > UV systems it is generally not that common otherwise.
> > 
> > So I guess the -stable is merely a suggestion, not a request.
> 
> Cc Greg for his thoughts!

Sounds like a good thing for stable.

thanks,

greg k-h
