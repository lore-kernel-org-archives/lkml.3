Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbaGYWYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:24:15 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:58358 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaGYWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:24:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140725150248.GZ11241@linux.vnet.ibm.com>
References: <1406264818-2296-1-git-send-email-bobby.prani@gmail.com>
 <CAJhHMCDQe5tSs7576uy8fRBW0txXoyUa6RiQdpg48UJs5TPsog@mail.gmail.com> <20140725150248.GZ11241@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Fri, 25 Jul 2014 18:23:41 -0400
Message-ID: <CAJhHMCDEFgwNVcd_ZaZ_1Eohv_eH9tCnjedxeQg122ACNdX2cQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] rcu: Use rcu_gp_kthread_wake() to wake up kthreads
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:02 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Jul 25, 2014 at 02:24:34AM -0400, Pranith Kumar wrote:
>> On Fri, Jul 25, 2014 at 1:06 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>>
>> >
>> > In rcu_report_qs_rsp(), I added a pr_info() call testing if any of the above
>> > conditions is true, in which case we can avoid calling wake_up(). It turns out
>> > that quite a few actually are. Most of the cases where we can avoid is condition 2
>> > above and condition 1 also occurs quite often. Condition 3 never happens.
>> >
>>
>> A little more data. On an idle system there are about 2000 unnecessary
>> wake_up() calls every 5 minutes with the most common trace being the
>> follows:
>>
>> [Fri Jul 25 02:05:49 2014]  [<ffffffff8109f7c5>] rcu_report_qs_rnp+0x285/0x2c0
>> [Fri Jul 25 02:05:49 2014]  [<ffffffff81838c09>] ? schedule_timeout+0x159/0x270
>> [Fri Jul 25 02:05:49 2014]  [<ffffffff8109fa21>] force_qs_rnp+0x111/0x190
>> [Fri Jul 25 02:05:49 2014]  [<ffffffff810a02c0>] ? synchronize_rcu_bh+0x50/0x50
>> [Fri Jul 25 02:05:49 2014]  [<ffffffff810a2e5f>] rcu_gp_kthread+0x85f/0xa70
>> [Fri Jul 25 02:05:49 2014]  [<ffffffff81086060>] ? __wake_up_sync+0x20/0x20
>> [Fri Jul 25 02:05:49 2014]  [<ffffffff810a2600>] ? rcu_barrier+0x20/0x20
>> [Fri Jul 25 02:05:49 2014]  [<ffffffff8106b4fb>] kthread+0xdb/0x100
>>                   [<ffffffff8106b420>]?kthread_create_on_node+0x180/0x180
>> [Fri Jul 25 02:05:49 2014]  [<ffffffff81839dac>] ret_from_fork+0x7c/0xb0
>>                   [<ffffffff8106b420>] ?kthread_create_on_node+0x180/0x180
>>
>> With rcutorture, there are about 2000 unnecessary wake_ups() every 3
>> minutes with the most common trace being:
>>
>> [Fri Jul 25 02:18:30 2014]  [<ffffffff8109f7c5>] rcu_report_qs_rnp+0x285/0x2c0
>> [Fri Jul 25 02:18:30 2014]  [<ffffffff81078b15>] ? __update_cpu_load+0xe5/0x140
>>                  [<ffffffffa09dc230>] ?rcu_read_delay+0x50/0x80 [rcutorture]
>>                  [<ffffffff810a3728>]rcu_process_callbacks+0x6b8/0x7e0
>
> Good to see the numbers!!!
>
> But to evaluate this analytically, we should compare the overhead of the
> wake_up() with the overhead of the extra checks in rcu_gp_kthread_wake(),
> and then compare the number of unnecessary wake_up()s to the number of
> calls to rcu_gp_kthread_wake() added by this patch.  This means that we
> need more numbers.
>
> For example, suppose that the extra checks cost 10ns on average, and that
> a unnecessary wake_up() costs 1us on average, to that each wake_up()
> is on average 100 times more expensive than the extra checks.  Then it
> makes sense to ask whether the saved wake_up() save more time than the
> extra tests cost.  Turning the arithmetic crank says that if more than 1%
> of the wake_up()s are unnecessary, we should add the checks.
>
> This means that if there are fewer than 200,000 grace periods in each
> of the time periods, then your patch really would provide performance
> benefits.  I bet that there are -way- fewer than 200,000 grace periods in
> each of the time periods, but why don't you build with RCU_TRACE and look
> at the "rcugp" file in RCU's debugfs hierarchy?  Or just periodically
> print out the rcu_state ->completed field?
>

