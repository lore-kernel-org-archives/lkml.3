Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3LBQT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:19:27 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63950 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3LBQT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:19:26 -0500
Message-ID: <529CB30A.1030306@gmail.com>
Date: Mon, 02 Dec 2013 09:19:22 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@iki.fi>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
CC: namhyung@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/2] perf sched: Introduce timehist command - v2
References: <1385943795-11761-1-git-send-email-dsahern@gmail.com> <1385943795-11761-2-git-send-email-dsahern@gmail.com> <529C53D2.8020203@iki.fi>
In-Reply-To: <529C53D2.8020203@iki.fi>
Content-Type: multipart/mixed;
 boundary="------------000005030303040509090102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000005030303040509090102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/13, 2:33 AM, Pekka Enberg wrote:
> I'm seeing rather large "sch delay" numbers on Fedora 19's default
> kernel that seem like a data error of some sort:
>
>      4500.663117 [02] fix_client[7216]         0.007
> 18446744073708.033     1.786


Does this address the large numbers for you?

David

--------------000005030303040509090102
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="timehist-check-ready-time.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="timehist-check-ready-time.patch"

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index abcb40a44151..ae71782064ac 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1751,8 +1751,12 @@ static void timehist_update_runtime_stats(struct thread_runtime *r,
 	r->dt_between = 0;
 	if (tprev) {
 		r->dt_run = t - tprev;
-		if (r->ready_to_run)
-			r->dt_delay = tprev - r->ready_to_run;
+		if (r->ready_to_run) {
+			if (r->ready_to_run > tprev)
+				pr_debug("time travel: wakeup time for task > previous sched_switch event\n");
+			else
+				r->dt_delay = tprev - r->ready_to_run;
+		}
 
 		if (r->last_time > tprev)
 			pr_debug("time travel: last sched out time for task > previous sched_switch event\n");

--------------000005030303040509090102--
