Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3ENHju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:39:50 -0400
Received: from canardo.mork.no ([148.122.252.1]:41055 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3ENHjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:39:49 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, Dipankar Sarma <dipankar@in.ibm.com>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [v3.10-rc1] WARNING: at kernel/rcutree.c:502
Organization: m
References: <87ip2opntp.fsf@nemi.mork.no>
	<20130512113905.GH3648@linux.vnet.ibm.com>
	<87li7kp50r.fsf@nemi.mork.no>
	<20130512172135.GJ3648@linux.vnet.ibm.com>
	<87a9o0ukll.fsf@nemi.mork.no> <87sj1rydol.fsf@nemi.mork.no>
	<87wqr3j656.fsf@nemi.mork.no> <519169BF.4080208@linux.vnet.ibm.com>
Date: Tue, 14 May 2013 09:38:56 +0200
In-Reply-To: <519169BF.4080208@linux.vnet.ibm.com> (Srivatsa S. Bhat's message
	of "Tue, 14 May 2013 04:01:27 +0530")
Message-ID: <87ppwuroxb.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
> On 05/13/2013 08:09 PM, Bjørn Mork wrote:
>
>> Hey, hey, hey.  Turns out this wasn't that wrong after all.  That merge
>> includes a oneline diff in kernel/cpu/idle.c and it *is* actually this
>> diff which trigger the problem for me.  Reverting it, using the attached
>> patch, makes the warning go away.  Which means that it had nothing to do
>> with your RCU changes.
>> 
>> But I haven't the faintest idea how this is supposed to work, or even
>> how to explain the patch properly, so I think I need some help from
>> Thomas here.  Unless this makes you understand the real issue?
>> 
>> Thomas, why does powertop trigger the
>> 
>>   WARNING: at kernel/rcutree.c:502 rcu_eqs_exit_common.isra.48+0x3d/0x125()
>> 
>> without the attached patch?  And what is the proper resolution?
>> 
>  
> The problem appears to be in the cpu idle poll implementation. You can trigger
> this problem by passing idle=poll in the kernel cmd-line as well, right?

That sounded so obvious that it made me think "Doh, why didn't I just
test that before?"  But unfortunately there must be some other factor
involved. No warnings observed during normal use when running with
idle=poll:

 bjorn@nemi:~$ dmesg|grep polling
 [    0.000000] process: using polling idle threads


I expected a flood of warnings here, but there is none until I start
powertop (to confirm that the original issue is still there).  So it's
more than just entering cpu_idle_poll().

> I think I understand what is going on here. Can you please try the fix below?
> (It is only compile-tested since its very late here and I really need to get
> some sleep!).

Works perfect.  Thanks.  I assume this is the correct fix even if the
problem isn't completely understood?



Bjørn
