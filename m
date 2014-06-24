Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaFXGrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:47:41 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:51313 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaFXGrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:47:40 -0400
X-CheckPoint: {53A91F0B-3-2100090A-C0000000}
From: Tony Lu <zlu@tilera.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: RE: [BUG] perf: can not resolve symbols for forked threads
Thread-Topic: [BUG] perf: can not resolve symbols for forked threads
Thread-Index: Ac+LkZpePTEeNhTMTFiyTTQLhkayegDUzbOAACKUfjA=
Date: Tue, 24 Jun 2014 06:47:38 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C5D76499C@USMAExch1.tad.internal.tilera.com>
References: <BAB94DBB0E89D8409949BC28AC95914C5D762567@USMAExch1.tad.internal.tilera.com>
 <20140623091243.GN19860@laptop.programming.kicks-ass.net>
In-Reply-To: <20140623091243.GN19860@laptop.programming.kicks-ass.net>
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

Thanks for your reply.

>-----Original Message-----
>From: Peter Zijlstra [mailto:peterz@infradead.org]
>Sent: Monday, June 23, 2014 5:13 PM
>To: Tony Lu
>Cc: Paul Mackerras; Ingo Molnar; Arnaldo Carvalho de Melo;
>linux-kernel@vger.kernel.org; Chris Metcalf
>Subject: Re: [BUG] perf: can not resolve symbols for forked threads
>
>On Thu, Jun 19, 2014 at 07:39:42AM +0000, Tony Lu wrote:
>> Hi
>>
>> I got the below output that shows perf can not resolve symbols for
>> forked threads. I did a system-wide collection from all CPUs after the
>> application hello run.
>
>There's no fork() in... :-)

Yes, but perf regards pthread_created threads as forked threads, and a PERF_RECORD_FORK event will be delivered when a thread is forked or cloned.

>
>> #include <pthread.h>
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <unistd.h>
>> #define NUM_THREADS     5
>>
>> void foo(void)
>> {
>>   long i = 1000000000;
>>   while (i--) {
>>     ;
>>   }
>> }
>>
>> void *PrintHello(void *threadid)
>> {
>>    long tid;
>>    tid = (long)threadid;
>>    printf("Hello World! It's me, thread #%ld!\n", tid);
>>    foo();
>>    pthread_exit(NULL);
>> }
>>
>> int main(int argc, char *argv[])
>> {
>>    pthread_t threads[NUM_THREADS];
>>    int rc;
>>    long t;
>>    for(t=0;t<NUM_THREADS;t++){
>>      printf("In main: creating thread %ld\n", t);
>>      rc = pthread_create(&threads[t], NULL, PrintHello, (void *)t);
>>      if (rc){
>>        printf("ERROR; return code from pthread_create() is %d\n", rc);
>>        exit(-1);
>>        }
>>      }
>>
>>    /* Last thing that main() should do */
>>    pthread_exit(NULL);
>> }
>
>That pthread_exit() is the problem; this results in:
>
>29456 pts/23   Zl     0:00          |               \_ [hello] <defunct>
>
>You want to wait for the threads to complete using pthread_join().
>
>I suspect the defunct state hides the process.

Yes, using pthread_join() can workaround this problem.
Does that mean the parent thread can not exit before the child threads? It still seems like a perf bug.

-Thanks
-Tony
