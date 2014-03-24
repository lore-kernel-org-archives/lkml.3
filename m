Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaCXKlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 06:41:04 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:36479 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbaCXKlC convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Mon, 24 Mar 2014 06:41:02 -0400
Message-Id: <533019C9020000A100014F79@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 24 Mar 2014 11:40:57 +0100
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q: uniqueness of pthread_t
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm programming a little bit with pthreads in Linux. As I understand pthread_t is an opaque type (a pointer address?) that cannot be mapped to the kernel's TID easily. Anyway: Is it expected that when one thread terminates and another thread is created (in fact the same thread again), that the p_thread my be resused?

It seems it just happened when debugging my program (or I made a programming mistake (code compiles clean with -Wall):
---
[...]
cleanup_thread: 1 used connection entries
 5888 [^D] (null) -> 192.168.255.18/80
cleanup_thread: leaves with -1: No child processes
8407: [8413](172.20.64.67/54560) handles socket 4
cleanup_thread 139852035340032 terminated
created cleanup_thread 139852035340032
accepting connection (1 handlers)
[...]
---
libgthread-2_0-0-2.22.5-0.8.12.1 (SLES11 SP3 on x86_64)

The code handling the threads looks like this (so the results should be reliable, I guess):

                        if ( tid != 0 && pthread_tryjoin_np(tid, &ret) == 0 )
                        {
                                DEBUG(1) printf("cleanup_thread %ld terminated\\
n",
                                                (long) tid);
                                tid = 0;
                        }
[...]
                        if ( tid != 0 && pthread_tryjoin_np(tid, &ret) == 0 )
                        {
                                DEBUG(1) printf("cleanup_thread %ld terminated\\
n",
                                                (long) tid);
                                tid = 0;
                        }

(The code above also runs strictly sequential)

And while I'm at it: There's a bug in the man page:
---
PTHREAD_TRYJOIN_NP(3)      Linux Programmer's Manual     PTHREAD_TRYJOIN_NP(3)



NAME
       pthread_tryjoin_np,  pthread_timedjoin_np  -  try to join with a termi-
       nated thread

SYNOPSIS
       #define _GNU_SOURCE
       #include <pthread.h>

       int pthread_tryjoin_np(pthread_t thread, void **retval);

       int pthread_timedjoin_np(pthread_t thread, void **retval,
                                const struct timespec *abstime);

       Compile and link with -pthread.
---

You must include <features.h> after defining  _GNU_SOURCE, and you must do this early in your includes...

I'm not subscribed d to LKML, so please CC your answers to me.

Regards,
Ulrich


