Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab3GVLTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:19:09 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49443 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab3GVLTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:19:07 -0400
Message-ID: <51ED1528.8070807@hitachi.com>
Date: Mon, 22 Jul 2013 20:19:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, jovi.zhangwei@huawei.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v3 2/9] tracing: add basic event trigger framework
References: <cover.1374245042.git.tom.zanussi@linux.intel.com> <8392a194f5994bc59b387bcde5cab5588e341fff.1374245042.git.tom.zanussi@linux.intel.com>
In-Reply-To: <8392a194f5994bc59b387bcde5cab5588e341fff.1374245042.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/20 0:09), Tom Zanussi wrote:
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index af6eb2c..d3e8626 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -1021,6 +1021,43 @@ extern int event_trace_del_tracer(struct trace_array *tr);
>  extern struct mutex event_mutex;
>  extern struct list_head ftrace_events;
>  
> +extern const struct file_operations event_trigger_fops;
> +
> +extern int register_trigger_cmds(void);
> +
> +struct event_trigger_ops {
> +	void			(*func)(void **data);
> +	int			(*init)(struct event_trigger_ops *ops,
> +					void **data);
> +	void			(*free)(struct event_trigger_ops *ops,
> +					void **data);
> +	int			(*print)(struct seq_file *m,
> +					 struct event_trigger_ops *ops,
> +					 void *data);
> +};

Please add comments what each ops does. :)

> +
> +struct event_command {
> +	struct list_head	list;
> +	char			*name;
> +	enum trigger_mode	trigger_mode;
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
> +	struct event_trigger_ops *(*get_trigger_ops)(char *cmd, char *param);
> +};

Ditto.

[...]
> +static int event_trigger_regex_open(struct inode *inode, struct file *file)
> +{
> +	struct trigger_iterator *iter;
> +	int ret = 0;
> +
> +	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
> +	if (!iter)
> +		return -ENOMEM;
> +
> +	iter->file = inode->i_private;
> +
> +	mutex_lock(&event_mutex);
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

Perhaps, unfortunately, this will not work correctly if currently
discussing bugfix approach is applied.

Oleg, would you help us what this should be?

> +	mutex_unlock(&event_mutex);
> +
> +	return ret;
> +}

[...]

> +static int unregister_event_command(struct event_command *cmd,
> +				    struct list_head *cmd_list,
> +				    struct mutex *cmd_list_mutex)
> +{
> +	struct event_command *p, *n;
> +	int ret = -ENODEV;
> +
> +	mutex_lock(cmd_list_mutex);
> +	list_for_each_entry_safe(p, n, cmd_list, list) {
> +		if (strcmp(cmd->name, p->name) == 0) {
> +			ret = 0;
> +			list_del_init(&p->list);
> +			goto out_unlock;
> +		}
> +	}
> + out_unlock:
> +	mutex_unlock(cmd_list_mutex);
> +
> +	return ret;
> +}

OK, it seems that this is used only for rollback process in __init
functions. If so, it should have __init (and a comment),
or we need a refcount to check no one uses the command anymore.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


