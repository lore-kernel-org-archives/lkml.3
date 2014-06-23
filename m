Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbaFWQoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:44:37 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:36088 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaFWQog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:44:36 -0400
Message-ID: <1403541870.2526.12.camel@j-VirtualBox>
Subject: Re: [PATCH v2] sched: Fast idling of CPU when system is partially
 loaded
From: Jason Low <jason.low2@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Date: Mon, 23 Jun 2014 09:44:30 -0700
In-Reply-To: <20140623162234.GP5714@two.firstfloor.org>
References: <1402948127.2970.578.camel@schen9-DESK>
	 <20140623125233.GZ19860@laptop.programming.kicks-ass.net>
	 <20140623162234.GP5714@two.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 18:22 +0200, Andi Kleen wrote:
> > So I don't get why we can't do the below; I think Jason tried to ask the
> > same...
> 
> The important part for performance is to minimize the cache line transfers. Your
> unconditional variant would cause more dirty cache lines than Tim's,
> right?

How about that change to the update_sg_lb_stats() call site along with:

                sgs->group_load += load;
                sgs->sum_nr_running += rq->nr_running;
-               if (overload && rq->nr_running > 1)
+               if (!env->sd->parent && rq->nr_running > 1)
                        *overload = true;

which keeps it as a conditional to avoid unnecessarily setting overload
when it's not used, and still get those benefits Peter mentioned.

