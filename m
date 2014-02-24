Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaBXRlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:41:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39093 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbaBXRlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:41:45 -0500
Message-ID: <530B841F.5050803@zytor.com>
Date: Mon, 24 Feb 2014 09:40:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
References: <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu> <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com> <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu> <530AD71E.50800@zytor.com> <alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu> <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com> <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu> <20140224172536.GD9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>
In-Reply-To: <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 09:32 AM, Vince Weaver wrote:
>>
>> Peter, does x32 have a slightly different ABI/calling convention that
>> would make any of these patches just slightly 'off'?
> 
> I do note that 
> 	perf_callchain_user();
> 
> Does
> 	fp = (void __user *)regs->bp;
> 	
> 	...
> 
> 	bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
> 
> 
> And in my particular executable RBP has nothing to do with a frame 
> pointer, but is instead being used as a general purpose register.
> 
> Am I missing something here?  Though in that case I'm not sure why this 
> wouldn't be easier to trigger.
> 

Neither x86-64 nor x32 are typically compiled with fixed frame pointers
(which would be %rbp if they are).  So I'm guessing the perf_callchain
logic is only applicable to a user-space binary explicitly compiled with
frame pointers turned on.

So copy_from_user_nmi() stumbles onto a nonexistent page and takes a
page fault.  This isn't a big deal, because perf_callchain_user() is set
up to handle that (and just terminates the trace), *except* now CR2 is
corrupt, and we took this event while handling a page fault already...
and apparently before we even did read_cr2() in __do_page_fault.

The description of copy_from_user_nmi() states:

/*
 * We rely on the nested NMI work to allow atomic faults from the NMI
path; the
 * nested NMI paths are careful to preserve CR2.
 */

... but that doesn't seem to happen here for whatever reason.

There is no hint in your trace what happens after the kernel page fault
so that makes it hard to know.

	-hpa

