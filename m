Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaLCGWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 01:22:18 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:50054 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaLCGWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 01:22:17 -0500
MIME-Version: 1.0
In-Reply-To: <20141203032106.156623189@goodmis.org>
References: <20141203031334.174087814@goodmis.org>
	<20141203032106.156623189@goodmis.org>
Date: Tue, 2 Dec 2014 22:22:16 -0800
Message-ID: <CAMEtUuyzfKYVSJUra6nib-wWYQ91uEPC6mizF9PLpg+5Kjb+3w@mail.gmail.com>
Subject: Re: [PATCH 3/3] ftracetests: Add test to test event filter logic
From: Alexei Starovoitov <ast@plumgrid.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 7:13 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>
> Add a test to test the event filter logic. It currently tests the
> following filters against sched:sched_switch event.
>
>    ( prev_pid != 0 )
>    ( prev_pid == 0 )
>    ( prev_pid < 100 )
>    ( prev_pid <= $$ )
>    ( prev_pid > 100 )
>    ( prev_pid >= $$ )
>   ! ( prev_pid != 0 )
>   ! ( prev_pid == 0 )
>   ! ( prev_pid < 100 )
>   ! ( prev_pid <= $$ )
>   ! ( prev_pid > 100 )
>   ! ( prev_pid >= $$ )
>    ( prev_pid != 0 && next_pid > 10 )
>    ( prev_pid != 0 || next_pid > 10 )
>   ! ( prev_pid != 0 && next_pid > 10 )
>   ! ( prev_pid != 0 || next_pid > 10 )
>    ( prev_pid & 1 )
>    ( prev_pid & 2 )
>    ( prev_pid & 4 )
>    ( prev_pid & 8 )
>    ( prev_pid & 16 )
>   ! ( prev_pid & 1 )
>   ! ( prev_pid & 2 )
>   ! ( prev_pid & 4 )
>   ! ( prev_pid & 8 )
>   ! ( prev_pid & 16 )
>    ( next_comm ~ "ftrace-test-fil" )
>    ( next_comm != "ftrace-test-fil" )
>   ! ( next_comm ~ "ftrace-test-fil" )
>   ! ( next_comm != "ftrace-test-fil" )

thanks for the tests!
Since you're adding full support for 'not',
I think would be good to have few more tests
where ! is not a top node. Like:
(prev_pid != 0 && !(next_pid & 2))
and another one with ! at multiple levels, like:
(prev_pid != 0 && !(next_pid != 2 && !(prev_pid > 3)))
... or reject them during parsing.
