Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3AYLhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:37:20 -0500
Received: from multi.imgtec.com ([194.200.65.239]:24866 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab3AYLhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:37:13 -0500
Message-ID: <51026E55.80905@imgtec.com>
Date: Fri, 25 Jan 2013 11:36:53 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: James Hogan <james.hogan@imgtec.com>, <linux-arch@vger.kernel.org>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 43/44] tty/metag_da: Add metag DA TTY driver
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <1357831872-29451-44-git-send-email-james.hogan@imgtec.com> <50F3E3FF.4080803@imgtec.com>
In-Reply-To: <50F3E3FF.4080803@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigD873AC0DC7897DD50441CA6B"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_25_11_37_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigD873AC0DC7897DD50441CA6B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 14/01/13 10:54, James Hogan wrote:
> Here's a new version addressing Jiri's feedback.
>=20
> Add a TTY driver for communicating over a Meta DA (Debug Adapter)
> channel using the bios channel SWITCH operation.
>=20
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Cesar Eduardo Barros <cesarb@cesarb.net>
> Cc: Joe Perches <joe@perches.com>
> Cc: "David S. Miller" <davem@davemloft.net>

If this looks okay, I'd appreciate if somebody could Ack it.

I have some further patches ready to simplify the code around
tty_prepare_flip_string and tty_flip_buffer_push to avoid taking a tty
kref, after Jiri's changes in that area in linux-next. I guess these can
be applied once both sets of changes are merged.

Thanks
James

