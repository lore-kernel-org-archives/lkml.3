Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaDDOt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:49:58 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:60785 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbaDDOtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:49:51 -0400
MIME-Version: 1.0
X-Originating-IP: [5.150.199.142]
In-Reply-To: <CALFYKtDjby_U+m4p5Lmu6UYVYt8V3zpNRbyvMhkV05w+W71GWg@mail.gmail.com>
References: <CABt9es_uq1ixwcyHcL8ptYi2fXQjVFHvaOp71uu2epoQk_ToPw@mail.gmail.com>
	<CALFYKtAGBizs8gDariQH2NJACjoRD=2-1u-zwnPfo7D5bVvy3Q@mail.gmail.com>
	<CABt9es8=oycaqfWmNuCY3p5CWCsN95+cLWAbSnLtFTTceDkqgA@mail.gmail.com>
	<CALFYKtDjby_U+m4p5Lmu6UYVYt8V3zpNRbyvMhkV05w+W71GWg@mail.gmail.com>
Date: Fri, 4 Apr 2014 16:49:49 +0200
Message-ID: <CABt9es-fczec=dF22xd-deiUjTDZTCZrCAA0uMBpY82BLbRzNA@mail.gmail.com>
Subject: Re: Crash in rbd, need advice
From: Hannes Landeholm <hannes@jumpstarter.io>
To: Ilya Dryomov <ilya.dryomov@inktank.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@inktank.com>, Sage Weil <sage@newdream.net>,
        Yehuda Sadeh <yehuda@hq.newdream.net>,
        Thorwald Lundqvist <thorwald@jumpstarter.io>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 3:10 PM, Ilya Dryomov <ilya.dryomov@inktank.com> wrote:
> On Fri, Apr 4, 2014 at 4:25 PM, Hannes Landeholm <hannes@jumpstarter.io> wrote:
>> On Fri, Apr 4, 2014 at 1:08 PM, Ilya Dryomov <ilya.dryomov@inktank.com> wrote:
>>> On Wed, Apr 2, 2014 at 12:18 AM, Hannes Landeholm <hannes@jumpstarter.io> wrote:
>>>> Hello,
>>>>
>>>> We're running a couple of Arch Linux servers of version 3.13.5-1 in
>>>> production and suddenly one of them had a strange problem after
>>>> running for a few days. One process (pid 319) was running with a few
>>>> threads, one of those threads (pid 322) was eating 100% cpu. I assumed
>>>> it was stuck in an infinite loop (this was our own software so I
>>>> assumed we had a bug) so I sent a SIGKILL to 319 which caused all
>>>> other threads to exit and it turning into a zombie, but thread 322 was
>>>> still running. After trying to stop some other services and failing I
>>>> realized that sending any signals to any process now didn't work at
>>>> all in the system.
>>>>
>>>> This was the process stack output:
>>>>
>>>> $ cat /proc/319/stack
>>>> [<ffffffff810642fa>] do_exit+0x73a/0xa80
>>>> [<ffffffff810646bf>] do_group_exit+0x3f/0xa0
>>>> [<ffffffff81073295>] get_signal_to_deliver+0x295/0x5f0
>>>> [<ffffffff810144a8>] do_signal+0x48/0x950
>>>> [<ffffffff81014e18>] do_notify_resume+0x68/0xa0
>>>> [<ffffffff8152326a>] int_signal+0x12/0x17
>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>> $ cat /proc/319/task/322/stack
>>>> [<ffffffff8151c11a>] error_exit+0x2a/0x60
>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>
>>>> We're using ceph + rbd and this happened right after doing a rbd
>>>> mapping (mounting it) or during the mapping itself, so we suspected
>>>> rbd.
>>>>
>>>> A few days later (today) we had a server crash in another server, same
>>>> version+distro and it had also just been running a few days as well.
>>>> After starting it again we found the following in the system log:
>>>>
>>>> hostname kernel: BUG: unable to handle kernel paging request at ffff87fff75ad450
>>>> hostname kernel: IP: [<ffffffffa018c196>] rbd_img_request_fill+0x126/0x930 [rbd]
>>>
>>> Can you try gdb'ing that exact rbd.ko and
>>>
>>> (gdb) list *rbd_img_request_fill+0x126
>>>
>>> Also, the entire stack trace pertaining to rbd_img_request_fill would
>>> help.
>>>
>>> Thanks,
>>>
>>>                 Ilya
>>
>> Sorry, rbd was not built with any symbols and there was no other
>> output in the journal.
>>
>> We're building a debug version of Linux 3.14 (with symbols) now that
>> is currently being tested and we hope that we can roll it out today. I
>> saw that at least one commit (638c323 rbd: drop an unsafe assertion)
>> looks like something that could fix a crash that has been happening
>> regularly on one of our development servers:
>> http://i.imgur.com/pEKsmql.jpg (rbd_img_obj_callback in the stack
>> trace). It might be related to the production crash we had.
>
> Yeah, it most probably is.  However, a bogus dereference in
> rbd_img_request_fill is something I haven't seen before.  If you have
> that rbd.ko lying around, send it along, just in case.

Unfortunately it got overwritten when we upgraded the kernel.

The crash could be something caused by running the osd's and the
client on the same machine. We're not doing that in production so we
assumed the development machine crashes was caused by that since we
heard that this didn't work very well and was not recommended.

If we get more crashes in 3.14 we should have much better backtraces now though.

Thank you for your time,
Hannes
