Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab3EGCNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:13:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20481 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757833Ab3EGCNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:13:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201685"
Message-ID: <51886409.9030203@cn.fujitsu.com>
Date: Tue, 07 May 2013 10:16:41 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
CC: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org, laijs@cn.fujitsu.com,
        davem@davemloft.net, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 10/13] x86, acpi, numa, mem-hotplug: Introduce MEMBLK_HOTPLUGGABLE
 to mark and reserve hotpluggable memory.
References: <1367313683-10267-1-git-send-email-tangchen@cn.fujitsu.com> <1367313683-10267-11-git-send-email-tangchen@cn.fujitsu.com> <20130503105037.GA4533@dhcp-192-168-178-175.profitbricks.localdomain> <51871520.6020703@cn.fujitsu.com> <20130506103743.GA4929@dhcp-192-168-178-175.profitbricks.localdomain>
In-Reply-To: <20130506103743.GA4929@dhcp-192-168-178-175.profitbricks.localdomain>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:12:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:12:58,
	Serialize complete at 2013/05/07 10:12:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasilis,

On 05/06/2013 06:37 PM, Vasilis Liaskovitis wrote:
>
> you can use qemu-kvm and seabios from these branches:
> https://github.com/vliaskov/qemu-kvm/commits/memhp-v4
> https://github.com/vliaskov/seabios/commits/memhp-v4
>
> Instructions on how to use the DIMM/memory hotplug are here:
>
> http://lists.gnu.org/archive/html/qemu-devel/2012-12/msg02693.html
> (these patchsets are not in mainline qemu/qemu-kvm and seabios)
>
> e.g. the following creates a VM with 2G initial memory on 2 nodes (1GB on each).
> There is also an extra 1GB DIMM on each node (the last 3 lines below describe
> this):
>
> /opt/qemu/bin/qemu-system-x86_64 -bios /opt/devel/seabios-upstream/out/bios.bin \
> -enable-kvm -M pc -smp 4,maxcpus=8 -cpu host -m 2G  \
> -drive
> file=/opt/images/debian.img,if=none,id=drive-virtio-disk0,format=raw,cache=none \
> -device virtio-blk-pci,bus=pci.0,drive=drive-virtio-disk0,id=virtio-disk0,bootindex=1 \
> -netdev type=tap,id=guest0,vhost=on -device virtio-net-pci,netdev=guest0 -vga \
> std -monitor stdio \
> -numa node,mem=1G,cpus=2,nodeid=0 -numa node,mem=0,cpus=2,nodeid=1 \
> -device dimm,id=dimm0,size=1G,node=0,bus=membus.0,populated=off \
> -device dimm,id=dimm1,size=1G,node=1,bus=membus.0,populated=off
>
> After startup I hotplug the dimm0 on node0 (or dimm1 on node1, same result)
> (qemu) device_add dimm,id=dimm0,size=1G,node=0,bus=membus.0
>
> than i reboot VM. Kernel works without "movablecore=acpi" but panics with this
> option.
>
> Note this qemu/seabios does not model initial memory (-m 2G) as memory devices.
> Only extra dimms ("device -dimm") are modeled as separate memory devices.
>

OK, I'll try it. Thank you for telling me this.:)

>>
>> Now in kernel, we can recognize a node (by PXM in SRAT), but we cannot
>> recognize a memory device. Are you saying if we have this
>> entry-granularity,
>> we can hotplug a single memory device in a node ? (Perhaps there are more
>> than on memory device in a node.)
>
> yes, this is what I mean. Multiple memory devices on one node is possible in
> both a real machine and a VM.
> In the VM case, seabios can present different DIMM devices for any number of
> nodes. Each DIMM is also given a separate SRAT entry by seabios. So when the
> kernel initially parses the entries, it sees multiple ones for the same node.
> (these are merged together in numa_cleanup_meminfo though)
>
>>
>> If so, it makes sense. But I don't the kernel is able to recognize which
>> device a memory range belongs to now. And I'm not sure if we can do this.
>
> kernel knows which memory ranges belong to each DIMM (with ACPI enabled, each
> DIMM is represented by an acpi memory device, see drivers/acpi/acpi_memhotplug.c)
>

Oh, I'll check acpi_memhotplug.c and see what we can do.

And BTW, as Yinghai suggested, we'd better put pagetable in local node. 
But the best
way is to put pagetable in the local memory device, I think. Otherwise, 
we are not
able to hot-remove a memory device.

Thanks. :)




