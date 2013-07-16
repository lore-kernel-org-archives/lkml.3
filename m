Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab3GPAMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:12:40 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:16499 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3GPAMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:12:39 -0400
Message-ID: <1373933551.4622.12.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mm/hugetlb: per-vma instantiation mutexes
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Gibson <david@gibson.dropbear.id.au>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        "AneeshKumarK.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hillf Danton <dhillf@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>
Date: Mon, 15 Jul 2013 17:12:31 -0700
In-Reply-To: <20130715160802.9d0cdc0ee012b5e119317a98@linux-foundation.org>
References: <1373671681.2448.10.camel@buesod1.americas.hpqcorp.net>
	 <alpine.LNX.2.00.1307121729590.3899@eggly.anvils>
	 <1373858204.13826.9.camel@buesod1.americas.hpqcorp.net>
	 <20130715072432.GA28053@voom.fritz.box>
	 <20130715160802.9d0cdc0ee012b5e119317a98@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 16:08 -0700, Andrew Morton wrote:
> On Mon, 15 Jul 2013 17:24:32 +1000 David Gibson <david@gibson.dropbear.id.au> wrote:
> 
> > I have previously proposed a correct method of improving scalability,
> > although it doesn't eliminate the lock.  That's to use a set of hashed
> > mutexes.
> 
> Yep - hashing the mutexes is an obvious and nicely localized way of
> improving this.  It's a tweak, not a design change.
> 
> The changelog should describe the choice of the hash key with great
> precision, please.  It's important and is the first thing which
> reviewers and readers will zoom in on.
> 
> Should the individual mutexes be cacheline aligned?  Depends on the
> acquisition frequency, I guess.  Please let's work through that.

In my test cases, involving different RDBMS, I'm getting around 114k
acquisitions.

> 
> Let's not damage uniprocesor kernels too much.  AFACIT the main offender
> here is fault_mutex_hash(), which is the world's most obfuscated "return
> 0;".

I guess we could add an ifndef CONFIG_SMP check to the function and
return 0 right away. That would eliminate any overhead in
fault_mutex_hash().

> 
> >  It wasn't merged before, but I don't recall the reasons
> > why. 

So I've forward ported the patch (will send once everyone agrees that
the matter is settled), including the changes Anton Blanchard added a
exactly two years ago:

https://lkml.org/lkml/2011/7/15/31

My tests show that the number of lock contentions drops from ~11k to
around 500. So this approach alleviates a lot of the bottleneck. I've
also ran it against libhugetlbfs without any regressions.

Thanks,
Davidlohr

