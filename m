Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbaFSHjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:39:45 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:13834 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaFSHjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:39:44 -0400
X-CheckPoint: {53A293BF-F-2100090A-C0000000}
From: Tony Lu <zlu@tilera.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lu <zlu@tilera.com>, Chris Metcalf <cmetcalf@tilera.com>
Subject: [BUG] perf: can not resolve symbols for forked threads
Thread-Topic: [BUG] perf: can not resolve symbols for forked threads
Thread-Index: Ac+LkZpePTEeNhTMTFiyTTQLhkayeg==
Date: Thu, 19 Jun 2014 07:39:42 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C5D762567@USMAExch1.tad.internal.tilera.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.200.0.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I got the below output that shows perf can not resolve symbols for forked threads. I did a system-wide collection from all CPUs after the application hello run.

-bash-4.1$ ./perf --version
perf version 3.16.rc1.ge99cfa2
-bash-4.1$ ./hello & ./perf record -a sleep 5
-bash-4.1$ ./perf report
# Overhead      Command       Shared Object                         Symbol
# ........  ...........  ..................  .............................
#
    54.77%        hello  [unknown]           [.] 0x0000000000400610       
    28.59%        hello  [unknown]           [.] 0x0000000000400615       
    16.53%        hello  [unknown]           [.] 0x000000000040061f       
     0.01%        hello  [kernel.kallsyms]   [k] __rcu_process_callbacks  
     0.01%         perf  [kernel.kallsyms]   [k] copy_user_generic_string 
     0.01%        sleep  [kernel.kallsyms]   [k] filemap_fault
....

/***************************************************************************** FILE: hello.c
** DESCRIPTION:
** A "hello world" Pthreads program to trigger this bug.
***************************************************************************/
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#define NUM_THREADS     5

void foo(void)
{
  long i = 1000000000;
  while (i--) {
    ;
  }
}

void *PrintHello(void *threadid)
{
   long tid;
   tid = (long)threadid;
   printf("Hello World! It's me, thread #%ld!\n", tid);
   foo();
   pthread_exit(NULL);
}

int main(int argc, char *argv[])
{
   pthread_t threads[NUM_THREADS];
   int rc;
   long t;
   for(t=0;t<NUM_THREADS;t++){
     printf("In main: creating thread %ld\n", t);
     rc = pthread_create(&threads[t], NULL, PrintHello, (void *)t);
     if (rc){
       printf("ERROR; return code from pthread_create() is %d\n", rc);
       exit(-1);
       }
     }

   /* Last thing that main() should do */
   pthread_exit(NULL);
}

Thanks
-Tony
