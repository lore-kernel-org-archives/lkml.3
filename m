Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3IHDHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:07:44 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:52790 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3IHDHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:07:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1309061302300.12830@cobra.newdream.net>
References: <cover.1378418255.git.milosz@adfin.com>
	<alpine.DEB.2.00.1309051555250.1073@cobra.newdream.net>
	<CANP1eJEk=eRmq1F+yYWB53spgifbU+zzKGdmKw6BGfx8SknkrA@mail.gmail.com>
	<18764.1378483142@warthog.procyon.org.uk>
	<CANP1eJFMdcsgSwVO9jhYQwn2C+19db1uy5=du7yYFbmiB6em0A@mail.gmail.com>
	<alpine.DEB.2.00.1309061302300.12830@cobra.newdream.net>
Date: Sat, 7 Sep 2013 23:07:39 -0400
Message-ID: <CANP1eJFtF7sRJkqg0xGqNjEzbz29GWywB8DAjfGFzDhCPSfjcg@mail.gmail.com>
Subject: Re: [PATCH 0/8] ceph: fscache support & upstream changes
From: Milosz Tanski <milosz@adfin.com>
To: David Howells <dhowells@redhat.com>
Cc: sprabhu@redhat.com, ceph-devel <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Hongyi Jia <jiayisuse@gmail.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Sage Weil <sage@inktank.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I ran into another issue that caused one my machines to hang on a
bunch of tasks and then hard lock. Here's the backtrace of the hang:

INFO: task kworker/1:2:4214 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:2     D ffff880443513fc0     0  4214      2 0x00000000
Workqueue: ceph-msgr con_work [libceph]
 ffff88042b093868 0000000000000246 ffff88042b8e5bc0 ffffffff81569fc6
 ffff88042c51dbc0 ffff88042b093fd8 ffff88042b093fd8 ffff88042b093fd8
 ffff88042c518000 ffff88042c51dbc0 ffff8804266b8d10 ffff8804439d7188
Call Trace:
 [<ffffffff81569fc6>] ? _raw_spin_unlock_irqrestore+0x16/0x20
 [<ffffffffa0016570>] ? fscache_wait_bit_interruptible+0x30/0x30 [fscache]
 [<ffffffff81568d09>] schedule+0x29/0x70
 [<ffffffffa001657e>] fscache_wait_atomic_t+0xe/0x20 [fscache]
 [<ffffffff815665cf>] out_of_line_wait_on_atomic_t+0x9f/0xe0
 [<ffffffff81083560>] ? autoremove_wake_function+0x40/0x40
 [<ffffffffa0015a9c>] __fscache_relinquish_cookie+0x15c/0x310 [fscache]
 [<ffffffffa00a4fae>] ceph_fscache_unregister_inode_cookie+0x3e/0x50 [ceph]
 [<ffffffffa007e373>] ceph_destroy_inode+0x33/0x200 [ceph]
 [<ffffffff811c13ae>] ? __fsnotify_inode_delete+0xe/0x10
 [<ffffffff8119ba1c>] destroy_inode+0x3c/0x70
 [<ffffffff8119bb69>] evict+0x119/0x1b0
 [<ffffffff8119c3f3>] iput+0x103/0x190
 [<ffffffffa009aaed>] iterate_session_caps+0x7d/0x240 [ceph]
 [<ffffffffa009b170>] ? remove_session_caps_cb+0x270/0x270 [ceph]
 [<ffffffffa00a1fc5>] dispatch+0x725/0x1b40 [ceph]
 [<ffffffff81459466>] ? kernel_recvmsg+0x46/0x60
 [<ffffffffa002c0e8>] ? ceph_tcp_recvmsg+0x48/0x60 [libceph]
 [<ffffffffa002ecbe>] try_read+0xc1e/0x1e70 [libceph]
 [<ffffffffa0030015>] con_work+0x105/0x1920 [libceph]
 [<ffffffff8100349e>] ? xen_end_context_switch+0x1e/0x30
 [<ffffffff8108dbca>] ? finish_task_switch+0x5a/0xc0
 [<ffffffff8107aa59>] process_one_work+0x179/0x490
 [<ffffffff8107bf5b>] worker_thread+0x11b/0x370
 [<ffffffff8107be40>] ? manage_workers.isra.21+0x2e0/0x2e0
 [<ffffffff81082a80>] kthread+0xc0/0xd0
 [<ffffffff81010000>] ? perf_trace_xen_mmu_set_pud+0xd0/0xd0
 [<ffffffff810829c0>] ? flush_kthread_worker+0xb0/0xb0
 [<ffffffff81572cec>] ret_from_fork+0x7c/0xb0
 [<ffffffff810829c0>] ? flush_kthread_worker+0xb0/0xb0

