Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaE2X30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:29:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbaE2X3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:29:23 -0400
Date: Fri, 30 May 2014 01:29:19 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Ian Campbell <Ian.Campbell@citrix.com>, luto@mit.edu
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        xen-devel@lists.xenproject.org, systemd-devel@lists.freedesktop.org,
        Ian Jackson <ian.jackson@eu.citrix.com>,
        Jan Beulich <jbeulich@suse.com>, Keir Fraser <keir@xen.org>,
        Tim Deegan <tim@xen.org>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, morgan@kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v5 12/14] autoconf: xen: enable explicit preference
	option for xenstored preference
Message-ID: <20140529232918.GG26450@wotan.suse.de>
References: <1400589095-3872-1-git-send-email-mcgrof@do-not-panic.com> <1400589095-3872-13-git-send-email-mcgrof@do-not-panic.com> <1400687040.7272.28.camel@kazak.uk.xensource.com> <20140521230233.GA13289@wotan.suse.de> <1400753147.14637.10.camel@kazak.uk.xensource.com> <20140523232031.GA26450@wotan.suse.de> <1401269449.24800.7.camel@kazak.uk.xensource.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <1401269449.24800.7.camel@kazak.uk.xensource.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm cc'ing a few security folks as I'd appreciate review on the ideas here,
in particular that of a launcher idea on system to replace alternatives on =
the
ExecStart=3D line of a systemd service unit file, alternative ideas are of
course welcomed. I'm also Cc'ing systemd-devel as this subject was reviewed
a little while ago with nothing concrete being recommended but instead a few
options being now archived as possibilities. I'm looking for a bit wider
review of the approaches and recomendations.

Some general background for non xen folks: old xen requires the launch of
a daemon which implements supports of the xenstore, which is the database
that xen uses for information about guests / dom0. There are two supported
daemons, xenstored (C version) and oxenstored (Ocaml version) but they do t=
he
same thing. Right now old init lets you override which one you pick through
an environment variable on /etc/{sysconfig,default}/xencommons, the script
will use the appropriate on there. Systemd doesn't let you use variables on
the ExecStart line of a service unit file so alternatives are required.

The reason I'm being very careful here this could set a precedent and at
least for the launcher idea it'd require the usage of getenv() and execve(),
and secure alternatives for these (secure_getenv(), execve_nosecurity())
have either been merged or suggested before for Linux. The systemd discussi=
on
is only specific to Linux but if we have a launcher we could consider it for
other supported OSes. All that said I'd like proper review of the security
implications of *all* strategies but obviously in particular the launcher
idea. I want to tread carefuly before setting precedents.

Details below as we discuss the approach we can take on Xen.

On Wed, May 28, 2014 at 10:30:49AM +0100, Ian Campbell wrote:
> On Sat, 2014-05-24 at 01:20 +0200, Luis R. Rodriguez wrote:
> > On Thu, May 22, 2014 at 11:05:47AM +0100, Ian Campbell wrote:
> > > On Thu, 2014-05-22 at 01:02 +0200, Luis R. Rodriguez wrote:
> > > > > It might be reasonable for hotplugpath.sh to define
> > > > > XENSTORE_xenstored=3D/path/to/xenstored
> > > > > XENSTORE_oxenstored=3D/path/to/oxenstored
> > > > >=20
> > > > > and use the existing XENSTORED variable in sysconfig to select wh=
ich.
> > > >=20
> > > > Ah but but hotplugpath.sh is one of those automatically generated f=
iles
> > > > and after my last patch in this series they are all now shared in o=
ne
> > > > master file, config/xen-environment-scripts.in, and since the we wa=
nt
> > > > to keep script file Shell / Python agnostic checking which one is s=
et
> > > > on sysconfig is not something reasonable to do on that master file.
> > >=20
> > > Well, it must be possible to change which xenstored implementation is
> > > used by editing a single setting in /etc/{sysconfig,default}/xencommo=
ns,
> > > maybe that means more code somewhere, I don't know. idieally you would
> > > be able to say
> > > XENSTORE=3Dxenstored # C xenstore at default path
> > > XENSTORE=3Doxenstored # Ocaml xenstore at default path
> > > XENSTORE=3D/path/to/something # xenstored at some custom path.
> >=20
> > Agreed.
> >=20
> > > > My series of patches already deals with the old init and xencommons=
 script to
