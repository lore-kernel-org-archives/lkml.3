Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaI2Smd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:42:33 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:50624 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbaI2Smc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:42:32 -0400
MIME-Version: 1.0
In-Reply-To: <9930.1412012182@turing-police.cc.vt.edu>
References: <CALCETrU3nNvG6+-7iScYT8LDRFnq8kYnpK0cdW1bgW5O4EGrUg@mail.gmail.com>
 <9930.1412012182@turing-police.cc.vt.edu>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 11:42:08 -0700
Message-ID: <CALCETrWQLEB1tPO1pfEEyA5LWre6x7aEa08+L4HDb4uUezFiPA@mail.gmail.com>
Subject: Re: Tightening up rdpmc permissions?
To: Valdis.Kletnieks@vt.edu
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 29, 2014 10:36 AM, <Valdis.Kletnieks@vt.edu> wrote:
>
> On Mon, 29 Sep 2014 09:39:16 -0700, Andy Lutomirski said:
>
> > Would it make sense to restrict rdpmc to tasks that are in mms that
> > have a perf_event mapping?  After all, unless I misunderstand
> > something, user code can't reliably use rdpmc unless they've mapped a
> > perf_event object to check the rdpmc bit and figure out what ecx value
> > to use.
>
> Wouldn't that be trivially easy for an attacker to bypass? Just map a dummy
> perf_event object  and then go to town?

Depends on the paranoia setting.  We could require that the mapped
object actually have an rdpmc-able counter running.

Seccomp can (and often does) block access to perf_event_open entirely.
We could certainly change the code to only twiddle CR4 if TIF_SECCOMP
or TIF_NOTSC is set.  I think that the real thing we should optimize
for is to minimize the chance that a given context switch actually
needs to *change* cr4.  Since perf_event maps are relatively unusual,
at least only perf-using programs would have overhead if we just gated
it on the existence of a useful rdpmc-able mapping.

(Also, why on earth is TIF_NOTSC a thread_info flag?  Wouldn't just
adding a field "cr4" to task_struct or something be simpler and quite
possibly faster?  We have a branch anyway...)

--Andy
