Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaFTOVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:21:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:61244 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751349AbaFTOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:21:46 -0400
Date: Fri, 20 Jun 2014 10:21:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 3/3] x86/nmi: Perform a safe NMI stack trace on all
 CPUs
Message-ID: <20140620102142.223ff42f@gandalf.local.home>
In-Reply-To: <20140620135815.GG7959@redhat.com>
References: <20140619213329.478113470@goodmis.org>
	<20140619213952.360076309@goodmis.org>
	<20140620135815.GG7959@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014 09:58:15 -0400
Don Zickus <dzickus@redhat.com> wrote:

> On Thu, Jun 19, 2014 at 05:33:32PM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > When trigger_all_cpu_backtrace() is called on x86, it will trigger an
> > NMI on each CPU and call show_regs(). But this can lead to a hard lock
> > up if the NMI comes in on another printk().
> > 
> > In order to avoid this, when the NMI triggers, it switches the printk
> > routine for that CPU to call a NMI safe printk function that records the
> > printk in a per_cpu trace_seq descriptor. After all NMIs have finished
> > recording its data, the trace_seqs are printed in a safe context.
> 
> Ah, if there is other places that need to call a printk from an NMI
> context, do we have to copy and paste this code there too?  That would
> seem a little much. :-)  I guess my only concern really is the seq_init
> and seq print stuff.  The handler seems relatively simple.

This is a special case for printing from NMI. As you can trigger it
with sysrq-l. But any other prints from NMI should only be in the BUG()
case, where we should just force the output and override any locks in
printk.

> 
> Can we isolate this to a pr_nmi() routine or something?  Or maybe a
> pr_nmi_queue and pr_nmi_dump or something?
> 

We'll have to see how traction this gets. It's just an RFC.

-- Steve
