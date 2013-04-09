Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936628Ab3DICQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:16:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761958Ab3DICQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:16:49 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=okGFd5LfGywA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=DMquL_tMeFEA:10 a=Of8M3iqWolH9iPJ-7GQA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365473805.25498.44.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] ftrace: Do not call stub functions in control loop
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        WANG Chao <chaowang@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Date: Mon, 08 Apr 2013 22:16:45 -0400
In-Reply-To: <51637830.1010309@huawei.com>
References: <20130408204937.649895945@goodmis.org>
	 <20130408210518.551272592@goodmis.org> <51637830.1010309@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 10:08 +0800, zhangwei(Jovi) wrote:
> On 2013/4/9 4:49, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > The function tracing control loop used by perf spits out a warning
> > if the called function is not a control function. This is because
> > the control function references a per cpu allocated data structure
> > on struct ftrace_ops that is not allocated for other types of
> > functions.
> > 
> > commit 0a016409e42 "ftrace: Optimize the function tracer list loop"
> > 
> > Had an optimization done to all function tracing loops to optimize
> > for a single registered ops. Unfortunately, this allows for a slight
> > race when tracing starts or ends, where the stub function might be
> > called after the current registered ops is removed. In this case we
> > get the following dump:
> > 

> Involve stable? 3.8 kernel user would need this fix.

Why? commit 0a016409e42 "ftrace: Optimize the function tracer list loop"
was added for 3.9. 3.8 has:

        op = rcu_dereference_raw(ftrace_control_list);
        while (op != &ftrace_list_end) {
                if (!ftrace_function_local_disabled(op) &&
                    ftrace_ops_test(op, ip))
                        op->func(ip, parent_ip, op, regs);

                op = rcu_dereference_raw(op->next);
        };

The stub function will never get called.

-- Steve



