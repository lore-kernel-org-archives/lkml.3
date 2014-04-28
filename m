Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaD1KYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:24:37 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35182 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbaD1KYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:24:34 -0400
Message-ID: <535E2C5A.9090702@linaro.org>
Date: Mon, 28 Apr 2014 11:24:26 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: Re: [RFC v3 1/9] sysrq: Implement __handle_sysrq_nolock to avoid
 recursive locking in kdb
References: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>	<1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>	<1398443370-12668-2-git-send-email-daniel.thompson@linaro.org> <20140425124530.52fd696c@gandalf.local.home>
In-Reply-To: <20140425124530.52fd696c@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 17:45, Steven Rostedt wrote:
> On Fri, 25 Apr 2014 17:29:22 +0100
> Daniel Thompson <daniel.thompson@linaro.org> wrote:
> 
>> If kdb is triggered using SysRq-g then any use of the sr command results
>> in the SysRq key table lock being recursively acquired, killing the debug
>> session. That patch resolves the problem by introducing a _nolock
>> alternative for __handle_sysrq.
>>
>> Strictly speaking this approach risks racing on the key table when kdb is
>> triggered by something other than SysRq-g however in that case any other
>> CPU involved should release the spin lock before kgdb parks the slave
>> CPUs.
> 
> Is that case documented somewhere in the code comments?

Perhaps not near enough to the _nolock but the primary bit of comment is
here (and in same file as kdb_sr).
--- cut here ---
 * kdb_main_loop - After initial setup and assignment of the
 *	controlling cpu, all cpus are in this loop.  One cpu is in
 *	control and will issue the kdb prompt, the others will spin
 *	until 'go' or cpu switch.
--- cut here ---

The mechanism kgdb uses to quiesce other CPUs means other CPUs cannot be
in irqsave critical sections.


