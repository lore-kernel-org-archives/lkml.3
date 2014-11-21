Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbaKUOak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:30:40 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51038 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaKUOaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:30:39 -0500
Message-ID: <546F4C8C.4040904@gmail.com>
Date: Fri, 21 Nov 2014 09:30:36 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com
Subject: Re: [PATCH tip/core/rcu 3/9] drivers/md: Use rcu_dereference() for
 accessing rcu pointer
References: <20141028220944.GA26114@linux.vnet.ibm.com> <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com> <1414534202-27312-3-git-send-email-paulmck@linux.vnet.ibm.com> <20141121133145.GA17245@node.dhcp.inet.fi>
In-Reply-To: <20141121133145.GA17245@node.dhcp.inet.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 08:31 AM, Kirill A. Shutemov wrote:
> On Tue, Oct 28, 2014 at 03:09:56PM -0700, Paul E. McKenney wrote:
>> From: Pranith Kumar <bobby.prani@gmail.com>
>>
>> Got Paul's email wrong the first time.
>>
>> The map field in 'struct mapped_device' is an rcu pointer. Use rcu_dereference()
>> while accessing it.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> On current -next I see this:
> 
> [    6.388264] ===============================
> [    6.389571] [ INFO: suspicious RCU usage. ]
> [    6.390869] 3.18.0-rc5-next-20141121-08303-g44cae4530372 #2 Not tainted
> [    6.392185] -------------------------------
> [    6.393479] /home/kas/git/public/linux/drivers/md/dm.c:2853 suspicious rcu_dereference_check() usage!
> [    6.394801] 
> other info that might help us debug this:
> 

Hi Kirill,

We are dereferencing an RCU pointer with the suspend_lock held which is causing this warning.

Can you please check if the following patch helps? Thanks!

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a0ece87..e584e66 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2830,7 +2830,7 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
  */
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 {
-       struct dm_table *map = NULL;
+       struct dm_table *map = rcu_dereference(md->map);
        int r = 0;
 
 retry:
@@ -2850,8 +2850,6 @@ retry:
                goto retry;
        }
 
-       map = rcu_dereference(md->map);
-
        r = __dm_suspend(md, map, suspend_flags, TASK_INTERRUPTIBLE);
        if (r)
                goto out_unlock;



> [    6.398714] 
> rcu_scheduler_active = 1, debug_locks = 0
> [    6.401247] 1 lock held by cryptsetup/159:
> [    6.402522]  #0:  (&md->suspend_lock/1){+.+...}, at: [<ffffffff8179dd1d>] dm_suspend+0x3d/0x140
> [    6.403848] 
> stack backtrace:
> [    6.406448] CPU: 3 PID: 159 Comm: cryptsetup Not tainted 3.18.0-rc5-next-20141121-08303-g44cae4530372 #2
> [    6.407726] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ET93WW (2.53 ) 02/04/2013
> [    6.408982]  0000000000000001 ffff8800d3ac7c38 ffffffff81b00bbd 0000000000000011
> [    6.410249]  ffff8800d301a560 ffff8800d3ac7c68 ffffffff81153be7 ffff8800d3928800
> [    6.411548]  ffff8800d3928970 ffff8800d3928aa0 0000000000000001 ffff8800d3ac7ca8
> [    6.412780] Call Trace:
> [    6.413980]  [<ffffffff81b00bbd>] dump_stack+0x4c/0x6e
> [    6.415178]  [<ffffffff81153be7>] lockdep_rcu_suspicious+0xe7/0x120
> [    6.416364]  [<ffffffff8179de1d>] dm_suspend+0x13d/0x140
> [    6.417535]  [<ffffffff817a2d80>] ? table_load+0x340/0x340
> [    6.418749]  [<ffffffff817a2f2b>] dev_suspend+0x1ab/0x260
> [    6.419901]  [<ffffffff817a2d80>] ? table_load+0x340/0x340
> [    6.421038]  [<ffffffff817a3781>] ctl_ioctl+0x251/0x540
> [    6.422164]  [<ffffffff812b6415>] ? mntput_no_expire+0x5/0x360
> [    6.423280]  [<ffffffff817a3a83>] dm_ctl_ioctl+0x13/0x20
> [    6.424389]  [<ffffffff812a6f98>] do_vfs_ioctl+0x308/0x540
> [    6.425515]  [<ffffffff81175d2d>] ? rcu_read_lock_held+0x6d/0x70
> [    6.426601]  [<ffffffff812b324e>] ? __fget_light+0xbe/0xd0
> [    6.427686]  [<ffffffff812a7251>] SyS_ioctl+0x81/0xa0
> [    6.428760]  [<ffffffff81b0d6ad>] system_call_fastpath+0x16/0x1b
> 

