Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbaD1UMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:12:25 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:41801 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaD1UMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:12:23 -0400
Message-ID: <535EB61E.1020706@linaro.org>
Date: Mon, 28 Apr 2014 21:12:14 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: Steven Rostedt <rostedt@goodmis.org>, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFC v3 1/9] sysrq: Implement __handle_sysrq_nolock to avoid
 recursive locking in kdb
References: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>	<1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>	<1398443370-12668-2-git-send-email-daniel.thompson@linaro.org>	<20140425124530.52fd696c@gandalf.local.home>	<535E2C5A.9090702@linaro.org> <CAMbhsRQfHCJ=hY=hyX2TJLRAArX7iAhDdxTkaP9hjC5nR5U5vA@mail.gmail.com>
In-Reply-To: <CAMbhsRQfHCJ=hY=hyX2TJLRAArX7iAhDdxTkaP9hjC5nR5U5vA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/04/14 18:44, Colin Cross wrote:
>>> Is that case documented somewhere in the code comments?
>>
>> Perhaps not near enough to the _nolock but the primary bit of comment is
>> here (and in same file as kdb_sr).
>> --- cut here ---
>>  * kdb_main_loop - After initial setup and assignment of the
>>  *      controlling cpu, all cpus are in this loop.  One cpu is in
>>  *      control and will issue the kdb prompt, the others will spin
>>  *      until 'go' or cpu switch.
>> --- cut here ---
>>
>> The mechanism kgdb uses to quiesce other CPUs means other CPUs cannot be
>> in irqsave critical sections.
>>
>>
> 
> One of the advantages of FIQ debugger is that it can be triggered from
> an FIQ (NMI for those in x86 land), and Jason and I have discussed
> using FIQs for kgdb to allow interrupting cpus stuck in critical
> sections.  If that gets implemented the above assumption will no
> longer be correct.

Quite so (I've got Anton's old FIQ patches running on latest kernel and
am trying to port to a GICv2-without-trustzone qemu model I've written
in order to kick the idea about a bit on an ARM multi-arch kernel).

This patch has therefore pained me a little bit to not complete cover
this case in the patch. As posted I deliberately ignore the problem. In
this particular case the SysRq table is so infrequently updated the
chances of an badly timed NMI are vanishingly small and, at that point,
even if we did actually hit that tiny window its *still* better to have
the new behaviour (risk of race) than the old behaviour (guaranteed
deadlock).

I'd very much welcome other ideas (I have tried out quite a few in my
head but none solve the problem of NMI "gratuitiously" hitting critical
sections). However when NMI/FIQ finally comes along I'd be tempted to
borrow the "bounce to normal interrupt mode" idea from FIQ debugger and
ensure commands like "sr" command do not run from the NMI handler.


Daniel.

