Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3I0SxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:53:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab3I0SxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:53:17 -0400
Message-ID: <5245D414.1020002@suse.com>
Date: Fri, 27 Sep 2013 14:53:08 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: fix race with open trace files and directory
 removal
References: <52425444.204@suse.com> <x49k3i2ds1a.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49k3i2ds1a.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="aehAKUX6EBPpWeSujOqAXFijjrBvNB3fc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aehAKUX6EBPpWeSujOqAXFijjrBvNB3fc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/27/13 2:43 PM, Jeff Moyer wrote:
> Jeff Mahoney <jeffm@suse.com> writes:
>=20
>> There's a bug in the blktrace client where it will stop and tear down
>> all of the tracing instances for devices it's opened whether it
>> successfully completed the setup or not.
>>
>> By starting multiple blktrace processes on the same device, it's possi=
ble
>> to permanently disable blktrace on that device. The cause is that when=

>> the first blktrace process to exit tears down the directory structure,=

>> the trace files are still held open. Debugfs removes the dentries for =
the
>> open files just fine but the relay implementation doesn't remove the
>> dentries until all of the references to the file are dropped. This mea=
ns
>> that if there are open files when debugfs_remove is called for the dev=
ice
>> directory, the directory is not empty and can't be removed. Since the
>> shutdown of the blktrace structure xchg's the structure out, there's n=
o
>> way to clean up the directory and any new blktrace processes will fail=

>> to start because it can't create the directory.
>>
>> This patch adds a kref to blk_trace so that we can release it after th=
e
>> initial reference as well as all of the references accumulated by the
>> relay files are dropped.
>=20
> Can't we just do proper unwinding of errors in the do_blktrace_setup
> function?  In other words, don't just blindly call blk_trace_free, but
> instead just undo anything we've done.

No. It's not the setup that's causing the problem. It's one process
holding the trace files open while another process calls BLKTRACETEARDOWN=
=2E

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--aehAKUX6EBPpWeSujOqAXFijjrBvNB3fc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSRdQXAAoJEB57S2MheeWyPj4P/3wowKcKS4+8jvRa0nMweH6T
NsYE8xT1ijwvv+zh88skLKtCobr1biglixmo8acoOEAI+j2EmVXXxEq4upnzvp0I
8c8kE76JCfie1xyut8wcE6DAAAfqQKqIX/tpl14CWmV6HN1cEoo0B9qE/J/77vg/
+K0cEe2qOcerDYbuyWd7MREHAX/F0xXQSkrZbsVI51vb82Sx8mPzA2RVfp8Wrftm
qUs3al0sUUjtG6AR4JezNfurNcSVvrBkcO58aA9mmOKxM25GQelSMsqb9poSZF8T
NUEnEfRU9UQWaRR1QWaUcSfjstF7psN96LE6b/LKxNXJdAx9y8Rst9RK/i2Azhq9
1Kg3v7eERQ9gI4sP7EBa2enaa4vfh+YZpT7DkB+lMrymPgYVQ7016ujWgzCTjjSz
ZsLAc6aeHqJ9gCH0PvYKBZ9dFvSslBHmMdv2QbvO2E7GT56HiUPQ8QWaSsvV6jhS
HoY8nZprs5lUAGGoqLPpxqKxNET+ol+UP0ZEJwhNJtUcuh9IOGI/Zduilhf/Ws51
9QDXJ3jDswTxOQmQrS6YmeS1L50unCsLrfXTx7lFKnESWnxAgUipSB/Qm/SNbpCW
TKC1FJZ13Dye6S8c/nqagEeRsWacZockq3e+G7qwYYeezFxMHd9gSlTtCPKTpKam
OJfdbRqJwhmjbAUwvgyY
=2MWz
-----END PGP SIGNATURE-----

--aehAKUX6EBPpWeSujOqAXFijjrBvNB3fc--
