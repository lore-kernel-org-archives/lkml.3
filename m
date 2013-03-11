Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3CKP6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:58:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3CKP6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:58:19 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wKN_jQIjfZgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=x1EhfJ_RtQAA:10 a=-WjUGPdimOB4EfE-2QgA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363017497.12608.25.camel@gandalf.local.home>
Subject: Re: [PATCH 06/13] tracing: remove dump_ran check in __ftrace_dump
From: Steven Rostedt <rostedt@goodmis.org>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Mon, 11 Mar 2013 11:58:17 -0400
In-Reply-To: <CACV3sb+b1TGzsSwsoCxXCf5=6KXbAf-=XhnNz3wL5upLq8LPtw@mail.gmail.com>
References: <513D8433.8000806@huawei.com>
	 <1363010894.12608.5.camel@gandalf.local.home>
	 <CACV3sb+b1TGzsSwsoCxXCf5=6KXbAf-=XhnNz3wL5upLq8LPtw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 23:35 +0800, Jovi Zhang wrote:
> On Mon, Mar 11, 2013 at 10:08 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Mon, 2013-03-11 at 15:13 +0800, zhangwei(Jovi) wrote:
> >> It's reasonable to call __ftrace_dump function not only once,
> >> so remove the dump_ran variable checking.
> >
> > This needs a little more work. On an oops, I only want it dumped once,
> > because a crash can cause another crash while its dumping, and without
> > that check in will corrupt the buffer.
> For reclusive dumping, it's already under the protection of
> ftrace_dump_lock spinlock,
> I missed something? would you explain more on this case?

Actually, it matters if it was called from NMI context or not. If an NMI
triggered and did a dump while a reader was reading the buffer, the NMI
can corrupt the buffer. It will print fine for the NMI, but if the
reader continues, there's a chance it can get messed up and corrupt the
buffer. The "dump once" is a paranoid method to say we only dump it once
on oops and stop (hence the ftrace_kill() there too).

Now I think there's a possible deadlock here as well. If the dump was
caused by something other than an NMI lock up, and while it is dumping
the NMI goes off and triggers a bug, it too can enter this and that
arch_spin_lock() will cause a deadlock. This will be something I need to
clean up as well.

Thanks for calling my attention to this.

-- Steve


