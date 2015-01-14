Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbbANQls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:41:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbbANQlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:41:47 -0500
Message-ID: <54B69C2D.9050202@redhat.com>
Date: Wed, 14 Jan 2015 11:41:17 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Jon Masters <jcm@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sysfs topology for arm64 cluster_id
References: <54B5BC84.8090603@redhat.com> <1514771.EWQBJle85Y@wuerfel>
In-Reply-To: <1514771.EWQBJle85Y@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 06:24 AM, Arnd Bergmann wrote:
> On Tuesday 13 January 2015 19:47:00 Jon Masters wrote:
>> Hi Folks,
>>
>> TLDR: I would like to consider the value of adding something like
>> "cluster_siblings" or similar in sysfs to describe ARM topology.
>>
>> A quick question on intended data representation in /sysfs topology
>> before I ask the team on this end to go down the (wrong?) path. On ARM
>> systems today, we have a hierarchical CPU topology:
>>
>>                   Socket ---- Coherent Interonnect ---- Socket
>>                     |                                    |
>>           Cluster0 ... ClusterN                Cluster0 ... ClusterN
>>              |             |                      |             |
>>        Core0...CoreN  Core0...CoreN        Core0...CoreN  Core0...CoreN
>>          |       |      |        |           |       |      |       |
>>       T0..TN  T0..Tn  T0..TN  T0..TN       T0..TN T0..TN  T0..TN  T0..TN
>>
>> Where we might (or might not) have threads in individual cores (a la SMT
>> - it's allowed in the architecture at any rate) and we group cores
>> together into units of clusters usually 2-4 cores in size (though this
>> varies between implementations, some of which have different but similar
>> concepts, such as AppliedMicro Potenza PMDs CPU complexes of dual
>> cores). There are multiple clusters per "socket", and there might be an
>> arbitrary number of sockets. We'll start to enable NUMA soon.
>
> Have you taken a look at the NUMA patches that Ganapatrao Kulkarni
> has sent out? These encode the system-wide topology based on the model
> from IBM Power machines.
>
Thanks for that ptr!  I'll take a look at this code today.

>> Is it not a good idea to expose the cluster details directly in sysfs
>> and have these utilities understand the possible extra level in the
>> calculation? Or do we want to just fudge the numbers (as seems to be the
>> case in some systems I am seeing) to make the x86 model add up?
>>
>> Let me know the preferred course...
>
> I like the idea of encoding the topology independent of the specific
> levels implemented in hardware, and we could use that same model
> that we have in DT to represent things to user space, or that
> can directly access the "arm,associativity" properties in
> /sys/firmware/devicetree/base, but that would not be portable to
> ACPI based systems.
>
> In the platform that Ganapatrao is interested in, there are no clusters,
> but they have two levels of NUMA topology (sockets and boards), and
> I could well imagine systems that have more than those two, or systems
> that have multiple levels below a socket (e.g. chip, cluster, core,
> thread) that all share the same NUMA node because they have a common
> memory controller.
>
> It would be nice to find a good representation for sysfs that covers
> all of these cases, and that also shows the associativity of I/O
> devices.
>
Caches too (and cpu associativity to them, esp. L2)

> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

