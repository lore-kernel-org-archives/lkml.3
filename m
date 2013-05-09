Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3EIOrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:47:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21891 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3EIOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:47:10 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DN1rENdJRV0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=CpQRuSp1N3wA:10 a=JkIHourfAAAA:8 a=2qSN0uKSAAAA:8 a=GPx4DGO_XsQ9d7txEBIA:9 a=QEXdDO2ut3YA:10 a=eROn50bYPj0A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368110829.7373.103.camel@gandalf.local.home>
Subject: Re: [PATCH 02/11] [BUGFIX] ftrace, kprobes: Fix a deadlock on
 ftrace_regex_lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 10:47:09 -0400
In-Reply-To: <20130509054417.30398.84254.stgit@mhiramat-M0-7522>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
	 <20130509054417.30398.84254.stgit@mhiramat-M0-7522>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 14:44 +0900, Masami Hiramatsu wrote:
> Fix a deadlock on ftrace_regex_lock which happens when setting
> an enable_event trigger on dynamic kprobe event as below.
> 
> ----
> sh-2.05b# echo p vfs_symlink > kprobe_events
> sh-2.05b# echo vfs_symlink:enable_event:kprobes:p_vfs_symlink_0 > set_ftrace_filter
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.9.0+ #35 Not tainted
> ---------------------------------------------
> sh/72 is trying to acquire lock:
>  (ftrace_regex_lock){+.+.+.}, at: [<ffffffff810ba6c1>] ftrace_set_hash+0x81/0x1f0
> 
> but task is already holding lock:
>  (ftrace_regex_lock){+.+.+.}, at: [<ffffffff810b7cbd>] ftrace_regex_write.isra.29.part.30+0x3d/0x220
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(ftrace_regex_lock);
>   lock(ftrace_regex_lock);

Ouch! I'm surprised I didn't trigger this in my tests. I have lockdep
enabled, and I did run kprobe testing. I'll have to look at how this was
missed :-/

> 
>  *** DEADLOCK ***
> ----
> 
> To fix that, this introduces a finer regex_lock for each ftrace_ops.
> ftrace_regex_lock seems that a big lock which protect all
> filter/notrace_hash operation, but it doesn't need to be a global
> lock after supporting multiple ftrace_ops because each ftrace_ops
> has its own filter/notrace_hash.

OK, I'll test this patch out and see how it goes. I first need to see
how it broke without this patch.

Thanks,

-- Steve


