Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbaFINse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:48:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:23285 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752118AbaFINsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:48:30 -0400
Date: Mon, 9 Jun 2014 09:48:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH ftrace/core V5] ftrace: Introduce saved_cmdlines_size
 file
Message-ID: <20140609094828.011b0eb8@gandalf.local.home>
In-Reply-To: <871tuycx3b.fsf@sejong.aot.lge.com>
References: <20140605012427.22115.16173.stgit@yunodevel>
	<871tuycx3b.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2014 17:21:12 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> Hi Yoshihiro,
> 
> Sorry for being late, but just wanna give you some (minor) feedbacks..
> 
> 
> On Thu, 05 Jun 2014 10:24:27 +0900, Yoshihiro YUNOMAE wrote:
> > +static int trace_create_savedcmd(void)
> > +{
> > +	int ret;
> > +
> > +	savedcmd = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
> 
> s/sizeof(struct saved_cmdlines_buffer)/sizeof(*savedcmd)/
> 
> 
> > +	if (!savedcmd)
> > +		return -ENOMEM;
> > +
> > +	ret = allocate_cmdlines_buffer(SAVED_CMDLINES_DEFAULT, savedcmd);
> > +	if (ret < 0) {
> > +		kfree(savedcmd);
> > +		savedcmd = NULL;
> > +		return -ENOMEM;
> > +	}
> > +
> > +	return 0;
> >  }
> 
> [SNIP]
> >  static ssize_t
> > +tracing_saved_cmdlines_size_read(struct file *filp, char __user *ubuf,
> > +				 size_t cnt, loff_t *ppos)
> > +{
> > +	char buf[64];
> > +	int r;
> > +
> > +	arch_spin_lock(&trace_cmdline_lock);
> > +	r = sprintf(buf, "%u\n", savedcmd->cmdline_num);
> 
> In general, it's better to use scnprintf() instead.
> 
> 
> > +	arch_spin_unlock(&trace_cmdline_lock);
> > +
> > +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
> > +}
> > +
> > +static void free_saved_cmdlines_buffer(struct saved_cmdlines_buffer *s)
> > +{
> > +	kfree(s->saved_cmdlines);
> > +	kfree(s->map_cmdline_to_pid);
> > +	kfree(s);
> > +}
> > +
> > +static int tracing_resize_saved_cmdlines(unsigned int val)
> > +{
> > +	struct saved_cmdlines_buffer *s, *savedcmd_temp;
> > +
> > +	s = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
> 
> s/sizeof(struct saved_cmdlines_buffer)/sizeof(*s)/
> 

I already pushed this to Linus. He hasn't pulled yet, but if you want
to send a patch against my ftrace/core, I'll add that. These are minor
enough to get into the merge window still.

-- Steve


> Thanks,
> Namhyung
> 
> 
> > +	if (!s)
> > +		return -ENOMEM;
> > +
> > +	if (allocate_cmdlines_buffer(val, s) < 0) {
> > +		kfree(s);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	arch_spin_lock(&trace_cmdline_lock);
> > +	savedcmd_temp = savedcmd;
> > +	savedcmd = s;
> > +	arch_spin_unlock(&trace_cmdline_lock);
> > +	free_saved_cmdlines_buffer(savedcmd_temp);
> > +
> > +	return 0;
> > +}

