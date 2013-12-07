Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3LGBMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:12:52 -0500
Received: from ozlabs.org ([203.10.76.45]:46891 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab3LGBMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:12:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>, Andrey Vagin <avagin@openvz.org>,
        virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 2/2] virtio: delete napi structures from netdev before releasing memory
In-Reply-To: <52A142CC.5000707@redhat.com>
References: <1386254181-17257-1-git-send-email-avagin@openvz.org> <1386254181-17257-3-git-send-email-avagin@openvz.org> <52A142CC.5000707@redhat.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sat, 07 Dec 2013 11:02:59 +1030
Message-ID: <8761r15wlg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wang <jasowang@redhat.com> writes:
> On 12/05/2013 10:36 PM, Andrey Vagin wrote:
>> free_netdev calls netif_napi_del too, but it's too late, because napi
>> structures are placed on vi->rq. netif_napi_add() is called from
>> virtnet_alloc_queues.
>>
>> general protection fault: 0000 [#1] SMP
>> Dumping ftrace buffer:
>>    (ftrace buffer empty)
>> Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables virtio_balloon pcspkr virtio_net(-) i2c_pii
>> CPU: 1 PID: 347 Comm: rmmod Not tainted 3.13.0-rc2+ #171
>> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>> task: ffff8800b779c420 ti: ffff8800379e0000 task.ti: ffff8800379e0000
>> RIP: 0010:[<ffffffff81322e19>]  [<ffffffff81322e19>] __list_del_entry+0x29/0xd0
>> RSP: 0018:ffff8800379e1dd0  EFLAGS: 00010a83
>> RAX: 6b6b6b6b6b6b6b6b RBX: ffff8800379c2fd0 RCX: dead000000200200
>> RDX: 6b6b6b6b6b6b6b6b RSI: 0000000000000001 RDI: ffff8800379c2fd0
>> RBP: ffff8800379e1dd0 R08: 0000000000000001 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000001 R12: ffff8800379c2f90
>> R13: ffff880037839160 R14: 0000000000000000 R15: 00000000013352f0
>> FS:  00007f1400e34740(0000) GS:ffff8800bfb00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 00007f464124c763 CR3: 00000000b68cf000 CR4: 00000000000006e0
>> Stack:
>>  ffff8800379e1df0 ffffffff8155beab 6b6b6b6b6b6b6b2b ffff8800378391c0
>>  ffff8800379e1e18 ffffffff8156499b ffff880037839be0 ffff880037839d20
>>  ffff88003779d3f0 ffff8800379e1e38 ffffffffa003477c ffff88003779d388
>> Call Trace:
>>  [<ffffffff8155beab>] netif_napi_del+0x1b/0x80
>>  [<ffffffff8156499b>] free_netdev+0x8b/0x110
>>  [<ffffffffa003477c>] virtnet_remove+0x7c/0x90 [virtio_net]
>>  [<ffffffff813ae323>] virtio_dev_remove+0x23/0x80
>>  [<ffffffff813f62ef>] __device_release_driver+0x7f/0xf0
>>  [<ffffffff813f6ca0>] driver_detach+0xc0/0xd0
>>  [<ffffffff813f5f28>] bus_remove_driver+0x58/0xd0
>>  [<ffffffff813f72ec>] driver_unregister+0x2c/0x50
>>  [<ffffffff813ae65e>] unregister_virtio_driver+0xe/0x10
>>  [<ffffffffa0036942>] virtio_net_driver_exit+0x10/0x6ce [virtio_net]
>>  [<ffffffff810d7cf2>] SyS_delete_module+0x172/0x220
>>  [<ffffffff810a732d>] ? trace_hardirqs_on+0xd/0x10
>>  [<ffffffff810f5d4c>] ? __audit_syscall_entry+0x9c/0xf0
>>  [<ffffffff81677f69>] system_call_fastpath+0x16/0x1b
>> Code: 00 00 55 48 8b 17 48 b9 00 01 10 00 00 00 ad de 48 8b 47 08 48 89 e5 48 39 ca 74 29 48 b9 00 02 20 00 00 00
>> RIP  [<ffffffff81322e19>] __list_del_entry+0x29/0xd0
>>  RSP <ffff8800379e1dd0>
>> ---[ end trace d5931cd3f87c9763 ]---
>>
>> Fixes: 986a4f4d452d (virtio_net: multiqueue support)
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Signed-off-by: Andrey Vagin <avagin@openvz.org>
>> ---
>>  drivers/net/virtio_net.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 930039a..c293764 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -1367,6 +1367,11 @@ static void virtnet_config_changed(struct virtio_device *vdev)
>>  
>>  static void virtnet_free_queues(struct virtnet_info *vi)
>>  {
>> +	int i;
>> +
>> +	for (i = 0; i < vi->max_queue_pairs; i++)
>> +		netif_napi_del(&vi->rq[i].napi);
>> +
>>  	kfree(vi->rq);
>>  	kfree(vi->sq);
>>  }
>
> Acked-by: Jason Wang <jasowang@redhat.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Needed since v3.8.  Dave, please apply.

Cheers,
Rusty.
