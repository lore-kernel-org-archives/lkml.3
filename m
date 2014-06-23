Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaFWJNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:13:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53071 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaFWJM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:12:58 -0400
Date: Mon, 23 Jun 2014 11:12:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tony Lu <zlu@tilera.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [BUG] perf: can not resolve symbols for forked threads
Message-ID: <20140623091243.GN19860@laptop.programming.kicks-ass.net>
References: <BAB94DBB0E89D8409949BC28AC95914C5D762567@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C5D762567@USMAExch1.tad.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 07:39:42AM +0000, Tony Lu wrote:
> Hi
> 
> I got the below output that shows perf can not resolve symbols for
> forked threads. I did a system-wide collection from all CPUs after the
> application hello run.

There's no fork() in... :-)

> #include <pthread.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #define NUM_THREADS     5
> 
> void foo(void)
> {
>   long i = 1000000000;
>   while (i--) {
>     ;
>   }
> }
> 
> void *PrintHello(void *threadid)
> {
>    long tid;
>    tid = (long)threadid;
>    printf("Hello World! It's me, thread #%ld!\n", tid);
>    foo();
>    pthread_exit(NULL);
> }
> 
> int main(int argc, char *argv[])
> {
>    pthread_t threads[NUM_THREADS];
>    int rc;
>    long t;
>    for(t=0;t<NUM_THREADS;t++){
>      printf("In main: creating thread %ld\n", t);
>      rc = pthread_create(&threads[t], NULL, PrintHello, (void *)t);
>      if (rc){
>        printf("ERROR; return code from pthread_create() is %d\n", rc);
>        exit(-1);
>        }
>      }
> 
>    /* Last thing that main() should do */
>    pthread_exit(NULL);
> }

That pthread_exit() is the problem; this results in:

29456 pts/23   Zl     0:00          |               \_ [hello] <defunct>

You want to wait for the threads to complete using pthread_join().

I suspect the defunct state hides the process.
