Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3JRP5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223Ab3JRP5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:57:21 -0400
Date: Fri, 18 Oct 2013 17:49:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uprobes: Change uprobe_copy_process() to dup
	xol_area
Message-ID: <20131018154934.GA14794@redhat.com>
References: <20131013191815.GA32466@redhat.com> <20131013191844.GA32502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013191844.GA32502@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13, Oleg Nesterov wrote:
>
> Unfortunately, uprobe_copy_process() can not simply do
> __create_xol_area(child, xol_area->vaddr). This could actually work
> but perf_event_mmap() doesn't expect the usage of foreign ->mm. So
> we offload this to task_work_run(), and pass the argument via not
> yet used utask->vaddr.

OK, this patch needs a fix, I'll send v2 in a minute.


> +	work = kmalloc(sizeof(*work), GFP_KERNEL);
> +	if (!work)
> +		return uprobe_warn(t, "dup xol area");
> +
> +	utask->vaddr = mm->uprobes_state.xol_area->vaddr;

Yes, currently utask->return_instances && !uprobes_state.xol_area
is not possible.

> +	init_task_work(work, dup_xol_work);
> +	task_work_add(t, work, true);

But if dup_xol_work() fails and the child does another fork(), it
can hit area == NULL, so we need to check this.

Oleg.

