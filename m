Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbaJ2R4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:56:33 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:58811 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJ2R4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:56:32 -0400
MIME-Version: 1.0
In-Reply-To: <1414533217-24910-10-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215140.GA23970@linux.vnet.ibm.com> <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1414533217-24910-10-git-send-email-paulmck@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 29 Oct 2014 13:56:01 -0400
Message-ID: <CAJhHMCDwxmNS0vA_9LqRKHxOVo=4RY-oHt2mPaVQK7MZJQ97=w@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 10/10] cpu: Avoid puts_pending overflow
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 5:53 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>
> A long string of get_online_cpus() with each followed by a
> put_online_cpu() that fails to acquire cpu_hotplug.lock can result in
> overflow of the cpu_hotplug.puts_pending counter.  Although this is
> perhaps improbably, a system with absolutely no CPU-hotplug operations
> will have an arbitrarily long time in which this overflow could occur.
> This commit therefore adds overflow checks to get_online_cpus() and
> try_get_online_cpus().
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This patch seems to be missing in the cover letter.

Reviewed-by: Pranith Kumar <bobby.prani@gmail.com>

> ---
>  kernel/cpu.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 90a3d017b90c..5d220234b3ca 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -86,6 +86,16 @@ static struct {
>  #define cpuhp_lock_acquire()      lock_map_acquire(&cpu_hotplug.dep_map)
>  #define cpuhp_lock_release()      lock_map_release(&cpu_hotplug.dep_map)
>
> +static void apply_puts_pending(int max)
> +{
> +       int delta;
> +
> +       if (atomic_read(&cpu_hotplug.puts_pending) >= max) {
> +               delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
> +               cpu_hotplug.refcount -= delta;
> +       }
> +}
> +
>  void get_online_cpus(void)
>  {
>         might_sleep();
> @@ -93,6 +103,7 @@ void get_online_cpus(void)
>                 return;
>         cpuhp_lock_acquire_read();
>         mutex_lock(&cpu_hotplug.lock);
> +       apply_puts_pending(65536);
>         cpu_hotplug.refcount++;
>         mutex_unlock(&cpu_hotplug.lock);
>  }
> @@ -105,6 +116,7 @@ bool try_get_online_cpus(void)
>         if (!mutex_trylock(&cpu_hotplug.lock))
>                 return false;
>         cpuhp_lock_acquire_tryread();
> +       apply_puts_pending(65536);
>         cpu_hotplug.refcount++;
>         mutex_unlock(&cpu_hotplug.lock);
>         return true;
> @@ -161,12 +173,7 @@ void cpu_hotplug_begin(void)
>         cpuhp_lock_acquire();
>         for (;;) {
>                 mutex_lock(&cpu_hotplug.lock);
> -               if (atomic_read(&cpu_hotplug.puts_pending)) {
> -                       int delta;
> -
> -                       delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
> -                       cpu_hotplug.refcount -= delta;
> -               }
> +               apply_puts_pending(1);
>                 if (likely(!cpu_hotplug.refcount))
>                         break;
>                 __set_current_state(TASK_UNINTERRUPTIBLE);
> --
> 1.8.1.5
>



-- 
Pranith
