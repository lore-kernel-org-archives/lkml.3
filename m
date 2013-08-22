Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3HVTy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:54:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:35187 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab3HVTy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:54:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,935,1367996400"; 
   d="scan'208";a="390539892"
Message-ID: <1377201249.1620.93.camel@empanada>
Subject: Re: [PATCH v4 02/11] tracing: add basic event trigger framework
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Date: Thu, 22 Aug 2013 14:54:09 -0500
In-Reply-To: <5203570E.3020201@hitachi.com>
References: <cover.1375111640.git.tom.zanussi@linux.intel.com>
	 <9660276cae921dfe8450cc259c99cd8b41ebb862.1375111640.git.tom.zanussi@linux.intel.com>
	 <5203570E.3020201@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 17:30 +0900, Masami Hiramatsu wrote:
> (2013/07/30 1:40), Tom Zanussi wrote:
> > +struct event_command {
> > +	struct list_head	list;
> > +	char			*name;
> > +	enum trigger_mode	trigger_mode;
> > +	bool			post_trigger;
> > +	int			(*func)(struct event_command *cmd_ops,
> > +					void *cmd_data,	char *glob, char *cmd,
> > +					char *params, int enable);
> > +	int			(*reg)(char *glob,
> > +				       struct event_trigger_ops *trigger_ops,
> > +				       void *trigger_data, void *cmd_data);
> > +	void			(*unreg)(char *glob,
> > +					 struct event_trigger_ops *trigger_ops,
> > +					 void *trigger_data, void *cmd_data);
> > +	int			(*set_filter)(char *filter_str,
> > +					      void *trigger_data,
> > +					      void *cmd_data);
> 
> I think you should pass trace_event_file *file (see below) instead of ambiguous
> void *cmd_data, because all handler implementations expect that.
> 
> 
> [...]
> > +#include <linux/module.h>
> > +#include <linux/ctype.h>
> > +#include <linux/mutex.h>
> > +#include <linux/slab.h>
> > +
> > +#include "trace.h"
> > +
> > +static LIST_HEAD(trigger_commands);
> > +static DEFINE_MUTEX(trigger_cmd_mutex);
> > +
> > +struct event_trigger_data {
> > +	struct ftrace_event_file	*file;
> > +	unsigned long			count;
> > +	int				ref;
> > +	bool				enable;
> > +	struct event_trigger_ops	*ops;
> > +	enum trigger_mode		mode;
> > +	struct event_filter		*filter;
> > +	char				*filter_str;
> > +	struct list_head		list;
> > +};
> > +
> > +struct trigger_iterator {
> > +	struct ftrace_event_file	*file;
> > +};
> 
> Why would you define this trigger_iterator even if it has
> only one member? This means all iterators can be replaced
> by the file. I'd like to keep it simple.
> 

Right, this and the void *cmd_data are vestiges of the original patchset
where I tried to keep the ftrace_triggers and event_triggers unified.
This was meant to be a common iterator abstration which obviously is no
longer needed and has been removed in the new patchset.  

> > +
> > +void event_triggers_call(struct ftrace_event_file *file)
> > +{
> > +	struct event_trigger_data *data;
> > +
> > +	if (list_empty(&file->triggers))
> > +		return;
> > +
> > +	preempt_disable_notrace();
> > +	list_for_each_entry_rcu(data, &file->triggers, list)
> > +		data->ops->func((void **)&data);
> > +	preempt_enable_notrace();
> > +}
> > +EXPORT_SYMBOL_GPL(event_triggers_call);
> > +
> > +static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
> > +{
> > +	struct trigger_iterator *iter = m->private;
> > +
> > +	return seq_list_next(t, &iter->file->triggers, pos);
> > +}
> > +
> > +static void *trigger_start(struct seq_file *m, loff_t *pos)
> > +{
> > +	struct trigger_iterator *iter = m->private;
> > +
> > +	mutex_lock(&event_mutex);
> > +
> > +	return seq_list_start(&iter->file->triggers, *pos);
> > +}
> 
> By Oleg's bugfixes, we are now using event_file_data(filp)
> please refer the f_start/trace_format_open implementation
> which is the closest usage of the trigger file.
> 
> 
> > +static int event_trigger_regex_open(struct inode *inode, struct file *file)
> > +{
> > +	struct trigger_iterator *iter;
> > +	int ret = 0;
> > +
> > +	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
> > +	if (!iter)
> > +		return -ENOMEM;
> > +
> > +	mutex_lock(&event_mutex);
> > +
> > +	iter->file = inode->i_private;
> > +
> > +	if (file->f_mode & FMODE_READ) {
> > +		ret = seq_open(file, &event_triggers_seq_ops);
> > +		if (!ret) {
> > +			struct seq_file *m = file->private_data;
> > +			m->private = iter;
> > +		} else {
> > +			/* Failed */
> > +			kfree(iter);
> > +		}
> > +	} else
> > +		file->private_data = iter;
> > +
> > +	mutex_unlock(&event_mutex);
> > +
> > +	return ret;
> > +}
> 
> As you can see in trace_format_open(), now file->private_data and
> m->private will point struct file *, don't need to allocate something.
> 

Right, and this has all been simplified now too as a result..

> > +static ssize_t event_trigger_regex_write(struct file *file,
> > +					 const char __user *ubuf,
> > +					 size_t cnt, loff_t *ppos, int enable)
> > +{
> > +	struct trigger_iterator *iter = file->private_data;
> > +	ssize_t ret;
> > +	char *buf;
> > +
> > +	if (!cnt)
> > +		return 0;
> > +
> > +	if (cnt >= PAGE_SIZE)
> > +		return -EINVAL;
> > +
> > +	if (file->f_mode & FMODE_READ) {
> > +		struct seq_file *m = file->private_data;
> > +		iter = m->private;
> > +	} else
> > +		iter = file->private_data;
> > +
> > +	buf = (char *)__get_free_page(GFP_TEMPORARY);
> > +	if (!buf)
> > +		return -ENOMEM;
> > +
> > +	if (copy_from_user(buf, ubuf, cnt)) {
> > +		free_page((unsigned long) buf);
> > +		return -EFAULT;
> > +	}
> > +	buf[cnt] = '\0';
> > +	strim(buf);
> > +
> > +	ret = trigger_process_regex(iter, buf, enable);
> 
> You also need to get event_mutex while processing event_file to
> prevent unexpected releasing.
> 

Thanks for catching that too.

> > +
> > +	free_page((unsigned long) buf);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	*ppos += cnt;
> > +	ret = cnt;
> > + out:
> > +	return ret;
> > +}
> 
> Thank you,
> 

Thank you.

Tom

