Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583Ab3GPSix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:38:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:55443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab3GPSiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:38:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,678,1367996400"; 
   d="scan'208";a="371312277"
Message-ID: <51E59497.3090202@linux.intel.com>
Date: Tue, 16 Jul 2013 11:44:39 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Thermal: Fix lockup of cpu_down()
References: <1373997748.6458.26.camel@gandalf.local.home>  <51E58ECE.2030405@linux.intel.com> <1373999590.6458.34.camel@gandalf.local.home>
In-Reply-To: <1373999590.6458.34.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 11:33 AM, Steven Rostedt wrote:
> On Tue, 2013-07-16 at 11:19 -0700, Srinivas Pandruvada wrote:
>> Thanks. How did you trigger this error condition? Is it a code review or
>> you have some way to reproduce?
> No, my tests do a cpu hotplug stress and the system would hang. I had to
> bisect it to find the bug and it came to this code. What was weird is
> that the module wasn't loaded. Then I ran the ftrace function tracer
> stared by the kernel command line with the following:
>
>   ftrace=function ftrace_filter=get_online_cpus,put_online_cpus
>
> and after I booted up, I ran:
>
> cat /debug/tracing/trace | perl -e '
> my @stack;
> while (<>) {
> 	if (/get_online/) {
> 		push @stack, $_;
> 	} elsif (/put_online/) {
> 		pop @stack;
> 	}
> }
> foreach my $line (@stack) {
> 	print $line;
> }'
>
> And it showed that get_online_cpus() was called twice without a matching
> put_online_cpu(). The strange thing was the calls had no parent
> function. Which is when I realized that the module was loaded but then
> failed to init, and was unloaded. Which explains why it didn't show up
> in my lsmod.
>
> Then it was just the matter of looking at all the calls to
> get_online_cpu() in the commit, and it was rather obvious to what the
> bug was.
>
> With the patch applied, the lockup went away.
>
> -- Steve
Thanks for your help in debugging and isolating.
>
>
>

