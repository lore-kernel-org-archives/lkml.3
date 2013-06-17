Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab3FQLvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:51:33 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54322 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab3FQLvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:51:32 -0400
Date: Mon, 17 Jun 2013 13:51:29 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, linux@arm.linux.org.uk,
        Oliver Schinagl <oliver@schinagl.nl>, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130617115129.GF16699@lukather>
References: <1371251781-17167-1-git-send-email-oliver+list@schinagl.nl>
 <1371251781-17167-2-git-send-email-oliver+list@schinagl.nl>
 <2828921.i3T9JhMInt@flatron>
 <51BEE6BF.30401@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BEE6BF.30401@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 12:36:47PM +0200, Oliver Schinagl wrote:
> On 15-06-13 12:28, Tomasz Figa wrote:
> >>+#define DRV_VERSION "1.0"
> >
> >What is this version thingy?
> >
> >Is there a versioning scheme defined for this driver? Do you expect it to
> >be changed every modification of this driver?
> >
> >I don't see any point of having such thing in a project with a version
> >control system, where you have all change history.
> Well we export something to userspace, while trivial there is the
> possibility it changes over time. Say A40 which outputs 256 bits
> instead of the current 128 bits. That would validate a bump in
> version number. It's purely so the user can be aware of differences
> in the driver. So maybe DRV_A[BP]I_VERSION would be better?

Except that in that case, the userspace API won't change. You'll still
call read on the same file in sysfs. The only thing that will change
will be the number of bytes returned by your read function, which is
(or should be) totally fine.

> >>+/* We read the entire key, but only return the requested byte. This is
> >>of + * course slower then it could be and uses 4 times more reads as
> >>needed but + * keeps code simpler.
> >
> >I have no idea how often this is going to be read, but since the whole sid
> >is really small (16 bytes), maybe it would be better to simply read the ID
> >in probe to a buffer and then just memcpy from it in read().
> The sid will be read once (well all 16 bytes) during probe and after
> that only on user request. Right now we don't have a user (yet)
> other then the sysfs entry.
> 
> In future, this key can be used to read the MAC (low reads) or AES
> keys for example (also low reads).
> 
> Initially I had such an approach, but Maxime recommended against
> having the value cached.
> 
> As I wrote to andy, the only 'more efficient' way would be to store
> the previously read key and see on the next read if its the same, So
> best case, we could save 4 reads. I think it makes the code
> unnecessarily complex for something that is read so little.

I asked Oliver that because I felt like it could still be updated by the
user, and sysfs should report that.

And since it's not like it would be used extensively and very often,
it's not a big deal anyway.

> >>+
> >>+	if (offset >= SID_SIZE)
> >>+		goto exit;
> >
> >		return 0; ...
> I did say in the changelog I opted for goto over return. But since
> everybody keeps preferring returns (I personally like 'one single
> exit point much more' I have already changed it all over to many
> returns, who am I to argue :)

Yet, you don't have a single exit point neither, you have several of
them. You can say that you have a single return statement in your code,
which is true, yet you have several times a jump to this location, so we
can definitely say that you actually have several exit points. Please
also refer to the chapter 7 of the Documentation/CodingStyle file.

> >>+	return (u8)sid_key;
> >
> >Unnecessary casting.
> Unnecessary because of the &= 0xff above, or because you can put a
> 32bit int in an 8bit int without worries? (we only want the last
> byte).

The latter. The & 0xff only filter out non-relevant informations from
your 32-bits integer in that case, that's all, it doesn't do any
casting.

> >>+	for (i = 0; i < size; i++) {
> >>+		if ((pos + i) >= SID_SIZE || (pos < 0))
> >>+			break;
> >>+		buf[i] = sunxi_sid_read_byte(sid_reg_base, pos + i);
> >>+	}
> >
> >This could be greatly simplified if you just read the whole sid to memory
> >in probe and memcpy from it here.
> But can't because we don't want to cache it.

And we can't simply use memcpy, since we will need to do some endianness
conversions. The data stored in the SID are big-endian, while we're
running most likely in little endian mode.

> >>+	if (!pdev->dev.of_node) {
> >>+		dev_err(&pdev->dev, "No devicetree data available\n");
> >>+		ret = -ENXIO;
> >>+		goto exit;
> >>+	}
> >
> >What is this check for? You don't seem to need anything from dev.of_node
> >in this driver.
> My understanding was, that when using the device tree, we check if
> the device tree is atleast available. And we use
> platform_get_resource, doesn't that get the data from the device
> tree?

If there's no device tree, you won't be probed in the first place. And
resources get filled by the kernel from the device tree automatically at
boot, so you're safe to assume that the resources are there when you get
probed.

You need this check when you actually need some more informations from
the DT, the value of an additionnal property for example.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
