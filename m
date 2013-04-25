Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3DYJK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:10:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab3DYJKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:10:25 -0400
Date: Thu, 25 Apr 2013 11:09:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/14] perf tools: Introduce new 'ftrace' tool
Message-ID: <20130425090956.GA1033@krava.brq.redhat.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
 <1366705872-12132-6-git-send-email-namhyung@kernel.org>
 <20130424140918.GF971@krava.brq.redhat.com>
 <87fvyf9maa.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvyf9maa.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 03:06:37PM +0900, Namhyung Kim wrote:
> On Wed, 24 Apr 2013 16:09:18 +0200, Jiri Olsa wrote:
> > On Tue, Apr 23, 2013 at 05:31:03PM +0900, Namhyung Kim wrote:
> >> From: Namhyung Kim <namhyung.kim@lge.com>
> >> +out:
> >> +	put_tracing_file(file);
> >> +	return ret;
> >> +}
> >> +
> >> +static int reset_tracing_files(struct perf_ftrace *ftrace __maybe_unused)
> >> +{
> >> +	if (write_tracing_file("tracing_on", "0") < 0)
> >> +		return -1;
> >> +
> >> +	if (write_tracing_file("current_tracer", "nop") < 0)
> >> +		return -1;
> >> +
> >> +	if (write_tracing_file("set_ftrace_pid", " ") < 0)
> >> +		return -1;
> >
> > I think we want to reset set_ftrace_pid file as well
> > probably to -1..
> >
> > if I'm tracing command with this file having wrong CPU(s)
> > I dont get any data..
> 
> Not sure I understood what you mean exactly.

ugh, sry.. I wrote set_ftrace_pid when I actually meant tracing_cpumask ;-)

> 
> Do you mean it should be changed to
> 
> 	if (write_tracing_file("set_ftrace_pid", "-1") < 0)
> 
> ?  It seems it's the right thing to do for compatibility.


looks like it's enough only to open it with O_TRUNC,
so I guess whatever minimal goes write_tracing_file

---
kernel/trace/ftrace.c:

ftrace_pid_open(struct inode *inode, struct file *file)
{
        int ret = 0;

        if ((file->f_mode & FMODE_WRITE) &&
            (file->f_flags & O_TRUNC))
                ftrace_pid_reset();


jirka
