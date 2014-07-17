Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbaGQXJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:09:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43571 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757592AbaGQXJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:09:35 -0400
Date: Thu, 17 Jul 2014 16:09:23 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: benh@kernel.crashing.org
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/2] Memoryless nodes and kworker
Message-ID: <20140717230923.GA32660@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 3.13.0-30-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071723-9332-0000-0000-0000016B92B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Apologies for the large Cc list, but I believe we have the following
interested parties:

x86 (recently posted memoryless node support)
ia64 (existing memoryless node support)
ppc (existing memoryless node support)
previous discussion of how to solve Anton's issue with slab usage
workqueue contributors/maintainers]

There is an issue currently where NUMA information is used on powerpc
(and possibly ia64) before it has been read from the device-tree, which
leads to large slab consumption with CONFIG_SLUB and memoryless nodes.

While testing memoryless nodes on PowerKVM guests with the patches in
this series, with a guest topology of
    
    available: 2 nodes (0-1)
    node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49
    node 0 size: 0 MB
    node 0 free: 0 MB
    node 1 cpus: 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99
    node 1 size: 16336 MB
    node 1 free: 15329 MB
    node distances:
    node   0   1
      0:  10  40
      1:  40  10
    
the slab consumption decreases from
    
    Slab:             932416 kB
    SUnreclaim:       902336 kB
    
to
    
    Slab:             395264 kB
    SUnreclaim:       359424 kB
    
And we see a corresponding increase in the slab efficiency from
    
    slab                                   mem     objs    slabs
                                          used   active   active
    ------------------------------------------------------------
    kmalloc-16384                       337 MB   11.28%  100.00%
    task_struct                         288 MB    9.93%  100.00%
    
to
    
    slab                                   mem     objs    slabs
                                          used   active   active
    ------------------------------------------------------------
    kmalloc-16384                        37 MB  100.00%  100.00%
    task_struct                          31 MB  100.00%  100.00%

It turns out we see this large slab usage due to using the wrong NUMA
information when creating kthreads.
    
Two changes are required, one of which is in the workqueue code and one
of which is in the powerpc initialization. Note that ia64 may want to
consider something similar.

