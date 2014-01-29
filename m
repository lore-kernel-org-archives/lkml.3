Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaA2JNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:13:08 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:44353 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaA2JNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:13:04 -0500
MIME-Version: 1.0
In-Reply-To: <20140127173149.GA8099@stfomichev-desktop>
References: <20140127173149.GA8099@stfomichev-desktop>
Date: Wed, 29 Jan 2014 01:13:03 -0800
Message-ID: <CAPcyv4gNdKqRYGfjNY0GyOysN-3WrTVRGbo-+6Jdb2ukFGPX9w@mail.gmail.com>
Subject: Re: [REGRESSION][BISECTED] 3.10.26: net_dma: mark broken (b69ec589136c)
From: Dan Williams <dan.j.williams@intel.com>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        David Whipple <whipple@securedatainnovations.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7b6dce841bacf604f118590e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6dce841bacf604f118590e
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jan 27, 2014 at 9:31 AM, Stanislav Fomichev
<stfomichev@yandex-team.ru> wrote:
> For Xeon machines in config we have:
> CONFIG_NET_DMA=y
> # CONFIG_ASYNC_TX_DMA is not set
> # CONFIG_DMATEST is not set
> CONFIG_DCA=m
>
> "net_dma: mark broken" changed it to (no CONFIG_NET_DMA):
> # CONFIG_ASYNC_TX_DMA is not set
> # CONFIG_DMATEST is not set
> CONFIG_DMA_ENGINE_RAID=y
> CONFIG_DCA=m
>
> Since this commit, we started to observe that after machine reboots there
> is some change (1 out of 10) that ksoftirqd/0 will eat 100% CPU#0.
> In this case I see huge number of tasklets executed on CPU#0 (about a million
> each second).
>
> To reproduce I just reboot machine and check ksoftirqd/0 CPU usage, if it's <5%,
> reboot machine again.
>
> I added trace_printk into tasklet_action and I see the same tasklet
> "executed" (it's disabled) over and over:
>      ksoftirqd/0-3     [000] ..s.    65.281375: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281376: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281376: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281376: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281377: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281377: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281377: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281378: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281378: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281378: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281379: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281379: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281379: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>
> Then I added more printk's and got the following (correct) trace for the case
> when ksoftirqd/0 doesn't consume 100% CPU:
>         modprobe-650   [005] ....     9.553511: ioat_init_channel: tasklet_init(ffff880c13d72500)
>      migration/3-71    [003] d...     9.554049: complete: x=ffff88061a6f9df0 ret=cpu_stop_signal_done
>     migration/15-132   [015] d...     9.554790: complete: x=ffff880c15fe3df0 ret=cpu_stop_signal_done
>         modprobe-650   [005] ..s.     9.556690: ioat_dma_self_test: init_completion(ffff88061c2bfa18) ret=ioat3_dma_self_test [ioatdma]
>         modprobe-650   [005] ....     9.556693: ioat_dma_self_test: wait_for_completion(ffff88061c2bfa18, 750)
>            mount-620   [000] d.h.     9.556694: ioat_dma_do_interrupt_msix: tasklet_schedule(ffff880c13d72500)
>            mount-620   [000] d.h.     9.556695: __tasklet_schedule: t=ffff880c13d72500 ret=ioat_dma_do_interrupt_msix [ioatdma]
>            mount-620   [000] ..s.     9.556696: tasklet_action: t=ffff880627c03e98 func=ioat3_cleanup_event [ioatdma] count=0
>            mount-620   [000] ..s.     9.556699: ioat_dma_test_callback: complete(ffff88061c2bfa18) ret=__cleanup [ioatdma]
>            mount-620   [000] d.s.     9.556700: complete: x=ffff88061c2bfa18 ret=ioat_dma_test_callback [ioatdma]
>            mount-620   [000] d.H.     9.556704: ioat_dma_do_interrupt_msix: tasklet_schedule(ffff880c13d72500)
>            mount-620   [000] d.H.     9.556705: __tasklet_schedule: t=ffff880c13d72500 ret=ioat_dma_do_interrupt_msix [ioatdma]
>            mount-620   [000] ..s.     9.556705: tasklet_action: t=ffff880627c03e98 func=ioat3_cleanup_event [ioatdma] count=0
>     migration/10-107   [010] d...     9.558487: complete: x=ffff880c15f4fdf0 ret=cpu_stop_signal_done
>         modprobe-650   [011] ....     9.560545: ioat_dma_self_test: wait_for_completion returned tmo=750
>
> And really weird trace when ksoftirqd/0 consumes 100% CPU:
>         modprobe-689   [014] ....     9.490260: ioat_init_channel: tasklet_init(ffff880c13c8b568)
>      migration/3-71    [003] d...     9.491727: complete: x=ffff88061a761df0 ret=cpu_stop_signal_done
>     migration/13-122   [013] d...     9.492212: complete: x=ffff880c15567df0 ret=cpu_stop_signal_done
>      migration/3-71    [003] d...     9.493098: complete: x=ffff880c15565df0 ret=cpu_stop_signal_done
>         modprobe-689   [014] ..s.     9.493655: ioat_dma_self_test: init_completion(ffff88061a503a18) ret=ioat3_dma_self_test [ioatdma]
>         modprobe-689   [014] ....     9.493657: ioat_dma_self_test: wait_for_completion(ffff88061a503a18, 750)
>         modprobe-689   [014] ....     9.494250: ioat_dma_self_test: wait_for_completion returned tmo=750
>         kthreadd-736   [002] d...     9.496220: complete: x=ffff880c143cfbe0 ret=kthread
>      migration/2-66    [002] d...     9.499974: complete: x=ffff880619c59df0 ret=cpu_stop_signal_done
>     migration/11-112   [011] d...     9.500705: complete: x=ffff880c15589df0 ret=cpu_stop_signal_done
>      migration/1-61    [001] d...     9.501807: complete: x=ffff88061a48ddf0 ret=cpu_stop_signal_done
>         modprobe-689   [014] ....     9.506554: ioat_init_channel: tasklet_init(ffff880c1363e358)
>      migration/3-71    [003] d...     9.506737: complete: x=ffff88061a7b1df0 ret=cpu_stop_signal_done
>     migration/13-122   [013] d...     9.508612: complete: x=ffff880c1570fdf0 ret=cpu_stop_signal_done
>         modprobe-689   [014] ..s.     9.508988: ioat_dma_self_test: init_completion(ffff88061a503a18) ret=ioat3_dma_self_test [ioatdma]
>         modprobe-689   [014] ....     9.508990: ioat_dma_self_test: wait_for_completion(ffff88061a503a18, 750)
>     migration/11-112   [011] d...     9.509157: complete: x=ffff88061a76ddf0 ret=cpu_stop_signal_done
>     migration/11-112   [011] d...     9.509998: complete: x=ffff880c14385df0 ret=cpu_stop_signal_done
>      migration/4-76    [004] d...     9.512649: complete: x=ffff880c155b1df0 ret=cpu_stop_signal_done
>     migration/10-107   [010] d...     9.513768: complete: x=ffff88061a773df0 ret=cpu_stop_signal_done
>      migration/8-97    [008] d...     9.515415: complete: x=ffff880c155b3df0 ret=cpu_stop_signal_done
>      migration/6-87    [006] d...     9.515475: complete: x=ffff880c155a5df0 ret=cpu_stop_signal_done
>     migration/11-112   [011] d...     9.515650: complete: x=ffff880c155a7df0 ret=cpu_stop_signal_done
>      migration/4-76    [004] d...     9.516355: complete: x=ffff880619c5bdf0 ret=cpu_stop_signal_done
>      migration/4-76    [004] d...     9.516492: complete: x=ffff880619c4bdf0 ret=cpu_stop_signal_done
>      migration/4-76    [004] d...     9.516882: complete: x=ffff880c1576ddf0 ret=cpu_stop_signal_done
>      migration/3-71    [003] d...     9.518353: complete: x=ffff880c15763df0 ret=cpu_stop_signal_done
>     migration/14-127   [014] d...     9.518737: complete: x=ffff880c15785df0 ret=cpu_stop_signal_done
>      migration/3-71    [003] d...     9.518947: complete: x=ffff880c15761df0 ret=cpu_stop_signal_done
>      migration/8-97    [008] d...     9.519121: complete: x=ffff88061ab03df0 ret=cpu_stop_signal_done
>      migration/8-97    [008] d...     9.519492: complete: x=ffff880c15b15df0 ret=cpu_stop_signal_done
>      migration/1-61    [001] d...     9.523569: complete: x=ffff880c15b2fdf0 ret=cpu_stop_signal_done
>      migration/3-71    [003] d...     9.524123: complete: x=ffff880619fc9df0 ret=cpu_stop_signal_done
>         modprobe-689   [008] ..s.     9.524370: ioat_dma_self_test: init_completion(ffff88061a503a18) ret=ioat3_dma_self_test [ioatdma]
>         modprobe-689   [008] ....     9.524372: ioat_dma_self_test: wait_for_completion(ffff88061a503a18, 750)
>      migration/1-61    [001] d...     9.524835: complete: x=ffff880c13e51df0 ret=cpu_stop_signal_done
>     ksoftirqd/14-128   [014] d.s.     9.525102: complete: x=ffff88061a7b1b20 ret=blk_end_sync_rq
>      ksoftirqd/3-72    [003] d.s.     9.526560: complete: x=ffff880c155b1b20 ret=blk_end_sync_rq
>      migration/9-102   [009] d...     9.526669: complete: x=ffff880c157e7df0 ret=cpu_stop_signal_done
>         kthreadd-768   [003] d...     9.526770: complete: x=ffff88061dbcfd00 ret=kthread
>         kthreadd-769   [012] d...     9.526833: complete: x=ffff88061dd29d00 ret=kthread
>      ksoftirqd/7-93    [007] d.s.     9.527077: complete: x=ffff880c1570fb20 ret=blk_end_sync_rq
>         kthreadd-771   [007] d...     9.527799: complete: x=ffff880c17403d00 ret=kthread
>      migration/7-92    [007] d...     9.527916: complete: x=ffff880c13e47df0 ret=cpu_stop_signal_done
>         modprobe-689   [003] ....     9.527917: ioat_dma_self_test: wait_for_completion returned tmo=750
>
> .. later
>
>      ksoftirqd/0-3     [000] ..s.    65.281375: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281376: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ksoftirqd/0-3     [000] ..s.    65.281376: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
>      ... and forever
>
> So nobody is completing the work (but wait_for_completion_timeout returns
> without a timeout) and nobody schedules tasklet, but it somehow ends up
> in the CPU#0 tasklet vector (disabled).
> Any ideas what could be wrong and how I can further debug it?
>
> If I put something like udelay(1000) in ioat_dma_self_test before
> wait_for_completion_timeout I never see this issue.
>
> Probably because we had NET_DMA=y, our NIC driver used DMA and somehow
> masked the issue prior to this 'bad' commit.
>
> This behavior also occurs on 3.13, I assume the reason is the same.
>
> Here is where I placed trace_printk, just in case:

I wonder if we are simply racing the initialization of the completion
vs when it is triggered by dma.  I also think we need to be waiting
for in-flight tasklet runs when stopping the channel.

Does the attached patch modulate the failure?

--047d7b6dce841bacf604f118590e
Content-Type: application/octet-stream; name=ioat-dbg
Content-Disposition: attachment; filename=ioat-dbg
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hr0dm47v0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZG1hL2lvYXQvZG1hLmMgYi9kcml2ZXJzL2RtYS9pb2F0L2Rt
YS5jCmluZGV4IDg3NTI5MTgxZWZjYy4uNDc1ODM3NDAwODk3IDEwMDY0NAotLS0gYS9kcml2ZXJz
L2RtYS9pb2F0L2RtYS5jCisrKyBiL2RyaXZlcnMvZG1hL2lvYXQvZG1hLmMKQEAgLTM3OSw3ICsz
NzksNyBAQCBzdGF0aWMgdm9pZCBpb2F0MV9kbWFfZnJlZV9jaGFuX3Jlc291cmNlcyhzdHJ1Y3Qg
ZG1hX2NoYW4gKmMpCiAJaWYgKGlvYXQtPmRlc2Njb3VudCA9PSAwKQogCQlyZXR1cm47CiAKLQl0
YXNrbGV0X2Rpc2FibGUoJmNoYW4tPmNsZWFudXBfdGFzayk7CisJdGFza2xldF9raWxsKCZjaGFu
LT5jbGVhbnVwX3Rhc2spOwogCWRlbF90aW1lcl9zeW5jKCZjaGFuLT50aW1lcik7CiAJaW9hdDFf
Y2xlYW51cChpb2F0KTsKIApAQCAtNzkwLDcgKzc5MCw3IEBAIGludCBpb2F0X2RtYV9zZWxmX3Rl
c3Qoc3RydWN0IGlvYXRkbWFfZGV2aWNlICpkZXZpY2UpCiAJZG1hX2FkZHJfdCBkbWFfZGVzdCwg
ZG1hX3NyYzsKIAlkbWFfY29va2llX3QgY29va2llOwogCWludCBlcnIgPSAwOwotCXN0cnVjdCBj
b21wbGV0aW9uIGNtcDsKKwlERUNMQVJFX0NPTVBMRVRJT05fT05TVEFDSyhjbXApOwogCXVuc2ln
bmVkIGxvbmcgdG1vOwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAKQEAgLTgzNiw3ICs4MzYsNiBA
QCBpbnQgaW9hdF9kbWFfc2VsZl90ZXN0KHN0cnVjdCBpb2F0ZG1hX2RldmljZSAqZGV2aWNlKQog
CX0KIAogCWFzeW5jX3R4X2Fjayh0eCk7Ci0JaW5pdF9jb21wbGV0aW9uKCZjbXApOwogCXR4LT5j
YWxsYmFjayA9IGlvYXRfZG1hX3Rlc3RfY2FsbGJhY2s7CiAJdHgtPmNhbGxiYWNrX3BhcmFtID0g
JmNtcDsKIAljb29raWUgPSB0eC0+dHhfc3VibWl0KHR4KTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
ZG1hL2lvYXQvZG1hX3YyLmMgYi9kcml2ZXJzL2RtYS9pb2F0L2RtYV92Mi5jCmluZGV4IDVkM2Fm
ZmU3ZTk3Ni4uZjlkN2E0NDg4M2UyIDEwMDY0NAotLS0gYS9kcml2ZXJzL2RtYS9pb2F0L2RtYV92
Mi5jCisrKyBiL2RyaXZlcnMvZG1hL2lvYXQvZG1hX3YyLmMKQEAgLTgwOSw3ICs4MDksNyBAQCB2
b2lkIGlvYXQyX2ZyZWVfY2hhbl9yZXNvdXJjZXMoc3RydWN0IGRtYV9jaGFuICpjKQogCWlmICgh
aW9hdC0+cmluZykKIAkJcmV0dXJuOwogCi0JdGFza2xldF9kaXNhYmxlKCZjaGFuLT5jbGVhbnVw
X3Rhc2spOworCXRhc2tsZXRfa2lsbCgmY2hhbi0+Y2xlYW51cF90YXNrKTsKIAlkZWxfdGltZXJf
c3luYygmY2hhbi0+dGltZXIpOwogCWRldmljZS0+Y2xlYW51cF9mbigodW5zaWduZWQgbG9uZykg
Yyk7CiAJZGV2aWNlLT5yZXNldF9odyhjaGFuKTsK
--047d7b6dce841bacf604f118590e--
