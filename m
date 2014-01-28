Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbaA1HHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 02:07:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:21042 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbaA1HHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 02:07:52 -0500
X-IronPort-AV: E=Sophos;i="4.95,734,1384272000"; 
   d="scan'208";a="9460801"
Message-ID: <52E757DA.4050000@cn.fujitsu.com>
Date: Tue, 28 Jan 2014 15:10:18 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when seting
 kernel nodes to unhotpluggable.
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com> <alpine.DEB.2.02.1401271631090.17114@chino.kir.corp.google.com> <52E70165.8070709@cn.fujitsu.com> <20140128025537.GA21730@redhat.com> <52E722F5.9010505@cn.fujitsu.com> <20140128035518.GA25386@redhat.com> <52E7364F.5010700@cn.fujitsu.com> <20140128044749.GA27164@redhat.com> <52E740BF.4000809@cn.fujitsu.com>
In-Reply-To: <52E740BF.4000809@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/28 15:06:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/28 15:06:15,
	Serialize complete at 2014/01/28 15:06:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dave,

I think here is the overflow problem. Not the stackoverflow,
but the array index overflow.

Please have a look at the following path:

numa_init()
  |---> numa_register_memblks()
  |      |---> memblock_set_node(memory)		set correct nid in memblock.memory
  |      |---> memblock_set_node(reserved)	set correct nid in 
memblock.reserved
  |      |......
  |      |---> setup_node_data()
  |             |---> memblock_alloc_nid()	here, nid is set to 
MAX_NUMNODES (1024)
  |......
  |---> numa_clear_kernel_node_hotplug()
         |---> node_set()			here, we have an index 1024, and overflowed

For now, I think this is the first problem you mentioned.

Will send a new patch to fix it and do more tests.

Thanks.

On 01/28/2014 01:31 PM, Tang Chen wrote:
> On 01/28/2014 12:47 PM, Dave Jones wrote:
>> On Tue, Jan 28, 2014 at 12:47:11PM +0800, Tang Chen wrote:
>> > On 01/28/2014 11:55 AM, Dave Jones wrote:
>> > > On Tue, Jan 28, 2014 at 11:24:37AM +0800, Tang Chen wrote:
>> > >
>> > > > > I did a bisect with the patch above applied each step of the way.
>> > > > > This time I got a plausible looking result....
>> > > >
>> > > > I cannot reproduce this. Would you please share how to reproduce
>> it ?
>> > > > Or does it just happen during the booting ?
>> > >
>> > > Just during boot. Very early. So early in fact, I have no logging
>> facilities
>> > > like usb-serial, just what is on vga console.
>> > >
>> > > If you want me to add some printk's, I can add a while (1); before
>> > > the part that oopses so we can diagnose further..
>> >
>> > Sure. Would you please do that for me ? Maybe we can find something in
>> > the early log.
>>
>> I was hoping you'd have suggestions what you'd like me to dump ;-)
>
>
> I think I found something.
>
> Since I can reproduce the first problem on 3.10, I found some memory
> ranges in memblock
> have nid = 1024. When we use node_set(), it will crash.
>
> I'll see if we have the same problem on the latest kernel.
>
> [ 0.000000] NUMA: Initialized distance table, cnt=2
> [ 0.000000] NUMA: Warning: node ids are out of bound, from=-1 to=-1
> distance=10
> [ 0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem
> 0x100000000-0x47fffffff] -> [mem 0x00000000-0x47fffffff]
> [ 0.000000] Initmem setup node 0 [mem 0x00000000-0x47fffffff]
> [ 0.000000] NODE_DATA [mem 0x47ffd9000-0x47fffffff]
> [ 0.000000] Initmem setup node 1 [mem 0x480000000-0x87fffffff]
> [ 0.000000] NODE_DATA [mem 0x87ffbb000-0x87ffe1fff]
> [ 0.000000] AAAA: i = 0, nid = 0
> [ 0.000000] AAAA: i = 1, nid = 0
> [ 0.000000] AAAA: i = 2, nid = 0
> [ 0.000000] AAAA: i = 3, nid = 0
> [ 0.000000] AAAA: i = 4, nid = 1024
> [ 0.000000] AAAA: i = 5, nid = 1024
> [ 0.000000] AAAA: i = 6, nid = 1
> [ 0.000000] AAAA: i = 7, nid = 1
> [ 0.000000] Reserving 128MB of memory at 704MB for crashkernel (System
> RAM: 32406MB)
> [ 0.000000] [ffffea0000000000-ffffea0011ffffff] PMD ->
> [ffff880470200000-ffff88047fdfffff] on node 0
> [ 0.000000] [ffffea0012000000-ffffea0021ffffff] PMD ->
> [ffff88086f600000-ffff88087f5fffff] on node 1
> [ 0.000000] Zone ranges:
> [ 0.000000] DMA [mem 0x00001000-0x00ffffff]
> [ 0.000000] DMA32 [mem 0x01000000-0xffffffff]
> [ 0.000000] Normal [mem 0x100000000-0x87fffffff]
> [ 0.000000] Movable zone start for each node
> [ 0.000000] Early memory node ranges
> [ 0.000000] node 0: [mem 0x00001000-0x00098fff]
> [ 0.000000] node 0: [mem 0x00100000-0x696f7fff]
> [ 0.000000] node 0: [mem 0x100000000-0x47fffffff]
> [ 0.000000] node 1: [mem 0x480000000-0x87fffffff]
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>
