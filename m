Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3KSS3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:29:45 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:16305
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823Ab3KSS3m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:29:42 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehzbb2dI98dIc89bh936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097h186068hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh1155h)
Message-ID: <1384885766.1403.366.camel@snotra.buserror.net>
Subject: Re: [PATCH] lib/crc32: slice by 4 is more efficient than the
 default slice by 8 on Powerpc 8xx.
From: Scott Wood <scottwood@freescale.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
CC: Christophe Leroy <christophe.leroy@c-s.fr>,
        Marcelo Tosatti <marcelo@kvack.org>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 19 Nov 2013 12:29:26 -0600
In-Reply-To: <OF5004EA63.AA9B7989-ONC1257C28.004D6C13-C1257C28.004DF922@transmode.se>
References: <20131118070423.E47181A4D3D@localhost.localdomain>
	 <OF5004EA63.AA9B7989-ONC1257C28.004D6C13-C1257C28.004DF922@transmode.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think we should go littering the Kconfig with defaults for
various bits of hardware -- especially since you've already pointed out
non-8xx hardware that would also want this.  Put it in defconfig
instead, unless you can identify very broad classes of machines for
which SLICEBY4 is faster.

-Scott

On Tue, 2013-11-19 at 15:11 +0100, Joakim Tjernlund wrote:
> I found the same on MPC8321 long time ago(when 64 bits change went in), 
> the 32 bits were much faster. I guess the "smaller"
> CPUs cannot handle the cache trashing these big tables impose, I didn't 
> look into the details though.
> So I think this is a good change for 8xx.
> 
> Acked-by: Joakim Tjernlund <joakim.tjernlund@transmode.se>
> 
> Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2013/11/18 08:04:23:
> 
> > From: Christophe Leroy <christophe.leroy@c-s.fr>
> > To: Vitaly Bordug <vitb@kernel.crashing.org>, Marcelo Tosatti 
> <marcelo@kvack.org>, Joakim Tjernlund <joakim.tjernlund@transmode.se>, Bob 
> Pearson <rpearson@systemfabricworks.com>, 
> > Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
> > Date: 2013/11/19 13:05
> > Subject: [PATCH] lib/crc32: slice by 4 is more efficient than the 
> default slice by 8 on Powerpc 8xx.
> > 
> > On PPC_8xx, CRC32_SLICEBY4 is more efficient (almost twice) than 
> CRC32_SLICEBY8,
> > as shown below:
> > 
> > With CRC32_SLICEBY8:
> > [    1.109204] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
> > [    1.114401] crc32: self tests passed, processed 225944 bytes in 
> 15118910 nsec
> > [    1.130655] crc32c: CRC_LE_BITS = 64
> > [    1.134235] crc32c: self tests passed, processed 225944 bytes in 
> 4479879 nsec
> > 
> > With CRC32_SLICEBY4:
> > [    1.097129] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
> > [    1.101878] crc32: self tests passed, processed 225944 bytes in 
> 8616242 nsec
> > [    1.116298] crc32c: CRC_LE_BITS = 32
> > [    1.119607] crc32c: self tests passed, processed 225944 bytes in 
> 3289576 nsec
> > 
> > Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> > 
> > Index: a/lib/Kconfig
> > ===================================================================
> > --- a/lib/Kconfig   (rÃ©vision 5325)
> > +++ b/lib/Kconfig   (copie de travail)
> > @@ -102,6 +102,7 @@
> >  choice
> >     prompt "CRC32 implementation"
> >     depends on CRC32
> > +   default CRC32_SLICEBY4 if PPC_8xx
> >     default CRC32_SLICEBY8
> >     help
> >       This option allows a kernel builder to override the default choice
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
> 



