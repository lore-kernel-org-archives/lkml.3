Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3DWFxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 01:53:40 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58918 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab3DWFxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 01:53:39 -0400
MIME-Version: 1.0
In-Reply-To: <87mwsr9md7.fsf@rustcorp.com.au>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
	<87wqs02uws.fsf@rustcorp.com.au>
	<CAAHg+HiHKV+8hBT1QWe4hSxocCX6wpRd3bCPWB7zU8jVFmPuAA@mail.gmail.com>
	<87ehe3bbsm.fsf@rustcorp.com.au>
	<CALrVBkub+TABrrBwh4+P6S5TGL1qSmnZrd1cbGgj6JiRpY=rOA@mail.gmail.com>
	<87mwsr9md7.fsf@rustcorp.com.au>
Date: Tue, 23 Apr 2013 11:23:38 +0530
Message-ID: <CAAHg+Hg1u-md_5hSWxyVOOrg_f9=h0tO5iv2WQL-U-MyTMAV9g@mail.gmail.com>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anup Patel <anup.patel@linaro.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2013 10:45, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Anup Patel <anup.patel@linaro.org> writes:
>> On 22 April 2013 06:51, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>
>>> Pranavkumar Sawargaonkar <pranavkumar@linaro.org> writes:
>>> > On 18 April 2013 12:21, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> >>
>>> >> PranavkumarSawargaonkar <pranavkumar@linaro.org> writes:
>>> >> > From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>>> >> >
>>> >> > This patch implements early printk support for virtio-mmio console
>>> >> > devices without using any hypercalls.
>>> >>
>>> >> This makes some sense, though not sure that early console *read* makes
>>> >> much sense.  I can see the PCI version of this being useful as well.
>>> >
>>> > Read can be useful for "mach-virt" which will have only virtio console
>>> > as a console device. Then if someone wants to have UEFI or any other
>>> > boot-loader emulation, which expects user to input few things, in that
>>> > case read might become handy.
>>>
>>> But implementing virtio inside a bootloader has already been done for
>>> coreboot, for example.  A bootloader probably wants a virtio block
>>> device, so a console is trivial.
>>>
>>> A single writable field for debugging makes sense.  Anything more is far
>>> less certain.
>>
>> The early read can be handy for bootloader who don't want to implement
>> complete VirtIO programming.
>
> I've said this twice already.  This is the last time.
>
> 1) We do not add complexity unless we have to.
> 2) Making it optional does not make it significantly less complex.
> 3) Having two ways of doing the same thing is always ugly.
> 4) Having an emergency output method makes sense for several use cases,
>    an emergency input method does not.
Okay,  i will restructure my patch by keeping just output write part
and post it back.

Thanks,
Pranav

> 5) A bootloader which uses virtio to get the images to boot can
>    implement a console in less than 10 lines.
> 6) A bootloader which does not use any virtio devices but nonetheless
>    wants to obtain input can implement a simple console in well under 100
>    lines.  See below.
>
> Finally, in case you still don't understand:
>
> My task is to make this decision, and I've made it.  Arguing with me is
> only useful if you bring new facts which you can change my mind.
>
> Hope that clarifies,
> Rusty.
>
> #define VIRTIO_MMIO_GUEST_PAGE_SIZE     0x028
> #define VIRTIO_MMIO_QUEUE_SEL           0x030
> #define VIRTIO_MMIO_QUEUE_NUM_MAX       0x034
> #define VIRTIO_MMIO_QUEUE_NUM           0x038
> #define VIRTIO_MMIO_QUEUE_ALIGN         0x03c
> #define VIRTIO_MMIO_QUEUE_PFN           0x040
> #define VIRTIO_MMIO_QUEUE_NOTIFY        0x050
>
> struct vring_desc {
>         __u64 addr;
>         __u32 len;
>         __u16 flags;
>         __u16 next;
> };
>
> struct vring_used_elem {
>         __u32 id;
>         __u32 len;
> };
>
> struct vconsole_ring {
>         struct vring_desc desc[2];
>         __u16 avail_flags;
>         __u16 avail_idx;
>         __u16 available[2];
>         __u16 used_event_idx;
>         __u16 pad; /* Hit 4-byte boundary */
>
>         // A ring of used descriptor heads with free-running index.
>         __u16 used_flags;
>         __u16 used_idx;
>         struct vring_used_elem used[2];
>         __u16 avail_event_idx;
> };
>
> static char console_in;
> static struct vconsole_ring vc_ring = {
>         { { PHYSICAL_ADDR(console_in), 1, 2, 0 } },
>         1, /* No interrupts */
> }
>
> static void post_buffer(void *base)
> {
>         vc_ring->avail_idx++;
>         wmb();
>         writel(0, base + VIRTIO_MMIO_QUEUE_NOTIFY);
> }
>
> bool vc_read(void *base, char *c)
> {
>         mb();
>         if (vc_ring->used_idx != vc_ring->avail_idx)
>                 return false;
>         *c = console_in;
>         post_buffer(base);
>         return true;
> }
>
> void vc_init(void *base)
> {
>         /* Alignment of 4 bytes, don't waste any. */
>         writel(4, base + VIRTIO_MMIO_GUEST_PAGE_SIZE);
>
>         /* Setup incoming vq. */
>         writel(0, base + VIRTIO_MMIO_QUEUE_SEL);
>
>         /* 2 elements */
>         writel(2, base + VIRTIO_MMIO_QUEUE_NUM);
>         /* Alignment of 4 bytes */
>         writel(4, base + VIRTIO_MMIO_QUEUE_ALIGN);
>         /* Location of queue. */
>         writel(PHYSICAL_ADDR(&vc_ring) >> 4, base + VIRTIO_MMIO_QUEUE_PFN);
>
>         post_buffer(base);
> }
