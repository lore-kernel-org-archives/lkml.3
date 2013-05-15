Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab3EOA5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 20:57:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab3EOA5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 20:57:07 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=K9uRuNqwL0EA:10 a=D19gQVrFAAAA:8 a=X0V3t9G-4c83C5qjrX0A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368579423.6828.63.camel@gandalf.local.home>
Subject: Re: V3.10-rc1 memory leak
From: Steven Rostedt <rostedt@goodmis.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 14 May 2013 20:57:03 -0400
In-Reply-To: <1368566427.6828.58.camel@gandalf.local.home>
References: <51912567.6090507@lwfinger.net>
	 <1368558586.6828.53.camel@gandalf.local.home>
	 <20130514203028.GA2997@MacBook-Pro.local> <5192A847.1000100@lwfinger.net>
	 <1368566427.6828.58.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 17:20 -0400, Steven Rostedt wrote:
> On Tue, 2013-05-14 at 16:10 -0500, Larry Finger wrote:
> > On 05/14/2013 03:30 PM, Catalin Marinas wrote:
> > >
> > > I just got a patch today:
> > >
> > > https://lkml.org/lkml/2013/5/10/607
> > >
> > > which could be related. If Rusty doesn't push it I'll do. But please let
> > > me know if it does not solve the problem.
> > 
> > This patch fixes my problem. Now I can see the next new problem reported by 
> > kmemleak. :)
> > 
> > Thanks to you and Jianpeng Ma,
> > 
> > Larry
> > 
> 
> It goes away on my testing too. So you can add:
> 
> Tested-by: Steven Rostedt <rostedt@goodmis.org>
> 

But we are not out of the woods yet. I'm also getting these:

unreferenced object 0xffff88007800efc0 (size 32):
  comm "modprobe", pid 1309, jiffies 4294697214 (age 188.356s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 a8 d0 3e a0 ff ff ff ff  ..........>.....
    30 d1 3e a0 ff ff ff ff 00 00 00 00 00 00 00 00  0.>.............
  backtrace:
    [<ffffffff814b535f>] kmemleak_alloc+0x73/0x98
    [<ffffffff8112003c>] kmemleak_alloc_recursive.constprop.42+0x16/0x18
    [<ffffffff81120dfe>] kmem_cache_alloc_trace+0xc0/0x10b
    [<ffffffff810e5478>] jump_label_module_notify+0xce/0x1d5
    [<ffffffff814d221d>] notifier_call_chain+0x37/0x63
    [<ffffffff8105c29c>] __blocking_notifier_call_chain+0x4b/0x60
    [<ffffffff8105c2c5>] blocking_notifier_call_chain+0x14/0x16
    [<ffffffff8108fe83>] load_module+0x1d7f/0x20d3
    [<ffffffff810902b0>] SyS_init_module+0xd9/0xdb
    [<ffffffff814d5754>] tracesys+0xdd/0xe2
    [<ffffffffffffffff>] 0xffffffffffffffff

Where it points to the allocation in jump_label_add_module() where it
allocates the jlm. And this does get freed in jump_label_del_module(). I
put in printks in add_module():

	printk("alloc %p (%s)\n", jlm, mod->name);

and in del_module:

	printk("free %p (%s)\n", jlm, mod->name);

And got this:

[   29.917577] alloc ffff88007800efc0 (kvm_intel)


And removing kvm_intel, I got:

[  364.965916] free ffff88007800efc0 (kvm_intel)


Thus it seems to be yet another false positive :-(

-- Steve


