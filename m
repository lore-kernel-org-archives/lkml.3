Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3AXN3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:29:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab3AXN3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:29:16 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=7UwS5AP4EsIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=tqG-MREYpvAA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=JiJ64MnnBwk5KDO_vOYA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359034154.21576.142.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL] tracing: Fix unsigned int compare of zero in
 recursion check
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 24 Jan 2013 08:29:14 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I've put this on top of the patches I posted for linux-next, as
those were the patches that contained the bug this fixed.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: d41032a83b4683481cadff84bbf8e0eafeaba830


Steven Rostedt (1):
      tracing: Fix unsigned int compare of zero in recursion check

----
 kernel/trace/trace_functions.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit d41032a83b4683481cadff84bbf8e0eafeaba830
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Jan 24 07:52:34 2013 -0500

    tracing: Fix unsigned int compare of zero in recursion check
    
    Dan's smatch found a compare bug with the result of the
    trace_test_and_set_recursion() and comparing to less than
    zero. If the function fails, it returns -1, but was saved in
    an unsigned int, which will never be less than zero and will
    ignore the result of the test if a recursion did happen.
    
    Luckily this is the last of the recursion tests, as the
    infrastructure of ftrace would catch recursions before it
    got here, except for some few exceptions.
    
    Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 1c327ef..6011525 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -61,7 +61,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip,
 	struct trace_array *tr = func_trace;
 	struct trace_array_cpu *data;
 	unsigned long flags;
-	unsigned int bit;
+	int bit;
 	int cpu;
 	int pc;
 


