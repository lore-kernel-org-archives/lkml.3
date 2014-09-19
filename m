Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbaISTUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:20:54 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:50754 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbaISTUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:20:52 -0400
Message-ID: <541C826D.7060702@googlemail.com>
Date: Fri, 19 Sep 2014 21:22:21 +0200
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>, luca@ventoso.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, crope@iki.fi
Subject: [media/dvb_usb_af9005] BUG: unable to handle kernel paging request
 (WAS: [media/em28xx] BUG: unable to handle kernel)
References: <20140919014124.GA8326@localhost> <541C7D9D.30908@googlemail.com>
In-Reply-To: <541C7D9D.30908@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adjusting the title and adding Luca Olivetti (dvb_usb_af9005 author)
and Antti Palosaari)


Am 19.09.2014 um 21:01 schrieb Frank Schäfer:
> Hi Fengguang,
>
> thank you for reporting this issue.
>
> Am 19.09.2014 um 03:41 schrieb Fengguang Wu:
[...]
>> [    8.528015] usbcore: registered new interface driver dvb_usb_ttusb2
>> [    8.529751] usbcore: registered new interface driver dvb_usb_af9005
>> [    8.529751] usbcore: registered new interface driver dvb_usb_af9005
>> [    8.531584] BUG: unable to handle kernel 
>> [    8.531584] BUG: unable to handle kernel paging requestpaging request at 02e00000
>>  at 02e00000
>> [    8.533385] IP:
>> [    8.533385] IP: [<7d9d67c6>] af9005_usb_module_init+0x6b/0x9d
>>  [<7d9d67c6>] af9005_usb_module_init+0x6b/0x9d
> And this tells us what is going wrong:
>
> (gdb) list *(af9005_usb_module_init+0x83)
> 0x2d11 is in af9005_usb_module_init
> (drivers/media/usb/dvb-usb/af9005.c:1092).
> 1087            if (rc_decode == NULL || rc_keys == NULL || rc_keys_size
> == NULL) {
> 1088                    err("af9005_rc_decode function not found,
> disabling remote");
> 1089                    af9005_properties.rc.legacy.rc_query = NULL;
> 1090            } else {
> 1091                    af9005_properties.rc.legacy.rc_map_table = rc_keys;
> 1092                    af9005_properties.rc.legacy.rc_map_size =
> *rc_keys_size;
> 1093            }
> 1094
> 1095            return 0;
> 1096    }
>
> So it happens in line 1092 when rc_keys_size is accessed.
>
> According to your kernel config you have
>
> CONFIG_MODULES disabled
> CONFIG_DVB_USB_AF9005 enabled
> CONFIG_DVB_USB_AF9005_REMOTE  disabled
>
> So af9005 is compiled in without remote control support.
> Thus we should have hit the "if"-path, which also prints a message about
> the missing remote control support.
>
> Instead, we have hit the "else" path, which means that rc_decode,
> rc_keys and rc_keys_size are all != NULL, although they should be NULL.
>
> You can verify this by enabling CONFIG_DVB_USB_AF9005_REMOTE.
> That makes the issue disappear.
>
> Now let's go a few lines up to see where these pointers come from:
>
> 1084           rc_decode = symbol_request(af9005_rc_decode);
> 1085           rc_keys = symbol_request(rc_map_af9005_table);
> 1086           rc_keys_size = symbol_request(rc_map_af9005_table_size);
>
> So symbol_request() returns pointers.!= NULL
>
> A closer look at the definition of symbol_request() shows, that it does
> nothing if CONFIG_MODULES is disabled (it just returns its argument).
>
>
> One possibility to fix this bug would be to embrace these three lines with
>
> #ifdef CONFIG_DVB_USB_AF9005_REMOTE
> ...
> #endif
Luca, what do you think ?

This seems to be an ancient bug, which is known at least since 5 1/2 years:
https://lkml.org/lkml/2009/2/4/350

Regards,
Frank Schäfer

