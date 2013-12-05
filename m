Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab3LEBNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:13:48 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:6200 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339Ab3LEBNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:13:44 -0500
X-IronPort-AV: E=Sophos;i="4.93,829,1378857600"; 
   d="asc'?scan'208";a="78404173"
Message-ID: <1386206018.3926.138.camel@Abyss>
Subject: Re: [Xen-devel] [PATCH v2 0/2] xen: vnuma introduction for pv guest
From: Dario Faggioli <dario.faggioli@citrix.com>
To: Elena Ufimtseva <ufimtseva@gmail.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <akpm@linux-foundation.org>, <wency@cn.fujitsu.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>, <mingo@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        Ian Campbell <ian.campbell@citrix.com>
Date: Thu, 5 Dec 2013 02:13:38 +0100
In-Reply-To: <CAEr7rXjgFi17vuV91R7=U4rkOKCMOw95kgWu0A0+yrfgHpR6Ow@mail.gmail.com>
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
	 <20131119153837.GA5966@phenom.dumpdata.com>
	 <1384885783.15360.40.camel@Solace>
	 <CAEr7rXiCL-MagPwn76ZdTOJH03M8GCrKF2fGw0YWdnPZK332CA@mail.gmail.com>
	 <CAEr7rXjgFi17vuV91R7=U4rkOKCMOw95kgWu0A0+yrfgHpR6Ow@mail.gmail.com>
Organization: Citrix Ltd
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-KnJr3et4PMH86EdEqAhW"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
MIME-Version: 1.0
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-KnJr3et4PMH86EdEqAhW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mer, 2013-12-04 at 01:20 -0500, Elena Ufimtseva wrote:
> On Tue, Dec 3, 2013 at 7:35 PM, Elena Ufimtseva <ufimtseva@gmail.com> wro=
te:
> > Oh guys, I feel really bad about not replying to these emails... Someho=
w these
> > replies all got deleted.. wierd.
> >
No worries... You should see *my* backlog. :-P

> > Ok, about that automatic balancing. At the moment of the last patch
> > automatic numa balancing seem to
> > work, but after rebasing on the top of 3.12-rc2 I see similar issues.
> > I will try to figure out what commits broke and will contact Ingo
> > Molnar and Mel Gorman.
> >
> As of now I have patch v4 for reviewing. Not sure if it will be
> beneficial to post it for review
> or look closer at the current problem.
>
You mean the Linux side? Perhaps stick somewhere a reference to the git
tree/branch where it lives, but, before re-sending, let's wait for it to
be as issue free as we can tell?

> The issue I am seeing right now is defferent from what was happening befo=
re.
> The corruption happens when on change_prot_numa way :
>=20
Ok, so, I think I need to step back a bit from the actual stack trace
and look at the big picture. Please, Elena or anyone, correct me if I'm
saying something wrong about how Linux's autonuma works and interacts
with Xen.

The way it worked when I last looked at it was sort of like this:
 - there was a kthread scanning all the pages, removing the PAGE_PRESENT
   bit from actually present pages, and adding a new special one
   (PAGE_NUMA or something like that);
 - when a page fault is triggered and the PAGE_NUMA flag is found, it
   figures out the page is actually there, so no swap or anything.
   However, it tracks from what node the access to that page came from,
   matches it with the node where the page actually is and collect some
   statistics about that;
 - at some point (and here I don't remember the exact logic, since it
   changed quite a few times) pages ranking badly in the stats above are
   moved from one node to another.

Is this description still accurate? If yes, here's what I would (double)
check, when running this in a PV guest on top of Xen:

 1. the NUMA hinting page fault, are we getting and handling them
    correctly in the PV guest? Are the stats in the guest kernel being
    updated in a sensible way, i.e., do they make sense and properly
    relate to the virtual topology of the guest?
    At some point we thought it would have been necessary to intercept
    these faults and make sure the above is true with some help from the
    hypervisor... Is this the case? Why? Why not?

 2. what happens when autonuma tries to move pages from one node to
    another? For us, that would mean in moving from one virtual node
    to another... Is there a need to do anything at all? I mean, is
    this, from our perspective, just copying the content of an MFN from
    node X into another MFN on node Y, or do we need to update some of
    our vnuma tracking data structures in Xen?

If we have this figured out already, then I think we just chase bugs and
repost the series. If not, well, I think we should. :-D

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://about.me/dario.faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-KnJr3et4PMH86EdEqAhW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iEYEABECAAYFAlKf00IACgkQk4XaBE3IOsT+xgCeOg7AfXbg9cyVeQO9edvoxa3x
oQUAniqA3TnuUusWL+TrSVgh36ikCbTT
=du2o
-----END PGP SIGNATURE-----

--=-KnJr3et4PMH86EdEqAhW--
