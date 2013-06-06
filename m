Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3FFBAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:00:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:41774 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab3FFBAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:00:34 -0400
Message-ID: <1370480404.3766.260.camel@pasglop>
Subject: Re: [PATCH] powerpc/pci: Improve device hotplug initialization
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chen Yuanquan-B41889 <B41889@freescale.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Yuanquan Chen <Yuanquan.Chen@freescale.com>,
        Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Date: Thu, 06 Jun 2013 11:00:04 +1000
In-Reply-To: <20130601135809.GA6395@roeck-us.net>
References: <1369762514-27352-1-git-send-email-linux@roeck-us.net>
	 <51A5CAC1.6030800@freescale.com> <20130531051423.GA15505@roeck-us.net>
	 <1369979047.3928.112.camel@pasglop> <20130601135809.GA6395@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-01 at 06:58 -0700, Guenter Roeck wrote:
> the comment was actuially directed towards Yuanquan.
> 
> No problem, take your time. I did my best to test it, but I agree that this is a
> critical area of the code, and it would be desirable to get additional scrutiny
> and test feedback.
> 
> The code has been running in our system (P2020 and P5040) for several months.
> I was preparing a patch for upstream submission when I noticed commit 37f02195b.
> After testing ithis commit, I noticed the problems with it and wrote this patch,
> which aligns the code with our initial patch. I tested it as good as I could on
> our systems as well as with a P5040 evaluation board and an Intel GE PCIe
> card.

Ok, so I like this very much. So much that I was considering still sneaking it
into 3.10, until I hit a snag...

[ Basically, the previous patch that moved the setup to pcibios_enable_device()
always made me nervous. It did regress at least one platform (mac stuff) due
to missed IRQ fixup, which I worked around later on, and I'm still not terribly
happy about it. Your approach is much cleaner. ]

I suppose that when I wrote the original setup stuff there wasn't an add
hook or I didn't see it...

In fact I would go further and completely remove pcibios_setup_bus_devices()
which is now empty since it's only called by the powerpc code, it's not
a generic hook.

However, here's the snag. Unless I missed something, we now setup the devices
DMA before we call pcibios_fixup_bus(). And *that* is going to break some
pseries.

We have an assumption in there that the bus fixup is done first, because in
some cases, the DMA windows are established at the bus level, and the "dev"
setup just picks up the bits.

Now looking at that code, it's not unfixable but it won't make 3.10. Maybe
we need a new pre-scan hook for busses... we can use the pcibios_add_device()
hook of the bridge itself for P2P but that won't do for the root bus and I
don't like having two different path here...

Cheers,
Ben.


