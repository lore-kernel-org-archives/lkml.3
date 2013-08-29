Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab3H2KNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:13:19 -0400
Received: from mail.renton.name ([90.155.165.44]:42541 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3H2KNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:13:17 -0400
Date: Thu, 29 Aug 2013 14:10:43 +0400
From: Alexey Vlasov <renton@renton.name>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org
Subject: Re: Kernel migration eat CPUs
Message-ID: <20130829101042.GA13306@beaver>
References: <20130823151711.f4c1f596b4c7aa1eecccc9a6@linux-foundation.org>
 <20130825142837.GD31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130825142837.GD31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Sun, Aug 25, 2013 at 04:28:37PM +0200, Peter Zijlstra wrote:
>
> Gargh.. I've never seen anything like that. Nor ever had a report like
> this. Is there anything in particular one can do to try and reproduce
> this?

I don't know how to reproduce it. This happens by itself and only on
high-loaded servers. For example this happens almost every hour on one
server with kernel 3.8.11 with 10k web-sites and 5k MySQL databases. On
another server with kernel 3.9.4 with same load this can take place 3-5
times per day. Sometimes this happens almost synchronously on both
servers.
I returned to kernel 2.6.35 on servers where this often took place. Or
they are not high-loaded enough that this effect doesn't appear.

For example here is server which earlier worked on kernel 3.9.4. It is
high-loaded, but migration stopped to eat CPUs after downgrade to
2.6.35.

# uname -r
2.6.35.7

# uptime
13:56:34 up 32 days, 10:31, 10 users, load average: 24.44, 23.44, 24.13

# ps -u root -o user,bsdtime,comm | grep -E 'COMMAND|migration'
USER       TIME COMMAND
root       4:20 migration/0
root       6:07 migration/1
root      17:00 migration/2
root       5:23 migration/3
root      16:43 migration/4
root       3:48 migration/5
root      12:28 migration/6
root       3:44 migration/7
root      12:25 migration/8
root       3:49 migration/9
root       1:52 migration/10
root       2:51 migration/11
root       1:28 migration/12
root       2:43 migration/13
root       2:16 migration/14
root       4:53 migration/15
root       2:15 migration/16
root       4:13 migration/17
root       2:13 migration/18
root       4:21 migration/19
root       2:07 migration/20
root       4:13 migration/21
root       2:13 migration/22
root       3:26 migration/23

For comparison 3.9.4:
# uptime
13:55:49 up 11 days, 15:36, 11 users, load average: 24.62, 24.36, 23.63

USER       TIME COMMAND
root     233:51 migration/0
root     233:38 migration/1
root     231:57 migration/2
root     233:26 migration/3
root     231:46 migration/4
root     233:26 migration/5
root     231:37 migration/6
root     232:56 migration/7
root     231:09 migration/8
root     232:34 migration/9
root     231:04 migration/10
root     232:22 migration/11
root     230:50 migration/12
root     232:16 migration/13
root     230:38 migration/14
root     231:51 migration/15
root     230:04 migration/16
root     230:16 migration/17
root     230:06 migration/18
root     230:22 migration/19
root     229:45 migration/20
root     229:43 migration/21
root     229:27 migration/22
root     229:24 migration/23
root     229:11 migration/24
root     229:25 migration/25
root     229:16 migration/26
root     228:58 migration/27
root     228:48 migration/28
root     229:06 migration/29
root     228:25 migration/30
root     228:25 migration/31
 

> Could you perhaps send your .config and a function (or function-graph)
> trace for when this happens?

My .config
https://www.dropbox.com/s/vuwvalj58cfgahu/.config_3.9.4-1gb-csmb-tr

I can't make trace because it isn't turned on on my kernels. I will be
able to reboot servers on weekend as there are many clients there and
will send you trace.

> Also, do you use weird things like cgroup/cpusets or other such fancy
> stuff? If so, could you outline your setup?

Grsec patch is used on all kernels. Also there is following patch only on
kernel 3.8.11:

--- kernel/cgroup.c.orig
+++ kernel/cgroup.c 
@@ -1931,7 +1931,8 @@
                           ss->attach(cgrp, &tset);
        }
-       synchronize_rcu();
+       synchronize_rcu_expedited();

        /*
	 * wake up rmdir() waiter. the rmdir should fail since the

Aslo I use https://github.com/facebook/flashcache/

Actually I really use cgroup namely controllers cpuacct, memory, blkio.
I create cgroup for every user on server, where all users processes are
running. To make it work there are needed patches in Apache/prefork, SSH
and other users staff. There can be about 10k-15k users and accordingly
same amount of cgroups.

The other day I disabled all cgroups, but controllers are still mounted.

# cat /proc/cgroups
#subsys_name    hierarchy       num_cgroups     enabled
cpuset  2       1       1
cpuacct 3       1       1
memory  4       1       1
blkio   5       1       1

But migration still eats CPUs. However I also use cgroup on kernel
2.6.35.

-- 
BRGDS. Alexey Vlasov.
