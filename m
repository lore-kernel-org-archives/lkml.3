Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbbANLZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:25:22 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:53229 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbbANLZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:25:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jon Masters <jcm@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sysfs topology for arm64 cluster_id
Date: Wed, 14 Jan 2015 12:24:49 +0100
Message-ID: <1514771.EWQBJle85Y@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54B5BC84.8090603@redhat.com>
References: <54B5BC84.8090603@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:tBm4I7+gIAElyfXsmxQnAv82J1SoatyVDVcc3sbJwQb0OmI3WgI
 2wHqmQc7BKfPrmnMwMHe3BRrso/mf9Ueu5tKAneFlPW/yWr/99V7a8nIyQxMUzSODqDI8XF
 MBGbROLAAjVVfugidfuRnVSYBJas3Xd1HdHcatHHBsnVjx3Uk+JuljQnTY2nt4zSiXoZH2Y
 Uqe90QnUU28rb07hTNPsA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2015 19:47:00 Jon Masters wrote:
> Hi Folks,
> 
> TLDR: I would like to consider the value of adding something like
> "cluster_siblings" or similar in sysfs to describe ARM topology.
> 
> A quick question on intended data representation in /sysfs topology
> before I ask the team on this end to go down the (wrong?) path. On ARM
> systems today, we have a hierarchical CPU topology:
> 
>                  Socket ---- Coherent Interonnect ---- Socket
>                    |                                    |
>          Cluster0 ... ClusterN                Cluster0 ... ClusterN
>             |             |                      |             |
>       Core0...CoreN  Core0...CoreN        Core0...CoreN  Core0...CoreN
>         |       |      |        |           |       |      |       |
>      T0..TN  T0..Tn  T0..TN  T0..TN       T0..TN T0..TN  T0..TN  T0..TN
> 
> Where we might (or might not) have threads in individual cores (a la SMT
> - it's allowed in the architecture at any rate) and we group cores
> together into units of clusters usually 2-4 cores in size (though this
> varies between implementations, some of which have different but similar
> concepts, such as AppliedMicro Potenza PMDs CPU complexes of dual
> cores). There are multiple clusters per "socket", and there might be an
> arbitrary number of sockets. We'll start to enable NUMA soon.

Have you taken a look at the NUMA patches that Ganapatrao Kulkarni
has sent out? These encode the system-wide topology based on the model
from IBM Power machines.

> Is it not a good idea to expose the cluster details directly in sysfs
> and have these utilities understand the possible extra level in the
> calculation? Or do we want to just fudge the numbers (as seems to be the
> case in some systems I am seeing) to make the x86 model add up?
> 
> Let me know the preferred course...

I like the idea of encoding the topology independent of the specific
levels implemented in hardware, and we could use that same model
that we have in DT to represent things to user space, or that
can directly access the "arm,associativity" properties in
/sys/firmware/devicetree/base, but that would not be portable to
ACPI based systems.

In the platform that Ganapatrao is interested in, there are no clusters,
but they have two levels of NUMA topology (sockets and boards), and
I could well imagine systems that have more than those two, or systems
that have multiple levels below a socket (e.g. chip, cluster, core,
thread) that all share the same NUMA node because they have a common
memory controller.

It would be nice to find a good representation for sysfs that covers
all of these cases, and that also shows the associativity of I/O
devices.

	Arnd
