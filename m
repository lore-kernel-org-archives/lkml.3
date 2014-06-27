Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaF0Ojh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:39:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:31156 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753039AbaF0Ojg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:39:36 -0400
Date: Fri, 27 Jun 2014 10:39:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?UTF-8?B?TWzDoWRlaw==?= <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 4/5 v2] printk: Add per_cpu printk func to allow
 printk to be diverted
Message-ID: <20140627103933.1e7b981b@gandalf.local.home>
In-Reply-To: <20140627142025.GD23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
	<20140626220130.356038089@goodmis.org>
	<20140627142025.GD23205@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 16:20:25 +0200
Petr Mládek <pmladek@suse.cz> wrote:


> >  	va_start(args, fmt);
> > -	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
> > +	preempt_disable();
> 
> I think that it is too late to disable the preemption here.
> It has to be done by the printk() caller if it wants to be sure
> that the requested function is used.

That's only if the printk() caller cares. But it would be nice that we
run the printk_func for the CPU that vprintk_func() is on, thus the
preempt_disable() is required. (in -rt, this would turn into a
migrate_disable()).

-- Steve

> 
> > +	vprintk_func = this_cpu_read(printk_func);
> > +	r = vprintk_func(fmt, args);
> > +	preempt_enable();
> >  	va_end(args);
> >  
> >  	return r;
> 
> Best Regards,
> Petr

