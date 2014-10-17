Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaJQONS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:13:18 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:64247 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaJQONR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:13:17 -0400
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Fri, 17 Oct 2014 10:19:50 -0400 (EDT)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: 3.17 another perf_fuzzer lockup
In-Reply-To: <alpine.DEB.2.11.1410161723220.9124@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1410171015540.15673@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1410061130100.11293@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410061151400.12313@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.11.1410151418570.3151@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1410161723220.9124@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014, Vince Weaver wrote:

> > It looks like the
> > 			else if (task->perf_event_ctxp[ctxn])
> > 	                        err = -EAGAIN;
> 
> It is indeed stuck there, waiting for task->perf_event_ctxp[1] to get
> set to zero, which never happens.
> 

OK, so with some more printk()s, it looks like somehow the parent thread
is trying to open a software event on itself.

	task->perf_event_ctxp[1]

has a valid pointer, but the ctx it points to has a ctx->lock of 0.

So perf_lock_task_context() always returns NULL.

So in find_get_context()
	we get stuck in an infinite retry loop, waiting forever for
	either ctx->lock to go positive or for task->perf_event_ctxp[1]
	to go NULL, neither of which is going to happen.

Now to find out why this could happen.  Probably something to do with 
crazy RCU magic :(

Vince

