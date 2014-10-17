Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaJQQa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:30:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40891 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaJQQa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:30:57 -0400
Date: Fri, 17 Oct 2014 12:30:55 -0400 (EDT)
Message-Id: <20141017.123055.1381956207136104867.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: tgraf@suug.ch, sgunderson@bigfoot.com, linux-kernel@vger.kernel.org,
        nikolay@redhat.com
Subject: Re: getaddrinfo slowdown in 3.17.1, due to getifaddrs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413563283.24953.30.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20141017003430.GB29584@sesse.net>
	<20141017062517.GA11584@casper.infradead.org>
	<1413563283.24953.30.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Oct 2014 09:30:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 17 Oct 2014 09:28:03 -0700

> On Fri, 2014-10-17 at 07:25 +0100, Thomas Graf wrote:
>> On 10/17/14 at 02:34am, Steinar H. Gunderson wrote:
>> > On Fri, Oct 17, 2014 at 02:21:32AM +0200, Steinar H. Gunderson wrote:
>> > > Hi,
>> > > 
>> > > We recently upgraded a machine from 3.14.5 to 3.17.1, and a Perl script we're
>> > > running to poll SNMP suddenly needed ten times as much time to complete.
>> > 
>> > e341694e3eb57fcda9f1adc7bfea42fe080d8d7a looks like it might cause something
>> > like this (it certainly added the synchronize_net() call). Cc-ing people on 
>> > that commit; quoting the entire rest of the message for reference.
>> 
>> I think the only option at this point is to re-add the nltable lock to
>> netlink_lookup() so we can drop the synchronize_net() until we find a
>> way to RCUify socket destruction. I will cook up a patch today unless
>> somebody can come up with a smarter way to work around needing the
>> synchronize_net().
> 
> I had a patch to add conditional RCUify socket destruction for some kind
> of sockets (opt-in at protocol level).
> 
> I needed this to remove too expensive UDP socket refcount inc/dec (so
> get rid of SLAB_DESTROY_BY_RCU, and instead use call_rcu() or kfree_rcu
> thing)
> 
> But I couldn't finish and submit this for 3.18, and I believe I got it
> wrong anyway. Cant remember exact details right now, maybe later in the
> day, once my headache is better.

Can I ask a serious question?  What is the synchronize_net() in AF_NETLINK
exactly needed for?
