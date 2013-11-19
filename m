Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3KSXjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:39:49 -0500
Received: from gw1.transmode.se ([195.58.98.146]:61031 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab3KSXjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:39:48 -0500
In-Reply-To: <1384885766.1403.366.camel@snotra.buserror.net>
References: <20131118070423.E47181A4D3D@localhost.localdomain>	 <OF5004EA63.AA9B7989-ONC1257C28.004D6C13-C1257C28.004DF922@transmode.se> <1384885766.1403.366.camel@snotra.buserror.net>
To: Scott Wood <scottwood@freescale.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Marcelo Tosatti <marcelo@kvack.org>,
        Bob Pearson <rpearson@systemfabricworks.com>
MIME-Version: 1.0
Subject: Re: [PATCH] lib/crc32: slice by 4 is more efficient than the default slice
 by 8 on Powerpc 8xx.
X-KeepSent: E596957E:9CEC5C97-C1257C28:00814EE8;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OFE596957E.9CEC5C97-ONC1257C28.00814EE8-C1257C28.0081FB80@transmode.se>
Date: Wed, 20 Nov 2013 00:39:45 +0100
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 20/11/2013 00:39:45,
	Serialize complete at 20/11/2013 00:39:45
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood <scottwood@freescale.com> wrote on 2013/11/19 19:29:26:
> 
> I don't think we should go littering the Kconfig with defaults for
> various bits of hardware -- especially since you've already pointed out
> non-8xx hardware that would also want this.  Put it in defconfig
> instead, unless you can identify very broad classes of machines for
> which SLICEBY4 is faster.

hmm, when 64bits went in there was not much proof that it was faster for
a wide range of CPU, just 2 or 3 if I recall correctly. I suspect there
are quite a few CPUs where 32 bits a equal or faster.

  Jocke

> 
> -Scott
> 
> On Tue, 2013-11-19 at 15:11 +0100, Joakim Tjernlund wrote:
> > I found the same on MPC8321 long time ago(when 64 bits change went 
in), 
> > the 32 bits were much faster. I guess the "smaller"
> > CPUs cannot handle the cache trashing these big tables impose, I 
didn't 
> > look into the details though.
> > So I think this is a good change for 8xx.
> > 
> > Acked-by: Joakim Tjernlund <joakim.tjernlund@transmode.se>
> > 
> > Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2013/11/18 
08:04:23:
> > 
> > > From: Christophe Leroy <christophe.leroy@c-s.fr>
> > > To: Vitaly Bordug <vitb@kernel.crashing.org>, Marcelo Tosatti 
> > <marcelo@kvack.org>, Joakim Tjernlund <joakim.tjernlund@transmode.se>, 
Bob 
> > Pearson <rpearson@systemfabricworks.com>, 
> > > Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
> > > Date: 2013/11/19 13:05
> > > Subject: [PATCH] lib/crc32: slice by 4 is more efficient than the 
> > default slice by 8 on Powerpc 8xx.
> > > 
> > > On PPC_8xx, CRC32_SLICEBY4 is more efficient (almost twice) than 
> > CRC32_SLICEBY8,
> > > as shown below:
> > > 
> > > With CRC32_SLICEBY8:
> > > [    1.109204] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
> > > [    1.114401] crc32: self tests passed, processed 225944 bytes in 
> > 15118910 nsec
> > > [    1.130655] crc32c: CRC_LE_BITS = 64
> > > [    1.134235] crc32c: self tests passed, processed 225944 bytes in 
> > 4479879 nsec
> > > 
> > > With CRC32_SLICEBY4:
> > > [    1.097129] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
> > > [    1.101878] crc32: self tests passed, processed 225944 bytes in 
> > 8616242 nsec
> > > [    1.116298] crc32c: CRC_LE_BITS = 32
> > > [    1.119607] crc32c: self tests passed, processed 225944 bytes in 
> > 3289576 nsec
> > > 
> > > Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> > > 
> > > Index: a/lib/Kconfig
> > > ===================================================================
> > > --- a/lib/Kconfig   (révision 5325)
> > > +++ b/lib/Kconfig   (copie de travail)
> > > @@ -102,6 +102,7 @@
> > >  choice
> > >     prompt "CRC32 implementation"
> > >     depends on CRC32
> > > +   default CRC32_SLICEBY4 if PPC_8xx
> > >     default CRC32_SLICEBY8
> > >     help
> > >       This option allows a kernel builder to override the default 
choice
> > 
> > _______________________________________________
> > Linuxppc-dev mailing list
> > Linuxppc-dev@lists.ozlabs.org
> > https://lists.ozlabs.org/listinfo/linuxppc-dev
> > 
> > 
> 
> 
> 

