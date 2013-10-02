Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3JBC6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 22:58:53 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65223 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3JBC6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 22:58:50 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-5b-524b8be8c09c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Set child_pid after perf_evlist__prepare_workload()
References: <1380531671-28076-1-git-send-email-namhyung@kernel.org>
	<524980ED.2000507@gmail.com>
	<20131001165133.GE2920@ghostprotocols.net>
Date: Wed, 02 Oct 2013 11:58:48 +0900
In-Reply-To: <20131001165133.GE2920@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 1 Oct 2013 13:51:33 -0300")
Message-ID: <878uycnztj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013 13:51:33 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Sep 30, 2013 at 07:47:25AM -0600, David Ahern escreveu:
>> On 9/30/13 3:01 AM, Namhyung Kim wrote:
>> >From: Namhyung Kim <namhyung.kim@lge.com>
>> >
>> >The commit acf2892270dc ("perf stat: Use perf_evlist__prepare/
>> >start_workload()") converted to use the function but forgot to update
>> >child_pid.  Fix it.
>> >
>> >Cc: David Ahern <dsahern@gmail.com>
>> >Cc: Stephane Eranian <eranian@google.com>
>> >Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> >---
>> >  tools/perf/builtin-stat.c | 1 +
>> >  1 file changed, 1 insertion(+)
>> >
>> >diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
>> >index f686d5ff594e..5098f144b92d 100644
>> >--- a/tools/perf/builtin-stat.c
>> >+++ b/tools/perf/builtin-stat.c
>> >@@ -457,6 +457,7 @@ static int __run_perf_stat(int argc, const char **argv)
>> >  			perror("failed to prepare workload");
>> >  			return -1;
>> >  		}
>> >+		child_pid = evsel_list->workload.pid;
>> >  	}
>> >
>> >  	if (group)
>> >
>> 
>> Interesting. I can't find a test case where is matters ... perhaps a
>> convenience of waitpid taking -1.
>
> Yeah, the interval part initially used the fork return, then after
> acf2892270dc used the default value of child_pid, -1, which is ok as it
> waits for any children, but I wonder what would happen in workloads with
> multiple children.

Hmm.. right.  And in fact what I actually concern was when killing child
if create_perf_stat_counter() failed.

	if (child_pid != -1)
		kill(child_pid, SIGTERM);

>
> But for correctness acf2892270dc should have kept the existing
> semantics, even if using -1 could in the end be ok.

Agreed.

Thanks,
Namhyung
