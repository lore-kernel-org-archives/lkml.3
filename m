Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaEHRYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:24:52 -0400
Received: from shelob.surriel.com ([74.92.59.67]:53764 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbaEHRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:23:41 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: [PATCH 0/4] sched,numa: task placement for complex NUMA topologies
Date: Thu,  8 May 2014 13:23:27 -0400
Message-Id: <1399569811-14362-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds code for placement of tasks on a NUMA system
with complex NUMA topology. The code is fairly well isolated, and
does not impact things on systems with directly connected NUMA
topology.

The strategy is to adjust the score of each node, by the score of
nearby NUMA nodes, weighed by the numa distance of that node from
the other nearby nodes.

One of the main reasons for choosing this strategy is that it allows
the current code to stay the same, and simply add one extra call,
which does nothing on systems with simple NUMA topologies.

There is a tradeoff between performance and complexity, which is why
performance tests were done with patches 1-2, and with the whole
series of 1-4.

SPECjbb2005 throughput on an 8 node system:

		average bops	standard deviation

vanilla		857814		53528
patches 1-2	926053		26590
patches 1-4	931791		13874


Full test results, 10 runs of 2 4-node wide instances. Throughput
and distribution of each JVM across memory nodes.

1) kernel without patches:
                                                                    Nodes
                                                                    -----
spec1.txt:           throughput =     901782.00 SPECjbb2005 bops   0,1,4,5
spec2.txt:           throughput =     861272.25 SPECjbb2005 bops   2,3,6,7

spec1.txt:           throughput =     828895.46 SPECjbb2005 bops   3,5,6,7
spec2.txt:           throughput =     834569.91 SPECjbb2005 bops   0,1,2,4

spec1.txt:           throughput =     798582.97 SPECjbb2005 bops   2,4,5,6
spec2.txt:           throughput =     856616.41 SPECjbb2005 bops   0,1,3,7

spec1.txt:           throughput =     805044.62 SPECjbb2005 bops   0,2,4,5
spec2.txt:           throughput =     827402.54 SPECjbb2005 bops   1,3,6,7

spec1.txt:           throughput =     836735.76 SPECjbb2005 bops   2,4,6,7
spec2.txt:           throughput =     830288.17 SPECjbb2005 bops   0,1,3,5

spec1.txt:           throughput =     856434.61 SPECjbb2005 bops   3,4,5,6
spec2.txt:           throughput =     831602.46 SPECjbb2005 bops   0,1,2,7

spec1.txt:           throughput =     796366.70 SPECjbb2005 bops   0,4,6,7
spec2.txt:           throughput =     829059.05 SPECjbb2005 bops   1,2,3,5

spec1.txt:           throughput =     820001.99 SPECjbb2005 bops   1,4,5,7
spec2.txt:           throughput =     836664.23 SPECjbb2005 bops   0,2,3,6

spec1.txt:           throughput =     950736.30 SPECjbb2005 bops   4,5,6,7
spec2.txt:           throughput =     931937.24 SPECjbb2005 bops   0,1,2,3

spec1.txt:           throughput =     956298.83 SPECjbb2005 bops   4,5,6,7
spec2.txt:           throughput =     965984.19 SPECjbb2005 bops   0,1,2,3


2) kernel with patches 1 - 2:
                                                                   nodes
                                                                   ------
spec1.txt:           throughput =     923364.71 SPECjbb2005 bops  0,1,2,3
spec2.txt:           throughput =     912929.23 SPECjbb2005 bops  4,5,6,7

spec1.txt:           throughput =     889254.77 SPECjbb2005 bops  0,1,6,7
spec2.txt:           throughput =     870275.31 SPECjbb2005 bops  2,3,4,5

spec1.txt:           throughput =     950790.19 SPECjbb2005 bops  4,5,6,7
spec2.txt:           throughput =     940626.50 SPECjbb2005 bops  0,1,2,3

spec1.txt:           throughput =     915422.01 SPECjbb2005 bops  4,5,6,7
spec2.txt:           throughput =     934301.50 SPECjbb2005 bops  0,1,2,3

spec1.txt:           throughput =     934467.57 SPECjbb2005 bops  4,5,6,7
spec2.txt:           throughput =     923753.88 SPECjbb2005 bops  0,1,2,3

spec1.txt:           throughput =     951261.79 SPECjbb2005 bops  0,1,2,3
spec2.txt:           throughput =     950683.73 SPECjbb2005 bops  4,5,6,7

spec1.txt:           throughput =     954495.68 SPECjbb2005 bops  0,1,2,3
spec2.txt:           throughput =     943342.78 SPECjbb2005 bops  4,5,6,7

spec1.txt:           throughput =     943429.43 SPECjbb2005 bops  0,1,2,3
spec2.txt:           throughput =     924885.84 SPECjbb2005 bops  4,5,6,7

spec1.txt:           throughput =     962104.96 SPECjbb2005 bops  4,5,6,7
spec2.txt:           throughput =     924263.56 SPECjbb2005 bops  0,1,2,3

spec1.txt:           throughput =     901460.65 SPECjbb2005 bops  2,3,6,7
spec2.txt:           throughput =     869961.50 SPECjbb2005 bops  0,1,4,5


3) kernel with patches 1 - 4:
                                                                    Nodes
                                                                    -----
spec1.txt:           throughput =     929011.11 SPECjbb2005 bops   4,5,6,7
spec2.txt:           throughput =     955879.30 SPECjbb2005 bops   0,1,2,3

spec1.txt:           throughput =     902287.44 SPECjbb2005 bops   4,5,6,7
spec2.txt:           throughput =     932429.31 SPECjbb2005 bops   0,1,2,3

spec1.txt:           throughput =     909671.34 SPECjbb2005 bops   0,1,2,3
spec2.txt:           throughput =     934057.16 SPECjbb2005 bops   4,5,6,7

spec1.txt:           throughput =     940457.57 SPECjbb2005 bops   0,1,2,3
spec2.txt:           throughput =     951272.07 SPECjbb2005 bops   4,5,6,7

spec1.txt:           throughput =     936920.56 SPECjbb2005 bops   0,1,2,3
spec2.txt:           throughput =     947703.47 SPECjbb2005 bops   4,5,6,7

spec1.txt:           throughput =     924643.52 SPECjbb2005 bops   4,5,6,7
spec2.txt:           throughput =     939721.24 SPECjbb2005 bops   0,1,2,3

spec1.txt:           throughput =     935592.32 SPECjbb2005 bops   0,1,2,3
spec2.txt:           throughput =     930367.11 SPECjbb2005 bops   4,5,6,7

spec1.txt:           throughput =     949498.38 SPECjbb2005 bops   0,1,2,3
spec2.txt:           throughput =     933686.74 SPECjbb2005 bops   4,5,6,7

spec1.txt:           throughput =     924315.44 SPECjbb2005 bops   0,1,2,3
spec2.txt:           throughput =     919825.21 SPECjbb2005 bops   4,5,6,7

spec1.txt:           throughput =     917190.04 SPECjbb2005 bops   0,1,2,3
spec2.txt:           throughput =     921301.56 SPECjbb2005 bops   4,5,6,7

