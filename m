Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3HAOZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:25:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30216 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3HAOZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:25:56 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=DwKIpjyhPi4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-mLxqvm8HbQA:10 a=20KFwNOVAAAA:8 a=WuOfCoqmzs_Qvyn3OUEA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375367154.1152.25.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 4/4] tracing/uprobes: Fail to unregister if probe
 event files are open
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 01 Aug 2013 10:25:54 -0400
In-Reply-To: <20130801140856.GA11109@redhat.com>
References: <20130704033347.807661713@goodmis.org>
	 <20130704034038.991525256@goodmis.org> <20130801140856.GA11109@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 16:08 +0200, Oleg Nesterov wrote:
> On 07/03, Steven Rostedt wrote:
> >
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Acked-by: Oleg Nesterov <oleg@redhat.com>

Thanks!

> 
> 
> Just a couple of nits in the case you are going to redo this change,
> 
> > Modules do with with the module owner set (automated
> > from the VFS layer).
> 
> This logic is dead, I think.
> 
> > The ftrace buffer instances have a ref count added
> > to the trace_array when the enabled file is opened
> 
> This is too.
> 

Yeah, the change log needs an update.

> > -static void cleanup_all_probes(void)
> > +static int cleanup_all_probes(void)
> >  {
> >  	struct trace_uprobe *tu;
> > +	int ret = 0;
> >  
> >  	mutex_lock(&uprobe_lock);
> >  	while (!list_empty(&uprobe_list)) {
> >  		tu = list_entry(uprobe_list.next, struct trace_uprobe, list);
> > -		unregister_trace_uprobe(tu);
> > +		ret = unregister_trace_uprobe(tu);
> > +		if (ret)
> > +			break;
> >  	}
> >  	mutex_unlock(&uprobe_lock);
> > +	return ret;
> >  }
> 
> Again, it is not clear what exactly we should do and I won't argue
> either way. But note that (with or without this patch) this doesn't
> match kprobe's release_all_trace_probes() which checks (tries to,
> actually) trace_probe_is_enabled() for every probe first. Perhaps
> we should cleanup this later.

Agreed on all accounts. Especially the "we should cleanup this later"
part ;-)

> 
> >  static int probes_open(struct inode *inode, struct file *file)
> >  {
> > +	int ret = 0;
> > +
> >  	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC))
> > -		cleanup_all_probes();
> > +		ret = cleanup_all_probes();
> > +	if (ret)
> > +		return ret;
> 
> Cosmetic, but perhaps it would be a bit more clean to move this check
> (with "int ret") under if (WRITE && TRUNC) block.
> 

Yeah, agreed.

-- Steve


