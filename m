Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbaGNQRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:17:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbaGNQRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:17:03 -0400
Date: Mon, 14 Jul 2014 18:15:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] tracing: instance_rmdir() leaks
	ftrace_event_file->filter
Message-ID: <20140714161525.GA12633@redhat.com>
References: <20140711190622.GA19499@redhat.com> <1405346096.1745.17.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405346096.1745.17.camel@leonhard>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Namhyung Kim wrote:
>
> > And could someone explain me why apply_subsystem_event_filter("0") clears
> > ->filter_string first, then the whole ->filter? It seems that the only
> > thing filter_free_subsystem_preds() should do is filter_disable(), no?
> > IOW, why the patch below (on top of this series) is wrong?
>
> I also think that the original code is bit strange.  I agree with your
> change and name of the function should be changed to something like
> 'filter_disable_subsystem_filters' IMHO (it does nothing with preds).
> With this change, the apply_subsystem_event_filter can simply do below:
>
> 	if (!strcmp(strstrip(filter_string), "0")) {
> 		filter_disable_subsystem_filters(system, tr);
> 		/* Ensure all filters are no longer used */
> 		synchronize_sched();
> 		filter_free_subsystem_filters(system, tr);
> 		__free_filter(system->filter);
> 		system->filter = NULL;
> 		goto out_unlock;
> 	}

Yes, thanks, this was my point.

And I thought that I saw the same pattern somewhere else, but can't recall
where... Will try to recheck.

Oleg.

