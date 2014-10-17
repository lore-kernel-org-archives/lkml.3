Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaJQQ2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:28:07 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48493 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaJQQ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:28:05 -0400
Message-ID: <1413563283.24953.30.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: getaddrinfo slowdown in 3.17.1, due to getifaddrs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Graf <tgraf@suug.ch>
Cc: "Steinar H. Gunderson" <sgunderson@bigfoot.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>
Date: Fri, 17 Oct 2014 09:28:03 -0700
In-Reply-To: <20141017062517.GA11584@casper.infradead.org>
References: <20141017002132.GA29584@sesse.net>
	 <20141017003430.GB29584@sesse.net>
	 <20141017062517.GA11584@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-17 at 07:25 +0100, Thomas Graf wrote:
> On 10/17/14 at 02:34am, Steinar H. Gunderson wrote:
> > On Fri, Oct 17, 2014 at 02:21:32AM +0200, Steinar H. Gunderson wrote:
> > > Hi,
> > > 
> > > We recently upgraded a machine from 3.14.5 to 3.17.1, and a Perl script we're
> > > running to poll SNMP suddenly needed ten times as much time to complete.
> > 
> > e341694e3eb57fcda9f1adc7bfea42fe080d8d7a looks like it might cause something
> > like this (it certainly added the synchronize_net() call). Cc-ing people on 
> > that commit; quoting the entire rest of the message for reference.
> 
> I think the only option at this point is to re-add the nltable lock to
> netlink_lookup() so we can drop the synchronize_net() until we find a
> way to RCUify socket destruction. I will cook up a patch today unless
> somebody can come up with a smarter way to work around needing the
> synchronize_net().

I had a patch to add conditional RCUify socket destruction for some kind
of sockets (opt-in at protocol level).

I needed this to remove too expensive UDP socket refcount inc/dec (so
get rid of SLAB_DESTROY_BY_RCU, and instead use call_rcu() or kfree_rcu
thing)

But I couldn't finish and submit this for 3.18, and I believe I got it
wrong anyway. Cant remember exact details right now, maybe later in the
day, once my headache is better.


