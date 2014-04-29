Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbaD2I7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:59:47 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43029 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698AbaD2I7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:59:44 -0400
Message-ID: <535F69F8.8040707@linaro.org>
Date: Tue, 29 Apr 2014 09:59:36 +0100
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

Reviewing this I realized I missed one of the most critical points in
the above.

Today kdb, even if triggered by FIQ/NMI, would still be likely to wedge
waiting for the IPI interrupts to be delivered to other processors.

Did you and Jason discuss getting the active CPU to quiesce the other
processors using FIQ/NMI, or to allow the active CPU to timeout while
waiting for them the stop?


Daniel.
