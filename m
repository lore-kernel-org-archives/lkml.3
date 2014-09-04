Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaIDIWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:22:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbaIDIWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:22:33 -0400
Date: Thu, 4 Sep 2014 11:25:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Jason Wang <jasowang@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process is
 runnable
Message-ID: <20140904082510.GA12448@redhat.com>
References: <53F6F14B.1030609@redhat.com>
 <20140822074224.GB7372@gmail.com>
 <53FFEEC0.4000304@redhat.com>
 <540414AB.9000004@linux.intel.com>
 <54053998.4040604@redhat.com>
 <54056076.2030603@linux.intel.com>
 <20140902083124.GB10356@redhat.com>
 <5406B9E6.6050103@linux.intel.com>
 <20140903075104.GA6187@redhat.com>
 <54080BF5.1070504@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54080BF5.1070504@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 09:51:33AM +0300, Eliezer Tamir wrote:
> On 03/09/2014 10:51, Michael S. Tsirkin wrote:
> > On Wed, Sep 03, 2014 at 09:49:10AM +0300, Eliezer Tamir wrote:
> >> On 02/09/2014 11:31, Michael S. Tsirkin wrote:
> >>> On Tue, Sep 02, 2014 at 09:15:18AM +0300, Eliezer Tamir wrote:
> 
> >> Busy polling is not a general purpose feature, it's not something you
> >> can casually turn on and will "just work". Most applications should not
> >> be using busy polling. Currently it is used by multiserver applications
> >> that you spend days tuning to specific platforms.
> >>
> >> What the user wants is to lower both avg and maximum latencies, at the
> >> expense of everything else including power efficiency and sometimes
> >> even throughput. The only exception is making the system crash ;)
> >>
> >> While letting other things take precedence over busy polling might not
> >> hurt the avg latency much, it will kill your maximum latency.
> > 
> > If scheduler happens to run both server and client on the
> > same CPU, polling will hurt maximum latency even more.
> > So I guess different users want different things.
> > 
> > How about applications giving us a hint what they prefer?
> > For example, a new flag that says "I don't have anything useful to do so
> > let's do busy polling but my server is on the local system, so please
> > only poll if CPU is otherwise idle".
> 
> I'm sorry for being ambiguous, when I said multi-server application, I
> meant an app that runs on more than one server machine.
> 
> The loopback test is as far as I know not interesting.

It's not interesting for ethernet NIC vendors :).

But people do deploy servers and clients on the same box, and
improving latency for them would be benefitial.

Loopback is widely used by desktops, containers, vpns, etc etc

Getting more theoretical, even with external networking, any
application processing traffic in more than one thread behaves the same.
For example, it's not uncommon to have a thread get messages from a
socket, and pass them out to other threads for processing.  At the
moment the polling thread would sometimes delay the processing if it
lands on the same CPU.

> Of course if busypoll becomes interesting for virtualization over
> loopback,

IMO bringing up virtualization just muddies the waters, it's a general
problem that arises whenever you run a lot of stuff on your CPU.

> I have no problem with that, provided that there is a way to
> get the old behavior and that it is well documented.
> 
> -Eliezer

I agree here, since some application might be relying on the old behavior.

-- 
MST
