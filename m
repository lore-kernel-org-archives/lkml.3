Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3HTQAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:00:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20526 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3HTQAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:00:08 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=dRXjL8aGtIIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vCXdsJORpdIA:10 a=3nbZYyFuAAAA:8 a=FvyAbXiTQkc0f18GIvgA:9 a=CjuIK1q_8ugA:10 a=EvKJbDF4Ut8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 20 Aug 2013 12:00:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 00/11] trace-cmd: Support the feature recording
 trace data of guests on the host
Message-ID: <20130820120006.1a4118c5@gandalf.local.home>
In-Reply-To: <20130819094620.26597.79499.stgit@yunodevel>
References: <20130819094620.26597.79499.stgit@yunodevel>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013 18:46:20 +0900
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:


> d) merge feature of trace data of multiple guests and a host in chronological
>    order
>  Current trace-cmd cannot merge trace data of multiple guests and a host in
> chronological order. If an user wants to analyze an I/O delay problem of a
> guest, the user will want to check trace data of all guests and the host in a
> file. However, trace-cmd does not support a merge feature yet, the user must
> make a merging script. So, trace-cmd had better support a merge feature for
> multiple files for virtualization.
> 

This is incorrect. trace-cmd already has a merge feature for multiple
machines.

If you have two boxes that are in sync by ntp, you can do the following:

On box1:

 trace-cmd record --date -o trace-box1.dat -e all ping box2

On box2:

 trace-cmd record --date -o trace-box2.dat -e all ping box1


And then copy over trace-box2.dat to box1 and run

 trace-cmd report -i trace-box1.dat -i trace-box2.dat

And you will see a merge. I just did this on two of my boxes called ixf
and bxtest and here's a partial output:

trace-bxtest.dat:        trace-cmd-1348  [003] 1377013771.682807: sys_enter:            NR 2 (22e2b00, 241, 1a4, 1a, 4361ac, 3)
trace-bxtest.dat:        trace-cmd-1348  [003] 1377013771.682808: sys_enter_open:       filename: 0x022e2b00, flags: 0x00000241, mode: 0x000001a4
   trace-ixf.dat:           <idle>-0     [002] 1377013771.682808: hrtimer_cancel:       hrtimer=0xffff880002110820
   trace-ixf.dat:           <idle>-0     [002] 1377013771.682808: hrtimer_expire_entry: hrtimer=0xffff880002110820 now=673528250850 function=tick_sched_timer/0x0
trace-bxtest.dat:        trace-cmd-1348  [003] 1377013771.682809:
kmem_cache_alloc:     (getname_flags+0x37) call_site=ffffffff8117b797 ptr=0xffff8800d38c0000 bytes_req=4096 bytes_alloc=4096 gfp_flags=GFP_KERNELGFP_NOTRACK


The --date option is used because the two machines are not in sync with
the trace time stamp. What the date option does, is to sync the
timestamp up with the gettimeofday and the output reports that. This
allows the two boxes to report information that is relatively close to
how the two interacted.

If the guest and the host have the same clock, then the --date option
is not needed and the two should be able to be merged normally.

Also, I haven't released it yet (will soon), but trace-cmd handles
multiple buffers too. That is, with the multiple buffers that ftrace
has, it will create and read from them as well as report them.

I'll finish my testing on all the latest features of trace-cmd I have
and push it out later today.

I'll also take a look at the rest of your patches.

Thanks,

-- Steve