It looks like it's waiting for the the cookie's n_active to drop down
to 0 ... but it isn't. After spending a bunch of hours reading the
code, then having a some beers (it is Saturday night after all), then
looking at code again... I think that the
__fscache_check_consistency() function increments the n_active counter
but never lowers it. I think the solution to this is the bellow diff
but I'm not a 100% sure. Can you let me know if I'm on the right
track... of it's beer googles?

diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 318e843..b2a86e3 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -586,7 +586,8 @@ int __fscache_check_consistency(struct
fscache_cookie *cookie)

        fscache_operation_init(op, NULL, NULL);
        op->flags = FSCACHE_OP_MYTHREAD |
-               (1 << FSCACHE_OP_WAITING);
+               (1 << FSCACHE_OP_WAITING) |
+               (1 << FSCACHE_OP_UNUSE_COOKIE);

        spin_lock(&cookie->lock);

Thanks,
- Milosz

On Fri, Sep 6, 2013 at 4:03 PM, Sage Weil <sage@inktank.com> wrote:
> On Fri, 6 Sep 2013, Milosz Tanski wrote:
>> Sage,
>>
>> I've taken David's latest changes and per his request merged his
>> 'fscache-fixes-for-ceph' tag then applied my changes on top of that.
>> In addition to the pervious changes I also added a fix for the
>> warnings the linux-next build bot found.
>>
>> I've given the results a quick test to make sure it builds, boots and
>> runs okay. The code is located in my repository:
>>
>>   https://adfin@bitbucket.org/adfin/linux-fs.git in the wip-fscache-v2 branch
>>
>> I hope that this is the final go for now and thanks for everyone's patience.
>
> Looks good; I'll send this to Linus along with the other ceph patches
> shortly.
>
> Thanks, everyone!
> sage
>
>
>>
>>  - Milosz
>>
>> On Fri, Sep 6, 2013 at 11:59 AM, David Howells <dhowells@redhat.com> wrote:
>> > Milosz Tanski <milosz@adfin.com> wrote:
>> >
>> >> After running this for a day on some loaded machines I ran into what
>> >> looks like an old issue with the new code. I remember you saw an issue
>> >> that manifested it self in a similar way a while back.
>> >>
>> >> [13837253.462779] FS-Cache: Assertion failed
>> >> [13837253.462782] 3 == 5 is false
>> >> [13837253.462807] ------------[ cut here ]------------
>> >> [13837253.462811] kernel BUG at fs/fscache/operation.c:414!
>> >
>> > Bah.
>> >
>> > I forgot to call fscache_op_complete().  Patch updated and repushed.
>> >
>> > Btw, I've reordered the patches to put the CIFS patch last.  Can you merge the
>> > patches prior to the CIFS commit from my branch rather than cherry picking
>> > them so that if they go via two different routes, GIT will handle the merge
>> > correctly?  I've stuck a tag on it (fscache-fixes-for-ceph) to make that
>> > easier for you.
>> >
>> > I've also asked another RH engineer to try doing some basic testing on the
>> > CIFS stuff - which may validate the fscache_readpages_cancel patch.
>> >
>> > David
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
