Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3AKKuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:50:39 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56912 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab3AKKuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:50:37 -0500
Message-ID: <50EFEE71.4000706@imgtec.com>
Date: Fri, 11 Jan 2013 10:50:25 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 43/44] tty/metag_da: Add metag DA TTY driver
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <1357831872-29451-44-git-send-email-james.hogan@imgtec.com> <50EEE642.20608@suse.cz>
In-Reply-To: <50EEE642.20608@suse.cz>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig4907F30B01C16AA7EB280313"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_11_10_50_32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig4907F30B01C16AA7EB280313
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On 10/01/13 16:03, Jiri Slaby wrote:
> Hi, few comments/questions below.
>=20
> On 01/10/2013 04:31 PM, James Hogan wrote:
>> --- /dev/null
>> +++ b/drivers/tty/metag_da.c
>> @@ -0,0 +1,696 @@
> ...
>> +struct dashtty_port {
>> +	struct tty_port		 port;
>> +	spinlock_t		 rx_lock;
>> +	void			*rx_buf;
>> +	struct mutex		 xmit_lock;
>> +	unsigned int		 xmit_cnt;
>> +	unsigned int		 xmit_head;
>> +	unsigned int		 xmit_tail;
>> +	struct completion	 xmit_empty;
>> +};
>> +
>> +static struct dashtty_port dashtty_ports[NUM_TTY_CHANNELS];
>=20
>> +static int chancall(int bios_function, int channel, int arg2, void *a=
rg3,
>> +			void *arg4)
>> +{
>> +	register int   bios_function__ __asm__("D1Ar1") =3D bios_function;
>> +	register int   channel__       __asm__("D0Ar2") =3D channel;
>> +	register int   arg2__          __asm__("D1Ar3") =3D arg2;
>> +	register void *arg3__          __asm__("D0Ar4") =3D arg3;
>> +	register void *arg4__          __asm__("D1Ar5") =3D arg4;
>> +	register int   bios_call       __asm__("D0Ar6") =3D 3;
>> +	register int   result          __asm__("D0Re0");
>=20
> This is really ugly. Couldn't it be specified in the asm's constraints
> below?

Unfortunately not. There aren't any constraints for these individual
registers. It could be made to use u64's with shifting and add/or'ing
but then the generated code is pretty bad. Using struct {int lo,hi;}'s
produces better code (none of the registers actually need moving from
their argument positions) but honestly isn't any less ugly.

>=20
>> +	__asm__ volatile (
>> +		"SETL   [A0StP++], %6,%5\n\t"
>> +		"SETL   [A0StP++], %4,%3\n\t"
>> +		"SETL   [A0StP++], %2,%1\n\t"

Using specific registers also allows these three to be combined into a
single MSETL instruction... I'll do that.

>> +		"ADD    A0StP, A0StP, #8\n\t"
>> +		"SWITCH #0x0C30208\n\t"
>> +		"GETD   %0, [A0StP+#-8]\n\t"
>> +		"SUB    A0StP, A0StP, #(4*6)+8\n\t"
>> +		: "=3Dr" (result)/* outs */
>> +		: "r" (bios_function__), "r" (channel__), "r" (arg2__),
>> +		  "r" (arg3__), "r" (arg4__), "r" (bios_call) /* ins */
>> +		: "memory");
>> +
>> +	return result;
>> +}
> ...
>> +static int dashtty_port_activate(struct tty_port *port, struct tty_st=
ruct *tty)
>> +{
>> +	struct dashtty_port *dport =3D container_of(port, struct dashtty_por=
t,
>> +						  port);
>> +	void *rx_buf;
>> +
>> +	/* Allocate the buffer we use for writing data */
>> +	if (tty_port_alloc_xmit_buf(port) < 0)
>> +		goto err;
>> +
>> +	/* Allocate the buffer we use for reading data */
>> +	rx_buf =3D kzalloc(RX_BUF_SIZE, GFP_KERNEL);
>> +	if (!rx_buf)
>> +		goto err_free_xmit;
>> +
>> +	spin_lock_bh(&dport->rx_lock);
>> +	dport->rx_buf =3D rx_buf;
>> +	spin_unlock_bh(&dport->rx_lock);
>> +
>> +	return 0;
>> +err_free_xmit:
>> +	tty_port_free_xmit_buf(port);
>> +err:
>> +	return -ENOMEM;
>> +}
>> +
>> +static void dashtty_port_shutdown(struct tty_port *port)
>> +{
>> +	struct dashtty_port *dport =3D container_of(port, struct dashtty_por=
t,
>> +						  port);
>> +	void *rx_buf;
>> +	unsigned int count;
>> +
>> +	mutex_lock(&dport->xmit_lock);
>> +	count =3D dport->xmit_cnt;
>> +	mutex_unlock(&dport->xmit_lock);
>> +	if (count) {
>> +		/*
>> +		 * There's still data to write out, so wake and wait for the
>> +		 * writer thread to drain the buffer.
>> +		 */
>> +		del_timer(&put_timer);
>> +		wake_up_interruptible(&dashtty_waitqueue);
>> +		wait_for_completion(&dport->xmit_empty);
>> +	}
>> +
>> +	/* Null the read buffer (timer could still be running!) */
>> +	spin_lock_bh(&dport->rx_lock);
>> +	rx_buf =3D dport->rx_buf;
>> +	dport->rx_buf =3D NULL;
>> +	spin_unlock_bh(&dport->rx_lock);
>> +	/* Free the read buffer */
>> +	kfree(rx_buf);
>> +
>> +	/* Free the write buffer */
>> +	tty_port_free_xmit_buf(port);
>> +}
>> +
>> +static const struct tty_port_operations dashtty_port_ops =3D {
>> +	.activate	=3D dashtty_port_activate,
>> +	.shutdown	=3D dashtty_port_shutdown,
>> +};
>> +
>> +static int dashtty_install(struct tty_driver *driver, struct tty_stru=
ct *tty)
>> +{
>> +	struct dashtty_port *port;
>> +	int ret, line;
>> +
>> +	if (!tty)
>> +		return -ENODEV;
>=20
> This will never happen.

Agreed, I thought I'd removed these but must've missed them.

>=20
>> +	line =3D tty->index;
>> +
>> +	if (line < 0 || line >=3D NUM_TTY_CHANNELS)
>> +		return -ENODEV;
>=20
> Neither this.

Agreed.

>=20
>> +	port =3D &dashtty_ports[line];
>> +
>> +	port->port.ops =3D &dashtty_port_ops;
>=20
> You can do that along with tty_port_init in the module_init function.

Yes, good idea.

>=20
>> +	ret =3D tty_port_install(&port->port, driver, tty);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/*
>> +	 * Don't add the poll timer if we're opening a console. This
>> +	 * avoids the overhead of polling the Dash but means it is not
>> +	 * possible to have a login on /dev/console.
>> +	 *
>> +	 */
>> +	if (line !=3D CONSOLE_CHANNEL)
>> +		if (atomic_inc_return(&num_channels_need_poll) =3D=3D 1)
>> +			add_poll_timer(&poll_timer);
>=20
> This should be in activate I suppose. You don't need install/cleanup at=

> all I beleive.

Yes, I've moved it in there (but with s/line !=3D CONSOLE_CHANNEL/dport !=
=3D
&dashtty_ports[CONSOLE_CHANNEL]/). That just leaves a one line install
callback which just passes the relevant tty_port to tty_port_install.

