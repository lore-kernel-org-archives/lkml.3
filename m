Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3FFDOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 23:14:50 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:41272 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182Ab3FFDOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 23:14:48 -0400
Date: Wed, 5 Jun 2013 20:14:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: stop_machine lockup issue in 3.9.y.
Message-ID: <20130606031444.GA12335@mtj.dyndns.org>
References: <51AE27D5.7050202@candelatech.com>
 <87sj0xry1k.fsf@rustcorp.com.au>
 <20130605071539.GA3429@mtj.dyndns.org>
 <51AF6E54.3050108@candelatech.com>
 <20130605184807.GD10693@mtj.dyndns.org>
 <51AF8D4B.4090407@candelatech.com>
 <51AF91F5.6090801@candelatech.com>
 <51AFA677.9010605@candelatech.com>
 <20130605211157.GK10693@mtj.dyndns.org>
 <1370482492.24311.308.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370482492.24311.308.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On Wed, Jun 05, 2013 at 06:34:52PM -0700, Eric Dumazet wrote:
> > Ingo, Thomas, we're seeing a stop_machine hanging because
> > 
> > * All other CPUs entered IRQ disabled stage.  Jiffies is not being
> >   updated.
> > 
> > * The last CPU get caught up executing softirq indefinitely.  As
> >   jiffies doesn't get updated, it never breaks out of softirq
> >   handling.  This is a deadlock.  This CPU won't break out of softirq
> >   handling unless jiffies is updated and other CPUs can't do anything
> >   until this CPU enters the same stop_machine stage.
> > 
> > Ben found out that breaking out of softirq handling after certain
> > number of repetitions makes the issue go away, which isn't a proper
> > fix but we might want anyway.  What do you guys think?
> > 
> 
> Interesting....
> 
> Before 3.9 and commit c10d73671ad30f5469
> ("softirq: reduce latencies") we used to limit the __do_softirq() loop
> to 10.

Ah, so, that's why it's showing up now.  We probably have had the same
issue all along but it used to be masked by the softirq limiting.  Do
you care to revive the 10 iterations limit so that it's limited by
both the count and timing?  We do wanna find out why softirq is
spinning indefinitely tho.

Thanks.

-- 
tejun
