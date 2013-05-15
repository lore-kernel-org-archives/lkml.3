Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab3EOOm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:42:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46924 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759180Ab3EOOm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:42:28 -0400
Date: Wed, 15 May 2013 15:37:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: V3.10-rc1 memory leak
Message-ID: <20130515143719.GB1096@darko.cambridge.arm.com>
References: <51912567.6090507@lwfinger.net>
 <1368558586.6828.53.camel@gandalf.local.home>
 <20130514203028.GA2997@MacBook-Pro.local>
 <5192A847.1000100@lwfinger.net>
 <1368566427.6828.58.camel@gandalf.local.home>
 <1368579423.6828.63.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368579423.6828.63.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 01:57:03AM +0100, Steven Rostedt wrote:
> On Tue, 2013-05-14 at 17:20 -0400, Steven Rostedt wrote:
> > On Tue, 2013-05-14 at 16:10 -0500, Larry Finger wrote:
> > > On 05/14/2013 03:30 PM, Catalin Marinas wrote:
> > > >
> > > > I just got a patch today:
> > > >
> > > > https://lkml.org/lkml/2013/5/10/607
> > > >
> > > > which could be related. If Rusty doesn't push it I'll do. But please let
> > > > me know if it does not solve the problem.
> > > 
> > > This patch fixes my problem. Now I can see the next new problem reported by 
> > > kmemleak. :)
> > > 
> > > Thanks to you and Jianpeng Ma,
> > > 
> > > Larry
> > > 
> > 
> > It goes away on my testing too. So you can add:
> > 
> > Tested-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> 
> But we are not out of the woods yet. I'm also getting these:
> 
> unreferenced object 0xffff88007800efc0 (size 32):
>   comm "modprobe", pid 1309, jiffies 4294697214 (age 188.356s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 a8 d0 3e a0 ff ff ff ff  ..........>.....
>     30 d1 3e a0 ff ff ff ff 00 00 00 00 00 00 00 00  0.>.............
>   backtrace:
>     [<ffffffff814b535f>] kmemleak_alloc+0x73/0x98
>     [<ffffffff8112003c>] kmemleak_alloc_recursive.constprop.42+0x16/0x18
>     [<ffffffff81120dfe>] kmem_cache_alloc_trace+0xc0/0x10b
>     [<ffffffff810e5478>] jump_label_module_notify+0xce/0x1d5
>     [<ffffffff814d221d>] notifier_call_chain+0x37/0x63
>     [<ffffffff8105c29c>] __blocking_notifier_call_chain+0x4b/0x60
>     [<ffffffff8105c2c5>] blocking_notifier_call_chain+0x14/0x16
>     [<ffffffff8108fe83>] load_module+0x1d7f/0x20d3
>     [<ffffffff810902b0>] SyS_init_module+0xd9/0xdb
>     [<ffffffff814d5754>] tracesys+0xdd/0xe2
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Where it points to the allocation in jump_label_add_module() where it
> allocates the jlm. And this does get freed in jump_label_del_module().

Indeed, another false positive (I should use modules more often ;).
Here's a patch:

---------------------8<----------------------------------

>From 0621c7e1909ea86bf8499a0ffe5ea59d1007ee8c Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 15 May 2013 15:30:46 +0100
Subject: [PATCH] kmemleak: Scan the jump label module section

Objects allocated in jump_label_add_module() are currently reported as
leaks, though the pointers are stored in the module jump label section.
This patch informs kmemleak that this section needs to be scanned.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/module.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index b049939..ff83711 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2764,6 +2764,13 @@ static void find_module_sections(struct module *mod, struct load_info *info)
 	mod->jump_entries = section_objs(info, "__jump_table",
 					sizeof(*mod->jump_entries),
 					&mod->num_jump_entries);
+	/*
+	 * This section contains pointers to objects allocated in
+	 * jump_label_add_module() and not scanning it leads to false
+	 * positives.
+	 */
+	kmemleak_scan_area(mod->jump_entries, sizeof(*mod->jump_entries) *
+			   mod->num_jump_entries, GFP_KERNEL);
 #endif
 #ifdef CONFIG_EVENT_TRACING
 	mod->trace_events = section_objs(info, "_ftrace_events",
