Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935122AbaKNE5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 23:57:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:14562 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934387AbaKNE5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 23:57:47 -0500
Date: Thu, 13 Nov 2014 23:57:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alex Elder <elder@linaro.org>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Jan Kara <jack@suse.cz>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Joe Perches <joe@perches.com>,
        open list <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [RFC PATCH] printk: Use ACCESS_ONCE() instead of a volatile
 type
Message-ID: <20141113235722.7457f9c7@gandalf.local.home>
In-Reply-To: <546589A1.9040100@linaro.org>
References: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>
	<546589A1.9040100@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 22:48:33 -0600
Alex Elder <elder@linaro.org> wrote:

> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > index e748971..4790191 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -1624,7 +1624,7 @@ asmlinkage int vprintk_emit(int facility, int level,
> >  	int printed_len = 0;
> >  	bool in_sched = false;
> >  	/* cpu currently holding logbuf_lock in this function */
> > -	static volatile unsigned int logbuf_cpu = UINT_MAX;
> > +	static unsigned int logbuf_cpu = UINT_MAX;
> 
> If this is not volatile, can the compiler assume that it
> can't change before the first access?  Put another way,
> does this assignment need to be done more like this?
> 
> 	static unsigned int ACCESS_ONCE(logbuf_cpu) = UINT_MAX;
> 
> (I haven't checked, but I don't believe that expands to valid code.)
> 

I can bet you that it doesn't compile.

That assignment is what it is initialized to at boot up. I can't see
any optimization that would cause gcc to modify that. Especially since
we are hiding its accesses within the ACCESS_ONCE(). That alone should
confuse gcc enough to leave it a hell alone J.

-- Steve
