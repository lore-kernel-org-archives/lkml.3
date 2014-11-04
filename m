Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaKDARh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:17:37 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45229 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKDARd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:17:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAGr1F2EV4p_nJP_oMe3N8pBPedAZHbdB=XCMPjSEZTC9jmZoAg@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-8-git-send-email-adityakali@google.com> <CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ@mail.gmail.com>
 <CAGr1F2FuPQxLraYv7PstJ9c8H-XQsgawaAtj4AS77B+_0k2o+A@mail.gmail.com>
 <CALCETrW64-6xC6psP-8k0H-1GfVnWBTeEBNSrE_sH+-DFtuZQQ@mail.gmail.com>
 <CAGr1F2GX45gC-V7kEzVjp-EiYfdPDVBRs+99nASpgFVAdYX+1w@mail.gmail.com>
 <CALCETrUB_xx5zno26k5UjAFt77nZTpgyndD4AuBSZxiZBNjXSw@mail.gmail.com> <CAGr1F2EV4p_nJP_oMe3N8pBPedAZHbdB=XCMPjSEZTC9jmZoAg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 16:17:11 -0800
Message-ID: <CALCETrXeG2t=fW9HbkirDZudw9pbDwoqDq5ygJBkBMbqqoDAvw@mail.gmail.com>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init cgroupns
To: Aditya Kali <adityakali@google.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 4:12 PM, Aditya Kali <adityakali@google.com> wrote:
> On Mon, Nov 3, 2014 at 3:48 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Mon, Nov 3, 2014 at 3:23 PM, Aditya Kali <adityakali@google.com> wrote:
>>> On Mon, Nov 3, 2014 at 3:15 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> On Mon, Nov 3, 2014 at 3:12 PM, Aditya Kali <adityakali@google.com> wrote:
>>>>> On Fri, Oct 31, 2014 at 5:07 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>>> On Fri, Oct 31, 2014 at 12:19 PM, Aditya Kali <adityakali@google.com> wrote:
>>>>>>>         if (opts->flags & CGRP_ROOT_SANE_BEHAVIOR) {
>>>>>>>                 pr_warn("sane_behavior: this is still under development and its behaviors will change, proceed at your own risk\n");
>>>>>>> -               if (nr_opts != 1) {
>>>>>>> +               if (nr_opts > 1) {
>>>>>>>                         pr_err("sane_behavior: no other mount options allowed\n");
>>>>>>>                         return -EINVAL;
>>>>>>
>>>>>> This looks wrong.  But, if you make the change above, then it'll be right.
>>>>>>
>>>>>
>>>>> It would have been nice if simple 'mount -t cgroup cgroup <mnt>' from
>>>>> cgroupns does the right thing automatically.
>>>>>
>>>>
>>>> This is a debatable point, but it's not what I meant.  Won't your code
>>>> let 'mount -t cgroup -o one_evil_flag cgroup mountpoint' through?
>>>>
>>>
>>> I don't think so. This check "if (nr_opts > 1)" is nested under "if
>>> (opts->flags & CGRP_ROOT_SANE_BEHAVIOR)". So we know that there is
>>> atleast 1 option ('__DEVEL__sane_behavior') present (implicit or not).
>>> Addition of 'one_evil_flag' will make nr_opts = 2 and result in EINVAL
>>> here.
>>
>> But the implicit __DEVEL__sane_behavior doesn't increment nr_opts, right?
>>
>
> Yes. Hence this change makes sure that we don't return EINVAL when
> nr_opts == 0 or nr_opts == 1 :)
> That way, both of the following are equivalent when inside non-init cgroupns:
>
> (1) $ mount -t cgroup -o __DEVEL__sane_behavior cgroup mountpoint
> (2) $ mount -t cgroup cgroup mountpoint
>
> Any other mount option will trigger the error here.

I still don't get it.  Can you walk me through why mount -o
some_other_option -t cgroup cgroup mountpoint causes -EINVAL?

--Andy
