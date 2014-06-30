Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaF3SAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:00:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbaF3SAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:00:06 -0400
Date: Mon, 30 Jun 2014 19:58:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] tracing/uprobes: Fix the usage of
	uprobe_buffer_enable() in probe_event_enable()
Message-ID: <20140630175836.GB21918@redhat.com>
References: <20140627170116.GA18298@redhat.com> <20140627170146.GA18332@redhat.com> <20140630170409.GD5619@linux.vnet.ibm.com> <20140630132126.5479795e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630132126.5479795e@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30, Steven Rostedt wrote:
>
> On Mon, 30 Jun 2014 22:34:09 +0530
> Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:
>
> > > +	if (ret)
> > > +		goto err_buffer;
> > >
> > > +	return 0;
> > > +
> > > + err_buffer:
> > > +	uprobe_buffer_disable();
> > > +
> >
> > How about avoiding err_buffer label?
> > +	if (!ret)
> > +		return 0;
> >
> > +	uprobe_buffer_disable();
> > +
> >
>
> Oleg, you OK with this update?
>
> I can kill my tests and restart with this update. Or you can resend this
> patch. Or we can just push it as is, and have this be a patch that
> get's queued as a cleanup for 3.17?

Well, if you too think that this change can make the code cleaner I should
probably make it ;)

But, to me

		err = init_1();
		if (err)
			goto err_1;

		err = init_2();
		if (err)
			goto err_2;

		return 0;

	 err_2:
		cleanup_2();
	 err_1:
		cleanup_1();

looks better than

		err = init_1();
		if (err)
			goto err_1;

		err = init_2();
		if (!err)
			return 0;

		cleanup_2();
	 err_1:
		cleanup_1();

just because the 1st variant is more symmetrical. And in fact it is more
flexible, we might add init_3/etc.

But I won't insist, this is subjective. So please let me know if you still
think it would be better to add this change, I'll send v2.

Oleg.

