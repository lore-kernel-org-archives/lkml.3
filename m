Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaEFSDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:03:40 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:56557 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaEFSDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:03:39 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 0/2] CPU hotplug: Fix the long-standing "IPI to offline CPU"
 issue
To: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org
Cc: mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 06 May 2014 23:32:35 +0530
Message-ID: <20140506180213.14375.5904.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050618-1618-0000-0000-0000002EBF57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

There is a long-standing problem related to CPU hotplug which causes IPIs to
be delivered to offline CPUs, and the smp-call-function IPI handler code
prints out a warning whenever this is detected. Every once in a while this
(usually harmless) warning gets reported on LKML, but so far it has not been
completely fixed. Usually the solution involves finding out the IPI sender
and fixing it by adding appropriate synchronization with CPU hotplug.

However, while going through one such internal bug reports, I found that
there is a significant bug in the receiver side itself (more specifically,
in stop-machine) that can lead to this problem even when the sender code
is perfectly fine. This patchset fixes that synchronization problem in the
CPU hotplug stop-machine code.

Patch 1 adds some additional debug code to the smp-call-function framework,
to help debug such issues easily.

Patch 2 modifies the stop-machine code to ensure that any IPIs that were sent
while the target CPU was online, would be noticed and handled by that CPU
without fail before it goes offline. Thus, this avoids scenarios where IPIs
are received on offline CPUs (as long as the sender uses proper hotplug
synchronization).


In fact, I debugged the problem by using Patch 1, and found that the
payload of the IPI was always the block layer's trigger_softirq() function.
But I was not able to find anything wrong with the block layer code. That's
when I started looking at the stop-machine code and realized that there is
a race-window which makes the IPI _receiver_ the culprit, not the sender.
Patch 2 fixes that race and hence this should put an end to most of the
hard-to-debug IPI-to-offline-CPU issues.


 Srivatsa S. Bhat (2):
      smp: Print more useful debug info upon receiving IPI on an offline CPU
      CPU hotplug, stop-machine: Plug race-window that leads to "IPI-to-offline-CPU"


 kernel/smp.c          |   15 ++++++++++++++-
 kernel/stop_machine.c |   22 +++++++++++++++++++---
 2 files changed, 33 insertions(+), 4 deletions(-)


Thanks,
Srivatsa S. Bhat
IBM Linux Technology Center

