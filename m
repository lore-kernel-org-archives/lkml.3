Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934879Ab3BNTZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:25:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25030 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab3BNTZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:25:34 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ThT10dvzlIIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=cbgMe-uw_AwA:10 a=KhC275XfP8E48t7OVW8A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360869932.23152.51.camel@gandalf.local.home>
Subject: Re: [PATCH]sched/stop_task: Do not account zero delta_exec in
 put_prev_task_stop
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Thu, 14 Feb 2013 14:25:32 -0500
In-Reply-To: <878v6spwmk.fsf@sejong.aot.lge.com>
References: <180751360618804@web6d.yandex.ru>
	 <878v6spwmk.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 15:15 +0900, Namhyung Kim wrote:
> ---
> >  kernel/sched/stop_task.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
> > index da5eb5b..78d0458 100644
> > --- a/kernel/sched/stop_task.c
> > +++ b/kernel/sched/stop_task.c
> > @@ -58,8 +58,8 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
> >  	u64 delta_exec;
> >  
> >  	delta_exec = rq->clock_task - curr->se.exec_start;
> > -	if (unlikely((s64)delta_exec < 0))
> > -		delta_exec = 0;
> > +	if (unlikely((s64)delta_exec <= 0))
> > +		return;
> 
> It seems it needs to update curr->se.exec_start then.
> 

Ah, if it's less than zero, it does.

A better patch would be:

	if (unlikely((s64)delta_exec <= 0)) {
		curr->se.exec_start = rq->clock_task;
		return;
	}

Thanks!

-- Steve


