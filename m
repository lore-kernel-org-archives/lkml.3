Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaAaD3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 22:29:40 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:42713 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaAaD3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 22:29:39 -0500
Message-ID: <1391138977.6284.82.camel@j-VirtualBox>
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Thu, 30 Jan 2014 19:29:37 -0800
In-Reply-To: <20140129115142.GE9636@twins.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
	 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
	 <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
	 <1390949495.2807.52.camel@j-VirtualBox>
	 <20140129115142.GE9636@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-29 at 12:51 +0100, Peter Zijlstra wrote:
> On Tue, Jan 28, 2014 at 02:51:35PM -0800, Jason Low wrote:
> > > But urgh, nasty problem. Lemme ponder this a bit.
> 
> OK, please have a very careful look at the below. It survived a boot
> with udev -- which usually stresses mutex contention enough to explode
> (in fact it did a few time when I got the contention/cancel path wrong),
> however I have not ran anything else on it.

I tested this patch on a 2 socket, 8 core machine with the AIM7 fserver
workload. After 100 users, the system gets soft lockups.

Some condition may be causing threads to not leave the "goto unqueue"
loop. I added a debug counter, and threads were able to reach more than
1,000,000,000 "goto unqueue".

I also was initially thinking if there can be problems when multiple
threads need_resched() and unqueue at the same time. As an example, 2
nodes that need to reschedule are next to each other in the middle of
the MCS queue. The 1st node executes "while (!(next =
ACCESS_ONCE(node->next)))" and exits the while loop because next is not
NULL. Then, the 2nd node execute its "if (cmpxchg(&prev->next, node,
NULL) != node)". We may then end up in a situation where the node before
the 1st node gets linked with the outdated 2nd node.

