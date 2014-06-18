Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbaFRCxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 22:53:37 -0400
Received: from ozlabs.org ([103.22.144.67]:42690 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaFRCxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 22:53:35 -0400
Date: Wed, 18 Jun 2014 12:53:29 +1000
From: Anton Blanchard <anton@samba.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Jack Miller <millerjo@us.ibm.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, miltonm@us.ibm.com
Subject: Re: [RESEND] shm: shm exit scalability fixes
Message-ID: <20140618125329.1f8cd8f9@kryten>
In-Reply-To: <1403027312.2464.5.camel@buesod1.americas.hpqcorp.net>
References: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
	<1403027312.2464.5.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> > Anton wrote a simple test to cause the issue:
> > 
> > http://ozlabs.org/~anton/junkcode/bust_shm_exit.c
> 
> I'm actually in the process of adding shm microbenchmarks to
> perf-bench so I might steal this :-)

Sounds good!

> Are you seeing this issue in any real world setups? While the program
> does stress the path you mention quite well, I fear it is very
> unrealistic... how many shared mem segments do real applications
> actually use/create for scaling issues to appear?

As Jack mentioned, we were asked to debug a box that was crawling. Each
process took over 10 minutes to execute which made it very hard to
analyse. We eventually narrowed it down to this.

> I normally wouldn't mind optimizing synthetic cases like this, but a
> quick look at patch 1/3 shows that we're adding an extra overhead (16
> bytes) in the task_struct.

The testcase is synthetic but I wrote it based on the application that
would, given enough time, take the box down.

> We have the shmmni limit (and friends) for that.

If we want to use this to guard against the problem, we may need to
drop shmmni. Looking at my notes, I could take down a box with 4096
segments and 16 threads. This is where I got to before it disappeared:

# ./bust_shm_exit 4096 16
# uptime
03:00:50 up 8 days, 18:05  5 users,load average: 6076.98, 2494.09, 910.37

Anton
