Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaBRUd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:33:57 -0500
Received: from sauhun.de ([89.238.76.85]:44396 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaBRUdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:33:54 -0500
Date: Tue, 18 Feb 2014 21:33:46 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: David Howells <dhowells@redhat.com>
Cc: wolfram@the-dreams.de, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: Add message transfer tracepoints for I2C
Message-ID: <20140218203346.GG18768@katana>
References: <20140109214954.25590.73057.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5UGlQXeG3ziZS81+"
Content-Disposition: inline
In-Reply-To: <20140109214954.25590.73057.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5UGlQXeG3ziZS81+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Thu, Jan 09, 2014 at 09:49:54PM +0000, David Howells wrote:
> Add tracepoints into the I2C message transfer function to retrieve the me=
ssage
> sent or received.  The following config options must be turned on to make=
 use
> of the facility:
>=20
> 	CONFIG_FTRACE
> 	CONFIG_ENABLE_DEFAULT_TRACERS
>=20
> The I2C tracepoint can be enabled thusly:
>=20
> 	echo 1 >/sys/kernel/debug/tracing/events/i2c/i2c_transfer/enable
>=20
> and will dump messages that can be viewed in /sys/kernel/debug/tracing/tr=
ace
> that look like:
>=20
> 	... i2c_write: i2c-5 #0 f=3D00 a=3D44 l=3D2 [0214]
> 	... i2c_read: i2c-5 #1 f=3D01 a=3D44 l=3D4
> 	... i2c_reply: i2c-5 #1 f=3D01 a=3D44 l=3D4 [33000000]
> 	... i2c_result: i2c-5 n=3D2 ret=3D2
>=20
> formatted as:
>=20
> 	i2c-<adapter-nr>
> 	#<message-array-index>
> 	f=3D<flags>
> 	a=3D<addr>
> 	l=3D<datalen>
> 	n=3D<message-array-size>
> 	ret=3D<result>
> 	[<data>]
>=20
> The operation is done between the i2c_write/i2c_read lines and the i2c_re=
ply
> and i2c_result lines so that if the hardware hangs, the trace buffer can =
be
> consulted to determine the problematic operation.
>=20
> The adapters to be traced can be selected by something like:
>=20
> 	echo adapter_nr=3D=3D1 >/sys/kernel/debug/tracing/events/i2c/filter
>=20
> These changes are based on code from Steven Rostedt.
>=20
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

I like it very much, just have some comments about the format.

> +TRACE_EVENT_FN(i2c_write,
> +	       TP_PROTO(const struct i2c_adapter *adap, const struct i2c_msg *m=
sg,
> +			int num),
> +	       TP_ARGS(adap, msg, num),
> +	       TP_STRUCT__entry(
> +		       __field(int,	adapter_nr		)
> +		       __field(__u16,	msg_nr			)
> +		       __field(__u16,	addr			)
> +		       __field(__u16,	flags			)
> +		       __field(__u16,	len			)
> +		       __dynamic_array(__u8, buf, msg->len)	),
> +	       TP_fast_assign(
> +		       __entry->adapter_nr =3D adap->nr;
> +		       __entry->msg_nr =3D num;
> +		       __entry->addr =3D msg->addr;
> +		       __entry->flags =3D msg->flags;
> +		       __entry->len =3D msg->len;
> +		       memcpy(__get_dynamic_array(buf), msg->buf, msg->len);
> +			      ),
> +	       TP_printk("i2c-%d #%u f=3D%02x a=3D%02x l=3D%u [%*phN]",

'flags' are u16 and the whole range is needed -> %04x

'addr' is u16 and either 7 or 10 bits are needed. The core does the
following when assigning names because it is possible to have devices
0x50 (7-bit) and 0x050 (10-bit) on the bus:

	/* For 10-bit clients, add an arbitrary offset to avoid collisions */
	dev_set_name(&client->dev, "%d-%04x", i2c_adapter_id(adap),
		     client->addr | ((client->flags & I2C_CLIENT_TEN)
				     ? 0xa000 : 0));

I don't know if this can be implemented. Actually, I don't think it
needs to be implemented since flags are printed, too. So, with this the
10-bit case is visible and for the address simply %03x should do.

And for the buffer: %*phN is difficult to read IMO. What about %*ph? Or
%*phD at least?

Thanks,

   Wolfram


--5UGlQXeG3ziZS81+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTA8OqAAoJEBQN5MwUoCm21aYP+wShsWS00Cqe5Y3vX6g5W2Ec
dMBVo8vPQUn+ekhlyMr+k99xbF0Tqh0e5/Pmlo02VLYK8nWKZscLHm8N/2pIsbDC
HteiMk5vTvTb11KJE2pnZNipWsTq+Qy754vTIE3motioT7a/TllyR19PINDc4BxC
F1GDCGHdbTkFz0uO8AgcstFp4wmU2XkCiQxuJjunDyQ5+c+/M0Myz962PohBv1Zk
Co5WMj8X+oUZCPm7tW+Ao0/yIwj+fkuAf+EBzgutw35vekzlGjqVGmgmnQcamL6/
W1Hzdy1qzX4kqgYgBwkJVI6U0nXYSo8xbc7ukNDhQpfyLS8rRmu/uaNRNMz4U+Uc
P9hpGTHnUOzJpktzQbU44sd5QN04I0IT1nqU9GzfYZBPOpKfij8+IAz9mkA52uOp
mQrDylqWtaFzivjC7j2p5QLecunINI1L66yg00DVeFzacWKZrSfna7Q2PKYHw/8R
tXN/y/awPXKkwPdGsEKAFny/okbeRNDgPW9NFxJd48UYJaUMlDIgFf8lxWQv//kF
7S7P9Uyra3F1yznGeltQAD7XQNQcvcnpbw1pNsIg6CJyepuCOtnp6O9AqCHsplPM
uBl63e5qxhYilrxpV6WoKfz7Rn9TyQ4e8PMk5UAW8qnMLc0W4vjyrTYjs+qAWEX0
9auB1mse+7I9Vhz9YnZJ
=3bQ2
-----END PGP SIGNATURE-----

--5UGlQXeG3ziZS81+--
