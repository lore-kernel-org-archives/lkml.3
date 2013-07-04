Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab3GDEBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:01:02 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48981 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3GDEBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:01:00 -0400
Message-ID: <51D4F377.6080002@hitachi.com>
Date: Thu, 04 Jul 2013 13:00:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/4] tracing/kprobes/uprobes: Fix race between
 opening probe event files and deleting probe
References: <20130704033347.807661713@goodmis.org>
In-Reply-To: <20130704033347.807661713@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/04 12:33), Steven Rostedt wrote:
> Currently there exists a race with deleting a kprobe or uprobe and
> a user opening the probe event file or using perf events.
> 
> The problem stems from not being able to take the probe_lock from the
> unregister code because we may have the event_mutex at the time, and
> the event mutex may be taken with the probe_lock held.
> 
> To solve this, the events get a ref count (using the flags field), where
> when an event file is opened, the ftrace_event_call ref count increments.
> Then this is checked under event_mutex and if set, the unregistering
> of the probe will fail.
> 
> Here's a test that shows how things break:
> 
>      # cd /sys/kernel/debug/tracing
>      # echo 'p:sigprocmask sigprocmask' > kprobe_events || exit -1
>      # enable_probe() {
>         sleep 10
>         echo 1
>      }
>      # file=events/kprobes/sigprocmask/enable
>      # enable_probe > $file &
>      > kprobe_events
>     
>     The above will corrupt the kprobe system, as the write to the enable
>     file will happen after the kprobe was deleted.
>     
>     Trying to create the probe again fails:
>     
>      # echo 'p:sigprocmask sigprocmask' > kprobe_events
>      # cat kprobe_events
>     p:kprobes/sigprocmask sigprocmask
>      # ls events/kprobes/
>     enable  filter
> 
> After applying these patches, the "> kprobe_events" fails due to the
> event being busy.
> 
> Masami, please review these patches and give your ack.

Thanks Steven!

> Oleg Nesterov (1):
>       tracing: trace_remove_event_call() should fail if call/file is in use
> 
> Steven Rostedt (Red Hat) (3):
>       tracing: Add ref count to ftrace_event_call
>       tracing/kprobes: Fail to unregister if probe event files are open
>       tracing/uprobes: Fail to unregister if probe event files are open

I just started to look into the series, but the 3/4 and 4/4 seems same...
Which one is good to go?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


