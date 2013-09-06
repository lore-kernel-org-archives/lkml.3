Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3IFOZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:25:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:60559 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab3IFOZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:25:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,854,1371106800"; 
   d="scan'208";a="291643571"
Message-ID: <1378477531.7570.17.camel@empanada>
Subject: Re: [PATCH v8 02/10] tracing: Add basic event trigger framework
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Fri, 06 Sep 2013 09:25:31 -0500
In-Reply-To: <20130905132153.550819bf@gandalf.local.home>
References: <cover.1378176577.git.tom.zanussi@linux.intel.com>
	 <1197d661c123b9c5d084de2b7817aef6a9779e8c.1378176577.git.tom.zanussi@linux.intel.com>
	 <20130905132153.550819bf@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-05 at 13:21 -0400, Steven Rostedt wrote:
> On Mon,  2 Sep 2013 22:52:18 -0500
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> 

[...]

> > +{
> > +	struct event_trigger_data *data;
> > +
> > +	if (list_empty(&file->triggers))
> > +		return;
> > +
> > +	preempt_disable_notrace();
> 
> What's the reason for preempt_disable()? This should be called with
> rcu_read_lock held, right?
> 

You're right, it is called under rcu_read_lock() and the
preempt_disable() is completely pointless - I'll remove these.

> > +	list_for_each_entry_rcu(data, &file->triggers, list)
> > +		data->ops->func(data);
> > +	preempt_enable_notrace();
> > +}
> > +EXPORT_SYMBOL_GPL(event_triggers_call);
> > +
> > +static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
> > +{
> > +	struct ftrace_event_file *event_file = event_file_data(m->private);
> > +
> > +	return seq_list_next(t, &event_file->triggers, pos);
> > +}
> > +
> > +static void *trigger_start(struct seq_file *m, loff_t *pos)
> > +{
> > +	struct ftrace_event_file *event_file;
> > +
> > +	/* ->stop() is called even if ->start() fails */
> > +	mutex_lock(&event_mutex);
> > +	event_file = event_file_data(m->private);
> > +	if (unlikely(!event_file))
> > +		return ERR_PTR(-ENODEV);
> > +
> > +	return seq_list_start(&event_file->triggers, *pos);
> > +}
> > +
> > +static void trigger_stop(struct seq_file *m, void *t)
> > +{
> > +	mutex_unlock(&event_mutex);
> > +}
> > +
> > +static int trigger_show(struct seq_file *m, void *v)
> > +{
> > +	struct event_trigger_data *data;
> > +
> > +	data = list_entry(v, struct event_trigger_data, list);
> > +	data->ops->print(m, data->ops, data);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct seq_operations event_triggers_seq_ops = {
> > +	.start = trigger_start,
> > +	.next = trigger_next,
> > +	.stop = trigger_stop,
> > +	.show = trigger_show,
> > +};
> > +
> > +static int event_trigger_regex_open(struct inode *inode, struct file *file)
> > +{
> > +	int ret = 0;
> > +
> > +	mutex_lock(&event_mutex);
> > +
> > +	if (unlikely(!event_file_data(file))) {
> > +		mutex_unlock(&event_mutex);
> > +		return -ENODEV;
> > +	}
> > +
> > +	if (file->f_mode & FMODE_READ) {
> > +		ret = seq_open(file, &event_triggers_seq_ops);
> > +		if (!ret) {
> > +			struct seq_file *m = file->private_data;
> > +			m->private = file;
> > +		}
> > +	}
> > +
> > +	mutex_unlock(&event_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static int trigger_process_regex(struct ftrace_event_file *file,
> > +				 char *buff, int enable)
> > +{
> > +	char *command, *next = buff;
> > +	struct event_command *p;
> > +	int ret = -EINVAL;
> > +
> > +	command = strsep(&next, ": \t");
> > +	command = (command[0] != '!') ? command : command + 1;
> > +
> > +	mutex_lock(&trigger_cmd_mutex);
> 
> What exactly is trigger_cmd_mutex protecting? It is only called here,
> and the event_mutex() is already held by its only caller, so this mutex
> is basically doing nothing.
> 

trigger_cmd_mutex is also passed into and used by
register/unregister_event_command() (as *cmd_list_mutex) and protects
writers setting trigger commands against changes in the command list.

The next question would be why pass the mutex and command list in to the
register/unregister command instead of having those functions use them
directly?  It's because these functions were originally meant to manage
multiple command lists, for both ftrace and event commands, but since it
now handles only event commands, I'll remove those extra params and just
use them directly.

Thanks,

Tom


