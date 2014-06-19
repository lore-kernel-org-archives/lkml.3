Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934569AbaFSUbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:31:31 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:57664 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaFSUba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:31:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140619201801.GV8178@tassilo.jf.intel.com>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
	<1403193509-22393-2-git-send-email-eranian@google.com>
	<20140619180028.GU8178@tassilo.jf.intel.com>
	<CABPqkBTw9wi1LSoqWUYcN2W1fvBYDfsdqkdxDTPQ0rWUEUFLmA@mail.gmail.com>
	<20140619201801.GV8178@tassilo.jf.intel.com>
Date: Thu, 19 Jun 2014 22:31:29 +0200
Message-ID: <CABPqkBRy=u6oyyFV9yC9uOykHbNUdDqDgeQ3XSTpcAfQAyS-+g@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 10:18 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> I don't quite understand that.
>> You need to know which events support PEBS. You need a table
>
> We're talking about the kernel allowing things here.
> Yes the user still needs to know what supports PEBS, but
> that doesn't concern the kernel.
>
Just need to make sure you don't return bogus information.

> You can just allow it for all, it's a nop if the event doesn't
> support it. And also the fields like DataLA are simply 0 when
> not supported.
>

Let's take a example. If I do resource_stalls:pp, the kernel
will let it go through and clear the PMI bit on the config as
is required for PEBS mode. The counter will count normally
and never fire an interrupt, even when it overflows. It would
never execute the PMI handler and thus never look at the
PEBS content. You'd never get any samples.

> The only thing you need is a rule to limit to 4 counters.
>
> Then only cases that are special (PREC_DIST, extra registers)
> would need to be handled explicitely.
>
extra registers do no impose counter constraints. That's the approach
used by Intel tools to simplify scheduling. As I said in my patch, in
Linux we do this differently.

So yes, you'd need this for PREC_DIST and precise store on SNB, IVB.
