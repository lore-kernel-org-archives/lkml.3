Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbaD2LQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:16:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933004AbaD2LQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:16:22 -0400
Date: Tue, 29 Apr 2014 13:15:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v3 2/3] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140429111551.GC1148@krava.brq.redhat.com>
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
 <1398346054-3322-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398346054-3322-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:27:33PM +0900, Namhyung Kim wrote:

SNIP

> -		rec->bytes_written / 24);
> +out_child:
> +	if (forks) {
> +		int exit_status;
>  
> -	return 0;
> +		if (!child_finished)
> +			kill(rec->evlist->workload.pid, SIGTERM);

also while at it.. do we want to force SIGKILL in case we dont
get any response for SIGTERM? so we dont get record hanging like
for following program:

---
#include <signal.h>

static void sig_handler(int sig)
{
}

int main(int argc, char **argv)
{
        signal(SIGINT, sig_handler);
        signal(SIGTERM, sig_handler);

        while (1) {}

        return 0;
}
---

the change would go into separate patch of course,
something like in patch below

thanks,
jirka


---
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 526edf5..a973ba5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -479,9 +479,20 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 out_child:
 	if (forks) {
 		int exit_status;
+		int zleep = 0;
+
+		while (!child_finished) {
+			if (!zleep)
+				kill(rec->evlist->workload.pid, SIGTERM);
+			if (zleep == 2000) {
+				pr_info("Child killed by SIGKILL.\n");
+				kill(rec->evlist->workload.pid, SIGKILL);
+				break;
+			}
 
-		if (!child_finished)
-			kill(rec->evlist->workload.pid, SIGTERM);
+			usleep(1000);
+			zleep++;
+		}
 
 		wait(&exit_status);
 