I put some debugging code to see how many unnecessary wake ups were
being generated in rcu_report_qs_rsp(). I ran both with and without
rcutorture running. Here are the results

Without rcutorture:

[   14.839214] Total:2000, unnecessary:2000, case1:1741, case2:2000, case3:0
[  224.284633] Total:4000, unnecessary:4000, case1:3652, case2:4000, case3:0
[  244.159021] Total:6000, unnecessary:6000, case1:5539, case2:6000, case3:0
[  260.522175] Total:8000, unnecessary:8000, case1:7447, case2:8000, case3:0
[  268.293058] Total:10000, unnecessary:10000, case1:9317, case2:10000, case3:0
[  275.962033] Total:12000, unnecessary:12000, case1:11159, case2:12000, case3:0
[  287.411032] Total:14000, unnecessary:14000, case1:13008, case2:14000, case3:0
[  304.868334] Total:16000, unnecessary:16000, case1:14885, case2:16000, case3:0
[  318.090930] Total:18000, unnecessary:18000, case1:16747, case2:18000, case3:0
[  333.423876] Total:20000, unnecessary:20000, case1:18631, case2:20000, case3:0
[  346.775399] Total:22000, unnecessary:22000, case1:20502, case2:22000, case3:0
[  362.867751] Total:24000, unnecessary:24000, case1:22386, case2:24000, case3:0
[  376.777817] Total:26000, unnecessary:26000, case1:24251, case2:26000, case3:0
[  391.839994] Total:28000, unnecessary:28000, case1:26118, case2:28000, case3:0
[  406.559406] Total:30000, unnecessary:30000, case1:27983, case2:30000, case3:0
[  419.973867] Total:32000, unnecessary:32000, case1:29855, case2:32000, case3:0
[  435.080002] Total:34000, unnecessary:34000, case1:31740, case2:34000, case3:0
[  449.077018] Total:36000, unnecessary:36000, case1:33588, case2:36000, case3:0
[  464.418942] Total:38000, unnecessary:38000, case1:35460, case2:38000, case3:0
[  478.654755] Total:40000, unnecessary:40000, case1:37326, case2:40000, case3:0
[  494.650198] Total:42000, unnecessary:42000, case1:39232, case2:42000, case3:0
[  508.594240] Total:44000, unnecessary:44000, case1:41134, case2:44000, case3:0
[  524.273907] Total:46000, unnecessary:46000, case1:43039, case2:46000, case3:0
[  537.227731] Total:48000, unnecessary:48000, case1:44916, case2:48000, case3:0
[  552.963362] Total:50000, unnecessary:50000, case1:46805, case2:50000, case3:0
[  567.333075] Total:52000, unnecessary:52000, case1:48662, case2:52000, case3:0
[  581.811693] Total:54000, unnecessary:54000, case1:50550, case2:54000, case3:0
[  596.404233] Total:56000, unnecessary:56000, case1:52417, case2:56000, case3:0
[  610.249344] Total:58000, unnecessary:58000, case1:54309, case2:58000, case3:0
[  625.682220] Total:60000, unnecessary:60000, case1:56190, case2:60000, case3:0
[  640.784361] Total:62000, unnecessary:62000, case1:58069, case2:62000, case3:0
[  656.142299] Total:64000, unnecessary:64000, case1:59953, case2:64000, case3:0
[  670.026376] Total:66000, unnecessary:66000, case1:61827, case2:66000, case3:0
[  685.972862] Total:68000, unnecessary:68000, case1:63696, case2:68000, case3:0



