Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188Ab3CZBLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 21:11:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab3CZBLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 21:11:36 -0400
Message-ID: <5150F5C0.70205@redhat.com>
Date: Mon, 25 Mar 2013 19:11:28 -0600
From: Ben Woodard <woodard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        roland@frob.com
CC: Oleg Nesterov <oleg@redhat.com>, "Mark A. Grondona" <grondona1@llnl.gov>
Subject: [PATCH] Fix child thread's introspection of /proc/self/exe
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow threads other than the main thread to do introspection of files in 
proc without relying on read permissions. proc_pid_follow_link() calls 
proc_fd_access_allowed() which ultimately calls __ptrace_may_access().

Though this allows additional access to some proc files, we do not 
believe that this has any unintended security implications. However it 
probably needs to be looked at carefully.

The original problem was a thread of a process whose permissions were 
111 couldn't open its own /proc/self/exe This was interfering with a 
special purpose debugging tool. A simple reproducer is below.:

#include <pthread.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>

#define BUFSIZE 2048

void *thread_main(void *arg){
   char *str=(char*)arg;
   char buf[BUFSIZE];
   ssize_t len=readlink("/proc/self/exe", buf, BUFSIZE);
   if(len==-1)
     printf("/proc/self/exe in %s: %s\n", str,sys_errlist[errno]);
   else
     printf("/proc/self/exe in %s: OK\n", str);

   return 0;
}

int main(){
   pthread_t thread;

   int retval=pthread_create( &thread, NULL, thread_main, "thread");
   if(retval!=0)
     exit(1);

   thread_main("main");
   pthread_join(thread, NULL);

   exit(0);
}

Signed-off-by: Ben Woodard <woodard@redhat.com>
Signed-off-by: Mark Grondona <mgrondona@llnl.gov>
---
  kernel/ptrace.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index acbd284..347c4c7 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -234,7 +234,7 @@ static int __ptrace_may_access(struct task_struct 
*task, unsigned int mode)
          */
         int dumpable = 0;
         /* Don't let security modules deny introspection */
-       if (task == current)
+       if (same_thread_group(task, current))
                 return 0;
         rcu_read_lock();
         tcred = __task_cred(task);
-- 
1.8.1.4

