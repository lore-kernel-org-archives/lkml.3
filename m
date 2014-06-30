Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaF3Mux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:50:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbaF3Muv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:50:51 -0400
Message-ID: <53B15D27.9010306@redhat.com>
Date: Mon, 30 Jun 2014 08:50:47 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RFC: /proc/cpuinfo confusion with AMD processors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD defines a "Package" as the hardware processor itself.  Each Package contains
multiple Nodes, and each Node has multiple Compute Units.  Each Compute Unit can
have up to 2 cores that [with the 62xx and 63xx] do not have multiple Threads.

That is, to determine the number of CPUs that Linux sees, multiply

     Package * Nodes * Compute Units * Cores

Note that Nodes and Compute Units are not indicated in /proc/cpuinfo directly
(although it could be argued that they should be).

The output of /proc/cpuinfo is confusing at this point as ...


processor       : 31
vendor_id       : AuthenticAMD
cpu family      : 21
model           : 2
model name      : AMD Opteron(tm) Processor 6386 SE
stepping        : 0
microcode       : 0x6000822
cpu MHz         : 2800.000
cache size      : 2048 KB
physical id     : 1
siblings        : 16  <<< this is number of threads per package
core id         : 7   <<< this is the core id of this thread relative to node
cpu cores       : 8   <<< this is the number of cores per node

which makes deciphering the system topology quite difficult as values are
relative to both nodes and the entire package.  It is not possible using this
information to uniquely identify a processor.

I want to make two changes.  The first is to modify /proc/cpuinfo to include
both the node information for all x86 processors and also include a "compute
unit id" field for AMD systems.

The second change would be to include the same data in /sys which currently does
not contain the above information in the topology directory.

Thoughts/concerns?

P.
