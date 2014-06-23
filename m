Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaFWTNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:13:37 -0400
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:49396 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753099AbaFWTNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:13:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553
X-HE-Tag: day85_75f1436be4820
X-Filterd-Recvd-Size: 3027
Message-ID: <1403550809.15811.13.camel@joe-AO725>
Subject: Re: [PATCH 00/22] Add and use pci_zalloc_consistent
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arch@vger.kernel.org, linux-scsi@vger.kernel.org,
        iss_storagedev@hp.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-crypto@vger.kernel.org, linux-eata@i-connect.net,
        linux-media@vger.kernel.org
Date: Mon, 23 Jun 2014 12:13:29 -0700
In-Reply-To: <20140623172512.GA1390@garbanzo.do-not-panic.com>
References: <cover.1403530604.git.joe@perches.com>
	 <20140623172512.GA1390@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 10:25 -0700, Luis R. Rodriguez wrote:
> On Mon, Jun 23, 2014 at 06:41:28AM -0700, Joe Perches wrote:
> > Adding the helper reduces object code size as well as overall
> > source size line count.
> > 
> > It's also consistent with all the various zalloc mechanisms
> > in the kernel.
> > 
> > Done with a simple cocci script and some typing.
> 
> Awesome, any chance you can paste in the SmPL? Also any chance
> we can get this added to a make coccicheck so that maintainers
> moving forward can use that to ensure that no new code is
> added that uses the old school API?

Not many of these are recent.

Arnd Bergmann reasonably suggested that the pci_alloc_consistent
api be converted the the more widely used dma_alloc_coherent.

https://lkml.org/lkml/2014/6/23/513

> Shouldn't these drivers just use the normal dma-mapping API now?

and I replied:

https://lkml.org/lkml/2014/6/23/525

> Maybe.  I wouldn't mind.
> They do seem to have a trivial bit of unnecessary overhead for 
> hwdev == NULL ? NULL : &hwdev->dev

Anyway, here's the little script.
I'm not sure it's worthwhile to add it though.

$ cat ./scripts/coccinelle/api/alloc/pci_zalloc_consistent.cocci
///
/// Use pci_zalloc_consistent rather than
///     pci_alloc_consistent followed by memset with 0
///
/// This considers some simple cases that are common and easy to validate
/// Note in particular that there are no ...s in the rule, so all of the
/// matched code has to be contiguous
///
/// Blatantly cribbed from: scripts/coccinelle/api/alloc/kzalloc-simple.cocci

@@
type T, T2;
expression x;
expression E1,E2,E3;
statement S;
@@

- x = (T)pci_alloc_consistent(E1,E2,E3);
+ x = pci_zalloc_consistent(E1,E2,E3);
  if ((x==NULL) || ...) S
- memset((T2)x,0,E2);