With rcutorture, the last lines(time makes the line wrap, so removed it):

Total:182000, unnecessary:182000, case1:171241, case2:182000, case3:0
Total:184000, unnecessary:184000, case1:173127, case2:184000, case3:0
Total:186000, unnecessary:186000, case1:174992, case2:186000, case3:0
Total:188000, unnecessary:188000, case1:176870, case2:188000, case3:0
Total:190000, unnecessary:190000, case1:178721, case2:190000, case3:0
Total:192000, unnecessary:192000, case1:180606, case2:192000, case3:0
Total:194000, unnecessary:194000, case1:182466, case2:194000, case3:0
Total:196000, unnecessary:196000, case1:184330, case2:196000, case3:0
Total:198000, unnecessary:198000, case1:186195, case2:198000, case3:0
Total:200000, unnecessary:200000, case1:188056, case2:200000, case3:0
Total:202000, unnecessary:202000, case1:189938, case2:202000, case3:0
Total:204000, unnecessary:204000, case1:190740, case2:204000, case3:0
Total:206000, unnecessary:206000, case1:190755, case2:206000, case3:0
Total:208000, unnecessary:208000, case1:190768, case2:208000, case3:0
Total:210000, unnecessary:210000, case1:190782, case2:210000, case3:0
Total:212000, unnecessary:212000, case1:190796, case2:212000, case3:0
Total:214000, unnecessary:214000, case1:190812, case2:214000, case3:0
Total:216000, unnecessary:216000, case1:190827, case2:216000, case3:0
Total:218000, unnecessary:218000, case1:190850, case2:218000, case3:0
Total:220000, unnecessary:220000, case1:190862, case2:220000, case3:0
Total:222000, unnecessary:222000, case1:190878, case2:222000, case3:0
Total:224000, unnecessary:224000, case1:190893, case2:224000, case3:0
Total:226000, unnecessary:226000, case1:190906, case2:226000, case3:0
Total:228000, unnecessary:228000, case1:190918, case2:228000, case3:0
Total:230000, unnecessary:230000, case1:190930, case2:230000, case3:0
Total:232000, unnecessary:232000, case1:190940, case2:232000, case3:0
Total:234000, unnecessary:234000, case1:190953, case2:234000, case3:0
Total:236000, unnecessary:236000, case1:190965, case2:236000, case3:0
Total:238000, unnecessary:238000, case1:190975, case2:238000, case3:0
Total:240000, unnecessary:240000, case1:190989, case2:240000, case3:0
Total:242000, unnecessary:242000, case1:191008, case2:242000, case3:0
Total:244000, unnecessary:244000, case1:191019, case2:244000, case3:0
Total:246000, unnecessary:246000, case1:192344, case2:246000, case3:0
Total:248000, unnecessary:248000, case1:194221, case2:248000, case3:0
Total:250000, unnecessary:250000, case1:196099, case2:250000, case3:0
Total:252000, unnecessary:252000, case1:198015, case2:252000, case3:0
Total:254000, unnecessary:254000, case1:199913, case2:254000, case3:0
Total:256000, unnecessary:256000, case1:201784, case2:256000, case3:0


Here total is the total number of times we enter th function rcu_report_qs_rsp()
and unnecessary is the times we call wake_up() unnecessarily.
case1, 2, 3 are the cases I listed above.

Note that the frequency has gone way up than before, I am not sure why that is.

*ALL* the wakeups seem to be unnecessary from that location. And the
main reason is that gp_flags is 0.

My rcugp file has the following:

completed=257515  gpnum=257516  age=1  max=1684

Thoughts?
-- 
Pranith
