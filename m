Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab3JSTRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 15:17:01 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:61737 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751788Ab3JSTRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 15:17:00 -0400
Date: Sat, 19 Oct 2013 15:16:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Petr Mladek <pmladek@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/6] x86: allow to call text_poke_bp during boot
Message-ID: <20131019151658.583ac18e@gandalf.local.home>
In-Reply-To: <52629F08.2010609@hitachi.com>
References: <1382106445-31468-3-git-send-email-pmladek@suse.cz>
	<52629F08.2010609@hitachi.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Oct 2013 00:02:32 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2013/10/18 23:27), Petr Mladek wrote:
> > We would like to use text_poke_bp in ftrace. It might be called also during
> > boot when the interupts are disabled. We need to enable them for syncing
> > the cores on each CPU. Otherwise, there might be a deadlock, see the
> > warning in "smp_call_function_many", kernel/smp.c:371.
> 
> Steven, is this really needed?
> I think if this is the special use(e.g. boottime test),
> we'd better to run it after boot...
> 

It's used to convert the calls to mcount to nops. But maybe a better
thing to do is to check if we only have a single CPU:

static void run_sync(void)
{
	if (num_online_cpus() != 1)
		on_each_cpu(do_sync_core, NULL, 1);
}


I believe that the only time we call this function with interrupts
disabled is before SMP is set up. Thus, the above change would handle
that case.

-- Steve
