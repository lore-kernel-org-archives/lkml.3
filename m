Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbbA2Fj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:39:28 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55228 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbbA2Fj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:39:26 -0500
Message-ID: <54C9C787.1040706@hitachi.com>
Date: Thu, 29 Jan 2015 14:39:19 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 linux-trace 1/8] tracing: attach eBPF programs to tracepoints
 and syscalls
References: <CAMEtUuz+N52ms4ZFh8+fSGhg1UaXpBdk9RVPU_zBDCjaZ4bj4A@mail.gmail.com>
In-Reply-To: <CAMEtUuz+N52ms4ZFh8+fSGhg1UaXpBdk9RVPU_zBDCjaZ4bj4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/29 13:40), Alexei Starovoitov wrote:
> On Wed, Jan 28, 2015 at 4:46 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>>>
>>> +static int event_filter_release(struct inode *inode, struct file *filp)
>>> +{
>>> +     struct ftrace_event_file *file;
>>> +     char buf[2] = "0";
>>> +
>>> +     mutex_lock(&event_mutex);
>>> +     file = event_file_data(filp);
>>> +     if (file) {
>>> +             if (file->flags & TRACE_EVENT_FL_BPF) {
>>> +                     /* auto-disable the filter */
>>> +                     ftrace_event_enable_disable(file, 0);
>>
>> Hmm.. what if user already enabled an event, attached a bpf filter and
>> then detached the filter - I'm not sure we can always auto-disable
>> it..
> 
> why not?
> I think it makes sense auto enable/disable, since that
> is cleaner user experience.

Maybe, would we need a reference counter for each event? :)

Actually, ftrace event is not similar to perf-event which ktap
is based on, ftrace event interface is always exported via
debugfs, this means users can share the event for different
usage.

One possible other solution is to add a instance-lock interface
for each ftrace instance and lock it by bpf. Then, other users
can not enable/disable the events in the instance.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


