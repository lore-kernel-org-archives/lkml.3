Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaKGR2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:28:01 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63815 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaKGR17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:27:59 -0500
Message-ID: <545D0114.2070002@linaro.org>
Date: Fri, 07 Nov 2014 17:27:48 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 3.18-rc3] kdb: Avoid printing KERN_ levels to consoles
References: <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>	 <1415361686-3797-1-git-send-email-daniel.thompson@linaro.org>	 <1415376272.23530.10.camel@perches.com> <545CF847.3020409@linaro.org> <1415380610.23530.12.camel@perches.com>
In-Reply-To: <1415380610.23530.12.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/14 17:16, Joe Perches wrote:
> On Fri, 2014-11-07 at 16:50 +0000, Daniel Thompson wrote:
>> On 07/11/14 16:04, Joe Perches wrote:
>>> why insert KERN_INFO?
>>
>> vkdb_printf() and  printk() can appear either way round in a stack
>> trace. Each is capable of calling the other and a flag (kdb_trap_printk)
>> is used to prevent mutual recursion.
> 
> I see.
> 
>> A complete solution would require a means to know whether vkdb_printf()
>> were entered directly or from printk(). A flag passed to vkdb_printf()
>> would achieve this. I'll take a look.
> 
> That bit seems pretty simple and sensible.
> 
> I don't know this code at all but would it be better if
> the kdb_trap_printk accesses were converted to atomic_<foo>?
> 
> Might this bit in vkdb_printf:
> 
> 	saved_trap_printk = kdb_trap_printk;
> 	kdb_trap_printk = 0;
> 
> be better atomic_xchg?
> 
> and the kdb_trap_printk++ bits as atomic_inc, etc...

At present I don't think it would make any difference. All of this code
is single threaded; interrupts are masked and all other cores are
quiesced and held in a loop as part of the debugger entry protocol.

If a full asynchronous mode were ever added to kdb, meaning the ability
to run some some commands without halting all the other cores, then we'd
have to review quite a lot of code, including this bit. However in that
case I think that flags like kdb_trap_printk might actually end up as
per_cpu variables rather than atomics.
