Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaBGULN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:11:13 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:10800 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaBGULL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:11:11 -0500
Message-ID: <1391803868.1099.23.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Max number of posix queues in vanilla kernel  
 (/proc/sys/fs/mqueue/queues_max)
From: Davidlohr Bueso <davidlohr@hp.com>
To: m@silodev.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>,
        dledford@redhat.com
Date: Fri, 07 Feb 2014 12:11:08 -0800
In-Reply-To: <11414.87.110.183.114.1391682066.squirrel@www.silodev.com>
References: <11414.87.110.183.114.1391682066.squirrel@www.silodev.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 12:21 +0200, m@silodev.com wrote:
> Hi Folks,
> 
> I have recently ported my multi-process application (like a classical open
> system) which uses POSIX Queues as IPC to one of the latest Linux kernels,
> and I have faced issue that number of maximum queues are dramatically
> limited down to 1024 (see include/linux/ipc_namespace.h, #define
> HARD_QUEUESMAX 1024).
> 
> Previously the max number of queues was INT_MAX (on 64bit system was:
> 2147483647).

Hmm yes, 1024 is quite unrealistic for some workloads and breaks
userspace - I don't see any reasons for _this_ specific value in the
changelog or related changes in the patchset that introduced commits
93e6f119 and 02967ea0. And the fact that this limit is per namespace
makes no difference really. Hell, if nothing else, the mq_overview(7)
manpage description is evidence enough. For privileged users:

The default value for queues_max is 256; it can be changed to any value in the range 0 to INT_MAX.

> 
> This update imposes bad limits on our multi-process application. As our
> app uses approaches that each process opens its own set of queues (usually
> something about 3-5 queues per process). In some scenarios we might run up
> to 3000 processes or more (which of-course for linux is not a problem).
> Thus we might need up to 9000 queues or more. All processes run under one
> user.
> 
> But now we have this limit, which limits our software down and we are
> getting in trouble. We could patch the kernel manually, but not all
> customers are capable of this and willing to do the patching.
> 
> Thus I *kindly* ask you guys to increase this limit to something like 1M
> queues or more (or to technical limit i.e. leave the same INT_MAX). If
> user can screw up the system by setting or using maximums, let it leave to
> the user. As it is doing system tuning and he is responsible for kernel
> parameters.
> 
> The kernel limit was introduced by:
> -
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=93e6f119c0ce8a1bba6e81dc8dd97d67be360844
> 
> Also I see other people are claiming issues with this, see:
> - https://bugs.launchpad.net/ubuntu/+source/manpages/+bug/1155695 - for
> them some database software is not working after the kernel upgrade...

Surprised we didn't hear about this earlier by Michael Kerrisk. At least
the upstream manpages haven't been updated to reflect this new behavior,
it would have been the wrong way to go.

> 
> Also I think that when people will upgrade from RHEL 5 or RHEL 6 to next
> versions where this hard limit will be defined, I suspect that many will
> claim problem about it...

Agreed, RHEL 7 will ship with some baseline version of the 3.10 kernel
and users will be exposed to this. Of course, the same goes for just
about any distro, and Ubuntu users are already complaining about it.

I believe that instead of bumping up this HARD limit of 1024, we should
go back to the original behavior. If we just increase it, instead, then
how high is high enough?

Thanks,
Davidlohr

