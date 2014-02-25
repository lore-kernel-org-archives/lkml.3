Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaBYT1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:27:21 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:42663 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaBYT1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:27:20 -0500
Message-ID: <1393356413.7727.27.camel@j-VirtualBox>
Subject: Re: [PATCH 0/8] locking/core patches
From: Jason Low <jason.low2@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Waiman Long <waiman.long@hp.com>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Tue, 25 Feb 2014 11:26:53 -0800
In-Reply-To: <20140210150230.b7f46688093ebc5c45fee870@linux-foundation.org>
References: <20140210195820.834693028@infradead.org>
	 <20140210150230.b7f46688093ebc5c45fee870@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 15:02 -0800, Andrew Morton wrote:
> On Mon, 10 Feb 2014 20:58:20 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Hi all,
> > 
> > I would propose merging the following patches...
> > 
> > The first set is mostly from Jason and tweaks the mutex adaptive
> > spinning, AIM7 throughput numbers:
> > 
> > PRE:  100   2000.04  21564.90 2721.29 311.99     3.12       0.01     0.00     99
> > POST: 100   2000.04  42603.85 5142.80 311.99     3.12       0.00     0.00     99
> 
> What do these columns represent?  I'm guessing the large improvement
> was in context switches?

Hello,

I also re-tested the mutex patches 1-6 on my 2 and 8 socket machines
with the high_systime and fserver AIM7 workloads (ran on disk). The
workloads are able to generate contention on the 
&EXT4_SB(inode->i_sb)->s_orphan_lock mutex. Below are the % improvement
in throughput with the patches on a recent tip kernel. The main benefits
were on the larger box and when there were higher number of users.

Note: the -0.7% drop in performance for fserver at 10-90 users on the 2
socket machine was mainly due to "[PATCH 6/8] mutex: Extra reschedule
point". Without patch 6, there was almost no % difference in throughput
between the baseline kernel and kernel with patches 1-5.


8 socket machine:

--------------------------
       	 fserver   
--------------------------
users     | % improvement
          | in throughput
          | with patches
--------------------------
1000-2000 |  +29.2%
--------------------------
100-900   |  +10.0%
--------------------------
10-90     |   +0.4%


--------------------------
       high_systime
--------------------------
users     | % improvement
          | in throughput
          | with patches
--------------------------
1000-2000 |  +34.9%
--------------------------
100-900   |  +49.2%
--------------------------
10-90     |   +3.1%



2 socket machine:

--------------------------
         fserver   
--------------------------
users     | % improvement
          | in throughput
          | with patches
--------------------------
1000-2000 |   +1.8%
--------------------------
100-900   |   +0.0%
--------------------------
10-90     |   -0.7%


--------------------------
       high_systime
--------------------------
users     | % improvement
          | in throughput
          | with patches
--------------------------
1000-2000 |   +0.8%
--------------------------
100-900   |   +0.4%
--------------------------
10-90     |   +0.0%




