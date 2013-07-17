Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3GQLiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:38:04 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:49149
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753055Ab3GQLiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:38:02 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 19
X-BigFish: VPS19(zz4015Ic55bs853kzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h947hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh19b6n1155h192ch)
Date: Wed, 17 Jul 2013 13:37:55 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Remoteproc v3.10 arm-microblaze
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <2dca3652-e141-4f9e-934e-29b7c4334b41@CH1EHSMHS037.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

I am working on another remoteproc driver.
Currently less problematic than arm-arm.
It is arm to microblaze on zynq.

I have two problems:
1. I need to allocate carveout first because my firmware must be added to that
space first. (I don't have any other mapping mechanism ready for use)
I have simple solution I am calling rproc_handle_resources in rproc_fw_config_virtio()
just for carveouts before rproc_count_vrings_handler and rproc_vdev_handler are called
which ensure that carveout is allocated first.

2. I am getting problem with rproc_handle_vdev().
Here is the flow which I see:
request_firmware_nowait() calls
rproc_fw_config_virtio() calls
rproc_handle_vdev() calls
rproc_add_virtio_dev() calls
register_virtio_device() calls dev->config->reset() without setup pointer rproc->table_ptr().

But rproc->table_ptr is setup in rproc_fw_boot()
which is called from rproc_boot() much later.

Which is causing that all rproc_virtio_config_ops operations
are using incorrect table_ptr().
Problematic for me are rproc_virtio_get_status, rproc_virtio_set_status
and especially rproc_virtio_reset();

And with BUG_ON I am getting problem virtio_dev_remove() where status should
be zero - WARN_ON_ONCE(dev->config->get_status(dev));

Below is log with some of my debug messages. (comments explain what's going on there)

Thanks,
Michal


root@zc702_mb-2mb-works-14:/# ./mbload xil-demo.elf
NET: Registered protocol family 41
XXXXXXXXXXXXXXXXXXX 8000000 fffffff // ram - arm and microblaze addresses are the same
xgpiops_set_irq_type
edge rising
xgpiops_irq_unmask: Enable 0 irq, irq_enable_mask 0x0 // using gpio for communication
mb_remoteproc 8000000.mb_remoteproc-test: Using microblaze BRAM bootloader: mb.bin
mb_remoteproc 8000000.mb_remoteproc-test: Using firmware: xil-demo.elf
 remoteproc0: 8000000.mb_remoteproc-test is available
 remoteproc0: Note: remoteproc is still under development and considered experimental.
 remoteproc0: THE BINARY FORMAT IS NOT YET FINALIZED, and backward compatibility isn't yet guaranteed.
 remoteproc0: rsc: type 0 // carveout handling
 remoteproc0: carveout rsc: da 8000000, pa 0, len 100000, flags 0
 remoteproc0: carveout va b1000000, dma 8000000, len 0x100000
 remoteproc0: rsc: type 3
 remoteproc0: rsc: type 2
 remoteproc0: rsc: type 0
 remoteproc0: rsc: type 3
 remoteproc0: rsc: type 2
root@zc702_mb-2mb-works-14:/#  remoteproc0: rsc: type 0
 remoteproc0: rsc: type 3
 remoteproc0: vdev rsc: id 7, dfeatures 1, cfg len 0, 2 vrings
11111111111111111111 rproc_handle_vdev 0
 remoteproc0: vdev rsc: vring0: da 7900000, qsz 256, align 4096
 remoteproc0: vdev rsc: vring1: da 7904000, qsz 256, align 4096
11111111111111111111 rproc_handle_vdev --- 81cd2e00, table ac921a80, rsc_offset 80 //here is the problem - table pointer is incorrect.
000000 rproc_add_virtio_dev---- rvdev 81cd2e00, vdev 81cd2e10
11111111111111111111 rproc_virtio_reset --- 81cd2e00, table ac921a80, rsc_offset 80
virtio virtio0: UUUUUUUUUUUUUUUUUUU   rproc_virtio_reset reset ! status = 0 ac921b14
-----add_status 7f015be4/7f01688c status 1
11111111111111111111 rproc_virtio_get_status --- 81cd2e00, table ac921a80, rsc_offset 80
 XXX rproc_virtio_get_status -> status 0/ac921b14
11111111111111111111 rproc_virtio_set_status --- 81cd2e00, table ac921a80, rsc_offset 80
virtio virtio0:  XXX rproc_virtio_set_status status: 1/ac921b14
-----add_status 7f015be4/7f01688c status 2
11111111111111111111 rproc_virtio_get_status --- 81cd2e00, table ac921a80, rsc_offset 80
 XXX rproc_virtio_get_status -> status 1/ac921b14
11111111111111111111 rproc_virtio_set_status --- 81cd2e00, table ac921a80, rsc_offset 80
virtio_rpmsg_bus virtio0:  XXX rproc_virtio_set_status status: 3/ac921b14
 remoteproc0: vring0: va b1100000 dma 8100000 size 3000 idr 0
 remoteproc0: vring1: va b1104000 dma 8104000 size 3000 idr 1
 remoteproc0: powering up 8000000.mb_remoteproc-test
 remoteproc0: Booting fw image xil-demo.elf, size 262355
mb_remoteproc 8000000.mb_remoteproc-test: iommu not found
 remoteproc0: rsc: type 0
 remoteproc0: rsc: type 3
 remoteproc0: rsc: type 2
 remoteproc0: trace0 added: va b108c6e0, da 0x808c6e0, len 0x8000
mb_remoteproc 8000000.mb_remoteproc-test: mb_rproc_start
KKKKKKKKKKKKKKKKKKKKKKKKKKKKK rproc_fw_boot, b1008730
 remoteproc0: remote processor 8000000.mb_remoteproc-test is now up
virtio_rpmsg_bus virtio0: buffers: va b1140000, dma 0x8140000
mb_remoteproc 8000000.mb_remoteproc-test: KICK Firmware to start send messages vqid 0
virtio_rpmsg_bus virtio0: rpmsg host is online
-----add_status 7f015be4/7f01688c status 4
11111111111111111111 rproc_virtio_get_status --- 81cd2e00, table b1008730, rsc_offset 80 // where rproc boots table is correctly setup
 XXX rproc_virtio_get_status -> status 3/b10087c4
11111111111111111111 rproc_virtio_set_status --- 81cd2e00, table b1008730, rsc_offset 80
virtio_rpmsg_bus virtio0:  XXX rproc_virtio_set_status status: 7/b10087c4
 remoteproc0: registered virtio0 (type 7)
11111111111111111111 rproc_handle_vdev 2
 remoteproc0: rsc: type 2
mb_remoteproc 8000000.mb_remoteproc-test: KICK Linux because of pending message
mb_remoteproc 8000000.mb_remoteproc-test: KICK Linux handled
handle_event
NS announcement: 72 70 6d 73 67 2d 74 69 6d 65 72 2d 73 74 61 74  rpmsg-timer-stat
NS announcement: 69 73 74 69 63 00 00 00 00 00 00 00 00 00 00 00  istic...........
NS announcement: 51 00 00 00 00 00 00 00                          Q.......
virtio_rpmsg_bus virtio0: creating channel rpmsg-timer-statistic addr 0x51
rpmsg_freertos_statistic rpmsg0: new channel: 0x400 -> 0x51!
mb_remoteproc 8000000.mb_remoteproc-test: KICK Firmware to start send messages vqid 0


