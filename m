Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaF3RVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:21:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:10369 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754774AbaF3RV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:21:28 -0400
Date: Mon, 30 Jun 2014 13:21:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] tracing/uprobes: Fix the usage of
 uprobe_buffer_enable() in probe_event_enable()
Message-ID: <20140630132126.5479795e@gandalf.local.home>
In-Reply-To: <20140630170409.GD5619@linux.vnet.ibm.com>
References: <20140627170116.GA18298@redhat.com>
	<20140627170146.GA18332@redhat.com>
	<20140630170409.GD5619@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 22:34:09 +0530
Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:


> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
> 

Oleg, you OK with this update?

I can kill my tests and restart with this update. Or you can resend this
patch. Or we can just push it as is, and have this be a patch that
get's queued as a cleanup for 3.17?

-- Steve

> 
> > + err_flags:
> > +	if (file) {
> > +		list_del(&link->list);
> > 
> > -- 
> > 1.5.5.1
> > 
> 

