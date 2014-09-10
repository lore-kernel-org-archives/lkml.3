Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaIJUag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:30:36 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52045 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaIJUa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:30:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXwEEoCTqksFEyJ7UigOJkf6g5UHnddEHcMDjwKz6K-DQ@mail.gmail.com>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
	<1609685.fbsF6EQ3X7@vostro.rjw.lan>
	<CAM_iQpXiJL=q6NFkiPF71dZHKXu=ReJ59Rbadc__+UX-GW2x8A@mail.gmail.com>
	<4809128.C6aPga5IjQ@vostro.rjw.lan>
	<CAM_iQpXwEEoCTqksFEyJ7UigOJkf6g5UHnddEHcMDjwKz6K-DQ@mail.gmail.com>
Date: Wed, 10 Sep 2014 13:30:25 -0700
Message-ID: <CAM_iQpUP9kSGMs6Lq9tBLGaJrW6yyBWU5z38WzBiH4x-H_ZdYA@mail.gmail.com>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 4:29 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Mon, Sep 8, 2014 at 4:42 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> On Monday, September 08, 2014 04:16:15 PM Cong Wang wrote:
>>> On Mon, Sep 8, 2014 at 4:23 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>>> >
>>> > The reason why it matters for the suspend-time freezing is that we freeze tasks
>>> > to take them out of the picture entirely until they are thawed.  Therefore we
>>> > can't allow them to go back to the picture just for a while until they are
>>> > killed.  Frozen tasks are not supposed to get back to the picture at all.
>>> >
>>>
>>>
>>> Ok, then checking TIF_MEMDIE is unsafe for PM freeze, we should
>>> keep the cgroup_freezing() test to make sure freeze request is from
>>> cgroup not PM. Question got answered. :)
>>
>> Do I think correctly that cgroups freezing and system suspend are
>> mutually exclusive?  If not, then this still is problematic.
>
> Good point! Although rare, but it is possible we freeze a process both from
> cgroup and PM. Hmm, this means we have to explicitly exclude PM rather
> just checking cgroup freeze? Interesting, but I am not familiar with PM.
>

I am wondering if the folllowing check makes any sense with regarding
to rule out PM freeze:

        if ((!pm_nosig_freezing && !pm_freezing) &&
            cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE))
                return true;

PM will not freeze the process again if it is already frozen by cgroup,
so here we just make sure that it will not thaw if PM freeze is in progress.

Am I missing anything?
