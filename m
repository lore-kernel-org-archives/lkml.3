Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaHNIZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:25:34 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:47753 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaHNIZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:25:29 -0400
Message-ID: <53EC7273.5060303@bjorling.me>
Date: Thu, 14 Aug 2014 10:25:23 +0200
From: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Jens Axboe <axboe@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Rob Nelson <rlnelson@google.com>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v11] NVMe: Convert to blk-mq
References: <1406365643-27020-1-git-send-email-m@bjorling.me> <1406365643-27020-2-git-send-email-m@bjorling.me> <CAOu_J6mW-2e2Jgm+khodLPah_-RZrD599SmSH+Mszd0AjterrQ@mail.gmail.com> <alpine.LRH.2.03.1408131519590.14603@AMR>
In-Reply-To: <alpine.LRH.2.03.1408131519590.14603@AMR>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 12:27 AM, Keith Busch wrote:
> On Sun, 10 Aug 2014, Matias Bjørling wrote:
>> On Sat, Jul 26, 2014 at 11:07 AM, Matias Bjørling <m@bjorling.me> wrote:
>>> This converts the NVMe driver to a blk-mq request-based driver.
>>>
>>
>> Willy, do you need me to make any changes to the conversion? Can you
>> pick it up for 3.17?
>
> Hi Matias,
>

Hi Keith, Thanks for taking the time to take another look.

> I'm starting to get a little more spare time to look at this again. I
> think there are still some bugs here, or perhaps something better we
> can do. I'll just start with one snippet of the code:
>
> @@ -765,33 +619,49 @@ static int nvme_submit_bio_queue(struct nvme_queue
> *nvmeq, struct nvme_ns *ns,
>   submit_iod:
>      spin_lock_irq(&nvmeq->q_lock);
>      if (nvmeq->q_suspended) {
>          spin_unlock_irq(&nvmeq->q_lock);
>          goto finish_cmd;
>      }
>
>   <snip>
>
>   finish_cmd:
>      nvme_finish_cmd(nvmeq, req->tag, NULL);
>      nvme_free_iod(nvmeq->dev, iod);
>      return result;
> }
>
>
> If the nvme queue is marked "suspended", this code just goto's the finish
> without setting "result", so I don't think that's right.

The result is set to BLK_MQ_RQ_QUEUE_ERROR, or am I mistaken?

>
> But do we even need the "q_suspended" flag anymore? It was there because
> we couldn't prevent incoming requests as a bio based driver and we needed
> some way to mark that the h/w's IO queue was temporarily inactive, but
> blk-mq has ways to start/stop a queue at a higher level, right? If so,
> I think that's probably a better way than using this driver specific way.

Not really, its managed by the block layer. Its on purpose I haven't 
removed it. The patch is already too big, and I want to keep the patch 
free from extra noise that can be removed by later patches.

Should I remove it anyway?

>
> I haven't event tried debugging this next one: doing an insmod+rmmod
> caused this warning followed by a panic:
>

I'll look into it. Thanks