> > > > start xenstore, it used the hotplugpath.sh for deducing the xenstore
> > > > daemon it should use by default and switching this to rely on the s=
ysconfig
> > > > xencommons should be easy if it wasn't already dealt with there alr=
eady.
> > > >=20
> > > > For systemd though we can't use varibles on ExecStart for the proce=
ss, we
> > > > however can use environment variables. We have a few options. Fedor=
a's
> > > > approach was to use two service unit files which conflicted with ea=
ch other,
> > > > although I'm sure we can work it out by using a target unit and let=
 folks
> > > > flip it seems rather silly to me to maintain two service unit files=
 with
> > > > identical entries. Therefore in my new approach usres would have to=
 manually
> > > > edit the service file with the differnt path / binary. Another poss=
ibility
> > > > is to have a central launcher binary that just does getenv() and ex=
ecve()
> > > > on the desired binary. If this is agreeable I can work on it and it=
 could
> > > > even be shared by the old init as well.
> > >=20
> > > Which is considered the most "systemd" approach?
> >=20
> > Systemd tries to even recommend to shy away from sysconfig/default dire=
ctory for
> > stashing entries, one can set environment variables within the service =
unit itself,
> > but if we are to maintain compatiblity with old stuff relying on syscon=
fig seems
> > the reasonable and accepted way, then we'd include that file as part of=
 the
> > running environment, just as our systemd service unit files do now in t=
his series.
>=20
> I'm mostly concerned that people *not* using systemd can continue to
> use /etc/{default,sysconfig}/xencommons in the way which they are used
> to.

Ah well that is already addressed in the series of patches, I'll be sure to=
 test
flipping it with the xencommons edit on my next respin. I think in my series
the xenstored variable was assumed coming from hotplug.sh and obviously we
just want /etc/{default,sysconfig}/xencommons as expressed I just had missed
that file.

> For people who are using systemd the question is whether it is more or
> less confusing to have an unused /etc/{default,sysconfig}/xencommons
> sitting there vs. doing things in the less "systemd" way. The compromise
> is perhaps to seed the defaults from /e/{d,s}/xencommons but allow them
> to be changed in either that file or in the unit file? Is that possible?

Environment variables cannot be used to replace the binary that systemd will
execute on the ExecStart=3D line and this is why I mentioned the different
possiblities available. As it stands right now then folks would have to edit
the xenstored.service file and replace the full path of the binary to get
a different xenstore to run, and then and reboot, right now on systemd the =
file
/e/{d,s}/xencommons could only be used to get daemon environment variables,
not change the daemon. If we can live with that as a compromise in
documentation then that would require only an edit to the file
/e/{d,s}/xencommons and make sure its clear that the daemon override would
only work on legacy init and not systemd. That's another option then, so to
be clear there are these known options:

  0) *Iff* we want to loose the /e/{d,s}/xencommons behavior we just docume=
nt
     that the /e/{d,s}/xencommons override is only for legacy init and have
     folks edit the service file to change the preferred daemon. They'd
     obviously just have to reboot.

*Iff* we want to conserve the /e/{d,s}/xencommons behaviour we have a few o=
ptions:

  1) two service unit files and one target file, the downside is that the s=
ervice
     files are identical except for the ExecStart line, that seems silly th=
en
     as you'd have to maintain two files or at least once installed they'd =
be
     nearly identical.
  2) two service unit files and use an alias for the general service name,
     the same downside applies though.
  3) we implement a launcher which will getenv() and execve() the appropria=
te
     daemon. To do this we can rename the C implementation to cxenstored,
     the Ocaml daemon remain as oxenstored, and the launcher would get
     the generic name xenstored. Although I had not mentioned before I am
     making it clear now that I'd like a bit more review on this strategy
     and the reasons for it.

