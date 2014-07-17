Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbaGQSnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:43:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41840 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaGQSnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:43:22 -0400
Message-ID: <53C81944.5080203@arm.com>
Date: Thu, 17 Jul 2014 20:43:16 +0200
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bruno Wolff III <bruno@wolff.to>
CC: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from caffcdd8d27ba78730d5540396ce72ad022aff2c
References: <20140716145546.GA6922@wolff.to> <20140716151748.GC2460@hansolo.jdub.homelinux.org> <53C6CFCC.2050300@arm.com> <20140716195414.GA16401@wolff.to> <53C7084C.7090104@arm.com> <20140717030947.GA17889@wolff.to> <53C79013.1020808@arm.com> <20140717163627.GA2489@wolff.to>
In-Reply-To: <20140717163627.GA2489@wolff.to>
X-OriginalArrivalTime: 17 Jul 2014 18:43:17.0722 (UTC) FILETIME=[F97FBBA0:01CFA1EE]
X-MC-Unique: 114071719432000701
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/14 18:36, Bruno Wolff III wrote:
> I did a few quick boots this morning while taking a bunch of pictures. I have
> gone through some of them this morning and found one that shows bug on
> was triggered at 5850 which is from:
> BUG_ON(!cpumask_empty(sched_group_cpus(sg)));
>
> You can see the JPEG at:
> https://bugzilla.kernel.org/attachment.cgi?id=143331
>

Many thanks for testing this, Bruno!

So the memory of the cpumask of some sched_group(s) in your system has 
been altered between __visit_domain_allocation_hell()->__sdt_alloc() and 
build_sched_groups().

In the meantime, PeterZ has posted a patch which barfs when this happens 
but also prints out the sched groups with the related cpus but also 
includes the cpumask_clear so your machine would boot still fine.

If you could apply the patch:

https://lkml.org/lkml/2014/7/17/288

and then run it on your machine, that would give us more details, i.e. 
the information on which sched_group(s) and in which sched domain level 
(SMT and/or DIE) this issue occurs.


Another thing which you could do is to boot with an extra 
'earlyprintk=keep sched_debug' in your command line options with a build 
containing the cpumask_clear() in build_sched_groups() and extract the 
dmesg output of the scheduler-setup code:

Example:

[    0.119737] CPU0 attaching sched-domain:
[    0.119740]  domain 0: span 0-1 level SIBLING
[    0.119742]   groups: 0 (cpu_power = 588) 1 (cpu_power = 588)
[    0.119745]   domain 1: span 0-3 level MC
[    0.119747]    groups: 0-1 (cpu_power = 1176) 2-3 (cpu_power = 1176)
[    0.119751] CPU1 attaching sched-domain:
[    0.119752]  domain 0: span 0-1 level SIBLING
[    0.119753]   groups: 1 (cpu_power = 588) 0 (cpu_power = 588)
[    0.119756]   domain 1: span 0-3 level MC
[    0.119757]    groups: 0-1 (cpu_power = 1176) 2-3 (cpu_power = 1176)
[    0.119759] CPU2 attaching sched-domain:
[    0.119760]  domain 0: span 2-3 level SIBLING
[    0.119761]   groups: 2 (cpu_power = 588) 3 (cpu_power = 588)
[    0.119764]   domain 1: span 0-3 level MC
[    0.119765]    groups: 2-3 (cpu_power = 1176) 0-1 (cpu_power = 1176)
[    0.119767] CPU3 attaching sched-domain:
[    0.119768]  domain 0: span 2-3 level SIBLING
[    0.119769]   groups: 3 (cpu_power = 588) 2 (cpu_power = 588)
[    0.119772]   domain 1: span 0-3 level MC
[    0.119773]    groups: 2-3 (cpu_power = 1176) 0-1 (cpu_power = 1176)


