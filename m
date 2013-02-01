Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3BAP7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 10:59:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab3BAP7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 10:59:19 -0500
Date: Fri, 1 Feb 2013 10:59:08 -0500
From: Don Zickus <dzickus@redhat.com>
To: Mike Lykov <combr@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, kirill@shutemov.name
Subject: Re: [BUG?] false positive in soft lockup detector while unlzma
 initramfs on slow cpu
Message-ID: <20130201155908.GR98867@redhat.com>
References: <5107D1D3.6040105@yandex.ru>
 <20130129153348.GR98867@redhat.com>
 <5108EA4B.7030003@yandex.ru>
 <20130130154033.GE98867@redhat.com>
 <510A539E.7020105@yandex.ru>
 <20130131144627.GL98867@redhat.com>
 <510B9C9B.6090605@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <510B9C9B.6090605@yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 02:44:43PM +0400, Mike Lykov wrote:
> 31.01.2013 18:46, Don Zickus пишет:
> 
> >>>I also attached another patch as suggested by Andrew to add a
> >>>touch_softlockup_watchdog in the unlzma routine.  Probably makes things
> >>>run a little slower.  Compiled tested only.
> >>
> >>In my case (3.2.32) it cannot compile:
> >>
> >>   LD      arch/x86/boot/compressed/vmlinux
> >>arch/x86/boot/compressed/misc.o: In function `decompress_kernel':
> >>misc.c:(.text+0x993): undefined reference to `touch_softlockup_watchdog'
> >
> >I think Andrew's suggestion is a better approach which is add the
> >touch_softlockup_watchdog.  So I would have to see you .config file to
> >understand the compile warning.
> 
> Attached lzma-compressed .config with this letter.
> 
> Kirill@ advices me to insert some stub to success compile:
> 
> --- arch/x86/boot/compressed/misc.c-orig 2013-01-30 15:23:41.639993355 +0400
> +++ arch/x86/boot/compressed/misc.c 2013-01-30 15:09:24.647993671 +0400
> @@ -147,6 +147,10 @@
>  #include "../../../../lib/decompress_unlzo.c"
>  #endif
> 
> +void touch_softlockup_watchdog()
> +{
> +}
> +
>  static void scroll(void)
> {
>         int i;

Hmm, that seems to make sense.  I was expecting that problem to pop up on
my end but didn't see.  I just asusmed the boot code didn't use that
decompressor.

Though I am not sure why that is leading to your other PATA problems
below.  Did you have similar problems when you used other decompression
levels?  I am not sure how to explain the differences.

Cheers,
Don
> 
> And then really compile and boot. But... another problem arises.
> On that motherboard
> (http://www.fastwel.com/products/433089/433197/433198/433223.html),
> by accident, soldered NAND-flash module and kernel pata driver don't
> recognize it (and it not needed now).
> (pata_rdc, needed to built-in IDE interface, and it works with IDE).
> 
> But it try to request it, wait for ~30sec, request again, fail, and
> go on further booting.
> Looks like:
> Apr 11 18:18:49 vep01 kernel: [ 9.515104] ata1.01: CFA: 1024MB ATA
> Flash Disk, ADBA408J, max MWDMA2
> ...
> Apr 11 18:18:50 vep01 kernel: [ 9.673242] sd 0:0:1:0: [sdb] 2001888
> 512-byte logical blocks: (1.02 GB/977 MiB)
> ...
> Apr 11 18:18:50 vep01 kernel: [ 40.058092] ata1: lost interrupt
> (Status 0x58)
> Apr 11 18:18:50 vep01 kernel: [ 40.113062] ata1.01: exception Emask
> 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> Apr 11 18:18:50 vep01 kernel: [ 40.120401] ata1.01: failed command: READ DMA
> Apr 11 18:18:50 vep01 kernel: [ 40.372722] ata1.01: device reported
> invalid CHS sector 0
> 
> And so.. if i not patch touch_softlockup_watchdog as above - it boot
> on this stage. If i patch it  (your patch + as above to compile) -
> it catch softlockup at requesting that flash and waiting (request
> flash going after usb hid load usually)
> 
> [ 42.591095] input: HID 04f3:0103 as
> /devices/pci0000:00/0000:00:0a.0/usb3/3-2/3-2:1.1/input/input2
> [ 42.601428] generic-usb 0003:04F3:0103.0002: input: USB HID v1.10
> Device [HID 04f3:0103] on usb-0000:00:0a.0-2/input1
> [ 68.064357] BUG: soft lockup - CPU#0 stuck for 22s! [swapper:0]
> [ 68.064357]
> [ 68.064357] Pid: 0, comm: swapper Not tainted
> 3.2.32VEP-01ML5-initramfs 0000020
> [ 68.064357] EIP: 0060:[<c0106009>] EFLAGS: 00000246 CPU: 0
> [ 68.064357] EIP is at default_idle+0x29/0x3e
> [ 68.064357] EAX: 00000000 EBX: c03b9118 ECX: 00000000 EDX: c0380300
> [ 68.064357] ESI: 0003e800 EDI: c037c000 EBP: c037bfc0 ESP: c037bfc0
> [ 68.064357] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [ 68.064357] Process swapper (pid: 0, ti=ce802000 task=c0380300
> task.ti=c037a000)
> [ 68.064357] Stack:
> [ 68.064357] c037bfc8 c0101413 c037bfd0 c02e385e c037bfe0 c039e67a
> c03b9118 0fff0000
> [ 68.064357] c037bff8 c039e0b0 0f0ee000 00000000 00000000 0003e800
> 00605003 00000000
> [ 68.064357] Call Trace:
> [ 68.064357] [<c0101413>] cpu_idle+0x21/0x36
> [ 68.064357] [<c02e385e>] rest_init+0x52/0x54
> [ 68.064357] [<c039e67a>] start_kernel+0x26b/0x270
> [ 68.064357] [<c039e0b0>] i386_start_kernel+0xb0/0xb7
> [ 68.064357] Code: 5d c3 83 3d 98 b6 3c c0 00 55 89 e5 75 2d 80 3d
> c5 b3 39 c0 00 74 24 89 e0 25 00 e0 ff ff 83 60 0c fb 8b 40 08 a8 08
> 75 04 fb f4 <eb> 01 fb 89 e0 25 00 e0 ff ff 83 48 0c 04 eb 03 fb f3
> 90 5d c3
> [ 68.064357] Call Trace:
> [ 68.064357] [<c0101413>] cpu_idle+0x21/0x36
> [ 68.064357] [<c02e385e>] rest_init+0x52/0x54
> [ 68.064357] [<c039e67a>] start_kernel+0x26b/0x270
> [ 68.064357] [<c039e0b0>] i386_start_kernel+0xb0/0xb7
> [ 68.064357] Kernel panic - not syncing: softlockup: hung tasks
> 
> 
> So I do not know to do with it, someone else will pay attention to it.
> 
> 
> 
> ---
> Mike
> 
> 
> 