> ---
>  MAINTAINERS                            |    1 +
>  arch/metag/Kconfig                     |    4 +-
>  arch/metag/configs/meta1_defconfig     |    2 +
>  arch/metag/configs/meta2_defconfig     |    2 +
>  arch/metag/configs/meta2_smp_defconfig |    2 +
>  arch/metag/kernel/setup.c              |   12 +
>  drivers/tty/Kconfig                    |   13 +
>  drivers/tty/Makefile                   |    1 +
>  drivers/tty/metag_da.c                 |  679 ++++++++++++++++++++++++=
++++++++
>  9 files changed, 715 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/tty/metag_da.c
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dbc2bd6..63ccab6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5002,6 +5002,7 @@ S:	Supported
>  F:	arch/metag/
>  F:	Documentation/metag/
>  F:	Documentation/devicetree/bindings/metag/
> +F:	drivers/tty/metag_da.c
> =20
>  MICROBLAZE ARCHITECTURE
>  M:	Michal Simek <monstr@monstr.eu>
> diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
> index 9bd0bc1..f4ef3bb 100644
> --- a/arch/metag/Kconfig
> +++ b/arch/metag/Kconfig
> @@ -221,7 +221,9 @@ config METAG_DA
>  	  of the DA will be detected automatically at boot, so it is safe to =
say
>  	  Y to this option even when booting without a DA.
> =20
> -	  This enables support for services provided by DA JTAG debug adapter=
s.
> +	  This enables support for services provided by DA JTAG debug adapter=
s,
> +	  such as:
> +	  - communication over DA channels (such as the console driver).
> =20
>  menu "Boot options"
> =20
> diff --git a/arch/metag/configs/meta1_defconfig b/arch/metag/configs/me=
ta1_defconfig
> index 0773425..ad663ca 100644
> --- a/arch/metag/configs/meta1_defconfig
> +++ b/arch/metag/configs/meta1_defconfig
> @@ -28,6 +28,8 @@ CONFIG_BLK_DEV_RAM_SIZE=3D16384
>  # CONFIG_SERIO is not set
>  # CONFIG_VT is not set
>  # CONFIG_LEGACY_PTYS is not set
> +CONFIG_DA_TTY=3Dy
> +CONFIG_DA_CONSOLE=3Dy
>  # CONFIG_DEVKMEM is not set
>  # CONFIG_HW_RANDOM is not set
>  # CONFIG_HWMON is not set
> diff --git a/arch/metag/configs/meta2_defconfig b/arch/metag/configs/me=
ta2_defconfig
> index 001f9bf..47922e93 100644
> --- a/arch/metag/configs/meta2_defconfig
> +++ b/arch/metag/configs/meta2_defconfig
> @@ -29,6 +29,8 @@ CONFIG_BLK_DEV_RAM_SIZE=3D16384
>  # CONFIG_SERIO is not set
>  # CONFIG_VT is not set
>  # CONFIG_LEGACY_PTYS is not set
> +CONFIG_DA_TTY=3Dy
> +CONFIG_DA_CONSOLE=3Dy
>  # CONFIG_DEVKMEM is not set
>  # CONFIG_HW_RANDOM is not set
>  # CONFIG_HWMON is not set
> diff --git a/arch/metag/configs/meta2_smp_defconfig b/arch/metag/config=
s/meta2_smp_defconfig
> index d6f7e46..f508250 100644
> --- a/arch/metag/configs/meta2_smp_defconfig
> +++ b/arch/metag/configs/meta2_smp_defconfig
> @@ -30,6 +30,8 @@ CONFIG_BLK_DEV_RAM_SIZE=3D16384
>  # CONFIG_SERIO is not set
>  # CONFIG_VT is not set
>  # CONFIG_LEGACY_PTYS is not set
> +CONFIG_DA_TTY=3Dy
> +CONFIG_DA_CONSOLE=3Dy
>  # CONFIG_DEVKMEM is not set
>  # CONFIG_HW_RANDOM is not set
>  # CONFIG_HWMON is not set
> diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
> index 1410db0..0d46334 100644
> --- a/arch/metag/kernel/setup.c
> +++ b/arch/metag/kernel/setup.c
> @@ -61,6 +61,11 @@ extern char _heap_start[];
>  extern u32 __dtb_start[];
>  #endif
> =20
> +#ifdef CONFIG_DA_CONSOLE
> +/* Our early channel based console driver */
> +extern struct console dash_console;
> +#endif
> +
>  struct machine_desc *machine_desc __initdata;
> =20
>  /*
> @@ -182,6 +187,13 @@ void __init setup_arch(char **cmdline_p)
>  	metag_cache_probe();
> =20
>  	metag_da_probe();
> +#ifdef CONFIG_DA_CONSOLE
> +	if (metag_da_enabled()) {
> +		/* An early channel based console driver */
> +		register_console(&dash_console);
> +		add_preferred_console("ttyDA", 1, NULL);
> +	}
> +#endif
> =20
>  	/* try interpreting the argument as a device tree */
>  	machine_desc =3D setup_machine_fdt(original_cmd_line);
> diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
> index 0ecf22b..5eef53d 100644
> --- a/drivers/tty/Kconfig
> +++ b/drivers/tty/Kconfig
> @@ -388,3 +388,16 @@ config PPC_EARLY_DEBUG_EHV_BC_HANDLE
>  	  If the number you specify is not a valid byte channel handle, then
>  	  there simply will be no early console output.  This is true also
>  	  if you don't boot under a hypervisor at all.
> +
> +config DA_TTY
> +	bool "DA TTY"
> +	depends on METAG_DA
> +	select SERIAL_NONSTANDARD
> +	help
> +	  This enables a TTY on a Dash channel.
> +
> +config DA_CONSOLE
> +	bool "DA Console"
> +	depends on DA_TTY
> +	help
> +	  This enables a console on a Dash channel.
> diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
> index 2953059..dbd7745 100644
> --- a/drivers/tty/Makefile
> +++ b/drivers/tty/Makefile
> @@ -27,5 +27,6 @@ obj-$(CONFIG_SYNCLINK_GT)	+=3D synclink_gt.o
>  obj-$(CONFIG_SYNCLINKMP)	+=3D synclinkmp.o
>  obj-$(CONFIG_SYNCLINK)		+=3D synclink.o
>  obj-$(CONFIG_PPC_EPAPR_HV_BYTECHAN) +=3D ehv_bytechan.o
> +obj-$(CONFIG_DA_TTY)	+=3D metag_da.o
> =20
>  obj-y +=3D ipwireless/
> diff --git a/drivers/tty/metag_da.c b/drivers/tty/metag_da.c
> new file mode 100644
> index 0000000..6a0b2e6
> --- /dev/null
> +++ b/drivers/tty/metag_da.c
> @@ -0,0 +1,679 @@
> +/*
> + *  dashtty.c - tty driver for Dash channels interface.
> + *
> + *  Copyright (C) 2007,2008,2012 Imagination Technologies
> + *
> + * This file is subject to the terms and conditions of the GNU General=
 Public
> + * License.  See the file COPYING in the main directory of this archiv=
e
> + * for more details.
> + *
> + */
> +
> +#include <linux/atomic.h>
> +#include <linux/completion.h>
> +#include <linux/console.h>
> +#include <linux/delay.h>
> +#include <linux/export.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/kthread.h>
> +#include <linux/mutex.h>
> +#include <linux/sched.h>
> +#include <linux/serial.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/string.h>
> +#include <linux/timer.h>
> +#include <linux/tty.h>
> +#include <linux/tty_driver.h>
> +#include <linux/tty_flip.h>
> +#include <linux/uaccess.h>
> +
> +#include <asm/da.h>
> +
> +/* Channel error codes */
> +#define CONAOK	0
> +#define CONERR	1
> +#define CONBAD	2
> +#define CONPRM	3
> +#define CONADR	4
> +#define CONCNT	5
> +#define CONCBF	6
> +#define CONCBE	7
> +#define CONBSY	8
> +
> +/* Default channel for the console */
> +#define CONSOLE_CHANNEL      1
> +
> +#define NUM_TTY_CHANNELS     6
> +
> +/* Auto allocate */
> +#define DA_TTY_MAJOR        0
> +
> +/* A speedy poll rate helps the userland debug process connection resp=
onse.
> + * But, if you set it too high then no other userland processes get mu=
ch
> + * of a look in.
> + */
> +#define DA_TTY_POLL (HZ / 50)
> +
> +/*
> + * A short put delay improves latency but has a high throughput overhe=
ad
> + */
> +#define DA_TTY_PUT_DELAY (HZ / 100)
> +
> +static atomic_t num_channels_need_poll =3D ATOMIC_INIT(0);
> +
> +static struct timer_list poll_timer;
> +
> +static struct tty_driver *channel_driver;
> +
> +static struct timer_list put_timer;
> +static struct task_struct *dashtty_thread;
> +
> +#define RX_BUF_SIZE 1024
> +
> +enum {
> +	INCHR =3D 1,
> +	OUTCHR,
> +	RDBUF,
> +	WRBUF,
> +	RDSTAT
> +};
> +
> +/**
> + * struct dashtty_port - Wrapper struct for dashtty tty_port.
> + * @port:		TTY port data
> + * @rx_lock:		Lock for rx_buf.
> + *			This protects between the poll timer and user context.
> + *			It's also held during read SWITCH operations.
> + * @rx_buf:		Read buffer
> + * @xmit_lock:		Lock for xmit_*, and port.xmit_buf.
> + *			This protects between user context and kernel thread.
> + *			It's also held during write SWITCH operations.
> + * @xmit_cnt:		Size of xmit buffer contents
> + * @xmit_head:		Head of xmit buffer where data is written
> + * @xmit_tail:		Tail of xmit buffer where data is read
> + * @xmit_empty:		Completion for xmit buffer being empty
> + */
> +struct dashtty_port {
> +	struct tty_port		 port;
> +	spinlock_t		 rx_lock;
> +	void			*rx_buf;
> +	struct mutex		 xmit_lock;
> +	unsigned int		 xmit_cnt;
> +	unsigned int		 xmit_head;
> +	unsigned int		 xmit_tail;
> +	struct completion	 xmit_empty;
> +};
> +
> +static struct dashtty_port dashtty_ports[NUM_TTY_CHANNELS];
> +
> +static atomic_t dashtty_xmit_cnt =3D ATOMIC_INIT(0);
> +static wait_queue_head_t dashtty_waitqueue;
> +
> +/*
> + * Low-level DA channel access routines
> + */
> +static int chancall(int in_bios_function, int in_channel,
> +		    int in_arg2, void *in_arg3,
> +		    void *in_arg4)
> +{
> +	register int   bios_function asm("D1Ar1") =3D in_bios_function;
> +	register int   channel       asm("D0Ar2") =3D in_channel;
> +	register int   arg2          asm("D1Ar3") =3D in_arg2;
> +	register void *arg3          asm("D0Ar4") =3D in_arg3;
> +	register void *arg4          asm("D1Ar5") =3D in_arg4;
> +	register int   bios_call     asm("D0Ar6") =3D 3;
> +	register int   result        asm("D0Re0");
> +
> +	asm volatile (
> +		"MSETL	[A0StP++], %6,%4,%2\n\t"
> +		"ADD	A0StP, A0StP, #8\n\t"
> +		"SWITCH	#0x0C30208\n\t"
> +		"GETD	%0, [A0StP+#-8]\n\t"
> +		"SUB	A0StP, A0StP, #(4*6)+8\n\t"
> +		: "=3Dd" (result)   /* outs */
> +		: "d" (bios_function),
> +		  "d" (channel),
> +		  "d" (arg2),
> +		  "d" (arg3),
> +		  "d" (arg4),
> +		  "d" (bios_call) /* ins */
> +		: "memory");
> +
> +	return result;
> +}
> +
> +/*
> + * Attempts to fetch count bytes from channel and returns actual count=
=2E
> + */
> +static int fetch_data(struct tty_struct *tty)
> +{
> +	unsigned int channel =3D tty->index;
> +	struct dashtty_port *dport =3D &dashtty_ports[channel];
> +	int received =3D 0;
> +
> +	spin_lock_bh(&dport->rx_lock);
> +	/* check the port isn't being shut down */
> +	if (!dport->rx_buf)
> +		goto unlock;
> +	if (chancall(RDBUF, channel, RX_BUF_SIZE,
> +		     (void *)dport->rx_buf, &received) =3D=3D CONAOK) {
> +		if (received) {
> +			int space;
> +			unsigned char *cbuf;
> +
> +			space =3D tty_prepare_flip_string(tty, &cbuf, received);
> +
> +			if (space <=3D 0)
> +				goto unlock;
> +
> +			memcpy(cbuf, dport->rx_buf, space);
> +			tty_flip_buffer_push(tty);
> +		}
> +	}
> +unlock:
> +	spin_unlock_bh(&dport->rx_lock);
> +
> +	return received;
> +}
> +
> +/**
> + * find_channel_to_poll() - Returns kref to the next channel tty to po=
ll.
> + * Returns:	The TTY of the next channel to poll, or NULL if no TTY nee=
ds
> + *		polling. Release with tty_kref_put().
> + */
> +static struct tty_struct *find_channel_to_poll(void)
> +{
> +	static int last_polled_channel;
> +	int last =3D last_polled_channel;
> +	int chan;
> +	struct tty_struct *tty =3D NULL;
> +
> +	for (chan =3D last + 1; ; ++chan) {
> +		if (chan >=3D NUM_TTY_CHANNELS)
> +			chan =3D 0;
> +
> +		tty =3D tty_port_tty_get(&dashtty_ports[chan].port);
> +		if (tty) {
> +			last_polled_channel =3D chan;
> +			return tty;
> +		}
> +
> +		if (chan =3D=3D last)
> +			break;
> +	}
> +	return tty;
> +}
> +
> +/**
> + * put_channel_data() - Write out a block of channel data.
> + * @chan:	DA channel number.
> + *
> + * Write a single block of data out to the debug adapter. If the circu=
lar buffer
> + * is wrapped then only the first block is written.
> + *
> + * Returns:	1 if the remote buffer was too full to accept data.
> + *		0 otherwise.
> + */
> +static int put_channel_data(unsigned int chan)
> +{
> +	struct dashtty_port *dport;
> +	struct tty_struct *tty;
> +	int number_written;
> +	unsigned int count =3D 0;
> +
> +	dport =3D &dashtty_ports[chan];
> +	mutex_lock(&dport->xmit_lock);
> +	if (dport->xmit_cnt) {
> +		count =3D min((unsigned int)(SERIAL_XMIT_SIZE - dport->xmit_tail),
> +			    dport->xmit_cnt);
> +		chancall(WRBUF, chan, count,
> +			 dport->port.xmit_buf + dport->xmit_tail,
> +			 &number_written);
> +		dport->xmit_cnt -=3D number_written;
> +		if (!dport->xmit_cnt) {
> +			/* reset pointers to avoid wraps */
> +			dport->xmit_head =3D 0;
> +			dport->xmit_tail =3D 0;
> +			complete(&dport->xmit_empty);
> +		} else {
> +			dport->xmit_tail +=3D number_written;
> +			if (dport->xmit_tail >=3D SERIAL_XMIT_SIZE)
> +				dport->xmit_tail -=3D SERIAL_XMIT_SIZE;
> +		}
> +		atomic_sub(number_written, &dashtty_xmit_cnt);
> +	}
> +	mutex_unlock(&dport->xmit_lock);
> +
> +	/* if we've made more data available, wake up tty */
> +	if (count && number_written) {
> +		tty =3D tty_port_tty_get(&dport->port);
> +		if (tty) {
> +			tty_wakeup(tty);
> +			tty_kref_put(tty);
> +		}
> +	}
> +
> +	/* did the write fail? */
> +	return count && !number_written;
> +}
> +
> +/**
> + * put_data() - Kernel thread to write out blocks of channel data to D=
A.
> + * @arg:	Unused.
> + *
> + * This kernel thread runs while @dashtty_xmit_cnt !=3D 0, and loops o=
ver the
> + * channels to write out any buffered data. If any of the channels sta=
ll due to
> + * the remote buffer being full, a hold off happens to allow the debug=
ger to
> + * drain the buffer.
> + */
> +static int put_data(void *arg)
> +{
> +	unsigned int chan, stall;
> +
> +	__set_current_state(TASK_RUNNING);
> +	while (!kthread_should_stop()) {
> +		/*
> +		 * For each channel see if there's anything to transmit in the
> +		 * port's xmit_buf.
> +		 */
> +		stall =3D 0;
> +		for (chan =3D 0; chan < NUM_TTY_CHANNELS; ++chan)
> +			stall +=3D put_channel_data(chan);
> +
> +		/*
> +		 * If some of the buffers are full, hold off for a short while
> +		 * to allow them to empty.
> +		 */
> +		if (stall)
> +			msleep(25);
> +
> +		wait_event_interruptible(dashtty_waitqueue,
> +					 atomic_read(&dashtty_xmit_cnt));
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + *	This gets called every DA_TTY_POLL and polls the channels for data
> + */
> +static void dashtty_timer(unsigned long ignored)
> +{
> +	struct tty_struct *tty;
> +
> +	/* If there are no ports open do nothing and don't poll again. */
> +	if (!atomic_read(&num_channels_need_poll))
> +		return;
> +
> +	tty =3D find_channel_to_poll();
> +
> +	/* Did we find a channel to poll? */
> +	if (tty) {
> +		fetch_data(tty);
> +		tty_kref_put(tty);
> +	}
> +
> +	mod_timer_pinned(&poll_timer, jiffies + DA_TTY_POLL);
> +}
> +
> +static void add_poll_timer(struct timer_list *poll_timer)
> +{
> +	setup_timer(poll_timer, dashtty_timer, 0);
> +	poll_timer->expires =3D jiffies + DA_TTY_POLL;
> +
> +	/*
> +	 * Always attach the timer to the boot CPU. The DA channels are per-C=
PU
> +	 * so all polling should be from a single CPU.
> +	 */
> +	add_timer_on(poll_timer, 0);
> +}
> +
> +static int dashtty_port_activate(struct tty_port *port, struct tty_str=
uct *tty)
> +{
> +	struct dashtty_port *dport =3D container_of(port, struct dashtty_port=
,
> +						  port);
> +	void *rx_buf;
> +
> +	/* Allocate the buffer we use for writing data */
> +	if (tty_port_alloc_xmit_buf(port) < 0)
> +		goto err;
> +
> +	/* Allocate the buffer we use for reading data */
> +	rx_buf =3D kzalloc(RX_BUF_SIZE, GFP_KERNEL);
> +	if (!rx_buf)
> +		goto err_free_xmit;
> +
> +	spin_lock_bh(&dport->rx_lock);
> +	dport->rx_buf =3D rx_buf;
> +	spin_unlock_bh(&dport->rx_lock);
> +
> +	/*
> +	 * Don't add the poll timer if we're opening a console. This
> +	 * avoids the overhead of polling the Dash but means it is not
> +	 * possible to have a login on /dev/console.
> +	 *
> +	 */
> +	if (dport !=3D &dashtty_ports[CONSOLE_CHANNEL])
> +		if (atomic_inc_return(&num_channels_need_poll) =3D=3D 1)
> +			add_poll_timer(&poll_timer);
> +
> +	return 0;
> +err_free_xmit:
> +	tty_port_free_xmit_buf(port);
> +err:
> +	return -ENOMEM;
> +}
> +
> +static void dashtty_port_shutdown(struct tty_port *port)
> +{
> +	struct dashtty_port *dport =3D container_of(port, struct dashtty_port=
,
> +						  port);
> +	void *rx_buf;
> +	unsigned int count;
> +
> +	/* stop reading */
> +	if (dport !=3D &dashtty_ports[CONSOLE_CHANNEL])
> +		if (atomic_dec_and_test(&num_channels_need_poll))
> +			del_timer_sync(&poll_timer);
> +
> +	mutex_lock(&dport->xmit_lock);
> +	count =3D dport->xmit_cnt;
> +	mutex_unlock(&dport->xmit_lock);
> +	if (count) {
> +		/*
> +		 * There's still data to write out, so wake and wait for the
> +		 * writer thread to drain the buffer.
> +		 */
> +		del_timer(&put_timer);
> +		wake_up_interruptible(&dashtty_waitqueue);
> +		wait_for_completion(&dport->xmit_empty);
> +	}
> +
> +	/* Null the read buffer (timer could still be running!) */
> +	spin_lock_bh(&dport->rx_lock);
> +	rx_buf =3D dport->rx_buf;
> +	dport->rx_buf =3D NULL;
> +	spin_unlock_bh(&dport->rx_lock);
> +	/* Free the read buffer */
> +	kfree(rx_buf);
> +
> +	/* Free the write buffer */
> +	tty_port_free_xmit_buf(port);
> +}
> +
> +static const struct tty_port_operations dashtty_port_ops =3D {
> +	.activate	=3D dashtty_port_activate,
> +	.shutdown	=3D dashtty_port_shutdown,
> +};
> +
> +static int dashtty_install(struct tty_driver *driver, struct tty_struc=
t *tty)
> +{
> +	return tty_port_install(&dashtty_ports[tty->index].port, driver, tty)=
;
> +}
> +
> +static int dashtty_open(struct tty_struct *tty, struct file *filp)
> +{
> +	return tty_port_open(tty->port, tty, filp);
> +}
> +
> +static void dashtty_close(struct tty_struct *tty, struct file *filp)
> +{
> +	return tty_port_close(tty->port, tty, filp);
> +}
> +
> +static void dashtty_hangup(struct tty_struct *tty)
> +{
> +	int channel;
> +	struct dashtty_port *dport;
> +
> +	channel =3D tty->index;
> +	dport =3D &dashtty_ports[channel];
> +
> +	/* drop any data in the xmit buffer */
> +	mutex_lock(&dport->xmit_lock);
> +	if (dport->xmit_cnt) {
> +		atomic_sub(dport->xmit_cnt, &dashtty_xmit_cnt);
> +		dport->xmit_cnt =3D 0;
> +		dport->xmit_head =3D 0;
> +		dport->xmit_tail =3D 0;
> +		complete(&dport->xmit_empty);
> +	}
> +	mutex_unlock(&dport->xmit_lock);
> +
> +	tty_port_hangup(tty->port);
> +}
> +
> +/**
> + * dashtty_put_timer() - Delayed wake up of kernel thread.
> + * @ignored:	unused
> + *
> + * This timer function wakes up the kernel thread if any data exists i=
n the
> + * buffers. It is used to delay the expensive writeout until the write=
r has
> + * stopped writing.
> + */
> +static void dashtty_put_timer(unsigned long ignored)
> +{
> +	if (atomic_read(&dashtty_xmit_cnt))
> +		wake_up_interruptible(&dashtty_waitqueue);
> +}
> +
> +static int dashtty_write(struct tty_struct *tty, const unsigned char *=
buf,
> +			 int total)
> +{
> +	int channel, count, block;
> +	struct dashtty_port *dport;
> +
> +	/* Determine the channel */
> +	channel =3D tty->index;
> +	dport =3D &dashtty_ports[channel];
> +
> +	/*
> +	 * Write to output buffer.
> +	 *
> +	 * The reason that we asynchronously write the buffer is because if w=
e
> +	 * were to write the buffer synchronously then because DA channels ar=
e
> +	 * per-CPU the buffer would be written to the channel of whatever CPU=

> +	 * we're running on.
> +	 *
> +	 * What we actually want to happen is have all input and output done =
on
> +	 * one CPU.
> +	 */
> +	mutex_lock(&dport->xmit_lock);
> +	/* work out how many bytes we can write to the xmit buffer */
> +	total =3D min(total, (int)(SERIAL_XMIT_SIZE - dport->xmit_cnt));
> +	atomic_add(total, &dashtty_xmit_cnt);
> +	dport->xmit_cnt +=3D total;
> +	/* write the actual bytes (may need splitting if it wraps) */
> +	for (count =3D total; count; count -=3D block) {
> +		block =3D min(count, (int)(SERIAL_XMIT_SIZE - dport->xmit_head));
> +		memcpy(dport->port.xmit_buf + dport->xmit_head, buf, block);
> +		dport->xmit_head +=3D block;
> +		if (dport->xmit_head >=3D SERIAL_XMIT_SIZE)
> +			dport->xmit_head -=3D SERIAL_XMIT_SIZE;
> +		buf +=3D block;
> +	}
> +	count =3D dport->xmit_cnt;
> +	/* xmit buffer no longer empty? */
> +	if (count)
> +		INIT_COMPLETION(dport->xmit_empty);
> +	mutex_unlock(&dport->xmit_lock);
> +
> +	if (total) {
> +		/*
> +		 * If the buffer is full, wake up the kthread, otherwise allow
> +		 * some more time for the buffer to fill up a bit before waking
> +		 * it.
> +		 */
> +		if (count =3D=3D SERIAL_XMIT_SIZE) {
> +			del_timer(&put_timer);
> +			wake_up_interruptible(&dashtty_waitqueue);
> +		} else {
> +			mod_timer(&put_timer, jiffies + DA_TTY_PUT_DELAY);
> +		}
> +	}
> +	return total;
> +}
> +
> +static int dashtty_write_room(struct tty_struct *tty)
> +{
> +	struct dashtty_port *dport;
> +	int channel;
> +	int room;
> +
> +	channel =3D tty->index;
> +	dport =3D &dashtty_ports[channel];
> +
> +	/* report the space in the xmit buffer */
> +	mutex_lock(&dport->xmit_lock);
> +	room =3D SERIAL_XMIT_SIZE - dport->xmit_cnt;
> +	mutex_unlock(&dport->xmit_lock);
> +
> +	return room;
> +}
> +
> +static int dashtty_chars_in_buffer(struct tty_struct *tty)
> +{
> +	struct dashtty_port *dport;
> +	int channel;
> +	int chars;
> +
> +	channel =3D tty->index;
> +	dport =3D &dashtty_ports[channel];
> +
> +	/* report the number of bytes in the xmit buffer */
> +	mutex_lock(&dport->xmit_lock);
> +	chars =3D dport->xmit_cnt;
> +	mutex_unlock(&dport->xmit_lock);
> +
> +	return chars;
> +}
> +
> +static const struct tty_operations dashtty_ops =3D {
> +	.install		=3D dashtty_install,
> +	.open			=3D dashtty_open,
> +	.close			=3D dashtty_close,
> +	.hangup			=3D dashtty_hangup,
> +	.write			=3D dashtty_write,
> +	.write_room		=3D dashtty_write_room,
> +	.chars_in_buffer	=3D dashtty_chars_in_buffer,
> +};
> +
> +static int __init dashtty_init(void)
> +{
> +	int ret;
> +	int nport;
> +	struct dashtty_port *dport;
> +
> +	if (!metag_da_enabled())
> +		return -ENODEV;
> +
> +	channel_driver =3D tty_alloc_driver(NUM_TTY_CHANNELS,
> +					  TTY_DRIVER_REAL_RAW);
> +	if (IS_ERR(channel_driver))
> +		return PTR_ERR(channel_driver);
> +
> +	channel_driver->driver_name =3D "metag_da";
> +	channel_driver->name =3D "ttyDA";
> +	channel_driver->major =3D DA_TTY_MAJOR;
> +	channel_driver->minor_start =3D 0;
> +	channel_driver->type =3D TTY_DRIVER_TYPE_SERIAL;
> +	channel_driver->subtype =3D SERIAL_TYPE_NORMAL;
> +	channel_driver->init_termios =3D tty_std_termios;
> +	channel_driver->init_termios.c_cflag |=3D CLOCAL;
> +
> +	tty_set_operations(channel_driver, &dashtty_ops);
> +	for (nport =3D 0; nport < NUM_TTY_CHANNELS; nport++) {
> +		dport =3D &dashtty_ports[nport];
> +		tty_port_init(&dport->port);
> +		dport->port.ops =3D &dashtty_port_ops;
> +		spin_lock_init(&dport->rx_lock);
> +		mutex_init(&dport->xmit_lock);
> +		/* the xmit buffer starts empty, i.e. completely written */
> +		init_completion(&dport->xmit_empty);
> +		complete(&dport->xmit_empty);
> +	}
> +
> +	setup_timer(&put_timer, dashtty_put_timer, 0);
> +
> +	init_waitqueue_head(&dashtty_waitqueue);
> +	dashtty_thread =3D kthread_create(put_data, NULL, "ttyDA");
> +	if (IS_ERR(dashtty_thread)) {
> +		pr_err("Couldn't create dashtty thread\n");
> +		ret =3D PTR_ERR(dashtty_thread);
> +		goto err_destroy_ports;
> +	}
> +	/*
> +	 * Bind the writer thread to the boot CPU so it can't migrate.
> +	 * DA channels are per-CPU and we want all channel I/O to be on a sin=
gle
> +	 * predictable CPU.
> +	 */
> +	kthread_bind(dashtty_thread, 0);
> +	wake_up_process(dashtty_thread);
> +
> +	ret =3D tty_register_driver(channel_driver);
> +
> +	if (ret < 0) {
> +		pr_err("Couldn't install dashtty driver: err %d\n",
> +		       ret);
> +		goto err_stop_kthread;
> +	}
> +
> +	return 0;
> +
> +err_stop_kthread:
> +	kthread_stop(dashtty_thread);
> +err_destroy_ports:
> +	for (nport =3D 0; nport < NUM_TTY_CHANNELS; nport++) {
> +		dport =3D &dashtty_ports[nport];
> +		tty_port_destroy(&dport->port);
> +	}
> +	put_tty_driver(channel_driver);
> +	return ret;
> +}
> +
> +static void dashtty_exit(void)
> +{
> +	int nport;
> +	struct dashtty_port *dport;
> +
> +	del_timer_sync(&put_timer);
> +	kthread_stop(dashtty_thread);
> +	del_timer_sync(&poll_timer);
> +	tty_unregister_driver(channel_driver);
> +	for (nport =3D 0; nport < NUM_TTY_CHANNELS; nport++) {
> +		dport =3D &dashtty_ports[nport];
> +		tty_port_destroy(&dport->port);
> +	}
> +	put_tty_driver(channel_driver);
> +}
> +
> +module_init(dashtty_init);
> +module_exit(dashtty_exit);
> +
> +#ifdef CONFIG_DA_CONSOLE
> +
> +static void dash_console_write(struct console *co, const char *s,
> +			       unsigned int count)
> +{
> +	int actually_written;
> +
> +	chancall(WRBUF, CONSOLE_CHANNEL, count, (void *)s, &actually_written)=
;
> +}
> +
> +static struct tty_driver *dash_console_device(struct console *c, int *=
index)
> +{
> +	*index =3D c->index;
> +	return channel_driver;
> +}
> +
> +struct console dash_console =3D {
> +	.name =3D "ttyDA",
> +	.write =3D dash_console_write,
> +	.device =3D dash_console_device,
> +	.flags =3D CON_PRINTBUFFER,
> +	.index =3D 1,
> +};
> +
> +#endif
>=20


--------------enigD873AC0DC7897DD50441CA6B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRAm5bAAoJEKHZs+irPybfPWEP/RJ0KJS/IIbSPMLgUeaweG7d
ZS8+aJAblgFXO43toOUEQOav1Nbuj6OIyGrh8Z+5yS46C9hkW7YTp2fR7gvJPGab
UKm67JMsLr5iyomqX5XQFgo/wVwMMb2ev9XeDFeZUUyOR6FP7uLeyr4wmOfYNKMW
pr2KjCCohZQ5R4DidxH8P2oodHSfSxtZS3Y3w/TJxXwzT6TPMqpoD23IUfYJOhdW
Gh109wg09Uq/9DRLQMRj043kbkf9ZaEYwmJWTuy5382jYf9jVQVgPy0aLsgD7wDJ
LYRDRLBk+sLc18llanwlHvB7cRYtTrhs4ev5khCSc9Ftm1E2jNxk+qhYSGd8lY/8
DkY4D1rBWWl12L5HPquiosHMSMdHJWCmUCavil8hrGY1l1rpgWLvEpt/wFDNPIQj
0TlgqrK/LtswHQafWz0sIdx8GrWJjyAmknoLDYqsbj3BX3nwqvG1bbmqhiJGmLp3
0b+EShUIemnPDS6wPHDOB8+oBkoV+zVJWoz8QqhWOYnwtysE7EpGgQPfaVhDxKi2
MIMUordfA6S9pYutHAFbhnY2thmJO+a59YK43n3KohRvFNObCp/SAGyJc7eVHzU8
XLamB6Rcmo79sC1n+XkU6FvyaI2uiWTYgtg/kfyRLWfDMd6JHlz20I7arXHkCdk3
GtLbDr/Xyd5YupC4/HZC
=1jFx
-----END PGP SIGNATURE-----

--------------enigD873AC0DC7897DD50441CA6B--

