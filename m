Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965239Ab3DRDAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 23:00:24 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:3325 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054Ab3DRDAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 23:00:22 -0400
Message-ID: <1366254012.1716.11.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v4 3/4] mutex: Queue mutex spinners with MCS lock to
 reduce cacheline contention
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Date: Wed, 17 Apr 2013 20:00:12 -0700
In-Reply-To: <1366226594-5506-4-git-send-email-Waiman.Long@hp.com>
References: <1366226594-5506-1-git-send-email-Waiman.Long@hp.com>
	 <1366226594-5506-4-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-17 at 15:23 -0400, Waiman Long wrote:
> The current mutex spinning code (with MUTEX_SPIN_ON_OWNER option turned
> on) allow multiple tasks to spin on a single mutex concurrently. A
> potential problem with the current approach is that when the mutex
> becomes available, all the spinning tasks will try to acquire the
> mutex more or less simultaneously. As a result, there will be a lot of
> cacheline bouncing especially on systems with a large number of CPUs.
> 
> This patch tries to reduce this kind of contention by putting the
> mutex spinners into a queue so that only the first one in the queue
> will try to acquire the mutex. This will reduce contention and allow
> all the tasks to move forward faster.
> 
> The queuing of mutex spinners is done using an MCS lock based
> implementation which will further reduce contention on the mutex
> cacheline than a similar ticket spinlock based implementation. This
> patch will add a new field into the mutex data structure for holding
> the MCS lock. This expands the mutex size by 8 bytes for 64-bit system
> and 4 bytes for 32-bit system. This overhead will be avoid if the
> MUTEX_SPIN_ON_OWNER option is turned off.
> 
> The following table shows the jobs per minute (JPM) scalability data
> on an 8-node 80-core Westmere box with a 3.7.10 kernel. The numactl
> command is used to restrict the running of the fserver workloads to
> 1/2/4/8 nodes with hyperthreading off.
[...]
> 
> The short workload is the only one that shows a decline in performance
> probably due to the spinner locking and queuing overhead.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Acked-by: Rik van Riel <riel@redhat.com>

Reviewed-by: Davidlohr Bueso <davidlohr.bueso@hp.com>


