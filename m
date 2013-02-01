Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422928Ab3BAKwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:52:33 -0500
Received: from forward11.mail.yandex.net ([95.108.130.93]:40777 "EHLO
	forward11.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422847Ab3BAKw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:52:28 -0500
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2013 05:52:27 EST
Message-ID: <510B9C9B.6090605@yandex.ru>
Date: Fri, 01 Feb 2013 14:44:43 +0400
From: Mike Lykov <combr@yandex.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.10) Gecko/20121030 Thunderbird/10.0.10
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, kirill@shutemov.name
Subject: Re: [BUG?] false positive in soft lockup detector while unlzma initramfs
 on slow cpu
References: <5107D1D3.6040105@yandex.ru> <20130129153348.GR98867@redhat.com> <5108EA4B.7030003@yandex.ru> <20130130154033.GE98867@redhat.com> <510A539E.7020105@yandex.ru> <20130131144627.GL98867@redhat.com>
In-Reply-To: <20130131144627.GL98867@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------070603030400050006070003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070603030400050006070003
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

31.01.2013 18:46, Don Zickus пишет:

>>> I also attached another patch as suggested by Andrew to add a
>>> touch_softlockup_watchdog in the unlzma routine.  Probably makes things
>>> run a little slower.  Compiled tested only.
>>
>> In my case (3.2.32) it cannot compile:
>>
>>    LD      arch/x86/boot/compressed/vmlinux
>> arch/x86/boot/compressed/misc.o: In function `decompress_kernel':
>> misc.c:(.text+0x993): undefined reference to `touch_softlockup_watchdog'
>
> I think Andrew's suggestion is a better approach which is add the
> touch_softlockup_watchdog.  So I would have to see you .config file to
> understand the compile warning.

Attached lzma-compressed .config with this letter.

Kirill@ advices me to insert some stub to success compile:

--- arch/x86/boot/compressed/misc.c-orig 2013-01-30 15:23:41.639993355 +0400
+++ arch/x86/boot/compressed/misc.c 2013-01-30 15:09:24.647993671 +0400
@@ -147,6 +147,10 @@
  #include "../../../../lib/decompress_unlzo.c"
  #endif

+void touch_softlockup_watchdog()
+{
+}
+
  static void scroll(void)
{
         int i;

And then really compile and boot. But... another problem arises.
On that motherboard 
(http://www.fastwel.com/products/433089/433197/433198/433223.html), by 
accident, soldered NAND-flash module and kernel pata driver don't 
recognize it (and it not needed now).
(pata_rdc, needed to built-in IDE interface, and it works with IDE).

But it try to request it, wait for ~30sec, request again, fail, and go 
on further booting.
Looks like:
Apr 11 18:18:49 vep01 kernel: [ 9.515104] ata1.01: CFA: 1024MB ATA Flash 
Disk, ADBA408J, max MWDMA2
...
Apr 11 18:18:50 vep01 kernel: [ 9.673242] sd 0:0:1:0: [sdb] 2001888 
512-byte logical blocks: (1.02 GB/977 MiB)
...
Apr 11 18:18:50 vep01 kernel: [ 40.058092] ata1: lost interrupt (Status 
0x58)
Apr 11 18:18:50 vep01 kernel: [ 40.113062] ata1.01: exception Emask 0x0 
SAct 0x0 SErr 0x0 action 0x6 frozen
Apr 11 18:18:50 vep01 kernel: [ 40.120401] ata1.01: failed command: READ DMA
Apr 11 18:18:50 vep01 kernel: [ 40.372722] ata1.01: device reported 
invalid CHS sector 0

And so.. if i not patch touch_softlockup_watchdog as above - it boot on 
this stage. If i patch it  (your patch + as above to compile) - it catch 
softlockup at requesting that flash and waiting (request flash going 
after usb hid load usually)

[ 42.591095] input: HID 04f3:0103 as 
/devices/pci0000:00/0000:00:0a.0/usb3/3-2/3-2:1.1/input/input2
[ 42.601428] generic-usb 0003:04F3:0103.0002: input: USB HID v1.10 
Device [HID 04f3:0103] on usb-0000:00:0a.0-2/input1
[ 68.064357] BUG: soft lockup - CPU#0 stuck for 22s! [swapper:0]
[ 68.064357]
[ 68.064357] Pid: 0, comm: swapper Not tainted 3.2.32VEP-01ML5-initramfs 
0000020
[ 68.064357] EIP: 0060:[<c0106009>] EFLAGS: 00000246 CPU: 0
[ 68.064357] EIP is at default_idle+0x29/0x3e
[ 68.064357] EAX: 00000000 EBX: c03b9118 ECX: 00000000 EDX: c0380300
[ 68.064357] ESI: 0003e800 EDI: c037c000 EBP: c037bfc0 ESP: c037bfc0
[ 68.064357] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[ 68.064357] Process swapper (pid: 0, ti=ce802000 task=c0380300 
task.ti=c037a000)
[ 68.064357] Stack:
[ 68.064357] c037bfc8 c0101413 c037bfd0 c02e385e c037bfe0 c039e67a 
c03b9118 0fff0000
[ 68.064357] c037bff8 c039e0b0 0f0ee000 00000000 00000000 0003e800 
00605003 00000000
[ 68.064357] Call Trace:
[ 68.064357] [<c0101413>] cpu_idle+0x21/0x36
[ 68.064357] [<c02e385e>] rest_init+0x52/0x54
[ 68.064357] [<c039e67a>] start_kernel+0x26b/0x270
[ 68.064357] [<c039e0b0>] i386_start_kernel+0xb0/0xb7
[ 68.064357] Code: 5d c3 83 3d 98 b6 3c c0 00 55 89 e5 75 2d 80 3d c5 b3 
39 c0 00 74 24 89 e0 25 00 e0 ff ff 83 60 0c fb 8b 40 08 a8 08 75 04 fb 
f4 <eb> 01 fb 89 e0 25 00 e0 ff ff 83 48 0c 04 eb 03 fb f3 90 5d c3
[ 68.064357] Call Trace:
[ 68.064357] [<c0101413>] cpu_idle+0x21/0x36
[ 68.064357] [<c02e385e>] rest_init+0x52/0x54
[ 68.064357] [<c039e67a>] start_kernel+0x26b/0x270
[ 68.064357] [<c039e0b0>] i386_start_kernel+0xb0/0xb7
[ 68.064357] Kernel panic - not syncing: softlockup: hung tasks


So I do not know to do with it, someone else will pay attention to it.



---
Mike




--------------070603030400050006070003
Content-Type: application/x-lzma;
 name="config.lzma"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="config.lzma"

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
HypxKPmstT/JYuTXnoYS9l1vv//fHlGf
--------------070603030400050006070003--
