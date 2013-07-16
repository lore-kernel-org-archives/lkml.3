Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791Ab3GPSdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:33:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4929 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab3GPSdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:33:12 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=jXjMzMfnHQIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ontQpU8t3gQA:10 a=aRyrC8561qDYo9RhLw0A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373999590.6458.34.camel@gandalf.local.home>
Subject: Re: [PATCH] Thermal: Fix lockup of cpu_down()
From: Steven Rostedt <rostedt@goodmis.org>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Date: Tue, 16 Jul 2013 14:33:10 -0400
In-Reply-To: <51E58ECE.2030405@linux.intel.com>
References: <1373997748.6458.26.camel@gandalf.local.home>
	 <51E58ECE.2030405@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 11:19 -0700, Srinivas Pandruvada wrote:
> Thanks. How did you trigger this error condition? Is it a code review or 
> you have some way to reproduce?

No, my tests do a cpu hotplug stress and the system would hang. I had to
bisect it to find the bug and it came to this code. What was weird is
that the module wasn't loaded. Then I ran the ftrace function tracer
stared by the kernel command line with the following:

 ftrace=function ftrace_filter=get_online_cpus,put_online_cpus

and after I booted up, I ran:

cat /debug/tracing/trace | perl -e '
my @stack;
while (<>) {
	if (/get_online/) {
		push @stack, $_;
	} elsif (/put_online/) {
		pop @stack;
	}
}
foreach my $line (@stack) {
	print $line;
}'

And it showed that get_online_cpus() was called twice without a matching
put_online_cpu(). The strange thing was the calls had no parent
function. Which is when I realized that the module was loaded but then
failed to init, and was unloaded. Which explains why it didn't show up
in my lsmod.

Then it was just the matter of looking at all the calls to
get_online_cpu() in the commit, and it was rather obvious to what the
bug was.

With the patch applied, the lockup went away.

-- Steve



