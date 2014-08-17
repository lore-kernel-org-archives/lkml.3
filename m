Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaHQVOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 17:14:53 -0400
Received: from forward4l.mail.yandex.net ([84.201.143.137]:60732 "EHLO
	forward4l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaHQVOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 17:14:52 -0400
X-Yandex-Uniq: 0521db18-7b31-4c2a-b4d5-19566e37b092
Authentication-Results: smtp19.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <53F11B45.8070105@yandex.ru>
Date: Mon, 18 Aug 2014 01:14:45 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] sched: tasklist_lock cleanups (Was: don't use while_each_thread())
References: <20140813191938.GA19301@redhat.com> <20140817152549.GA17984@redhat.com>
In-Reply-To: <20140817152549.GA17984@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.08.2014 19:25, Oleg Nesterov wrote:
> On 08/13, Oleg Nesterov wrote:
>>
>> Peter, could you take these simple patches ?
>>
>> Better later than never... per-file, but please feel free to join
>> them in a single patch.
>>
>> read_lock_irq*(tasklist_lock) in kernel/sched/ files looks strange.
>> Why? I'll recheck, but this looks unneeded.
> 
> Yes, please consider these minor cleanups on top of for_each_thread
> conversions.
> 
> read_lock_irq(tasklist) in normalize_rt_tasks() doesn't really hurt,
> but it looks confusing. If we really have a reason to disable irqs
> this (subtle) reason should be documented.
> 
> And I can't understand tg_has_rt_tasks(). Don't we need something
> like the patch below? If not, please do not ask me why I think so,
> I don't understand this black magic ;) But the usage of the global
> "runqueues" array looks suspicious.

This function searches RT task which is related to this tg. It's
opaquely because it looks that there is an error.

task_rq(p)->rt.tg is a task group of a top rt_rq, while the task may
be queued on a child rt_rq instead of this. So, your patch is a BUGFIX,
not a cleanup.

> --- x/kernel/sched/core.c
> +++ x/kernel/sched/core.c
> @@ -7354,7 +7354,7 @@ static inline int tg_has_rt_tasks(struct
>  	struct task_struct *g, *p;
>  
>  	for_each_process_thread(g, p) {
> -		if (rt_task(p) && task_rq(p)->rt.tg == tg)
> +		if (rt_task(p) && task_group(p) == tg)
>  			return 1;
>  	}
