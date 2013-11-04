Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3KDRES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:04:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab3KDREQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:04:16 -0500
Date: Mon, 4 Nov 2013 17:04:13 +0000
From: Mel Gorman <mgorman@suse.de>
To: Don Morris <don.morris@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>
Subject: Re: BUG: soft lockup - CPU#8 stuck for 22s!
Message-ID: <20131104170413.GA25764@suse.de>
References: <5266B5F2.5070102@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5266B5F2.5070102@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 01:29:22PM -0400, Don Morris wrote:
> Greetings, all.
> 
> Just wanted to drop this out there to see if it rang any bells.
> I've been getting a soft lockup (numad thread stuck on a cpu
> while attempting to attach a task to a cgroup) for a while now,
> but I thought it was only happening when I applied Mel Gorman's
> set of AutoNUMA patches.

This maybe?

---8<---
mm: memcontrol: Release css_set_lock when aborting an OOM scan

css_task_iter_start acquires the css_set_lock and it must be released with
a call to css_task_iter_end. Commmit 9cbb78bb (mm, memcg: introduce own
oom handler to iterate only over its own threads) introduced a loop that
was not guaranteed to call css_task_iter_end.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5ef8929..941f67d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1795,6 +1795,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				mem_cgroup_iter_break(memcg, iter);
 				if (chosen)
 					put_task_struct(chosen);
+				css_task_iter_end(&it);
 				return;
 			case OOM_SCAN_OK:
 				break;