> Aug 13 15:41:41 kbgrz1 kernel: [   89.207525] ------------[ cut here
> ]------------
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207538] WARNING: CPU: 8 PID: 5768
> at mm/slab_common.c:491 kmalloc_slab+0x33/0x8b()
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207541] Modules linked in: nvme(-)
> parport_pc ppdev lp parport dlm sctp libcrc32c configfs nfsd auth_rpcgss
> oid_registry nfs_acl nfs lockd fscache sunrpc md4 hmac cifs bridge stp
> llc jfs joydev hid_generic usbhid hid loop md_mod x86_pkg_temp_thermal
> coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support microcode pcspkr
> ehci_pci ehci_hcd usbcore acpi_cpufreq lpc_ich usb_common ioatdma
> mfd_core i2c_i801 evdev wmi tpm_tis ipmi_si tpm ipmi_msghandler
> processor thermal_sys button ext4 crc16 jbd2 mbcache sg sr_mod cdrom
> sd_mod crct10dif_generic crc_t10dif crct10dif_common nbd dm_mod
> crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw
> gf128mul ablk_helper cryptd isci libsas igb ahci libahci
> scsi_transport_sas ptp pps_core libata i2c_algo_bit i2c_core scsi_mod dca
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207653] CPU: 8 PID: 5768 Comm:
> nvme1 Not tainted 3.16.0-rc6+ #24
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207656] Hardware name: Intel
> Corporation S2600GZ/S2600GZ, BIOS SE5C600.86B.02.02.0002.122320131210
> 12/23/2013
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207659]  0000000000000000
> 0000000000000009 ffffffff8139f9ba 0000000000000000
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207664]  ffffffff8103db86
> ffffe8ffff601d80 ffffffff810f0d59 0000000000000246
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207669]  0000000000000000
> ffff880827bf28c0 0000000000008020 ffff88082b8d9d00
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207674] Call Trace:
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207685]  [<ffffffff8139f9ba>] ?
> dump_stack+0x41/0x51
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207694]  [<ffffffff8103db86>] ?
> warn_slowpath_common+0x7d/0x95
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207699]  [<ffffffff810f0d59>] ?
> kmalloc_slab+0x33/0x8b
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207704]  [<ffffffff810f0d59>] ?
> kmalloc_slab+0x33/0x8b
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207710]  [<ffffffff81115329>] ?
> __kmalloc+0x28/0xf1
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207719]  [<ffffffff811d0daf>] ?
> blk_mq_tag_busy_iter+0x30/0x7c
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207728]  [<ffffffffa052c426>] ?
> nvme_init_hctx+0x49/0x49 [nvme]
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207733]  [<ffffffff811d0daf>] ?
> blk_mq_tag_busy_iter+0x30/0x7c
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207738]  [<ffffffffa052c98b>] ?
> nvme_clear_queue+0x72/0x7d [nvme]
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207744]  [<ffffffffa052c9a8>] ?
> nvme_del_queue_end+0x12/0x26 [nvme]
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207750]  [<ffffffff810576e3>] ?
> kthread_worker_fn+0xb1/0x111
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207754]  [<ffffffff81057632>] ?
> kthread_create_on_node+0x171/0x171
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207758]  [<ffffffff81057632>] ?
> kthread_create_on_node+0x171/0x171
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207762]  [<ffffffff810574b9>] ?
> kthread+0x9e/0xa6
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207766]  [<ffffffff8105741b>] ?
> __kthread_parkme+0x5c/0x5c
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207773]  [<ffffffff813a3a2c>] ?
> ret_from_fork+0x7c/0xb0
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207777]  [<ffffffff8105741b>] ?
> __kthread_parkme+0x5c/0x5c
> Aug 13 15:41:41 kbgrz1 kernel: [   89.207780] ---[ end trace
> 8dc4a4c97c467d4c ]---
> Aug 13 15:41:41 kbgrz1 kernel: [   89.223627] PGD 0 Aug 13 15:41:41
> kbgrz1 kernel: [   89.226038] Oops: 0000 [#1] SMP Aug 13 15:41:41 kbgrz1
> kernel: [   89.229917] Modules linked in: nvme(-) parport_pc ppdev lp
> parport dlm sctp libcrc32c configfs nfsd auth_rpcgss oid_registry
> nfs_acl nfs lockd fscache sunrpc md4 hmac cifs bridge stp llc jfs joydev
> hid_generic usbhid hid loop md_mod x86_pkg_temp_thermal coretemp
> kvm_intel kvm iTCO_wdt iTCO_vendor_support microcode pcspkr ehci_pci
> ehci_hcd usbcore acpi_cpufreq lpc_ich usb_common ioatdma mfd_core
> i2c_i801 evdev wmi tpm_tis ipmi_si tpm ipmi_msghandler processor
> thermal_sys button ext4 crc16 jbd2 mbcache sg sr_mod cdrom sd_mod
> crct10dif_generic crc_t10dif crct10dif_common nbd dm_mod crc32c_intel
> ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul
> ablk_helper cryptd isci libsas igb ahci libahci scsi_transport_sas ptp
> pps_core libata i2c_algo_bit i2c_core scsi_mod dca
> Aug 13 15:41:41 kbgrz1 kernel: [   89.315211] CPU: 8 PID: 5768 Comm:
> nvme1 Tainted: G        W     3.16.0-rc6+ #24
> Aug 13 15:41:41 kbgrz1 kernel: [   89.323563] Hardware name: Intel
> Corporation S2600GZ/S2600GZ, BIOS SE5C600.86B.02.02.0002.122320131210
> 12/23/2013
> Aug 13 15:41:41 kbgrz1 kernel: [   89.335121] task: ffff88042ad92d70 ti:
> ffff880425ff0000 task.ti: ffff880425ff0000
> Aug 13 15:41:41 kbgrz1 kernel: [   89.343574] RIP:
> 0010:[<ffffffff811d0d38>]  [<ffffffff811d0d38>] bt_for_each_free+0x31/0x78
> Aug 13 15:41:41 kbgrz1 kernel: [   89.353144] RSP:
> 0018:ffff880425ff3de8  EFLAGS: 00010086
> Aug 13 15:41:41 kbgrz1 kernel: [   89.359189] RAX: 0000000000000010 RBX:
> ffffffffffffffff RCX: 0000000000000007
> Aug 13 15:41:41 kbgrz1 kernel: [   89.367276] RDX: 0000000000000000 RSI:
> 0000000000000010 RDI: ffff880827bf2850
> Aug 13 15:41:41 kbgrz1 kernel: [   89.375362] RBP: 0000000000000000 R08:
> 000000000000000f R09: 00000000fffffffe
> Aug 13 15:41:41 kbgrz1 kernel: [   89.383448] R10: 0000000000000000 R11:
> 0000000000000046 R12: ffff880827bf2850
> Aug 13 15:41:41 kbgrz1 kernel: [   89.391534] R13: 00000000ffffffff R14:
> 0000000000000010 R15: 0000000000000001
> Aug 13 15:41:41 kbgrz1 kernel: [   89.399622] FS:
> 0000000000000000(0000) GS:ffff88083f200000(0000) knlGS:0000000000000000
> Aug 13 15:41:41 kbgrz1 kernel: [   89.408805] CS:  0010 DS: 0000 ES:
> 0000 CR0: 0000000080050033
> Aug 13 15:41:41 kbgrz1 kernel: [   89.415340] CR2: 0000000000000007 CR3:
> 0000000001610000 CR4: 00000000000407e0
> Aug 13 15:41:41 kbgrz1 kernel: [   89.423426] Stack:
> Aug 13 15:41:41 kbgrz1 kernel: [   89.425775]  0000000000000007
> 0000000000000010 ffff880827bf2840 ffffffffa052c426
> Aug 13 15:41:41 kbgrz1 kernel: [   89.434515]  ffff88082b8d9f00
> ffff88042ad92d70 0000000000000000 ffffffff811d0dc6
> Aug 13 15:41:41 kbgrz1 kernel: [   89.443254]  00000000fffffffe
> ffff88082b8d9f00 ffff88082b8d9f28 ffff88042ad92d70
> Aug 13 15:41:41 kbgrz1 kernel: [   89.452012] Call Trace:
> Aug 13 15:41:41 kbgrz1 kernel: [   89.454852]  [<ffffffffa052c426>] ?
> nvme_init_hctx+0x49/0x49 [nvme]
> Aug 13 15:41:41 kbgrz1 kernel: [   89.461968]  [<ffffffff811d0dc6>] ?
> blk_mq_tag_busy_iter+0x47/0x7c
> Aug 13 15:41:41 kbgrz1 kernel: [   89.468987]  [<ffffffffa052c98b>] ?
> nvme_clear_queue+0x72/0x7d [nvme]
> Aug 13 15:41:41 kbgrz1 kernel: [   89.476298]  [<ffffffffa052c9a8>] ?
> nvme_del_queue_end+0x12/0x26 [nvme]
> Aug 13 15:41:41 kbgrz1 kernel: [   89.483801]  [<ffffffff810576e3>] ?
> kthread_worker_fn+0xb1/0x111
> Aug 13 15:41:41 kbgrz1 kernel: [   89.490625]  [<ffffffff81057632>] ?
> kthread_create_on_node+0x171/0x171
> Aug 13 15:41:41 kbgrz1 kernel: [   89.498038]  [<ffffffff81057632>] ?
> kthread_create_on_node+0x171/0x171
> Aug 13 15:41:41 kbgrz1 kernel: [   89.505446]  [<ffffffff810574b9>] ?
> kthread+0x9e/0xa6
> Aug 13 15:41:41 kbgrz1 kernel: [   89.511200]  [<ffffffff8105741b>] ?
> __kthread_parkme+0x5c/0x5c
> Aug 13 15:41:41 kbgrz1 kernel: [   89.517833]  [<ffffffff813a3a2c>] ?
> ret_from_fork+0x7c/0xb0
> Aug 13 15:41:41 kbgrz1 kernel: [   89.524170]  [<ffffffff8105741b>] ?
> __kthread_parkme+0x5c/0x5c
> Aug 13 15:41:41 kbgrz1 kernel: [   89.530799] Code: 57 41 bf 01 00 00 00
> 41 56 49 89 f6 41 55 41 89 d5 41 54 49 89 fc 55 31 ed 53 51 eb 42 48 63
> dd 31 d2 48 c1 e3 06 49 03 5c 24 10 <48> 8b 73 08 48 63 d2 48 89 df e8
> e2 28 02 00 48 63 c8 48 3b 4b Aug 13 15:41:41 kbgrz1 kernel: [
> 89.564696]  RSP <ffff880425ff3de8>
> Aug 13 15:41:41 kbgrz1 kernel: [   89.568699] CR2: 0000000000000007
> Aug 13 15:41:41 kbgrz1 kernel: [   89.572518] ---[ end trace
> 8dc4a4c97c467d4d ]---
