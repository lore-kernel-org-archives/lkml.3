Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3EVTIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:08:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3069 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3EVTIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:08:46 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=3AOBlnlxc8cA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=WH5RVVIf4hAA:10 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=Mkpltr33E9gHoIikWhAA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369249725.6828.180.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL] tracing: Return -EBUSY when event_enable_func()
 fails to get module
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tom.zanussi@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Wed, 22 May 2013 15:08:45 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Masami Hiramatsu fixed another bug. This time returning a proper
result in event_enable_func(). After checking the return status
of try_module_get(), it returned the status of try_module_get(). But
try_module_get() returns 0 on failure, which is success for
event_enable_func().

Please pull the latest trace-fixes-v3.10-rc2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.10-rc2

Tag SHA1: f1733dffe0252fd03bf115d6b15b0e0842b3facd
Head SHA1: 6ed0106667d76589cb648c27edb4f4ffbf9d59ca


Masami Hiramatsu (1):
      tracing: Return -EBUSY when event_enable_func() fails to get module

----
 kernel/trace/trace_events.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
---------------------------
commit 6ed0106667d76589cb648c27edb4f4ffbf9d59ca
Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date:   Thu May 16 20:48:49 2013 +0900

    tracing: Return -EBUSY when event_enable_func() fails to get module
    
    Since try_module_get() returns false( = 0) when it fails to
    pindown a module, event_enable_func() returns 0 which means
    "succeed". This can cause a kernel panic when the entry
    is removed, because the event is already released.
    
    This fixes the bug by returning -EBUSY, because the reason
    why it fails is that the module is being removed at that time.
    
    Link: http://lkml.kernel.org/r/20130516114848.13508.97899.stgit@mhiramat-M0-7522
    
    Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    Cc: Oleg Nesterov <oleg@redhat.com>
    Cc: Tom Zanussi <tom.zanussi@intel.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7a0cf68..27963e2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2072,8 +2072,10 @@ event_enable_func(struct ftrace_hash *hash,
  out_reg:
 	/* Don't let event modules unload while probe registered */
 	ret = try_module_get(file->event_call->mod);
-	if (!ret)
+	if (!ret) {
+		ret = -EBUSY;
 		goto out_free;
+	}
 
 	ret = __ftrace_event_enable_disable(file, 1, 1);
 	if (ret < 0)


