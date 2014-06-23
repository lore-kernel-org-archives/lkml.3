Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbaFWPnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:43:21 -0400
Received: from shelob.surriel.com ([74.92.59.67]:54753 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbaFWPnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:43:19 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: chegu_vinod@hp.com, peterz@infradead.com, mgorman@suse.de,
        mingo@kernel.org
Subject: [PATCH 0/7] sched,numa: improve NUMA convergence times
Date: Mon, 23 Jun 2014 11:41:28 -0400
Message-Id: <1403538095-31256-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running things like the below pointed out a number of situations in
which the current NUMA code has extremely slow task convergence, and
even some situations in which tasks do not converge at all.

 ###
 # 160 tasks will execute (on 4 nodes, 80 CPUs):
 #         -1x     0MB global  shared mem operations
 #         -1x  1000MB process shared mem operations
 #         -1x     0MB thread  local  mem operations
 ###

 ###
 #
 #    0.0%  [0.2 mins]  0/0   1/1  36/2   0/0  [36/3 ] l:  0-0   (  0) {0-2}
 #    0.0%  [0.3 mins] 43/3  37/2  39/2  41/3  [ 6/10] l:  0-1   (  1) {1-2}
 #    0.0%  [0.4 mins] 42/3  38/2  40/2  40/2  [ 4/9 ] l:  1-2   (  1) [50.0%] {1-2}
 #    0.0%  [0.6 mins] 41/3  39/2  40/2  40/2  [ 2/9 ] l:  2-4   (  2) [50.0%] {1-2}
 #    0.0%  [0.7 mins] 40/2  40/2  40/2  40/2  [ 0/8 ] l:  3-5   (  2) [40.0%] (  41.8s converged)

In this example, convergence requires that a task be moved from node
0 to node 1. Before this patch series, the load balancer would have
to perform that task move, because the NUMA code would only consider
a task swap when all the CPUs on a target node are busy...

Various related items have been fixed, and task convergence times are
way down now with various numbers of proceses and threads when doing
"perf bench numa mem -m -0 -P 1000 -p X -t Y" runs.

Before the patch series, convergence sometimes did not happen at all,
or randomly got delayed by many minutes.

With the patch series, convergence generally happens in 10-20 seconds,
with a few spikes up to 30-40 seconds, and very rare instances where
things take a few minutes.

