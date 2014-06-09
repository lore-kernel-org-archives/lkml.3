Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbaFIIVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:21:23 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:38783 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaFIIVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:21:14 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH ftrace/core V5] ftrace: Introduce saved_cmdlines_size file
References: <20140605012427.22115.16173.stgit@yunodevel>
Date: Mon, 09 Jun 2014 17:21:12 +0900
In-Reply-To: <20140605012427.22115.16173.stgit@yunodevel> (Yoshihiro YUNOMAE's
	message of "Thu, 05 Jun 2014 10:24:27 +0900")
Message-ID: <871tuycx3b.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoshihiro,

Sorry for being late, but just wanna give you some (minor) feedbacks..


On Thu, 05 Jun 2014 10:24:27 +0900, Yoshihiro YUNOMAE wrote:
> +static int trace_create_savedcmd(void)
> +{
> +	int ret;
> +
> +	savedcmd = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);

s/sizeof(struct saved_cmdlines_buffer)/sizeof(*savedcmd)/


> +	if (!savedcmd)
> +		return -ENOMEM;
> +
> +	ret = allocate_cmdlines_buffer(SAVED_CMDLINES_DEFAULT, savedcmd);
> +	if (ret < 0) {
> +		kfree(savedcmd);
> +		savedcmd = NULL;
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
>  }

[SNIP]
>  static ssize_t
> +tracing_saved_cmdlines_size_read(struct file *filp, char __user *ubuf,
> +				 size_t cnt, loff_t *ppos)
> +{
> +	char buf[64];
> +	int r;
> +
> +	arch_spin_lock(&trace_cmdline_lock);
> +	r = sprintf(buf, "%u\n", savedcmd->cmdline_num);

In general, it's better to use scnprintf() instead.


> +	arch_spin_unlock(&trace_cmdline_lock);
> +
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
> +}
> +
> +static void free_saved_cmdlines_buffer(struct saved_cmdlines_buffer *s)
> +{
> +	kfree(s->saved_cmdlines);
> +	kfree(s->map_cmdline_to_pid);
> +	kfree(s);
> +}
> +
> +static int tracing_resize_saved_cmdlines(unsigned int val)
> +{
> +	struct saved_cmdlines_buffer *s, *savedcmd_temp;
> +
> +	s = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);

s/sizeof(struct saved_cmdlines_buffer)/sizeof(*s)/

Thanks,
Namhyung


> +	if (!s)
> +		return -ENOMEM;
> +
> +	if (allocate_cmdlines_buffer(val, s) < 0) {
> +		kfree(s);
> +		return -ENOMEM;
> +	}
> +
> +	arch_spin_lock(&trace_cmdline_lock);
> +	savedcmd_temp = savedcmd;
> +	savedcmd = s;
> +	arch_spin_unlock(&trace_cmdline_lock);
> +	free_saved_cmdlines_buffer(savedcmd_temp);
> +
> +	return 0;
> +}
