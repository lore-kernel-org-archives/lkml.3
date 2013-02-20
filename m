Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab3BTVgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:36:45 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52148 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3BTVgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:36:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Li Fei <fei.li@intel.com>, <pavel@ucw.cz>, <rjw@sisk.pl>,
        <len.brown@intel.com>, <mingo@redhat.com>, <peterz@infradead.org>,
        <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
        <gorcunov@openvz.org>, <rientjes@google.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <chuansheng.liu@intel.com>, <biao.wang@intel.com>
References: <Pine.LNX.4.44L0.1302201541000.1671-100000@iolanthe.rowland.org>
Date: Wed, 20 Feb 2013 13:36:19 -0800
In-Reply-To: <Pine.LNX.4.44L0.1302201541000.1671-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Wed, 20 Feb 2013 15:48:43 -0500 (EST)")
Message-ID: <87zjyyekh8.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19KB1V0cIRXFAcBe3Xf56xHfBWuCKK29Po=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0083]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Stern <stern@rowland.harvard.edu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] freezer: configure user space process frozen along with kernel threads
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Wed, 20 Feb 2013, Eric W. Biederman wrote:
>
>> >> Why can't the fuse filesystem freeze when there are requests pending?
>> >
>> > It _can_ freeze (that is, the fuse daemon can).  The problem is that
>> > tasks _using_ the fuse filsystem can't if the daemon doesn't respond. 
>> 
>> Which is what I meant when I said that the fuse filesystem couldn't
>> freeze.
>
> Oh, okay.  But it's no different from any other filesystem in that
> respect.  Processes generally can't be frozen while they are waiting
> for filesystem I/O to complete.  In many cases they can't receive 
> signals either (they are in an uninterruptible wait state).

Ick.  So the process freezer and all network filesystems has problems?
Especially nfs?

>> > These tasks are stuck in uninterruptible wait states deep in the
>> > filesystem layer, probably holding important locks.  They can't be
>> > frozen until the outstanding requests complete.
>> 
>> Why is it that processes that can be preempted can't be frozen?
>
> There's a big difference between preemption and freezing: Preemption
> is involuntary whereas freezing is voluntary.  It's like the difference
> between preemptive and cooperative multitasking.

I hadn't realized freezing was voluntary.  That certainly seems like a
pain.

> Processes can be frozen only by making explicit checks, and they 
> mustn't be frozen while they are holding locks that would prevent other 
> processes from reaching one of those checks.
>
>> At most I would suggest that processes be frozen in reverse priority
>> order.  Which unless there is a priority inversion should solve this
>> problem without an additional proc file.
>
> Do fuse daemons (and the processes they rely upon) run with elevated 
> priority?

I don't know if the daemons are of an elevated scheduling priority today
but if they aren't it is as easy to require an elevated scheduling
priority as it is to require a magic freezer priority.  Furthermore if
they don't run at an elevated priority there is the possibility of
priority inversion.

With a little care you might even be able to drop the kernel thread
special case if you freeze processes by prirority.

Eric
