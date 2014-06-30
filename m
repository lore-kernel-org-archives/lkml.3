Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaF3Rvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:51:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbaF3Rvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:51:50 -0400
Date: Mon, 30 Jun 2014 19:50:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] tracing/uprobes: Fix the usage of
	uprobe_buffer_enable() in probe_event_enable()
Message-ID: <20140630175025.GA21918@redhat.com>
References: <20140627170116.GA18298@redhat.com> <20140627170146.GA18332@redhat.com> <20140630170409.GD5619@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630170409.GD5619@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30, Srikar Dronamraju wrote:
>
> > The usage of uprobe_buffer_enable() added by dcad1a20 is very wrong,
> >
> > 1. uprobe_buffer_enable() and uprobe_buffer_disable() are not balanced,
> >    _enable() should be called only if !enabled.
> >
> > 2. If uprobe_buffer_enable() fails probe_event_enable() should clear
> >    tp.flags and free event_file_link.
> >
> > 3. If uprobe_register() fails it should do uprobe_buffer_disable().
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks!

> (one nit .. )
>
> > +	ret = uprobe_buffer_enable();
> > +	if (ret)
> > +		goto err_flags;
> > +
> >  	tu->consumer.filter = filter;
> >  	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
> > -	if (ret) {
> > -		if (file) {
> > -			list_del(&link->list);
> > -			kfree(link);
> > -			tu->tp.flags &= ~TP_FLAG_TRACE;
> > -		} else
> > -			tu->tp.flags &= ~TP_FLAG_PROFILE;
> > -	}
> > +	if (ret)
> > +		goto err_buffer;
> >
> > +	return 0;
> > +
> > + err_buffer:
> > +	uprobe_buffer_disable();
> > +
>
> How about avoiding err_buffer label?
> +	if (!ret)
> +		return 0;
>
> +	uprobe_buffer_disable();
> +

Well, I do not really mind. But to me it looks more consistent this way,
if-something-fail-goto-err_label.

IOW, I think that the code should either not use err-labels, or always
use them like above.

Besides, perhaps we will add "if (file) uprobe_apply()" after _register()
to mix perf/ftrace, then we will need to change this "if (!ret)" code again.

Oleg.