>=20
>> +	return 0;
>> +}
>> +
>> +static void dashtty_cleanup(struct tty_struct *tty)
>> +{
>> +	int line;
>> +
>> +	if (!tty)
>> +		return;
>=20
> The same as above.
>=20
>> +	line =3D tty->index;
>> +
>> +	if (line < 0 || line >=3D NUM_TTY_CHANNELS)
>> +		return;
>=20
> Detto.
>=20
>> +	if (line !=3D CONSOLE_CHANNEL)
>> +		if (atomic_dec_and_test(&num_channels_need_poll))
>> +			del_timer_sync(&poll_timer);
>=20
> To shutdown. No need for cleanup.

agreed, done.

>> +static int dashtty_write_room(struct tty_struct *tty)
>> +{
>> +	struct dashtty_port *dport;
>> +	int channel;
>> +	int room;
>> +
>> +	channel =3D FIRST_TTY_CHANNEL + tty->index;
>=20
> FIRST_TTY_CHANNEL doesn't make much sense. Better to be removed complet=
ely.

Agreed, I'm not sure what this was originally for but I've removed it now=
=2E

>=20
>> +	dport =3D &dashtty_ports[channel];
>> +
>> +	/* report the space in the xmit buffer */
>> +	mutex_lock(&dport->xmit_lock);
>> +	room =3D SERIAL_XMIT_SIZE - dport->xmit_cnt;
>> +	mutex_unlock(&dport->xmit_lock);
>> +
>> +	return room;
>> +}
> ...
>> +static int __init dashtty_init(void)
>> +{
>> +	int ret;
>> +	int nport;
>> +	struct dashtty_port *dport;
>> +
>> +	if (!metag_da_enabled())
>> +		return -ENODEV;
>> +
>> +	channel_driver =3D tty_alloc_driver(NUM_TTY_CHANNELS, 0);
>=20
> This should be s/0/TTY_DRIVER_REAL_RAW/.

Neat, thanks

>=20
>> +	if (IS_ERR(channel_driver))
>> +		return PTR_ERR(channel_driver);
>> +
>> +	channel_driver->owner =3D THIS_MODULE;
>=20
> No need to set this.

Yes, I see it's passed into __tty_alloc_driver automatically.

>=20
>> +	channel_driver->driver_name =3D "ttyDA";
>=20
> This should be rather "metag".

Yes, I'll set to "metag_da" if that's okay since the transport is the
DA. I presume this is pretty much just to appear in /proc/tty/drivers?

>=20
>> +	channel_driver->name =3D "ttyDA";
>> +	channel_driver->major =3D DA_TTY_MAJOR;
>> +	channel_driver->minor_start =3D 0;
>> +	channel_driver->type =3D TTY_DRIVER_TYPE_SERIAL;
>> +	channel_driver->subtype =3D SERIAL_TYPE_NORMAL;
>> +	channel_driver->init_termios =3D tty_std_termios;
>> +	channel_driver->init_termios.c_cflag |=3D CLOCAL;
>> +	channel_driver->flags =3D TTY_DRIVER_REAL_RAW;
>=20
> And this is unnecessary now.
>=20
>> +
>> +	tty_set_operations(channel_driver, &dashtty_ops);
>> +	for (nport =3D 0; nport < NUM_TTY_CHANNELS; nport++) {
>> +		dport =3D &dashtty_ports[nport];
>> +		tty_port_init(&dport->port);
>> +		spin_lock_init(&dport->rx_lock);
>> +		mutex_init(&dport->xmit_lock);
>> +		/* the xmit buffer starts empty, i.e. completely written */
>> +		init_completion(&dport->xmit_empty);
>> +		complete(&dport->xmit_empty);
>> +	}
>> +
>> +	init_timer(&put_timer);
>> +	put_timer.function =3D dashtty_put_timer;
>=20
> setup_timer()

Thanks, I've also changed the other timer to use this too

>=20
>> +	init_waitqueue_head(&dashtty_waitqueue);
>> +	dashtty_thread =3D kthread_create(put_data, NULL, "ttyDA");
>> +	if (IS_ERR(dashtty_thread)) {
>> +		pr_err("Couldn't create dashtty thread\n");
>> +		ret =3D PTR_ERR(dashtty_thread);
>> +		goto err_free_driver;
>> +	}
>> +	kthread_bind(dashtty_thread, 0);
>=20
> This deserves a comment why you bind it to CPU0...

Okay, comment added:
+	/*
+	 * Bind the writer thread to the boot CPU so it can't migrate.
+	 * DA channels are per-CPU and we want all channel I/O to be on a singl=
e
+	 * predictable CPU.
+	 */

>=20
>> +	wake_up_process(dashtty_thread);
>> +
>> +	ret =3D tty_register_driver(channel_driver);
>> +
>> +	if (ret < 0) {
>> +		pr_err("Couldn't install dashtty driver: err %d\n",
>> +		       ret);
>> +		goto err_stop_kthread;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_stop_kthread:
>> +	kthread_stop(dashtty_thread);
>> +err_free_driver:
>> +	put_tty_driver(channel_driver);
>> +	return ret;
>> +}
>> +
>> +static void dashtty_exit(void)
>> +{
>> +	del_timer_sync(&put_timer);
>> +	kthread_stop(dashtty_thread);
>> +	del_timer_sync(&poll_timer);
>> +	tty_unregister_driver(channel_driver);
>> +	put_tty_driver(channel_driver);
>=20
> No tty_port_destroy anywhere?

Ah yes, I've added a loop to do this before put_tty_driver() both here
and in the error handling of dashtty_init().

This driver isn't actually buildable as a module at the moment, but if
it was, would the module owner being set ensure that the ttys/ports are
closed down prior to dashtty_exit being called? (i.e. is it racy?)

>=20
>> +}
>> +
>> +module_init(dashtty_init);
>> +module_exit(dashtty_exit);
>=20
> thanks,
>=20

Thanks for reviewing,

Cheers
James


--------------enig4907F30B01C16AA7EB280313
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7+53AAoJEKHZs+irPybfBoIQALTrqUhwxERmibxC+DVOtO7v
hCpYYWIRnoqUtv10An81dlDMg614BWmRZ3IQ9KSUIqtW4Nt4I1ajFGepUQ/XNofC
eKBuSfcycwB586xaflv6ogI+lzNmJk8xK8px82C4MugneFMRTnkXt2nRv83QcSCH
5OsZDeke39U0+xzLZw1izJnd3QgLihSQaRSXdFVXd5Nk+QXbQaFYfP0UpNZf69LG
8Nf2Gswz0/U5GKSW4JhC8mM/TDPzTl1RV691shLe5Abf4v8GVL0utKoyTF8gijTf
pN67dSmm6TjcAbDgFDkcm+TB/wQq1NHxcxEC1GZ3w7O8dhD8MEQwl93C70aALxaN
ewmQLACjX1FuXQ9wD9Ut2lnP40cDuTu88905HHUlg2cvAxN08fLxAodFlsamL1Ar
R4/Fyc4mRwGgUZrU1rTWZupDhs/q35WfcNy+doZXHYLn3+abF/yAAMpgXx28Ffu8
7jSf4MplaQDxMNvKHjE18AOMT34SUrFCDKU0GMrnE2DKOD3xa+pFCuBl35kqnBFp
kvbcwElIp9BgouVJchkH3HuhnQPrYMTS7ExIU0Dd3rmg4WZ6D8aZRbbDKnMPoSi8
QPi04EDs9BZwlDit6HBf7lyVWoulT84KMEXXWrVwiBcwG+gaZCZEdf+wGgItoYMq
hQjSRLtDhm8CTKYduEzf
=g2Ta
-----END PGP SIGNATURE-----

--------------enig4907F30B01C16AA7EB280313--