>
>> [    8.535613] *pde = 00000000 
>> [    8.535613] *pde = 00000000 
>>
>> [    8.536416] Oops: 0000 [#1] 
>> [    8.536416] Oops: 0000 [#1] PREEMPT PREEMPT DEBUG_PAGEALLOCDEBUG_PAGEALLOC
>>
>> [    8.537863] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc6-00151-ga5c075c #1
>> [    8.537863] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc6-00151-ga5c075c #1
>> [    8.539827] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
>> [    8.539827] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
>> [    8.541519] task: 89c9a670 ti: 89c9c000 task.ti: 89c9c000
>> [    8.541519] task: 89c9a670 ti: 89c9c000 task.ti: 89c9c000
>> [    8.541519] EIP: 0060:[<7d9d67c6>] EFLAGS: 00010206 CPU: 0
>> [    8.541519] EIP: 0060:[<7d9d67c6>] EFLAGS: 00010206 CPU: 0
>> [    8.541519] EIP is at af9005_usb_module_init+0x6b/0x9d
>> [    8.541519] EIP is at af9005_usb_module_init+0x6b/0x9d
>> [    8.541519] EAX: 02e00000 EBX: 00000000 ECX: 00000006 EDX: 00000000
>> [    8.541519] EAX: 02e00000 EBX: 00000000 ECX: 00000006 EDX: 00000000
>> [    8.541519] ESI: 00000000 EDI: 7da33ec8 EBP: 89c9df30 ESP: 89c9df2c
>> [    8.541519] ESI: 00000000 EDI: 7da33ec8 EBP: 89c9df30 ESP: 89c9df2c
>> [    8.541519]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
>> [    8.541519]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
>> [    8.541519] CR0: 8005003b CR2: 02e00000 CR3: 05a54000 CR4: 00000690
>> [    8.541519] CR0: 8005003b CR2: 02e00000 CR3: 05a54000 CR4: 00000690
>> [    8.541519] Stack:
>> [    8.541519] Stack:
>> [    8.541519]  7d9d675b
>> [    8.541519]  7d9d675b 89c9df90 89c9df90 7d992a49 7d992a49 7d7d5914 7d7d5914 89c9df4c 89c9df4c 7be3a800 7be3a800 7d08c58c 7d08c58c 8a4c3968 8a4c3968
>>
>> [    8.541519]  89c9df80
>> [    8.541519]  89c9df80 7be3a966 7be3a966 00000192 00000192 00000006 00000006 00000006 00000006 7d7d3ff4 7d7d3ff4 8a4c397a 8a4c397a 00000200 00000200
>>
>> [    8.541519]  7d6b1280
>> [    8.541519]  7d6b1280 8a4c3979 8a4c3979 00000006 00000006 000009a6 000009a6 7da32db8 7da32db8 b13eec81 b13eec81 00000006 00000006 000009a6 000009a6
>>
>> [    8.541519] Call Trace:
>> [    8.541519] Call Trace:
>> [    8.541519]  [<7d9d675b>] ? ttusb2_driver_init+0x16/0x16
>> [    8.541519]  [<7d9d675b>] ? ttusb2_driver_init+0x16/0x16
>> [    8.541519]  [<7d992a49>] do_one_initcall+0x77/0x106
>> [    8.541519]  [<7d992a49>] do_one_initcall+0x77/0x106
>> [    8.541519]  [<7be3a800>] ? parameqn+0x2/0x35
>> [    8.541519]  [<7be3a800>] ? parameqn+0x2/0x35
>> [    8.541519]  [<7be3a966>] ? parse_args+0x113/0x25c
>> [    8.541519]  [<7be3a966>] ? parse_args+0x113/0x25c
>> [    8.541519]  [<7d992bc2>] kernel_init_freeable+0xea/0x167
>> [    8.541519]  [<7d992bc2>] kernel_init_freeable+0xea/0x167
>> [    8.541519]  [<7cf01070>] kernel_init+0x8/0xb8
>> [    8.541519]  [<7cf01070>] kernel_init+0x8/0xb8
>> [    8.541519]  [<7cf27ec0>] ret_from_kernel_thread+0x20/0x30
>> [    8.541519]  [<7cf27ec0>] ret_from_kernel_thread+0x20/0x30
>> [    8.541519]  [<7cf01068>] ? rest_init+0x10c/0x10c
>> [    8.541519]  [<7cf01068>] ? rest_init+0x10c/0x10c
>> [    8.541519] Code:
>> [    8.541519] Code: 08 08 c2 c2 c7 c7 05 05 44 44 ed ed f9 f9 7d 7d 00 00 00 00 e0 e0 02 02 c7 c7 05 05 40 40 ed ed f9 f9 7d 7d 00 00 00 00 e0 e0 02 02 c7 c7 05 05 3c 3c ed ed f9 f9 7d 7d 00 00 00 00 e0 e0 02 02 75 75 1f 1f b8 b8 00 00 00 00 e0 e0 02 02 85 85 c0 c0 74 74 16 16 <a1> <a1> 00 00 00 00 e0 e0 02 02 c7 c7 05 05 54 54 84 84 8e 8e 7d 7d 00 00 00 00 e0 e0 02 02 a3 a3 58 58 84 84 8e 8e 7d 7d eb eb
>>
>> [    8.541519] EIP: [<7d9d67c6>] 
>> [    8.541519] EIP: [<7d9d67c6>] af9005_usb_module_init+0x6b/0x9daf9005_usb_module_init+0x6b/0x9d SS:ESP 0068:89c9df2c
>>  SS:ESP 0068:89c9df2c
>> [    8.541519] CR2: 0000000002e00000
>> [    8.541519] CR2: 0000000002e00000
>> [    8.541519] ---[ end trace 768b6faf51370fc7 ]---
>> [    8.541519] ---[ end trace 768b6faf51370fc7 ]---
[...]
>> This script may reproduce the error.
>>
>> ----------------------------------------------------------------------------
>> #!/bin/bash
>>
>> kernel=$1
>> initrd=quantal-core-i386.cgz
>>
>> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
>>
>> kvm=(
>> 	qemu-system-x86_64
>> 	-cpu kvm64
>> 	-enable-kvm
>> 	-kernel $kernel
>> 	-initrd $initrd
>> 	-m 320
>> 	-smp 2
>> 	-net nic,vlan=1,model=e1000
>> 	-net user,vlan=1
>> 	-boot order=nc
>> 	-no-reboot
>> 	-watchdog i6300esb
>> 	-rtc base=localtime
>> 	-serial stdio
>> 	-display none
>> 	-monitor null 
>> )
>>
>> append=(
>> 	hung_task_panic=1
>> 	earlyprintk=ttyS0,115200
>> 	debug
>> 	apic=debug
>> 	sysrq_always_enabled
>> 	rcupdate.rcu_cpu_stall_timeout=100
>> 	panic=-1
>> 	softlockup_panic=1
>> 	nmi_watchdog=panic
>> 	oops=panic
>> 	load_ramdisk=2
>> 	prompt_ramdisk=0
>> 	console=ttyS0,115200
>> 	console=tty0
>> 	vga=normal
>> 	root=/dev/ram0
>> 	rw
>> 	drbd.minor_count=8
>> )
>>
>> "${kvm[@]}" --append "${append[*]}"
>> ----------------------------------------------------------------------------
>>
>> Thanks,
>> Fengguang
>>
>>
>> _______________________________________________
>> LKP mailing list
>> LKP@linux.intel.com

