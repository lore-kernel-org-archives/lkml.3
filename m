Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbbAWVHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 16:07:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43258 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbbAWVHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 16:07:45 -0500
Message-ID: <54C2B80B.8050501@zytor.com>
Date: Fri, 23 Jan 2015 13:07:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Suresh Siddha <suresh.b.siddha@intel.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: question about save_xstate_sig() - WHY DOES THIS WORK?
References: <54C2A245.4010307@redhat.com>
In-Reply-To: <54C2A245.4010307@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 11:34 AM, Rik van Riel wrote:
> While working on a patch series to defer FPU state loading until
> kernel -> user space transition, and be more lazy with FPU state
> while in the kernel, I came across this code in save_xstate_sig().
> 
> Not only is this broken with my new code, but it looks like it may
> be broken with the current code, too...
> 
> Specifically, save_user_xstate() may page fault and sleep. After
> returning from the page fault, there is no guarantee that the
> FPU state will be restored into the CPU, when the system is not
> running with eager fpu mode.
> 
> In that case, what prevents us from saving random FPU register state
> to the user's stack frame?  Potentially state containing data from
> other programs...
> 

If the FPU state is not current, we'll have CR0.TS = 1 and the XSAVE
will cause an #NM exception, which will cause the FPU state to be
swapped in.

	-hpa