Options 1-2 would require no changes to other OSes. Option 3 however could
be considered for integration on other OSes. When evaluating these options
please note that any security issues with getenv() and execve() also have
to be considered in light of the current strategy for legacy init which
would rely on an environment file which allows full override on the binary.

> > More details here:
> >=20
> > http://0pointer.de/blog/projects/on-etc-sysinit.html
> >=20
> > As for dynamic use daemons, there aren't good examples but the undocume=
nted way
> > of doing this but as a per a conversation at the LF Linux Collaboration=
 summit
> > one way to deal with this is to use one service target files for defini=
ng what
> > we do, we'd have two separate service unit files for each cxenstored and
> > oxenstored, the services that need to depend on it would depend on the =
target,
> > not the actual service unit files, the user then would have to enable o=
ne or
> > the other. A sysconfig edit however would not trigger a change, which i=
s what
> > we seem to want,
>=20
> What do you mean? I don't expect editing sysconfig will automagically do
> anything, some further action would be required, and since xenstored is
> involved that further action most likely involves a reboot.

Sorry dynamic was the wrong word, what I meant was a way that would not req=
uire
a service unit change but rather an environment file much as with the legac=
y init
approach.

> Can a systemd unit "soft fail"? i.e. fail but not make a huge red
> highlighted fuss about it?

Not that I have seen documented.

> Then each of the two units could check if
> they were configured and softfail if not (expecting that the other one
> is configured). Alternatively perhaps there is some sort of pre-check
> hook which could be used to see if the unit can/should be run?

Option 1) and 2) can be used for something like this if we did not want
to have a system administrator ever involved in selectin between the two
units, but it would then require adding code on both C version of xentored
and on the ocaml oxenstored to getenv() on XENSTORED and fail to load if
it didn't match. I am not sure if two service units that claim the same
alias (option 2) would work well in a situation where one is expected
to fail though. Likewise for the target (option 1). Seems a bit hacky,
but then again so do all of these options and hence the wide review.

IMHO the launcher is the cleanest solution and my preferred strategy
provided of course all possible security concerns and any other concenrs
check out well.

  Luis

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAEBAgAGBQJTh8LOAAoJEPep4JnvMe6zaP8P/jgfsjkFM0/44CHZIa8w2rS/
XEADll5iTsP6NgnfdHDHEl27z4bMQrN7gNtSSeWQJrpUVUdWBKgzAcz/KPR8Q9YT
Ard+5Yw22DV2uJL7K2M/+ZC452WB5pdWGOnXS7hPdpng14tWEa+C4B/CdPctWj06
M7yr/v2Cyv+qq/iwul98gRoGt7UkBjWiwmt5yHEuHXCguhlm4NB1pG4h2ND+2YLX
s2vFY6VwBwAAQ92INRKvjLAS4Z2sTXu6xPBSi1UMwMcNLMW0GeHjaVAHVWhAs/cr
730Fbh6y9jNlMHsJ9AE3pG8aGbb26h9BaqJxBtrV6mdbL+3GhLGSghe0kS1VAlPg
ThT7VfrudlfRI44HbfNx+9xV3BsSjNpkHcV8b9tB5i1m8yeThajkUZrdSYcj4Zyn
Ah6+II7wwYOHtt0kvEDJf9R4DBWthf1DGdZ6fzLhJu3DcHkWbnFJR5wnoNWEL4DH
9fawKSbhUCgS+RvSafuSzqTghWq95kUDtMBFeDS/C2Y8KQoi6bBSKYZoDjb64D6m
xj4PYyhPQLn6tGYG8Sq2jOywmD+2/DPajine0a6jLeaaR7lWw/IYc1vebjota5k4
p9pm4HgrWblanOrYi30xwoKkcyJq8nFlyuLt/yN0G/TcqB7L3W7e6xfP8AzwC/OH
iYNtcdWnJXOSZeueM3p7
=Iubg
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
