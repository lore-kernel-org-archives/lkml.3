Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936606Ab3DJW0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:26:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10593 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933304Ab3DJW0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:26:15 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=vGiWZ4XeiFUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=RJ2c6mANKGMA:10 a=VwQbUJbxAAAA:8 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=RwSQF0DHOOTZsKkpFZEA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365632757.9609.17.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL] tracing: Fix double free when function profile
 init failed
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, stable <stable@vger.kernel.org>
Date: Wed, 10 Apr 2013 18:25:57 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Namhyung Kim fixed a long standing bug that can cause a kernel panic.
If the function profiler fails to allocate memory for everything,
it will do a double free on the same pointer which can cause a panic.

Please pull the latest trace-fixes-3.9-rc-v2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-3.9-rc-v2

Head SHA1: 19d9c3b1c660a157c6c8b352793497cc67f7321e


Namhyung Kim (1):
      tracing: Fix double free when function profile init failed

----
 kernel/trace/ftrace.c |    1 -
 1 file changed, 1 deletion(-)
---------------------------
commit 83e03b3fe4daffdebbb42151d5410d730ae50bd1
Author: Namhyung Kim <namhyung.kim@lge.com>
Date:   Mon Apr 1 21:46:23 2013 +0900

    tracing: Fix double free when function profile init failed
    
    On the failure path, stat->start and stat->pages will refer same page.
    So it'll attempt to free the same page again and get kernel panic.
    
    Link: http://lkml.kernel.org/r/1364820385-32027-1-git-send-email-namhyung@kernel.org
    
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Namhyung Kim <namhyung.kim@lge.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Namhyung Kim <namhyung@kernel.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7e89710..926ebfb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -694,7 +694,6 @@ int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 		free_page(tmp);
 	}
 
-	free_page((unsigned long)stat->pages);
 	stat->pages = NULL;
 	stat->start = NULL;
 


