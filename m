Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaJQCdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 22:33:41 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:56280 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaJQCdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 22:33:40 -0400
MIME-Version: 1.0
In-Reply-To: <20141016222237.GA30063@redhat.com>
References: <20141016203954.GA26336@redhat.com>
	<CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com>
	<20141016211136.GA27468@redhat.com>
	<CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com>
	<20141016213512.GA28099@redhat.com>
	<CAM_iQpUFBDscS2n41FdE3S016c_jkb4HaKomy14G7Ez9x4w3+g@mail.gmail.com>
	<20141016222237.GA30063@redhat.com>
Date: Thu, 16 Oct 2014 19:33:39 -0700
Message-ID: <CAM_iQpVZtOCzWA3wWuG5y7AyOBUx41-81jrt+dSeHvr6eHY4RA@mail.gmail.com>
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm tree
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 3:22 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 10/16, Cong Wang wrote:
>>
>> On Thu, Oct 16, 2014 at 2:35 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > If a task B is already frozen, it sleeps in D state.
>> >
>> > If OOM selects B as a victim after that, it won't be woken by
>> > SIGKILL, thus it obviously can't call should_thaw_current() and
>> > notice TIF_MEMDIE.
>>
>> I see your point now, it would be more clear if you can just quote
>> the patch instead of changelog.
>>
>> So are you saying the loop in __refrigerator() is useless?
>
> No.
>
>> Since
>> it will always stay in asleep after schedule()?
>
> Not always. But it will stay asleep in this particular case.

Hmm, so we still need to wake it up in oom killer:

        if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
               if (unlikely(frozen(task)))
                      wake_up_state(task, TASK_UNINTERRUPTIBLE);

I will update the patch if Michal doesn't.
