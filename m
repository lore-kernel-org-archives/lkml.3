Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaEONod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:44:33 -0400
Received: from romulus.wittsend.com ([130.205.32.3]:48211 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaEONoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:44:32 -0400
Message-ID: <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Michael H.Warfield" <mhw@WittsEnd.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org
Date: Thu, 15 May 2014 09:42:17 -0400
In-Reply-To: <20140515040032.GA6702@kroah.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	 <20140515013245.GA1764@kroah.com>
	 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
	 <20140515031527.GA146352@ubuntu-hedt> <20140515040032.GA6702@kroah.com>
Organization: Thaumaturgy & Speculums Technology
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-4412cZ/3BYpMCrzRXYqo"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: s4FDgHEC026307
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-SpamScore: s
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1400766140.37134@6W2+KX8XhXZqtrDrkFFneA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4412cZ/3BYpMCrzRXYqo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-05-14 at 21:00 -0700, Greg Kroah-Hartman wrote:
> On Wed, May 14, 2014 at 10:15:27PM -0500, Seth Forshee wrote:
> > On Wed, May 14, 2014 at 10:17:31PM -0400, Michael H. Warfield wrote:
> > > > > Using devtmpfs is one possible
> > > > > solution, and it would have the added benefit of making container=
 setup
> > > > > simpler. But simply letting containers mount devtmpfs isn't suffi=
cient
> > > > > since the container may need to see a different, more limited set=
 of
> > > > > devices, and because different environments making modifications =
to
> > > > > the filesystem could lead to conflicts.
> > > > >=20
> > > > > This series solves these problems by assigning devices to user
> > > > > namespaces. Each device has an "owner" namespace which specifies =
which
> > > > > devtmpfs mount the device should appear in as well allowing prive=
leged
> > > > > operations on the device from that namespace. This defaults to
> > > > > init_user_ns. There's also an ns_global flag to indicate a device=
 should
> > > > > appear in all devtmpfs mounts.
> > >=20
> > > > I'd strongly argue that this isn't even a "problem" at all.  And, a=
s I
> > > > said at the Plumbers conference last year, adding namespaces to dev=
ices
> > > > isn't going to happen, sorry.  Please don't continue down this path=
.
> > >=20
> > > I was just mentioning that to Serge just a week or so ago reminding h=
im
> > > of what you told all of us face to face back then.  We were having a
> > > discussion over loop devices into containers and this topic came up.
> >=20
> > It was the loop device use case that got me started down this path in
> > the first place, so I don't personally have any interest in physical
> > devices right now (though I was sure others would).

> Why do you want to give access to a loop device to a container?
> Shouldn't you set up the loop devices before creating the container and
> then pass those mount points into the container?  I thought that was how
> things worked today, or am I missing something?

Ah, you keep feeding me easy ones.  I need raw access to loop devices
and loop-control because I'm using containers to build NST (Network
Security Toolkit) distribution iso images (one container is x86_64 while
the other is i686).  Each requires 2 loop devices.  You can't set up the
loop devices in advance since the containers will be creating the images
and building them.  NST tinkers with the base build engine
configuration, so I really DON'T want it running on a hard iron host.=20
There may be other cases where I need other specialized containers for
building distros.  I'm also looking at custom builds of Kali (another
security distribution).

> Giving the ability for a container to create a loop device at all is a
> horrid idea, as you have pointed out, lots of information leakage could
> easily happen.

It does but only slightly.  I noticed that losetup will list all the
devices regardless of container where run or the container where set up.
But that seems to be largely cosmetic.  You can't do anything with the
loop device in the other container.  You can't disconnected it, read it,
or mount it (I've tested it).  In the former case, losetup returns with
no error but does nothing.  In the later case, you get a busy error.
Not clean, not pretty, but no damage.  Since loop-control is working on
the global pool of loop devices, it's impossible to know what device to
move to what container when the container runs losetup.

For me, this isn't a serious problem, since it only involves 2
specialized containers out of over 4 dozen containers I have running
across 3 sites.  And those two containers are under my explicit and
exclusive control.  None of the others need it.  I can get away with
adding extra loop devices and adding them to the containers and let
losetup deal with allocation and contention.

Serge mentioned something to me about a loopdevfs (?) thing that someone
else is working on.  That would seem to be a better solution in this
particular case but I don't know much about it or where it's at.

Mind you, I heard your arguments at LinuxPlumbers regarding pushing user
space policies into the kernel and all and basically I agree with you,
this should be handled in host system user space and it seems
reasonable.  I'm just pointing out real world cases I have in operation
right now and pointing out that I have solutions for them in host user
space, even if some of them may not be estheticly pretty.

> greg k-h

Regards,
Mike
--=20
Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!


--=-4412cZ/3BYpMCrzRXYqo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU3TEOcDrlnVnRif/AQhVwwgAtBXY89svyfLFCOZsgYDDRjSswCnZzgMo
lA3zB4oK7q0GLv39Y/k1jejpqBbsDGgXUmbQTVE8NL9SfcNURpVSpqsc5IvWQRNX
6GpXeszdJVVWMzeesQQ4HfztB1e0a1NydL0ncxUmasr0dl2mypRfL5RYHyjVPlzd
AwoE99B2c3UpEKg6pif1aCVn8kuAOd9DjofHdCqw2JFv8bTjpXPQmWDZs5xZ0HDh
8OePGBk0ZqcRRLpfVAL8CLSsPYr3JkTV4juEWXGzrnmMOKsGinPlWpxspVtTcAsw
vRvzuQNSE1mqzvosgSbBLVqKOpVvWWzxEGdnQGL5RuXr/+ZNn7+3Hw==
=jzXG
-----END PGP SIGNATURE-----

--=-4412cZ/3BYpMCrzRXYqo--

