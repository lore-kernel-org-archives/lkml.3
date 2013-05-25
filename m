Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3EYMWO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 08:22:14 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46017 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab3EYMWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 08:22:11 -0400
Date: Sat, 25 May 2013 14:22:08 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130525122208.GD17847@lukather>
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl>
 <1368797744-13737-2-git-send-email-oliver+list@schinagl.nl>
 <51969EA9.1060602@free-electrons.com>
 <5197B82F.8010809@schinagl.nl>
 <519FE0AE.2010102@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519FE0AE.2010102@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

On Fri, May 24, 2013 at 11:50:38PM +0200, Oliver Schinagl wrote:
> On 05/18/13 19:19, Oliver Schinagl wrote:
> <snip>
> >>>+
> >>>+
> >>>+/* We read the entire key, using a look up table. Returned is only the
> >>>+ * requested byte. This is of course slower then it could be and uses 4 times
> >>>+ * more reads as needed but keeps code a little simpler.
> >>>+ */
> >>>+u8 sunxi_sid_read_byte(const int key)
> >>>+{
> >>>+	u32 sid_key;
> >>>+	u8 ret;
> >>>+
> >>>+	ret = 0;
> >>>+	if (likely((key <= SUNXI_SID_SIZE))) {
> >>>+		sid_key = ioread32(p->sid_base + keys_lut[key >> 2]);
> >>>+		switch (key % 4) {
> >>>+		case 0:
> >>>+			ret = (sid_key >> 24) & 0xff;
> >>>+			break;
> >>>+		case 1:
> >>>+			ret = (sid_key >> 16) & 0xff;
> >>>+			break;
> >>>+		case 2:
> >>>+			ret = (sid_key >> 8) & 0xff;
> >>>+			break;
> >>>+		case 3:
> >>>+			ret = sid_key & 0xff;
> >>>+			break;
> >>>+		}
> >>>+	}
> >>
> >>Come on, you can do better. This lookup table is useless.
> >I didn't want to depend on the fixed layout of memory, but consider it
> >removed.
> But i'm not smart enough :p
> 
> We can either use the look up table (which does have benefits as its
> potentially more future proof), or do some ((key >> 2) << 2) to
> 'drop' the LSB's that we want to ignore (unless there's some smarter
> way).
> 
> Personally, I think the LUT is a little cleaner and more readable,
> but I guess if you look at poor efficiency, the lut costs some
> memory, the left/right shift cost an additional >> 2 ... what you
> prefer.

What about:

val = ioread32be(base + (key / 4));
val >>= (key % 4) * 8;
return val & 0xff;

No lookup table, no weird swich statement, and you get the endianness
conversion only when you need it.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
