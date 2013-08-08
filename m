Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab3HHIaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:30:13 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51674 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab3HHIaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:30:10 -0400
Message-ID: <5203570E.3020201@hitachi.com>
Date: Thu, 08 Aug 2013 17:30:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 02/11] tracing: add basic event trigger framework
References: <cover.1375111640.git.tom.zanussi@linux.intel.com> <9660276cae921dfe8450cc259c99cd8b41ebb862.1375111640.git.tom.zanussi@linux.intel.com>
In-Reply-To: <9660276cae921dfe8450cc259c99cd8b41ebb862.1375111640.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/30 1:40), Tom Zanussi wrote:
> +struct event_command {
> +	struct list_head	list;
> +	char			*name;
> +	enum trigger_mode	trigger_mode;
> +	bool			post_trigger;
> +	int			(*func)(struct event_command *cmd_ops,
> +					void *cmd_data,	char *glob, char *cmd,
> +					char *params, int enable);
> +	int			(*reg)(char *glob,
> +				       struct event_trigger_ops *trigger_ops,
> +				       void *trigger_data, void *cmd_data);
> +	void			(*unreg)(char *glob,
> +					 struct event_trigger_ops *trigger_ops,
> +					 void *trigger_data, void *cmd_data);
> +	int			(*set_filter)(char *filter_str,
> +					      void *trigger_data,
> +					      void *cmd_data);

I think you should pass trace_event_file *file (see below) instead of ambiguous
void *cmd_data, because all handler implementations expect that.


[...]
> +#include <linux/module.h>
> +#include <linux/ctype.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +
> +#include "trace.h"
> +
> +static LIST_HEAD(trigger_commands);
> +static DEFINE_MUTEX(trigger_cmd_mutex);
> +
> +struct event_trigger_data {
> +	struct ftrace_event_file	*file;
> +	unsigned long			count;
> +	int				ref;
> +	bool				enable;
> +	struct event_trigger_ops	*ops;
> +	enum trigger_mode		mode;
> +	struct event_filter		*filter;
> +	char				*filter_str;
> +	struct list_head		list;
> +};
> +
> +struct trigger_iterator {
> +	struct ftrace_event_file	*file;
> +};

Why would you define this trigger_iterator even if it has
only one member? This means all iterators can be replaced
by the file. I'd like to keep it simple.

> +
> +void event_triggers_call(struct ftrace_event_file *file)
> +{
> +	struct event_trigger_data *data;
> +
> +	if (list_empty(&file->triggers))
> +		return;
> +
> +	preempt_disable_notrace();
> +	list_for_each_entry_rcu(data, &file->triggers, list)
> +		data->ops->func((void **)&data);
> +	preempt_enable_notrace();
> +}
> +EXPORT_SYMBOL_GPL(event_triggers_call);
> +
> +static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
> +{
> +	struct trigger_iterator *iter = m->private;
> +
> +	return seq_list_next(t, &iter->file->triggers, pos);
> +}
> +
> +static void *trigger_start(struct seq_file *m, loff_t *pos)
> +{
> +	struct trigger_iterator *iter = m->private;
> +
> +	mutex_lock(&event_mutex);
> +
> +	return seq_list_start(&iter->file->triggers, *pos);
> +}

By Oleg's bugfixes, we are now using event_file_data(filp)
please refer the f_start/trace_format_open implementation
which is the closest usage of the trigger file.


> +static int event_trigger_regex_open(struct inode *inode, struct file *file)
> +{
> +	struct trigger_iterator *iter;
> +	int ret = 0;
> +
> +	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
> +	if (!iter)
> +		return -ENOMEM;
> +
> +	mutex_lock(&event_mutex);
> +
> +	iter->file = inode->i_private;
> +
> +	if (file->f_mode & FMODE_READ) {
> +		ret = seq_open(file, &event_triggers_seq_ops);
> +		if (!ret) {
> +			struct seq_file *m = file->private_data;
> +			m->private = iter;
> +		} else {
> +			/* Failed */
> +			kfree(iter);
> +		}
> +	} else
> +		file->private_data = iter;
> +
> +	mutex_unlock(&event_mutex);
> +
> +	return ret;
> +}

As you can see in trace_format_open(), now file->private_data and
m->private will point struct file *, don't need to allocate something.

> +static ssize_t event_trigger_regex_write(struct file *file,
> +					 const char __user *ubuf,
> +					 size_t cnt, loff_t *ppos, int enable)
> +{
> +	struct trigger_iterator *iter = file->private_data;
> +	ssize_t ret;
> +	char *buf;
> +
> +	if (!cnt)
> +		return 0;
> +
> +	if (cnt >= PAGE_SIZE)
> +		return -EINVAL;
> +
> +	if (file->f_mode & FMODE_READ) {
> +		struct seq_file *m = file->private_data;
> +		iter = m->private;
> +	} else
> +		iter = file->private_data;
> +
> +	buf = (char *)__get_free_page(GFP_TEMPORARY);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(buf, ubuf, cnt)) {
> +		free_page((unsigned long) buf);
> +		return -EFAULT;
> +	}
> +	buf[cnt] = '\0';
> +	strim(buf);
> +
> +	ret = trigger_process_regex(iter, buf, enable);

You also need to get event_mutex while processing event_file to
prevent unexpected releasing.

> +
> +	free_page((unsigned long) buf);
> +	if (ret < 0)
> +		goto out;
> +
> +	*ppos += cnt;
> +	ret = cnt;
> + out:
> +	return ret;
> +}

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


