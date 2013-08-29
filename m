Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab3H2VJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:09:42 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:59282 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3H2VJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:09:37 -0400
From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "majianpeng@gmail.com" <majianpeng@gmail.com>
Subject: Re: [PATCH] elevator: Fix a race in elevator switching and md
 device initialization
Thread-Topic: [PATCH] elevator: Fix a race in elevator switching and md
 device initialization
Thread-Index: AQHOomKEe8NHX1i8QUyRMlMbtDjKDpms6y8A///IHYA=
Date: Thu, 29 Aug 2013 21:09:24 +0000
Message-ID: <CE452851.7662%Tomoki.Sekiyama@hds.com>
In-Reply-To: <20130829202924.GD6171@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5621B555F09B8843A41CE65194A931A7@hds.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-29_07:2013-08-29,2013-08-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1308290120
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/13 16:29 , "Vivek Goyal" <vgoyal@redhat.com> wrote:

>On Mon, Aug 26, 2013 at 09:45:15AM -0400, Tomoki Sekiyama wrote:
>> The soft lockup below happes at the boot time of the system using dm
>> multipath and automated elevator switching udev rules.
>> 
>> [  356.127001] BUG: soft lockup - CPU#3 stuck for 22s! [sh:483]
>> [  356.127001] RIP: 0010:[<ffffffff81072a7d>]  [<ffffffff81072a7d>]
>>lock_timer_base.isra.35+0x1d/0x50
>> ...
>> [  356.127001] Call Trace:
>> [  356.127001]  [<ffffffff81073810>] try_to_del_timer_sync+0x20/0x70
>> [  356.127001]  [<ffffffff8118b08a>] ?
>>kmem_cache_alloc_node_trace+0x20a/0x230
>> [  356.127001]  [<ffffffff810738b2>] del_timer_sync+0x52/0x60
>> [  356.127001]  [<ffffffff812ece22>] cfq_exit_queue+0x32/0xf0
>> [  356.127001]  [<ffffffff812c98df>] elevator_exit+0x2f/0x50
>> [  356.127001]  [<ffffffff812c9f21>] elevator_change+0xf1/0x1c0
>> [  356.127001]  [<ffffffff812caa50>] elv_iosched_store+0x20/0x50
>> [  356.127001]  [<ffffffff812d1d09>] queue_attr_store+0x59/0xb0
>> [  356.127001]  [<ffffffff812143f6>] sysfs_write_file+0xc6/0x140
>> [  356.127001]  [<ffffffff811a326d>] vfs_write+0xbd/0x1e0
>> [  356.127001]  [<ffffffff811a3ca9>] SyS_write+0x49/0xa0
>> [  356.127001]  [<ffffffff8164e899>] system_call_fastpath+0x16/0x1b
>> 
>> This is caused by a race between md device initialization and sysfs knob
>> to switch the scheduler.
>
>I think we can also improve changelog a bit. So IIUC, softlockup
>happens because one thread called del_timer_sync() on a timer which
>was not even initilized. Timer initialization should have happened
>in cfq_init_queue() using init_timer(). But before init_timer()
>could be called, elevator switch path called del_timer_sync().
>
>del_timer_sync() in turn calls lock_timer_base() which will loop
>infinitely if timer->base == NULL. And because we have not called
>init_timer() yet, I am assuming timer->base is null?
>
>Is this right analysis? If yes, then this patch should most likely
>fix following bz.
>
>https://bugzilla.redhat.com/show_bug.cgi?id=902012

I think your analysis is correct. If del_timer_sync() is called right after
cfqd is allocated (with __GFP_ZERO), timer->base == NULL. Otherwise it may
hit NULL pointer.

The other reason of NULL timer->base is that the timer is migrating in
__mod_timer(), but then the it must be set to non-NULL in a short time.

Maybe __mod_timer should use some illegal pointer value (like LIST_POISON1)
instead of NULL to represent the timer is migrating....
Actually, when I changed __mod_timer to timer_set_base(timer, 0xdeadbeaf),
made lock_timer_base wait while base == 0xdeadbeaf, and
added BUG_ON(!timer->base) to lock_timer_base, my system hits the BUG.

>I had concluded that some how timer->base is NULL but could not understand
>how come timer base is NULL when we have called init_timer() on it.
>
>Thanks
>Vivek

Thanks,
Tomoki

