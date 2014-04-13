Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaDMRUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 13:20:16 -0400
Received: from mout.gmx.net ([212.227.15.19]:54677 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaDMRUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 13:20:13 -0400
MIME-Version: 1.0
Message-ID: <trinity-aed1f545-ee92-43ee-a8a9-85f452aa8aab-1397409611332@3capp-gmx-bs45>
From: Alexander.Kleinsorge@gmx.de
To: linux-kernel@vger.kernel.org
Subject: Aw: Re: Re: new module to check constant memory for corruption
Content-Type: multipart/mixed;
 boundary=rekcebs-be244d09-d5d9-49ad-86d1-48bc90a07fbe
Date: Sun, 13 Apr 2014 19:20:11 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <CAFLxGvyiVaONh61j7z1s6u15f0Uz-Yb3Js0Vk9C2WiB6OR4yKA@mail.gmail.com>
References: <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18>
 <87eh12hr1t.fsf@tassilo.jf.intel.com>
 <trinity-516ff83e-4833-4dad-856a-dd0597993837-1397384072115@3capp-gmx-bs62>,
 <CAFLxGvyiVaONh61j7z1s6u15f0Uz-Yb3Js0Vk9C2WiB6OR4yKA@mail.gmail.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:mRGGwny1evt7NlvRoXL5J/twsBSf1hyIwD7Rq8ABwiH
 SSMBiqCKmlARjfU58uXE0rCL4NGE+wUxa/L1hjIvuwQbDtFkmV
 YW0gpZIxNWj1LszHvam25l/k8D5MZ69GZQlbNRekHvjdwLlYjL
 a8ng6anQtixMaWyrINxtZkGvpj1uwG8M8MjBBV4RU6DkRECgde
 BWBUxvkrHFiygeZrbibjW1ebiYwCXkPfwjcbuDhizlAXd0Q4Bx
 h3v4y8ALpD9JVXuK+NoCYes0t4EyyBVQGlrxpwhuPDN21vh7aX pVLrb4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rekcebs-be244d09-d5d9-49ad-86d1-48bc90a07fbe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

1. KERN_EMERG is now KERN_INFO or ALERT (depending on ftrace_enabled).
2. there is no trigger for real ram errors possible! (only for out of boun=
d writes)
Therefore it is checked periodically and can also be triggered by /proc/ra=
mcheck

Alex

=C2=A0On Sun, 13 Apr 2014 03:33:10 +0200, Alexander.Kleinsorge [at] gmx sa=
id:

> printk(KERN_EMERG MODNAME "error: const kernel memory is broken (%08lx !=
=3D 0), please reboot!", g_SumLast);

Make a list of all the things that can dynamically modify kernel text whil=
e
it's running, starting with the alternatives code, and adding in the vario=
us
tracing and debugging tools, and ask yourself if KERN_EMERG is the right
choice here...

Also, that printk is in the wrong place - it only fires if somebody reads
the /proc file, and it *should* trigger as soon as practical after a
problem has been detected.

Bonus points for computing what percent of single, double, triple, and
other error syndromes your xor detects (hint - what is the behavior of a
dead row or column of bits?).=20
=C2=A0

Gesendet:=C2=A0Sonntag, 13. April 2014 um 12:26 Uhr
Von:=C2=A0"Richard Weinberger" <richard.weinberger@gmail.com>
An:=C2=A0Alexander.Kleinsorge@gmx.de
Cc:=C2=A0"Andi Kleen" <andi@firstfloor.org>, LKML <linux-kernel@vger.kerne=
l.org>
Betreff:=C2=A0Re: Re: new module to check constant memory for corruption
On Sun, Apr 13, 2014 at 12:14 PM, <Alexander.Kleinsorge@gmx.de> wrote:
> Hi Andi,
>
> the module considers only the adress range between: kallsyms_lookup_name=
("_text") .. kallsyms_lookup_name("__end_rodata").
> this range has a typical size of 10..20 mb (depending on kernel-version =
and arch).
> see files: linux-3.*\arch\x86\mm\init_32.c + init_64.c
> function: void mark_rodata_ro(void)
> "Write protecting the kernel text: %luk\n"
> "Write protecting the kernel read-only data: %luk\n"
> dmesg | grep protecting
>
> your question: there are no writes in this write protected adress range =
(e.g. kernel code).

And what happens if one enables dynamic ftrace or other kernel
features which modify kernel code?

> my idea is to calculate a checksum (xor is fastest) over this range and =
check later (periodically) if its unchanged.
> see source code download (5 KB): http://tauruz.homeip.net/ramcheck.tgz
> the code is working fine and the checksum is (as expected) constant (at =
least for many hours).
>
> regards, Alexander
>
>
> Gesendet: Sonntag, 13. April 2014 um 05:00 Uhr
> Von: "Andi Kleen" <andi@firstfloor.org>
> An: Alexander.Kleinsorge@gmx.de
> Cc: linux-kernel@vger.kernel.org
> Betreff: Re: new module to check constant memory for corruption
> Alexander.Kleinsorge@gmx.de writes:
>
>> ramcheck kernel module
>> new module to check constant memory for corruption
>>
>> detect corruption of constant kernel memory (text and data) periodicall=
y.
>> runtime costs about 1..2 ms per sec (about 10 mb with 5 mb/ms),
>> which is distributed over 8 (BLOCKS) time partitions (less than half
>> ms per sec).
>> in case of checksum (xor) error, an kernel log is posted.
>> manual trigger via /proc/ramcheck is possible.
>> range: kallsyms_lookup_name("_text") .. kallsyms_lookup_name("__end_rod=
ata")
>
>
> Can you explain how this works? How does it handle legal writes?
>
> If it just checks its own memory it could be done in user space.
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html[http:/=
/vger.kernel.org/majordomo-info.html]
> Please read the FAQ at http://www.tux.org/lkml/[http://www.tux.org/lkml/=
]



--
Thanks,
//richard
--rekcebs-be244d09-d5d9-49ad-86d1-48bc90a07fbe
Content-Type: text/plain
Content-Disposition: attachment; filename=ramcheck.c

/* ramcheck.c - checks predefined kernel memory region
*
* KernelRamCheck by
*
* Copyright 2014 Alexander Kleinsorge <alexander[dot]kleinsorge[at]gmx[dot]de>
* Copyright 2014 Benjamin Schroedl <benjamin[at]dev-tec[dot]de>
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*
*/

// Defining __KERNEL__ and MODULE allows us to access kernel-level code not usually available to userspace programs.
/*
#undef __KERNEL__
#define __KERNEL__

#undef MODULE
#define MODULE
*/
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kallsyms.h>
#include <linux/kernel.h>
#include <linux/pfn.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/timer.h>
#include <linux/delay.h>
#include <crypto/algapi.h>
#include <asm/uaccess.h>
#include <asm/sections.h>
#include <linux/time.h>
#include <linux/ftrace.h>
#include <asm/cacheflush.h>
/* read file: /proc/sys/kernel/ftrace_enabled */
#include <linux/fs.h>
#include <asm/segment.h>
#include <asm/uaccess.h>
#include <linux/buffer_head.h>

#ifdef CONFIG_DYNAMIC_FTRACE
# warning "RAMCHECK: using FTRACE can cause false alarm."
/* cat /proc/sys/kernel/ftrace_enabled (default 1) */
#endif

#define DRIVER_AUTHOR    "Alexander Kleinsorge <alexander[dot]kleinsorge[at]gmx[dot]de> and Benjamin Schroedl <benjamin[at]dev-tec[dot]de>"
#define DRIVER_DESC      "checks predefined memory kernel region"
#define proc_fs_name     "ramcheck"
#define MODNAME proc_fs_name" "

#define CHECK_TIMER_MS   1000
#define BLOCK ((sizeof(long) <= 4) ? 1u << 20 : 2u << 20) /* 64bit CPU is often faster (bigger blocks at once) */
#define BLOCKS 8

MODULE_LICENSE("GPL");
MODULE_AUTHOR(DRIVER_AUTHOR);
MODULE_DESCRIPTION(DRIVER_DESC);


static void ram_check_exit(void);
static int  ram_check_init(void);
static int  ram_check_print(struct seq_file *m, void *v);
static int  ram_check_run(void);
void        ram_check_timer_callback(unsigned long data);
static int  ram_check_open(struct inode *inode, struct file *file);

static struct timer_list ram_check_timer;
struct proc_dir_entry *ram_check_proc_file;
struct file_operations proc_fops = {
	.open     = ram_check_open,
	.read     = seq_read,
	.llseek   = seq_lseek,
	.release  = single_release,
};


/* Global Variables */

struct s_ramcheck_init
{
	unsigned long RangeSize;
	unsigned long RangeStart;
	unsigned long SumFirst;
	unsigned long BlockSum[BLOCKS];
	unsigned int  TimerActive;
	unsigned int  dummy; // allign 64 bit
};
static struct s_ramcheck_init g_init = {0u,0u,0u, {0},0u,0u};

static unsigned long g_SumLast = 0;
static unsigned int g_TempCount = 0;
static unsigned int g_Timers = 0;


/* Functions */

/* simple checksum/hash, xor is fastest (~1-6 MB/ms) */
static unsigned long calcChecksumXor(const void* ptr, const unsigned long bytes)
{
	unsigned long ret, i;
	const unsigned long long* ptr64 = (const unsigned long long*) ptr;
	const unsigned long len = bytes / sizeof(*ptr64);
	unsigned long long sum64 = 0u;

	for (i=0; i < len; i++) {
		sum64 ^= ptr64[i];
	}

	/* return 32 or 64 bit possible */
	ret = ((unsigned long) sum64) ^ ((unsigned long) (sum64>>32));

	return ret;
}

/* merge 4 to 1 byte ==> less info (security reason) */
static unsigned char shrink2byte(unsigned long u)
{
	unsigned long ret = (u) ^ (u>>8) ^ (u>>16) ^ (u>>24);
	/* (lowest) 32 bit --> 8 bit */
	return (unsigned char) ret;
}

static unsigned long long getTimeUS(void)
{
	struct timespec ts;
	ktime_get_ts( &ts );

	return (ts.tv_sec*USEC_PER_SEC) + (ts.tv_nsec/1000u);
}

// check for const range (in case of strange checksum)
static int check_range(void)
{
	unsigned long start = kallsyms_lookup_name("_text");
	unsigned long size  = kallsyms_lookup_name("__end_rodata") - start;
	int ret = 0;

	if (g_init.RangeSize && ((start != g_init.RangeStart) || (size != g_init.RangeSize))) {
		printk(KERN_WARNING MODNAME "error: const kernel memory address changed (%08lx + %lu K), stop!\n", start, size/1024u);
		g_init.RangeSize = 0; /* stop working */
		ret = -1;
	}

	return ret;
}


static int fread_ftrace(void)
{
	int rights = 0, flags = O_RDONLY;
	const char path[64] = "/proc/sys/kernel/ftrace_enabled";
	char data[4] = "\0\0\0";
	struct file* filp = NULL;
	mm_segment_t oldfs;
	int err = 0, ret;
	unsigned long long offset = 0u;

	oldfs = get_fs();
	set_fs(get_ds());
	filp = filp_open(path, flags, rights);
	set_fs(oldfs);
	if (IS_ERR(filp)) {
		err = PTR_ERR(filp);
		return -1;
	}

	oldfs = get_fs();
	set_fs(get_ds());
	ret = vfs_read(filp, data, 1, &offset);
	set_fs(oldfs);
	filp_close(filp, NULL);

	if (!ret) return -2;
	if ('1' == data[0]) return 1;

	return 0;
}

static int check_ftrace(void)
{
	int ft = fread_ftrace();
	
#ifdef CONFIG_DYNAMIC_FTRACE
	/* unknown: function_trace_stop, ftrace_enabled, ftrace_nr_registered_ops() */
	if (ft > 0)
		printk(KERN_WARNING MODNAME ": ftrace state = %d (enabled), false alarm possible!\n", ft);
	else
        printk(KERN_INFO MODNAME ": ftrace state = %d (disabled).\n", ft);
#else
	if (ft >= 0) 
		printk(KERN_WARNING MODNAME ": CONFIG_DYNAMIC_FTRACE not defined, but useable (%d)!\n", ft);
#endif
	return 0;
}

/* partitions to limit runtime to 1 ms (1..6 MB) */
static unsigned long check_block(unsigned long blk, unsigned long lastblk)
{
	const unsigned long offset = blk * BLOCK;
	unsigned long start = g_init.RangeStart + offset;
	unsigned long size = BLOCK;
	unsigned long ret;

	if (blk >= lastblk) {
		size = g_init.RangeSize % BLOCK;
		if (blk > lastblk) {
			return (~0u); /* should never happen */
		}
	}
	ret = calcChecksumXor((const void *) start, size);

	return ret;
}

/* INIT: call not before mark_rodata_ro(void) */
static int ram_check_init(void)
{
	int ret;
	unsigned long start, size, end;
	unsigned long b, t, bps;

	for (b=0; b<BLOCKS; b++) {
		g_init.BlockSum[b] = 0u;
	}

	ram_check_proc_file = proc_create(proc_fs_name, 0, NULL, &proc_fops);

	if (ram_check_proc_file == NULL) {
		remove_proc_entry(proc_fs_name, NULL);
		printk(KERN_ALERT MODNAME "error: Could not initialize /proc/%s\n", proc_fs_name);

		return -ENOMEM;
	}

	start = kallsyms_lookup_name("_text");
	end   = kallsyms_lookup_name("__end_rodata");
	/* kallsyms_lookup_name("__end_rodata_hpage_align"); ==> Bad Address! */
	size  = (end - start);

	/* error handling on illegal size and ptr or size to big */
	if ((start == 0) || (end == 0) || (end <= start) || (size > (1000u << 20))) {
		printk(KERN_ALERT MODNAME "error: bad start or end adress [%lx + %lx]\n", start, size);

		return -EFAULT;
	}
	if ((size < (1u << 20)) || (size > (200u << 20))) {
		printk(KERN_INFO MODNAME "warning: strange const size = %lu MB\n", size>>20);
	}

	check_ftrace();

	g_init.RangeStart = start;
	g_init.RangeSize  = size;

	t = (unsigned long) getTimeUS();
	for (b = 0; b <= size/BLOCK; b++) {
		g_init.BlockSum[b % BLOCKS] ^= check_block(b, size/BLOCK);
	}
	t = (unsigned long) getTimeUS() - t; /* ca. 1k..7k Byte/us */
	for (b = 0; b < BLOCKS; b++) {
		g_init.SumFirst ^= g_init.BlockSum[b]; /* all together */
	}

	bps = (t > 0) ? (size / t) : 0;
	printk(KERN_INFO MODNAME "init: %lu B/us, %lu kB, %d bit, (0x%02x, %u)\n",
		bps, size>>10, (int)sizeof(g_init.SumFirst)*8, shrink2byte(g_init.SumFirst), BLOCKS);

	/* TIMER init */
	setup_timer(&ram_check_timer, ram_check_timer_callback, 0);

	ret = mod_timer(&ram_check_timer, jiffies + msecs_to_jiffies(CHECK_TIMER_MS));
	if (ret) {
		printk(KERN_ALERT MODNAME "error: Failure in mod_timer\n");

		return -EFAULT;
	}
	g_init.TimerActive = 1;
	/* optional: clflush_cache_range or flush_icache_range (&g_init, &g_init + sizeof(g_init)); */

	return 0;
}


static void ram_check_exit(void)
{
	int ret;
	g_init.RangeSize = 0; /* stop work */

	remove_proc_entry(proc_fs_name, NULL);
	check_range();

	for (ret = 0; (g_init.TimerActive > 0) && (ret < 1000/20); ret ++) {
		mdelay(20);
	}

	ret = del_timer_sync(&ram_check_timer);

	if (ret) {
		printk(KERN_WARNING MODNAME "warning: timer still in use on exit...(%d,%u)\n", ret, g_Timers);
	} else {
		printk(KERN_INFO MODNAME ": exit (%lx,%u)\n", g_SumLast, g_Timers);
	}
}

/* file handler /proc/.. */
static int ram_check_print(struct seq_file *m, void *v)
{
	int ret = 0;
	unsigned long t = 0;

	ret = check_range();
	if (ret) {
		seq_printf(m, "ERROR: const kernel memory address changed (%08lx), stop!\n", g_SumLast);

		return -1;
	}

	if (g_SumLast != 0u) {
		seq_printf(m, "ERROR: const kernel memory was earlier broken (%08lx), no check again!\n", g_SumLast);

		return -2;
	}

	if (g_TempCount <= 2) { /* max 2 calls per timer (1 sec) */
		unsigned long xor;
		g_TempCount ++;
		t = (unsigned long) getTimeUS();
		xor = calcChecksumXor((const void *) g_init.RangeStart, g_init.RangeSize);
		t = (unsigned long) getTimeUS() - t;
		xor = g_init.SumFirst ^ xor;
		if (xor) g_SumLast = xor; /* only write bad events */
	} else {
		g_TempCount ++;
		seq_printf(m, "warning: too much triggers (%u) for ram_check (%08lx) !\n", g_TempCount, g_SumLast);
	}

	if (!g_SumLast) {
		seq_printf(m, "const kernel memory is OK, size = %lu MB, t = %lu us (%u)\n", g_init.RangeSize>>20, t, g_Timers);
	} else {
		int ft = fread_ftrace();
		if (ft > 0) {
			printk(KERN_INFO MODNAME "warning: const kernel memory is broken (%08lx != 0), ftrace used (%d)?\n", g_SumLast, ft);
			seq_printf(m, "WARNING: const kernel memory is broken (%08lx != 0), ftrace used (%d)?\n", g_SumLast, ft);
		} else {
			printk(KERN_ALERT MODNAME "error: const kernel memory is broken (%08lx != 0), please reboot!\n", g_SumLast);
			seq_printf(m, "ERROR: const kernel memory is broken (%08lx != 0), please reboot!\n", g_SumLast);
		}
		ret = -3;
		/* if (!FTRACE) : kernel panic (ram error) !! */
	}

	return ret;
}

/* only inside timer (1 sec) */
static int ram_check_run(void)
{
	const unsigned int lastblk = (unsigned int) (g_init.RangeSize / BLOCK);
	const unsigned int b = g_Timers % BLOCKS;
	unsigned int  l;
	unsigned long x = 0;

	if (0 == b) {
		check_range(); /* check sometimes */
	}

	for (l = b; l <= lastblk; l += BLOCKS) {
		x ^= check_block(l, lastblk);
	}
	x ^= g_init.BlockSum[b];

	if (x != 0u) {
		int ft = fread_ftrace();
		check_range();
		g_SumLast = x;
		if (ft > 0) {
			printk(KERN_ALERT MODNAME "error: const kernel memory broken (%08lx != 0), timer(%u, %u), ftrace=on(%d)!\n", x, g_Timers, b, ft);
			/* kernel panic (ram error) !! */
		} else {
			printk(KERN_WARNING MODNAME "warning: const kernel memory broken (%08lx != 0), timer(%u, %u), ftrace=off(%d)!\n", x, g_Timers, b, ft);
		}
	}

	return 0;
}

/* Timer Callback */
void ram_check_timer_callback(unsigned long data)
{
	int ret;

	g_Timers ++;
	if (0 == g_init.RangeSize) {
		g_init.TimerActive = 0;

		return;
	}

	if (g_SumLast != 0u) { /* failure earlier detected, skip */
		if (0 == (g_Timers % 32u)) {
			printk(KERN_WARNING MODNAME "error: const kernel memory earlier broken (%08lx), skip !\n", g_SumLast);
		}

		return;
	}

	ram_check_run();

	ret = mod_timer(&ram_check_timer, jiffies + msecs_to_jiffies(CHECK_TIMER_MS));
	if (ret) {
		printk(KERN_ALERT MODNAME "error: in mod_timer (%u, %d)\n", g_Timers, ret);
	}

	g_init.TimerActive = 1; /* is already set, but be safe */
	g_TempCount = 0;
}


static int ram_check_open(struct inode *inode, struct file *file)
{
	return single_open(file, ram_check_print, NULL);
}


module_init(ram_check_init);
module_exit(ram_check_exit);


--rekcebs-be244d09-d5d9-49ad-86d1-48bc90a07fbe
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=ramcheck.tgz
Content-Transfer-Encoding: base64

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

--rekcebs-be244d09-d5d9-49ad-86d1-48bc90a07fbe--
