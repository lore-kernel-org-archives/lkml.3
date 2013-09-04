Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934399Ab3IDILp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:11:45 -0400
Received: from mail-de.keymile.com ([195.8.104.250]:34621 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934321Ab3IDILm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:11:42 -0400
Message-ID: <5226EB35.6080604@keymile.com>
Date: Wed, 04 Sep 2013 10:11:33 +0200
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130807 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: kernel deadlock
References: <521F6D06.1040107@keymile.com> <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net> <521FDD12.7050000@linaro.org> <52212511.9050206@keymile.com> <5221264F.4070402@linaro.org> <5225F8EF.3040701@keymile.com> <52261BBB.60904@linaro.org>
In-Reply-To: <52261BBB.60904@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On 09/03/2013 07:26 PM, John Stultz wrote:
> On 09/03/2013 07:57 AM, Gerlando Falauto wrote:
>> Hi,
>>
>> I tried again from scratch, so let me recap the whole situation, so we
>> can all view it from the same standpoint. This should make the problem
>> easier to see and reproduce.
>>
>> I can confirm that running a stock 3.10 kernel with HRTICK enabled:
> [snip]
>> makes the following program (and the whole board, as a matter of fact)
>> hang with no further notice:
>>
> [snip]
>> If I then revert everything up to (and including) the offending commit
>> (mind the '~'):
>>
>> $ git log --oneline ...06c017f~ -- kernel/time/timekeeping.c
>> kernel/time/ntp.c | cut -f1 -d' ' | xargs git revert
>>
>> The problem disappears.
>>
>> If I then cherry-pick again the offending commit:
>>
>> $ git cherry-pick 06c017f; git log -1
>>
>> commit 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40
>> Author: John Stultz <john.stultz@linaro.org>
>> Date:   Fri Mar 22 11:37:28 2013 -0700
>>
>>       timekeeping: Hold timekeepering locks in do_adjtimex and hardpps
>>
> [snip]
>> And as soon as I also cherry-pick (notice there is another commit in
>> between, which seems not to be relevant on this matter):
>>
>> $ git cherry-pick a076b2146fabb0894cae5e0189a8ba3f1502d737; git show
>>
>> commit a076b2146fabb0894cae5e0189a8ba3f1502d737
>> Author: John Stultz <john.stultz@linaro.org>
>> Date:   Fri Mar 22 11:52:03 2013 -0700
>>
>>      ntp: Remove ntp_lock, using the timekeeping locks to protect ntp
>> state
>>
> [snip]
>>
>> I end up in the situation where the system hangs completely and NO
>> deadlock report whatsoever is output.
>>
>> So it looks like 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40 introduces
>> the deadlock, while a076b2146fabb0894cae5e0189a8ba3f1502d737 cares to
>> hide the report.
>>
>> Notice how I tested the above on an ARM board; on PowerPC I get
>> similar results, although I am not able to see the deadlock report
>> under any circumstances (enabling CONFIG_PROVE_LOCKING, which is the
>> flag that triggers the deadlock report, causes the kernel to hang at
>> startup even on a vanilla 3.10 kernel).
>>
>> John, could you please confirm whether you're at least able to
>> reproduce it somehow?
>
> Thanks again for the detailed notes. I've so far been unable to
> reproduce this, but I'm still looking at it.
>
> Enabling the SCHED_FEAT(HRTICK, true) bit tends to cause lots of issues
> on the various hardware I have, tripping the lockdep warnings on various
> other issues:
>
> [    4.224487] ======================================================
> [    4.230987] [ INFO: possible circular locking dependency detected ]
> [    4.237579] 3.9.0-rc2-00148-g06c017f-dirty #8 Not tainted
> [    4.243255] -------------------------------------------------------
> [    4.249847] kworker/0:1H/1329 is trying to acquire lock:
> [    4.255432]  (&p->pi_lock){-.-.-.}, at: [<c006d184>]
> try_to_wake_up+0x30/0x3c
> [    4.263092]
> [    4.263092] but task is already holding lock:
> [    4.269226]  (&rq->lock){-.-.-.}, at: [<c0721f18>] __schedule+0xb8/0x7d0
> [    4.276306]
> [    4.276306] which lock already depends on the new lock.
>
> and
>
> [    2.360591] =============================================
> [    2.363072] [ INFO: possible recursive locking detected ]
> [    2.364882] 3.9.0-rc2+ #9 Not tainted
> [    2.365486] ---------------------------------------------
> [    2.366345] blkid/999 is trying to acquire lock:
> [    2.367092]  (&p->pi_lock){-.-.-.}, at: [<ffffffff810c763c>]
> try_to_wake_up+0x2c/0x300
> [    2.367275]
> [    2.367275] but task is already holding lock:
> [    2.367275]  (&p->pi_lock){-.-.-.}, at: [<ffffffff810c763c>]
> try_to_wake_up+0x2c/0x300
> [    2.367275]
> [    2.367275] other info that might help us debug this:
> [    2.367275]  Possible unsafe locking scenario:
> [    2.367275]
>
> These warnings disable lockdep, so it may just be I'm not getting a
> chance to see the warning you describe.
>
>
> That said, the one system that doesn't throw those lockdep warnings,
> doesn't seem to hit your lockdep warning either, and I've not been able
> to trigger any hang using the test code you provided.
>

So by the sounds of it, it is more of an issue with HRTICK than with 
your changes...

 > Just in case there's something else here at play, could you send me your
 > .config that you're using?
 >

Yes, it's definitely possible that there's something else.
Even though my rate of failure (2 out of 2 boards tested) had me 
thinking this problem would have been quite common instead...

Here is my km_kirkwood_defconfig (hope that's the right way to send it):

# CONFIG_ARM_PATCH_PHYS_VIRT is not set
CONFIG_PHYS_OFFSET=0x0
CONFIG_SYSVIPC=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_LOG_BUF_SHIFT=19
CONFIG_CGROUPS=y
CONFIG_CGROUP_SCHED=y
CONFIG_NAMESPACES=y
CONFIG_EMBEDDED=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_ARCH_KIRKWOOD=y
CONFIG_MACH_D2NET_V2=y
CONFIG_MACH_DOCKSTAR=y
CONFIG_MACH_ESATA_SHEEVAPLUG=y
CONFIG_MACH_GURUPLUG=y
CONFIG_MACH_INETSPACE_V2=y
CONFIG_MACH_MV88F6281GTW_GE=y
CONFIG_MACH_NET2BIG_V2=y
CONFIG_MACH_NET5BIG_V2=y
CONFIG_MACH_NETSPACE_MAX_V2=y
CONFIG_MACH_NETSPACE_V2=y
CONFIG_MACH_OPENRD_BASE=y
CONFIG_MACH_OPENRD_CLIENT=y
CONFIG_MACH_OPENRD_ULTIMATE=y
CONFIG_MACH_RD88F6192_NAS=y
CONFIG_MACH_RD88F6281=y
CONFIG_MACH_SHEEVAPLUG=y
CONFIG_MACH_T5325=y
CONFIG_MACH_TS219=y
CONFIG_MACH_TS41X=y
CONFIG_MACH_DLINK_KIRKWOOD_DT=y
CONFIG_MACH_DOCKSTAR_DT=y
CONFIG_MACH_DREAMPLUG_DT=y
CONFIG_MACH_GOFLEXNET_DT=y
CONFIG_MACH_IB62X0_DT=y
CONFIG_MACH_ICONNECT_DT=y
CONFIG_MACH_INETSPACE_V2_DT=y
CONFIG_MACH_IOMEGA_IX2_200_DT=y
CONFIG_MACH_KM_KIRKWOOD_DT=y
CONFIG_MACH_LSXL_DT=y
CONFIG_MACH_MPLCEC4_DT=y
CONFIG_MACH_NETSPACE_LITE_V2_DT=y
CONFIG_MACH_NETSPACE_MAX_V2_DT=y
CONFIG_MACH_NETSPACE_MINI_V2_DT=y
CONFIG_MACH_NETSPACE_V2_DT=y
CONFIG_MACH_OPENBLOCKS_A6_DT=y
CONFIG_MACH_TOPKICK_DT=y
CONFIG_MACH_TS219_DT=y
# CONFIG_CPU_FEROCEON_OLD_ID is not set
CONFIG_CACHE_FEROCEON_L2_WRITETHROUGH=y
CONFIG_PREEMPT=y
CONFIG_AEABI=y
# CONFIG_OABI_COMPAT is not set
CONFIG_ZBOOT_ROM_TEXT=0x0
CONFIG_ZBOOT_ROM_BSS=0x0
CONFIG_CPU_IDLE=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IPV6 is not set
CONFIG_NET_PKTGEN=m
CONFIG_CFG80211=y
CONFIG_MAC80211=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_MTD=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_BLOCK=y
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_M25P80=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_ORION=y
CONFIG_BLK_DEV_LOOP=y
# CONFIG_SCSI_PROC_FS is not set
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_ATA=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_MV=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_MV643XX_ETH=y
CONFIG_MARVELL_PHY=y
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_SDIO=y
CONFIG_INPUT_EVDEV=y
CONFIG_KEYBOARD_GPIO=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_LEGACY_PTY_COUNT=16
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_RUNTIME_UARTS=2
CONFIG_SERIAL_OF_PLATFORM=y
# CONFIG_HW_RANDOM is not set
CONFIG_I2C=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MV64XXX=y
CONFIG_SPI=y
CONFIG_SPI_ORION=y
CONFIG_GPIO_SYSFS=y
# CONFIG_HWMON is not set
CONFIG_WATCHDOG=y
CONFIG_ORION_WATCHDOG=y
CONFIG_HID_DRAGONRISE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_HID_ZEROPLUS=y
CONFIG_USB=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_PRINTER=m
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_MMC=y
CONFIG_SDIO_UART=y
CONFIG_MMC_MVSDIO=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_MV=y
CONFIG_DMADEVICES=y
CONFIG_MV_XOR=y
CONFIG_EXT2_FS=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_UDF_FS=m
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_TMPFS=y
CONFIG_JFFS2_FS=y
CONFIG_CRAMFS=y
CONFIG_NFS_FS=y
CONFIG_ROOT_NFS=y
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_UTF8=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_FS=y
# CONFIG_SCHED_DEBUG is not set
# CONFIG_DEBUG_PREEMPT is not set
CONFIG_DEBUG_INFO=y
# CONFIG_FTRACE is not set
CONFIG_DEBUG_USER=y
CONFIG_DEBUG_LL=y
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DEV_MV_CESA=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_LIBCRC32C=y

What kind of systems are you using? ARM boards right?
I guess it would be nice for the two of us to work on the same board.
I could try reproducing it on a TK71 or on a Dreamplug, though that's 
going to take quite some time.
Before I even try, I'd like to know whether you would have either of 
those available.
As I said, we might be looking at an issue that's caused by something 
completely unrelated (which is not even turned on by default, and has 
several other issues too). So I'm not sure we should keep bothering.

Thanks,
Gerlando
