Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3LLOrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:47:25 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35113 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3LLOrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:47:23 -0500
Message-ID: <52A9CC77.20904@linaro.org>
Date: Thu, 12 Dec 2013 16:47:19 +0200
From: Ciprian Barbu <ciprian.barbu@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Clark Williams <williams@redhat.com>, RT <linux-rt-users@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>
Subject: [PATCH] rt-tests: hackbench: fix for uninitialized start time
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While playing around with hackbench I discovered that I would sometimes 
get an enormous time reported, even if the run time would be less than a 
second or so. The problem was that the struct timeval start was not 
initialized until after all children have been created. But if the 
program receives a signal before this is done, the start time is left 
uninitialized.

I propose that in such situations an error message be displayed, like 
the following patch does.

Please let me know if this is acceptable.

Regards,
/Ciprian

---
diff -rupN rt-tests/src/hackbench/hackbench.c 
rt-tests2/src/hackbench/hackbench.c
--- rt-tests/src/hackbench/hackbench.c  2013-12-12 16:27:06.273731063 +0200
+++ rt-tests2/src/hackbench/hackbench.c 2013-12-12 16:24:01.945738814 +0200
@@ -442,6 +442,7 @@ int main(int argc, char *argv[])
     struct timeval start, stop, diff;
     int readyfds[2], wakefds[2];
     char dummy;
+   int timer_started = 0;
     struct sched_param sp;

     process_options (argc, argv);
@@ -490,6 +491,7 @@ int main(int argc, char *argv[])
             }

         gettimeofday(&start, NULL);
+       timer_started = 1;

         /* Kick them off */
         if (write(wakefds[1], &dummy, 1) != 1) {
@@ -509,8 +511,12 @@ int main(int argc, char *argv[])
     gettimeofday(&stop, NULL);

     /* Print time... */
-   timersub(&stop, &start, &diff);
-   printf("Time: %lu.%03lu\n", diff.tv_sec, diff.tv_usec/1000);
+   if (timer_started) {
+       timersub(&stop, &start, &diff);
+       printf("Time: %lu.%03lu\n", diff.tv_sec, diff.tv_usec/1000);
+   } else {
+       fprintf(stderr, "No measurements available\n");
+   }
     free(child_tab);
     exit(0);
  }
