Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaGKL4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:56:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaGKL4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:56:39 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/5] perf: Fix tracepoint events permissions check
Date: Fri, 11 Jul 2014 13:56:17 +0200
Message-Id: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending fix for bug reported by Alexander Yarygin in here:
  http://marc.info/?l=linux-kernel&m=140475133707722&w=2

The main problem was, that the event_init tracepoint callback
checked permission of the 'current' task instead of the event
owner task.

While this is ok for perf_event_open syscall check, it is wrong
once event_init is called during fork to create child events.
In this case the permission of the forked task is checked instead
of the owner task of the parent event.

Changing tracepoint permission code to check event's owner task,
plus some other changes I needed for this.

thanks,
jirka


---
Jiri Olsa (5):
      perf: Make perf_init_event function static
      perf: Destroy event's children on task exit
      perf: Initialize owner before calling event_init callback
      perf: Move event owner retrieval into perf_event_get_owner
      perf: Check event's owner permission in tracepoint init callback

 include/linux/perf_event.h      |  1 +
 kernel/events/core.c            | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------
 kernel/trace/trace_event_perf.c | 19 +++++++++++++++++--
 3 files changed, 73 insertions(+), 19 deletions(-)
