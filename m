Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3FZSWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:22:17 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36666 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3FZSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:22:14 -0400
Message-ID: <51CB307E.9050508@linux.vnet.ibm.com>
Date: Wed, 26 Jun 2013 23:48:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: David Laight <David.Laight@aculab.com>
CC: paulmck@linux.vnet.ibm.com, peterz@infradead.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, walken@google.com, mingo@kernel.org,
        linux-arch@vger.kernel.org, vincent.guittot@linaro.org,
        xiaoguangrong@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, rostedt@goodmis.org, namhyung@kernel.org,
        tglx@linutronix.de, laijs@cn.fujitsu.com, zhong@linux.vnet.ibm.com,
        netdev@vger.kernel.org, oleg@redhat.com, sbw@mit.edu, tj@kernel.org,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 15/45] rcu: Use get/put_online_cpus_atomic() to prevent
 CPU offline
References: <20130625202452.16593.22810.stgit@srivatsabhat.in.ibm.com> <20130625202755.16593.67819.stgit@srivatsabhat.in.ibm.com> <20130625220026.GG3828@linux.vnet.ibm.com> <51CAF624.6060004@linux.vnet.ibm.com> <AE90C24D6B3A694183C094C60CF0A2F6026B72AA@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B72AA@saturn3.aculab.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062618-5140-0000-0000-0000036F3D84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 07:59 PM, David Laight wrote:
>> Once stop_machine() is gone from the CPU offline path, we won't be able
>> to depend on disabling preemption to prevent CPUs from going offline
>> from under us.
> 
> Could you use an rcu-like sequence so that disabling pre-emption
> would be enough?
> 
> Something like rebuilding the cpu list, then forcing yourself
> to run on all the cpu.
> 

Certainly, and we had debated schemes similar to that (including
schemes invoking synchronize_sched() itself) in earlier discussions.
(But IIRC even those schemes required converting call-sites from
preempt_disable() to get/put_online_cpus_atomic(), to properly
synchronize).

> That would be far less intrusive.
> 

But that would increase the latency of hotplug operations like Paul
pointed out, and that in turn is not good for use-cases such as
suspend/resume, where we take all non-boot CPUs offline in a loop.
(That would mean executing the above logic num_online_cpus() times!).

So we started hunting for ideas that can make the hotplug writer
side not only less intrusive, but also remain fast. That's how
the later designs evolved.
 
Regards,
Srivatsa S. Bhat

