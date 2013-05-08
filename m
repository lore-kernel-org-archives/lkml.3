Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3EHPp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:45:26 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34325 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab3EHPpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:45:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+xjVY0beIED9Dt1/EZXC1u
Date: Wed, 8 May 2013 08:45:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] SLAB changes for v3.10
Message-ID: <20130508154518.GW28721@atomide.com>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org>
 <20130508003022.GS28721@atomide.com>
 <20130508042422.GU28721@atomide.com>
 <0000013e846d76c8-d376963d-e953-4eff-92ea-742ba09cdb98-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fd5uyaI9j6xoeUBo"
Content-Disposition: inline
In-Reply-To: <0000013e846d76c8-d376963d-e953-4eff-92ea-742ba09cdb98-000000@email.amazonses.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fd5uyaI9j6xoeUBo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Christoph Lameter <cl@linux.com> [130508 07:01]:
> On Tue, 7 May 2013, Tony Lindgren wrote:
> 
> > OK got it narrowed down to CONFIG_DEBUG_SPINLOCK=y causing the problem
> > with commit 8a965b3b. Ain't nothing like bisecting and booting and then
> > diffing .config files on top of that.
> >
> > > Without reverting 8a965b3b I'm getting:
> 
> The patch (commit 8a965b3baa89ffedc73c0fbc750006c631012ced) merely changed the sequence of
> slab creation to address an issue in SLAB.
> 
> Hmmm.. But if KMALLOC_SHIFT_LOW is higher than 6 or 7 then the creation of
> the non-power of two slab could be skipped as a result of the patch. But
> we should not need them in those cases.
> 
> Can I see the kernel config?

Attached are minimal defconfig-bad and defconfig-good with pretty
much everything disabled. These boot vexpress in qemu using earlyprintk
for the output.
 
> What is the value of KMALLOC_SHIFT_LOW?

It's 6.
 
> Can you figure out which kernel slab the function is trying to access?

I can certainly debug it further, but it's also pretty easy to reproduce:

1. Download and build qemu-linaro from:

   https://git.linaro.org/gitweb?p=qemu/qemu-linaro.git

   The last time I tried the stock qemu I could not get vexpress to
   boot with it, don't know if that's still the case. But the above
   works for me.

2. Cross compile kernel with the attached defconfig-bad

   $ ARCH=arm CROSS_COMPILE=... make zImage

3. Try to boot the kernel in qemu

   $ qemu-system-arm -machine vexpress-a9 -m 1024 -curses -net nic \
	-net user -serial stdio -append "console=ttyAMA0,115200n8 \
	root=/dev/mmcblk0p2 ro rootwait physmap.enabled=0 \
	debug earlyprintk" -kernel zImage

Regards,

Tony

--fd5uyaI9j6xoeUBo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=defconfig-bad

CONFIG_SYSVIPC=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=16
CONFIG_BLK_DEV_INITRD=y
CONFIG_EXPERT=y
CONFIG_SLAB=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_BLOCK is not set
CONFIG_ARCH_VEXPRESS_CA9X4=y
CONFIG_ARM_THUMBEE=y
CONFIG_SMP=y
CONFIG_NR_CPUS=2
CONFIG_ZBOOT_ROM_TEXT=0x0
CONFIG_ZBOOT_ROM_BSS=0x0
CONFIG_CMDLINE="root=/dev/mmcblk0p2 rootwait console=ttyO2,115200"
CONFIG_KEXEC=y
CONFIG_FPE_NWFPE=y
CONFIG_BINFMT_MISC=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_CMA=y
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_INPUT_MISC=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_AMBA_PL011=y
CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
# CONFIG_HWMON is not set
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_PLATFORM=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_USB_SUPPORT is not set
# CONFIG_IOMMU_SUPPORT is not set
# CONFIG_FILE_LOCKING is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_TMPFS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_PRINTK_TIME=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_PROVE_LOCKING=y
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
# CONFIG_FTRACE is not set
CONFIG_DEBUG_LL=y
CONFIG_DEBUG_VEXPRESS_UART0_CA9=y
CONFIG_EARLY_PRINTK=y

--fd5uyaI9j6xoeUBo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=defconfig-good

CONFIG_SYSVIPC=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=16
CONFIG_BLK_DEV_INITRD=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS_ALL=y
CONFIG_SLAB=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_BLOCK is not set
CONFIG_ARCH_VEXPRESS_CA9X4=y
CONFIG_ARM_THUMBEE=y
CONFIG_SMP=y
CONFIG_NR_CPUS=2
CONFIG_ZBOOT_ROM_TEXT=0x0
CONFIG_ZBOOT_ROM_BSS=0x0
CONFIG_CMDLINE="root=/dev/mmcblk0p2 rootwait console=ttyO2,115200"
CONFIG_KEXEC=y
CONFIG_FPE_NWFPE=y
CONFIG_BINFMT_MISC=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_CMA=y
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_INPUT_MISC=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_AMBA_PL011=y
CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
# CONFIG_HWMON is not set
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_PLATFORM=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_USB_SUPPORT is not set
# CONFIG_IOMMU_SUPPORT is not set
# CONFIG_FILE_LOCKING is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_TMPFS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_PRINTK_TIME=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
# CONFIG_FTRACE is not set
CONFIG_DEBUG_LL=y
CONFIG_DEBUG_VEXPRESS_UART0_CA9=y
CONFIG_EARLY_PRINTK=y

--fd5uyaI9j6xoeUBo--
