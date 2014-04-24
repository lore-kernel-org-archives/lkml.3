Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbaDXMtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:49:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:56562 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753383AbaDXMtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:49:49 -0400
Date: Thu, 24 Apr 2014 08:49:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: masami.hiramatsu.pt@hitachi.com, rusty@rustcorp.com.au, fweisbec@gmail.com,
        mingo@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: ftrace/kprobes: Warning when insmod two modules
Message-ID: <20140424084947.38ecc6f9@gandalf.local.home>
In-Reply-To: <5358B62D.2020701@jp.fujitsu.com>
References: <1395637826-3312-1-git-send-email-indou.takao@jp.fujitsu.com>
	<5330164D.6030507@hitachi.com>
	<20140324105939.7f823b81@gandalf.local.home>
	<87bnvunhs9.fsf@rustcorp.com.au>
	<5355FE49.3030502@jp.fujitsu.com>
	<53561A06.9050405@hitachi.com>
	<535629E1.9090107@jp.fujitsu.com>
	<535716A8.4050205@hitachi.com>
	<20140422215637.6920fb4a@gandalf.local.home>
	<5357277B.10208@hitachi.com>
	<5358B62D.2020701@jp.fujitsu.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014 15:58:53 +0900
Takao Indoh <indou.takao@jp.fujitsu.com> wrote:

> Ok, I'll do this. Something like this, right?
> 
> static void ftrace_init_module(struct module *mod,
>                                unsigned long *start, unsigned long *end)
> {
> 	if (ftrace_disabled || start == end)
> 		return;
> 
> 	/*
> 	 * Need ftrace_lock here to prevent someone from changing the module
> 	 * text to RO by set_all_modules_text_ro(). Currently ftrace is the
> 	 * only user of set_all_modules_text_ro(), so until another user
> 	 * appears, ftrace_lock mutex can work.
> 	 */
> 	mutex_lock(&ftrace_lock);
> 
> 	set_one_module_text_rw(mod);
> 	ftrace_process_locs(mod, start, end);
> 	set_one_module_text_ro(mod);
> 
> 	mutex_unlock(&ftrace_lock);
> }
> 

I like Rusty's solution the best. Just hard code the call to ftrace's
module init code where it is still safe to do so
(MODULE_STATE_UNFORMED). This seems to be an ftrace only issue.

Thanks,

-- Steve
