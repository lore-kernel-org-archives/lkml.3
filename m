Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbbANArZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:47:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbbANArY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:47:24 -0500
Message-ID: <54B5BC84.8090603@redhat.com>
Date: Tue, 13 Jan 2015 19:47:00 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: sysfs topology for arm64 cluster_id
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

TLDR: I would like to consider the value of adding something like
"cluster_siblings" or similar in sysfs to describe ARM topology.

A quick question on intended data representation in /sysfs topology
before I ask the team on this end to go down the (wrong?) path. On ARM
systems today, we have a hierarchical CPU topology:

                 Socket ---- Coherent Interonnect ---- Socket
                   |                                    |
         Cluster0 ... ClusterN                Cluster0 ... ClusterN
            |             |                      |             |
      Core0...CoreN  Core0...CoreN        Core0...CoreN  Core0...CoreN
        |       |      |        |           |       |      |       |
     T0..TN  T0..Tn  T0..TN  T0..TN       T0..TN T0..TN  T0..TN  T0..TN

Where we might (or might not) have threads in individual cores (a la SMT
- it's allowed in the architecture at any rate) and we group cores
together into units of clusters usually 2-4 cores in size (though this
varies between implementations, some of which have different but similar
concepts, such as AppliedMicro Potenza PMDs CPU complexes of dual
cores). There are multiple clusters per "socket", and there might be an
arbitrary number of sockets. We'll start to enable NUMA soon.

The existing ARM architectural code understands expressing topology in
terms of the above, but it doesn't quite map these concepts directly in
sysfs (does not expose cluster_ids as an example). Currently, a cpu-map
in DeviceTree can expose hierarchies (included nested clusters) and this
is parsed at boot time to populate scheduler information, as well as the
topology files in sysfs (if that is provided - none of the reference
devicetrees upstream do this today, but some exist). But the cluster
information itself isn't quite exposed (whereas other whacky
architectural concepts such as s390 books are exposed already today).

Anyway. We have a small problem with tools such as those in util-linux
(lscpu) getting confused as a result of translating x86-isms to ARM. For
example, the lscpu utility calculates the number of sockets using the
following computation:

nsockets = desc->ncpus / nthreads / ncores

(number of sockets = total number of online processing elements /
threads within a single core / cores within a single socket)

If you're not careful, you can end up with something like:

# lscpu
Architecture:          aarch64
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0-7
Thread(s) per core:    1
Core(s) per socket:    2
Socket(s):             4

Now we can argue that the system in question needs an updated cpu-map
(it'll actually be something ACPI but I'm keeping this discussion to DT
to avoid that piece further in discussion, and you can assume I'm
booting any test boxes in further work on this using DeviceTree prior to
switching the result over to ACPI) but either way, util-linux is
thinking in an x86-centric sense of what these files mean. And I think
the existing topology/cpu-map stuff in arm64 is doing the same.

Is it not a good idea to expose the cluster details directly in sysfs
and have these utilities understand the possible extra level in the
calculation? Or do we want to just fudge the numbers (as seems to be the
case in some systems I am seeing) to make the x86 model add up?

Let me know the preferred course...

Jon.
