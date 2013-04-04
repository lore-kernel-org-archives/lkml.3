Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764488Ab3DDSZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:25:01 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52000 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764474Ab3DDSZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:25:00 -0400
MIME-Version: 1.0
From: Fabien Gaud <fgaud@sfu.ca>
Date: Thu, 4 Apr 2013 20:24:28 +0200
X-Google-Sender-Auth: onTJUurhed3Xo6CxPluVCa0Kt8E
Message-ID: <CAO4k2LcFjs-q=bUNB5eai5uP_4H_ga3wV7EZe4yindyF-bWFeQ@mail.gmail.com>
Subject: Carrefour: memory traffic management for NUMA multicore systems
To: linux-kernel@vger.kernel.org,
        "Alexandra (Sasha) Fedorova" <fedorova@sfu.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

We are researchers from Simon Fraser Unviversity (Canada) and CNRS/INP
Grenoble/Universite Joseph Fourier (France). We are working on memory
traffic management for NUMA multicore architectures. We published a
paper at ASPLOS (http://asplos13.rice.edu/) on that subject and we
think that this might interest you.

Basically, we found in our paper that it is more important to balance
memory pressure on memory controllers than to increase locality
because memory controller congestion and interconnect congestion drive
up memory access latencies. We designed Carrefour, a memory management
algorithm that first tries to balance the load on memory controllers
and second tries to improve locality (note that this is not necessary
contradictory).

Carrefour is based on classic memory management techniques (page
migration, page interleaving, page replication). The algorithm works
as follow:
First, we decide if memory management is required, using global
statistics gathered with hardware counters.
Second, we decide for each page which technique to apply, using per
page statistics gathered with IBS (specific to AMD processor, INTEL
has a similar solution with PEBS).

We have significant improvements on many different applications.
Especially, we usually have  a low overhead when memory management is
not required and better performance than autonuma when it is.

If you are interested, here is a link to our paper:
http://www.cs.sfu.ca/~fedorova/papers/asplos284-dashti.pdf and, for a
brief overview, some slides:
http://www.fabiengaud.net/resources/dashti13traffic-slides.pdf

If you are interested in the code, it is available here :
https://github.com/Carrefour. Carrefour is divided in three modules: a
patched kernel that supports page replication, a kernel module and a
runtime.
Page replication has been implemented in Linux 3.6. It has not been
tested on many configurations, so it is likely to have bugs. We know
that there's at least a problem with vmalloc. We did not test KSM, but
I suspect that it will not work well too. Nevertheless, it is stable
on our machines with our configuration. The current implementation has
not been optimized for many-node machines (we tested it on two 4-node
machines with respectively 16 and 24 cores). Especially, for a
"replicated" process, we create one pgd per node and most of the
algorithms are O(nr_nodes).
The runtime is the part that decides whether we need Carrefour or not.
The module is the part that collects IBS samples and decides what to
do for each page. The module uses hooks on functions that are not
exported and I agree that is not a very clean implementation.

We hope that our work will interest you. We believe that some
important insights could be used in future autonuma/balance-numa
versions, like balancing memory accesses to reduce congestion on
memory controllers and interconnects or use hardware counters to
assist the memory management algorithm and reduce its overhead.

Fabien Gaud
