Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3FZUAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:00:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab3FZUAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:00:40 -0400
Date: Wed, 26 Jun 2013 16:00:03 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130626200003.GB2833@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>
References: <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <1372177414.18733.211.camel@gandalf.local.home>
 <20130626052352.GB31416@redhat.com>
 <1372276335.18733.271.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372276335.18733.271.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:52:15PM -0400, Steven Rostedt wrote:

 > >  > Hmm, no it needs a fix to make this work. I applied a patch below that
 > >  > should do this correctly (and will put this into my 3.11 queue).
 > >  > 
 > >  > If you run the test again with this change and with the above filter, it
 > >  > should stop the trace before overwriting the first dump, as it should
 > >  > ignore the printk output.
 > > 
 > > I think something isn't right with this patch.
 > > After 10 hours, I hit the bug again, but...
 > > 
 > > (01:21:28:root@binary:tracing)# cat trace
 > > # tracer: preemptirqsoff
 > > #
 > > (01:21:30:root@binary:tracing)# 
 > 
 > Did you apply the patch I added to my last email. It should have prevent
 > that form happening :-/
 
Yeah, that's what I meant by "this patch".
To reduce ambiguity, I mean the one below.. There wasn't another patch
that I missed right ?

	Dave


diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index b19d065..2aefbee 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -373,7 +373,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 	struct trace_array_cpu *data;
 	unsigned long flags;
 
-	if (likely(!tracer_enabled))
+	if (!tracer_enabled || !tracing_is_enabled())
 		return;
 
 	cpu = raw_smp_processor_id();
@@ -416,7 +416,7 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 	else
 		return;
 
-	if (!tracer_enabled)
+	if (!tracer_enabled || !tracing_is_enabled())
 		return;
 
 	data = per_cpu_ptr(tr->trace_buffer.data, cpu);


