Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaF0H7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:59:21 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:49769
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbaF0H7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:59:17 -0400
X-IronPort-AV: E=Sophos;i="5.01,559,1400018400"; 
   d="scan'208";a="69156841"
Date: Fri, 27 Jun 2014 09:59:13 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Joe Perches <joe@perches.com>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Drop cast
In-Reply-To: <1403848366.7977.92.camel@joe-AO725>
Message-ID: <alpine.DEB.2.10.1406270956470.2594@hadrien>
References: <20140626172852.GA2878@himangi-Dell>  <1403804286.7977.58.camel@joe-AO725>  <alpine.DEB.2.02.1406270729110.2016@localhost6.localdomain6> <1403848366.7977.92.camel@joe-AO725>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Jun 2014, Joe Perches wrote:

> On Fri, 2014-06-27 at 07:29 +0200, Julia Lawall wrote:
> > On Thu, 26 Jun 2014, Joe Perches wrote:
> > > The cast of a const void * to a void * was odd.
> > >
> > > Maybe a mechanism to verify appropriateness of
> > > loss of constness for any pointer might be useful.
> >
> > I tried the following, but didn't find anything interesting:
> >
> > @disable drop_cast@
> > type T;
> > const T e;
> > @@
> >
> > * (T)e
>
> What code does this match?
> Do you have an example match?
>
> This doesn't find a cast of a void type like:
>
> void func(const void * const p)
> {
> 	char *p2 = p;
>
> 	p2[0] = 1;
> }

The results are below.  Except in the first case, none are pointer types.
The first case looks very intentional, although if the intention is
needed, perhaps the types should be listed differently.

I was surprised not to get more results.  Maybe there is not enough type
information.  I did use --all-includes but not --recursive-includes, ie
only explicitly mentioned include files are taken into account.

My rule doesn't consider implicit casts like in your example.  I can try
that.

julia


diff -u -p /var/linuxes/linux-next/lib/devres.c /tmp/nothing/lib/devres.c
--- /var/linuxes/linux-next/lib/devres.c
+++ /tmp/nothing/lib/devres.c
@@ -296,7 +296,6 @@ void __iomem *pcim_iomap(struct pci_dev

 	BUG_ON(bar >= PCIM_IOMAP_MAX);

-	tbl = (void __iomem **)pcim_iomap_table(pdev);
 	if (!tbl || tbl[bar])	/* duplicate mappings not allowed */
 		return NULL;

@@ -319,7 +318,6 @@ void pcim_iounmap(struct pci_dev *pdev,

 	pci_iounmap(pdev, addr);

-	tbl = (void __iomem **)pcim_iomap_table(pdev);
 	BUG_ON(!tbl);

 	for (i = 0; i < PCIM_IOMAP_MAX; i++)
diff -u -p /var/linuxes/linux-next/drivers/video/fbdev/smscufx.c /tmp/nothing/drivers/video/fbdev/smscufx.c
--- /var/linuxes/linux-next/drivers/video/fbdev/smscufx.c
+++ /tmp/nothing/drivers/video/fbdev/smscufx.c
@@ -976,7 +976,6 @@ static void ufx_dpy_deferred_io(struct f
 		const int width = dev->info->var.xres;
 		const int y = (cur->index << PAGE_SHIFT) / (width * 2);
 		int height = (PAGE_SIZE / (width * 2)) + 1;
-		height = min(height, (int)(dev->info->var.yres - y));

 		BUG_ON(y >= dev->info->var.yres);
 		BUG_ON((y + height) > dev->info->var.yres);
diff -u -p /var/linuxes/linux-next/drivers/mtd/chips/jedec_probe.c /tmp/nothing/drivers/mtd/chips/jedec_probe.c
--- /var/linuxes/linux-next/drivers/mtd/chips/jedec_probe.c
+++ /tmp/nothing/drivers/mtd/chips/jedec_probe.c
@@ -2027,11 +2027,8 @@ static inline int jedec_match( uint32_t
 		}
 		break;
 	case CFI_DEVICETYPE_X16:
-		mfr = (uint16_t)finfo->mfr_id;
-		id = (uint16_t)finfo->dev_id;
 		break;
 	case CFI_DEVICETYPE_X32:
-		mfr = (uint16_t)finfo->mfr_id;
 		id = (uint32_t)finfo->dev_id;
 		break;
 	default:
diff -u -p /var/linuxes/linux-next/drivers/net/wireless/libertas/defs.h /tmp/nothing/drivers/net/wireless/libertas/defs.h
--- /var/linuxes/linux-next/drivers/net/wireless/libertas/defs.h
+++ /tmp/nothing/drivers/net/wireless/libertas/defs.h
@@ -105,7 +105,6 @@ static inline void lbs_deb_hex(unsigned
 					printk("\n");
 				printk(DRV_NAME " %s: ", prompt);
 			}
-			printk("%02x ", (u8) * buf);
 			buf++;
 		}
 		printk("\n");
diff -u -p /var/linuxes/linux-next/drivers/media/i2c/tvp5150.c /tmp/nothing/drivers/media/i2c/tvp5150.c
--- /var/linuxes/linux-next/drivers/media/i2c/tvp5150.c
+++ /tmp/nothing/drivers/media/i2c/tvp5150.c
@@ -95,7 +95,6 @@ static void dump_reg_range(struct v4l2_s
 {
 	int i = 0;

-	while (init != (u8)(end + 1)) {
 		if ((i % max_line) == 0) {
 			if (i > 0)
 				printk("\n");
diff -u -p /var/linuxes/linux-next/net/netfilter/ipvs/ip_vs_sync.c /tmp/nothing/net/netfilter/ipvs/ip_vs_sync.c
--- /var/linuxes/linux-next/net/netfilter/ipvs/ip_vs_sync.c
+++ /tmp/nothing/net/netfilter/ipvs/ip_vs_sync.c
@@ -1543,7 +1543,6 @@ ip_vs_send_async(struct socket *sock, co
 	iov.iov_base     = (void *)buffer;
 	iov.iov_len      = length;

-	len = kernel_sendmsg(sock, &msg, &iov, 1, (size_t)(length));

 	LeaveFunction(7);
 	return len;
@@ -1575,7 +1574,6 @@ ip_vs_receive(struct socket *sock, char

 	/* Receive a packet */
 	iov.iov_base     = buffer;
-	iov.iov_len      = (size_t)buflen;

 	len = kernel_recvmsg(sock, &msg, &iov, 1, buflen, MSG_DONTWAIT);

diff -u -p /var/linuxes/linux-next/net/ipv4/tcp_output.c /tmp/nothing/net/ipv4/tcp_output.c
--- /var/linuxes/linux-next/net/ipv4/tcp_output.c
+++ /tmp/nothing/net/ipv4/tcp_output.c
@@ -177,7 +177,6 @@ static void tcp_event_data_sent(struct t
 	/* If it is a reply for ato after last received
 	 * packet, enter pingpong mode.
 	 */
-	if ((u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato &&
 	    (!dst || !dst_metric(dst, RTAX_QUICKACK)))
 			icsk->icsk_ack.pingpong = 1;
 }

