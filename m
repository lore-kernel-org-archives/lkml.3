Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3KLHwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:52:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:53034 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab3KLHwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:52:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407322321"
Message-ID: <5281DFE5.3000909@intel.com>
Date: Tue, 12 Nov 2013 09:59:33 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: "Test object code reading" failing, debug messages don't help
References: <20131111195117.GI27198@ghostprotocols.net> <20131111195559.GJ27198@ghostprotocols.net> <20131111195810.GK27198@ghostprotocols.net>
In-Reply-To: <20131111195810.GK27198@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/13 21:58, Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 11, 2013 at 04:55:59PM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Mon, Nov 11, 2013 at 04:51:17PM -0300, Arnaldo Carvalho de Melo escreveu:
>>> Hi Adrian,
>>>
>>> 	I have perf test failing here:
>>>
>>> [root@ssdandy ~]# perf test 21
>>> 21: Test object code reading                               : FAILED!
>>> [root@ssdandy ~]# 
>>>
>>> Try it with -v, but all messages, except for that elf header, which I
>>> assume is for a previous entry that is not suitable and should not be
>>> considered, seems to say all is well, except that the test fails :-\
>>
>> If I try gdb on test__code_reading, go on stepping thru it to try to
>> figure out why it fails, it works :-\
> 
> Why this is so is still unclear, but since the other problem I had was
> due to the kernel reducing the max sample_freq, I tried:
> 
> [root@ssdandy ~]# echo 10000 > /proc/sys/kernel/perf_event_max_sample_rate 
> [root@ssdandy ~]# perf test 21
> 21: Test object code reading                               : Ok
> [root@ssdandy ~]# echo 7000 > /proc/sys/kernel/perf_event_max_sample_rate 
> [root@ssdandy ~]# perf test 21
> 21: Test object code reading                               : FAILED!
> [root@ssdandy ~]# 


From: Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] perf tests: Handle throttle events in 'object code reading' test

Unhandled events cause an error that fails the test

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/tests/code-reading.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 6d9dc19..85d4919 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -275,8 +275,19 @@ static int process_event(struct machine *machine, struct perf_evlist *evlist,
 	if (event->header.type == PERF_RECORD_SAMPLE)
 		return process_sample_event(machine, evlist, event, state);
 
-	if (event->header.type < PERF_RECORD_MAX)
-		return machine__process_event(machine, event, NULL);
+	if (event->header.type == PERF_RECORD_THROTTLE ||
+	    event->header.type == PERF_RECORD_UNTHROTTLE)
+		return 0;
+
+	if (event->header.type < PERF_RECORD_MAX) {
+		int ret;
+
+		ret = machine__process_event(machine, event, NULL);
+		if (ret < 0)
+			pr_debug("machine__process_event failed, event type %u\n",
+				 event->header.type);
+		return ret;
+	}
 
 	return 0;
 }
-- 
1.7.11.7


