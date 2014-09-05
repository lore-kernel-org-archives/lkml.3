Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaIERwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:52:00 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49881 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIERv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:51:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-pci@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: mvebu: Fix uninitialized variable in mvebu_get_tgt_attr()
Date: Fri, 05 Sep 2014 19:51:27 +0200
Message-ID: <89457154.qOQEu4X27r@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140905174122.GD8080@google.com>
References: <1407512045-26969-1-git-send-email-geert+renesas@glider.be> <20140905174122.GD8080@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:K0734czM5D0gMKF1fs2+BSxddxtTJ2suJOhfyU2sPXv
 Lo3nW8i8dZ8XXvHgmdfqJxshBkB0r849BPkc/Y2hAfVVmJZPrQ
 vXfYx63MxewOzLD0XEV83GlTfB6iQQtxodkUIvX0x1Gat08c5A
 urNuup1Pak5jbhDAg4KxKhfl/yiD5dL+jjGYpeOa16gPU1vcOb
 Zr+I6U7b+7g9BZ3bS8/NnxOgULyJTDpXFexbI7cWBZGYfflVDq
 AxB7eRAUq+FJV3+3w95JX8GP/Am0H2jK1Xh3ohUqVIDbTnZKr/
 z9saMGn+FlN84mPxA79sRqSRBMV8u+Lm1SDSZre3kjcaaYEPdP
 4uqRFyKSpBAlIZp7L280=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 11:41:22 Bjorn Helgaas wrote:
> On Fri, Aug 08, 2014 at 05:34:05PM +0200, Geert Uytterhoeven wrote:
> > drivers/pci/host/pci-mvebu.c: In function 'mvebu_get_tgt_attr':
> > drivers/pci/host/pci-mvebu.c:887:39: warning: 'rtype' may be used uninitialized in this function [-Wmaybe-uninitialized]
> >    if (slot == PCI_SLOT(devfn) && type == rtype) {
> >                                        ^
> > 
> > If there's ever gonna be a configuration space or 64-bit memory space
> > entry in DT, rtype will be uninitialized, and the wrong entry may be
> > returned.
> > 
> > Initialize rtype to 0 (which is an unused IORESOURCE_* type) to fix this.
> > 
> > Introduced in commit 11be65472a427dcf7a11ab6e3e3628f1c6768b5b ("PCI:
> > mvebu: Adapt to the new device tree layout").
> > 
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> > Alternatively, should the "else if (DT_FLAGS_TO_TYPE(flags) ==
> > DT_TYPE_MEM32)" just be changed to "else", assuming there can never be
> > other entries than for I/O or 32-bit memory space?
> > ---
> >  drivers/pci/host/pci-mvebu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
> > index ce23e0f076b6..9515f0d13fd4 100644
> > --- a/drivers/pci/host/pci-mvebu.c
> > +++ b/drivers/pci/host/pci-mvebu.c
> > @@ -877,7 +877,7 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
> >  		u32 flags = of_read_number(range, 1);
> >  		u32 slot = of_read_number(range + 1, 1);
> >  		u64 cpuaddr = of_read_number(range + na, pna);
> > -		unsigned long rtype;
> > +		unsigned long rtype = 0;
> >  
> >  		if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_IO)
> >  			rtype = IORESOURCE_IO;
> 
> This fix looks right to me.  I added a stable tag as follows.  Thomas
> and/or Jason, and you ack this?


I had a local fix for this, which I haven't gotten around to
send a proper changelog for, but it seems like a more appropriate
fix, avoiding the spurious initialization.

The other fix looks technically correct as well though.

	Arnd

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index a8c6f1a92e0f..678849836649 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -883,6 +883,8 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
 			rtype = IORESOURCE_IO;
 		else if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_MEM32)
 			rtype = IORESOURCE_MEM;
+		else
+			rtype = -1;
 
 		if (slot == PCI_SLOT(devfn) && type == rtype) {
 			*tgt = DT_CPUADDR_TO_TARGET(cpuaddr);

