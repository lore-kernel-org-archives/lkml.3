Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaKLL05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:26:57 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43258 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaKLL0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:26:55 -0500
Date: Wed, 12 Nov 2014 12:26:49 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Giedrius Statkevicius <giedriuswork@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, martink@posteo.de,
        linux-kernel@vger.kernel.org
Subject: Re: [Bisected] Regression: cpu stuck in gvfsd-fuse, can't shutdown
Message-ID: <20141112112643.GA30821@ulmo.nvidia.com>
References: <5462713F.4080406@gmail.com>
 <20141111210506.GA26119@kroah.com>
 <5462833A.5050706@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <5462833A.5050706@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2014 at 11:44:26PM +0200, Giedrius Statkevicius wrote:
> On 2014.11.11 23:05, Greg KH wrote:
> >=20
> > If you revert this patch, does things go back to "normal" for you?
>=20
> Originally I've only tested where the HEAD was
> 32eca22180804f71b06b63fd29b72f58be8b3c47 versus
> 32eca22180804f71b06b63fd29b72f58be8b3c47~1 but now I recompiled and
> tested a vanilla 3.18.0-rc4-next-20141111 on which this issue occurs and
> then tried a version with that particular patch reverted and then no
> lockups happen.

I've run into this same issue with sshfs:

[   49.231095] BUG: spinlock bad magic on CPU#1, sshfs/180
[   49.239078]  lock: fuse_miscdevice+0x0/0x24, .magic: c09ce64c, .owner: /=
0, .owner_cpu: -1065526976
[   49.248551] CPU: 1 PID: 180 Comm: sshfs Not tainted 3.18.0-rc4-next-2014=
1111-00275-g3eeaa958e58c-dirty #2654
[   49.258443] [<c00161f8>] (unwind_backtrace) from [<c0011a88>] (show_stac=
k+0x10/0x14)
[   49.266269] [<c0011a88>] (show_stack) from [<c07b50b4>] (dump_stack+0x98=
/0xd8)
[   49.273618] [<c07b50b4>] (dump_stack) from [<c0068670>] (do_raw_spin_loc=
k+0x1a4/0x1a8)
[   49.281621] [<c0068670>] (do_raw_spin_lock) from [<c022a0f0>] (fuse_dev_=
release+0x1c/0x68)
[   49.289900] [<c022a0f0>] (fuse_dev_release) from [<c00f5078>] (__fput+0x=
80/0x1c8)
[   49.297470] [<c00f5078>] (__fput) from [<c003fc38>] (task_work_run+0xb4/=
0xec)
[   49.304700] [<c003fc38>] (task_work_run) from [<c001140c>] (do_work_pend=
ing+0xa0/0xc0)
[   49.312712] [<c001140c>] (do_work_pending) from [<c000e5e0>] (work_pendi=
ng+0xc/0x20)
[   49.701449] BUG: spinlock lockup suspected on CPU#1, sshfs/180
[   49.707327]  lock: fuse_miscdevice+0x0/0x24, .magic: c09ce64c, .owner: /=
0, .owner_cpu: -1065526976
[   49.716341] CPU: 1 PID: 180 Comm: sshfs Not tainted 3.18.0-rc4-next-2014=
1111-00275-g3eeaa958e58c-dirty #2654
[   49.726238] [<c00161f8>] (unwind_backtrace) from [<c0011a88>] (show_stac=
k+0x10/0x14)
[   49.734051] [<c0011a88>] (show_stack) from [<c07b50b4>] (dump_stack+0x98=
/0xd8)
[   49.741293] [<c07b50b4>] (dump_stack) from [<c00685c8>] (do_raw_spin_loc=
k+0xfc/0x1a8)
[   49.749178] [<c00685c8>] (do_raw_spin_lock) from [<c022a0f0>] (fuse_dev_=
release+0x1c/0x68)
[   49.757508] [<c022a0f0>] (fuse_dev_release) from [<c00f5078>] (__fput+0x=
80/0x1c8)
[   49.765058] [<c00f5078>] (__fput) from [<c003fc38>] (task_work_run+0xb4/=
0xec)
[   49.772264] [<c003fc38>] (task_work_run) from [<c001140c>] (do_work_pend=
ing+0xa0/0xc0)
[   49.780197] [<c001140c>] (do_work_pending) from [<c000e5e0>] (work_pendi=
ng+0xc/0x20)

Reverting 32eca2218080 ("misc: always assign miscdevice to file->
private_data in open()") fixes the issue for me.

Looking at the stacktrace and correlating to the code, what happens is
that fuse_fill_super() checks that file->private_data hasn't been set
yet and errors out otherwise. Clearly this is what the misc_open()
change in the above commit triggers.

The BUG ensuing from that comes from the fact that the error cleanup
path assumes that if file->private_data is set, it will be a struct
fuse_conn *, so it's not a surprise that fuse_dev_release() will fail
as above.

The root of the issue is that the assumption in the above commit, that
drivers will always overwrite ->private_data, isn't true at least in
case of FUSE.

Thierry

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUY0PzAAoJEN0jrNd/PrOhDgAP/3+H7oBTUD98bNUviePQVtsT
Iw+BdTfL4ZyU4RLCTYGh7WHxTs8YYZYQwocMhLS+2RDIIqKaKrlX8Uu9aHjI1VN8
833t/34nPs1vWz7kNTs6HIznF5I1j3PWWh+oGOZ9aTcrbQBn6acqKHm0M/D7wzcb
d+k6SUAaierdET435L83321Ahph7SMqlvG4h636NrrXhOt/O4GKxY8uuB0gs48EK
suUnvvbH8l3czhibk3husVT6mrtGc+om5opeQrTpnWeITr9Tlz9PYqfn7rMYEOkY
7OEIekBHDldMG+wfAIrJCXcastWFXW/T0L7lRTZoB5LyWG2KoY6Ya5ULFLB3CcKC
/m5xGi5OWKUTng3EciHtwkeJZIp2G4O5rzdhbNbkomdkaBJKVTubsRZa1w+ZRLhR
5dqzSobBZojakVUqSHuay2KP0Qy2wZxhIrt8BulCFEgHE7v/MKLHvriHUItYabnu
YqQCqufpYBA33W1HlaEnU/G+ny7VK9XHhZ0mf+cDz8fnisOIp9KIJxFJh1nQQAZJ
s1k0NbeJml+NsvMyEF2lX/86JUyF95Z+yZrRB6y4BSGgNJZkouk2SSVy/qum04rx
UpkV7uiPpQHMp861wAitwijETzijTOBAD0Jbk5zvlfVsIgJK9zRXiKJlYVFp4E/A
T8mIeGo4i+qpoXXlHPGu
=9/w9
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
