Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbaD1Tiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:38:46 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:34074 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbaD1Tio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <535E2C5A.9090702@linaro.org>
References: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>
	<1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>
	<1398443370-12668-2-git-send-email-daniel.thompson@linaro.org>
	<20140425124530.52fd696c@gandalf.local.home>
	<535E2C5A.9090702@linaro.org>
Date: Mon, 28 Apr 2014 10:44:49 -0700
X-Google-Sender-Auth: XLtAKx7mJWwegsQkVE1AwGeGIJs
Message-ID: <CAMbhsRQfHCJ=hY=hyX2TJLRAArX7iAhDdxTkaP9hjC5nR5U5vA@mail.gmail.com>
Subject: Re: [RFC v3 1/9] sysrq: Implement __handle_sysrq_nolock to avoid
 recursive locking in kdb
From: Colin Cross <ccross@android.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 3:24 AM, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
> On 25/04/14 17:45, Steven Rostedt wrote:
>> On Fri, 25 Apr 2014 17:29:22 +0100
>> Daniel Thompson <daniel.thompson@linaro.org> wrote:
>>
>>> If kdb is triggered using SysRq-g then any use of the sr command results
>>> in the SysRq key table lock being recursively acquired, killing the debug
>>> session. That patch resolves the problem by introducing a _nolock
>>> alternative for __handle_sysrq.
>>>
>>> Strictly speaking this approach risks racing on the key table when kdb is
>>> triggered by something other than SysRq-g however in that case any other
>>> CPU involved should release the spin lock before kgdb parks the slave
>>> CPUs.
>>
>> Is that case documented somewhere in the code comments?
>
> Perhaps not near enough to the _nolock but the primary bit of comment is
> here (and in same file as kdb_sr).
> --- cut here ---
>  * kdb_main_loop - After initial setup and assignment of the
>  *      controlling cpu, all cpus are in this loop.  One cpu is in
>  *      control and will issue the kdb prompt, the others will spin
>  *      until 'go' or cpu switch.
> --- cut here ---
>
> The mechanism kgdb uses to quiesce other CPUs means other CPUs cannot be
> in irqsave critical sections.
>
>

One of the advantages of FIQ debugger is that it can be triggered from
an FIQ (NMI for those in x86 land), and Jason and I have discussed
using FIQs for kgdb to allow interrupting cpus stuck in critical
sections.  If that gets implemented the above assumption will no
longer be correct.
