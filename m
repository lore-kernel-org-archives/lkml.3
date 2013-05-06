Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3EFJkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:40:32 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58815 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3EFJka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:40:30 -0400
MIME-Version: 1.0
In-Reply-To: <87ip2wr8tp.fsf@rustcorp.com.au>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org>
	<BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de>
	<87obcyc9sh.fsf@rustcorp.com.au>
	<336C59AA-D5D7-472E-A8DA-EEB413DD6C68@suse.de>
	<CAAHg+Hj0tySbzUGnoFE9ybVYP291B-i8-Ck1EkwD57t8yG5wwg@mail.gmail.com>
	<C52CCDD4-D8FB-4AD6-B83D-3B5251A7A0F5@suse.de>
	<87sj27xxjr.fsf@rustcorp.com.au>
	<CAFEAcA9h8iSYfTBtf6n+Vk5sDtBR2yB2oafRxikHoWbKt0VRUw@mail.gmail.com>
	<87ip2wr8tp.fsf@rustcorp.com.au>
Date: Mon, 6 May 2013 15:10:29 +0530
Message-ID: <CAAHg+HhAgD=-YVOf_nmXv0MnX-3pp+yhNAwxXAfKr4Xp5XyP4w@mail.gmail.com>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Maydell <peter.maydell@linaro.org>, Alexander Graf <agraf@suse.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Amit Shah <amit.shah@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On 6 May 2013 10:41, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Peter Maydell <peter.maydell@linaro.org> writes:
>> On 1 May 2013 03:07, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> An emergency output is a reasonable idea, and this is a reasonable
>>> implementation.  The question is practical: will it be used?  Because we
>>> don't implement reasonable ideas which aren't going to be used.
>>
>> If you think it fits reasonably into the virtio spec (ie doesn't
>> implement things at the wrong level of the transport/backend
>> abstraction) then we can implement it in QEMU, and I think it
>> makes more sense to do this than to throw in a random extra
>> serial port.
>>
>> To be actually useful we need to also specify something in
>> the device tree to say "here is where you will find your
>> emergency output and what it is".
>
> Hmm, I'm not sure that's true.  It looks like it needs:
>
> 1) An enhancment to the vdev->set_config callback to pass through (at
>    least) an offset, probably offset and length.
>
> 2) An emerg_write() function ptr which can be called at any time, set by
>    virtio_console.c's class_init:
>
> static void emerg_write(VirtIOSerialPort *port, char c)
> {
>     VirtConsole *vcon = DO_UPCAST(VirtConsole, port, port);
>
>     if (vcon->chr)
>         qemu_chr_fe_write(vcon->chr, &c, 1);
> }
>
> 3) A routine to find an emerg-write-capable console in
>    virtio_serial_bus.c (or just assume port 0?):
>
> static VirtIOSerialPort *find_emerg_write_port(VirtIOSerial *vser)
> {
>     VirtIOSerialPort *port;
>
>     QTAILQ_FOREACH(port, &vser->ports, next) {
>         VirtIOSerialPortClass *vsc;
>         vsc = VIRTIO_SERIAL_PORT_GET_CLASS(port);
>
>         if (vsc->emerg_write) {
>             return port;
>         }
>     }
>     return NULL;
> }
>
> 4) set_config in virtio_serial_bus.c to notice emergency writes:
>
>     if (offset == offsetof(struct virtio_console_config, emerg_w) {
>         VirtIOSerial *vser;
>         vser = DO_UPCAST(VirtIOSerial, vdev, vdev);
>         VirtIOSerialPort *port;
>
>         port = find_emerg_write_port(vser);
>         if (port) {
>             vsc->emerg_write(port, config.emerg_w);
>         }
>     }
>
> Amit might have more clue... Amit?
>
> Thanks,
> Rusty.
>
> From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
> Subject: virtio: console: Add early writeonly register to config space
>
> This patch adds a emerg_wr register (writeonly) in config space of virtio console device which can be used for debugging.
>
> Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
> Signed-off-by: Anup Patel <anup.patel@linaro.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  include/uapi/linux/virtio_console.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/include/uapi/linux/virtio_console.h b/include/uapi/linux/virtio_console.h
> index ee13ab6..586678d 100644
> --- a/include/uapi/linux/virtio_console.h
> +++ b/include/uapi/linux/virtio_console.h
> @@ -38,6 +38,7 @@
>  /* Feature bits */
>  #define VIRTIO_CONSOLE_F_SIZE  0       /* Does host provide console size? */
>  #define VIRTIO_CONSOLE_F_MULTIPORT 1   /* Does host provide multiple ports? */
> +#define VIRTIO_CONSOLE_F_EMERG_WRITE 2 /* Does host support emergency write? */
>
>  #define VIRTIO_CONSOLE_BAD_ID          (~(u32)0)
>
> @@ -48,6 +49,8 @@ struct virtio_console_config {
>         __u16 rows;
>         /* max. number of ports this device can hold */
>         __u32 max_nr_ports;
> +       /* emergency write register */
> +       __u32 emerg_wr;
>  } __attribute__((packed));
>
>  /*

I will send above patch with V2 tagged with the addition of
documentation change and also separate arm64 early printk
implementation for the same.

Thanks,
Pranav
