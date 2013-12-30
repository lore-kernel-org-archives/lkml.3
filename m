Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3L3PzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 10:55:15 -0500
Received: from ext190.halfdog.net ([88.116.147.190]:52585 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab3L3PzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 10:55:14 -0500
Message-ID: <52C196C3.1040300@halfdog.net>
Date: Mon, 30 Dec 2013 15:52:35 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:27.0) Gecko/20100101 Firefox/27.0 SeaMonkey/2.24a1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sanitize CPU-state when switching from virtual-8086 mode to other
 task
References: <52BF4A80.3010503@halfdog.net> <52BF8AEE.6020904@zytor.com> <52C089AC.4000401@halfdog.net> <52C0C9F4.50101@zytor.com>
In-Reply-To: <52C0C9F4.50101@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 12/29/2013 12:44 PM, halfdog wrote:
>> H. Peter Anvin wrote:
>>> On 12/28/2013 02:02 PM, halfdog wrote:
>>>> It seems that missing CPU-state sanitation during task 
>>>> switching triggers kernel-panic. This might be related to 
>>>> unhandled FPU-errors. See [1] for POC and serial console log
>>>> of OOPs. Due to missing real 32-bit x86-hardware it is not
>>>> clear, if this issue might be related to subtle differences in 
>>>> virtual-8086 mode handling when inside a virtualbox guest.
>>>>
>>
>>> This oops happens inside the guest?  Either way, I would be 
>>> *very* skeptical of Virtualbox in this case.
>>
>>> You can run a 32-bit kernel on 64-bit hardware, you know...
>>
>> I know, but hardware was occupied with long-running simulation.
>>
>> With the initial POC, there might be a timing issue involved, with
>>  different process layout, exception does not occur in swith_to but
>>  sometimes on other locations.
>>
>> I created a new random-code testcase [1] , which works around that
>>  problem. When booted a Debian initrd and tried id, OOPSes are 
>> fired like wild but at least system does not lock up immediately.
>>
> 
> Still in VirtualBox?

Yes, again: after comparing the results from initrd on real hardware
with Vbox, I'm getting to understand the timing problem involved and why
timing in VBox is different: The test program usually OOPSes when
touching FPU multiple times, otherwise, when terminated before second
FPU-interacation, it OOPSes on next invocation, stumbling over invalid
CPU state from prior invocation. With improved code, I can rather
reliably bring CPU into that state, so that next process invoked and
touching FPU/MMX-state is OOPSed. Currently searching SUID-binaries and
running UID=0 daemons, that might show interesting reaction on that
event, but only on DOS level yet, e.g. after running V2 test program
once and then connecting via SSH, this currently kills the ssh daemon
nicely.

It seems that machine lockup occurs when e.g. switch to idle task
happens at exactly the right moment, which I currently cannot trigger on
real hardware, but still working on that.

-- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
