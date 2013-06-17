Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab3FQL2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:28:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43049 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab3FQL2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:28:03 -0400
Date: Mon, 17 Jun 2013 12:25:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, gregkh@linuxfoundation.org,
        Oliver Schinagl <oliver@schinagl.nl>, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        maxime.ripard@free-electrons.com
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130617112459.GD2718@n2100.arm.linux.org.uk>
References: <1371251781-17167-1-git-send-email-oliver+list@schinagl.nl> <1371251781-17167-2-git-send-email-oliver+list@schinagl.nl> <2828921.i3T9JhMInt@flatron> <51BEE6BF.30401@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BEE6BF.30401@schinagl.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 12:36:47PM +0200, Oliver Schinagl wrote:
> On 15-06-13 12:28, Tomasz Figa wrote:
>> What is this version thingy?
>>
>> Is there a versioning scheme defined for this driver? Do you expect it to
>> be changed every modification of this driver?
>>
>> I don't see any point of having such thing in a project with a version
>> control system, where you have all change history.
> Well we export something to userspace, while trivial there is the  
> possibility it changes over time. Say A40 which outputs 256 bits instead  
> of the current 128 bits. That would validate a bump in version number.  
> It's purely so the user can be aware of differences in the driver. So  
> maybe DRV_A[BP]I_VERSION would be better?

What is better to do is to export such things as properties, or
design the API in such a way that the length of the ID is reportable.

However, it's actually quite easy to do if you only care about the
number of bytes - you just arrange for the read() function to return
the number of bytes read.  So in the case of 128 bits available, that's
16 bytes, so a read() of the sysfs attribute with a buffer of (say)
256 bytes should report only 16 bytes read.

If it were to become 256 bytes later, then the read() would return
32 bytes read.  So there's no need for any new APIs to do this.

Also, this is over-complicated:

+       for (i = 0; i < size; i++) {
+               if ((pos + i) >= SID_SIZE || (pos < 0))
+                       break;
+               buf[i] = sunxi_sid_read_byte(sid_reg_base, pos + i);
+       }

Maybe:
	if (pos < 0 || pos >= SID_SIZE)
		return 0;
	if (size > SID_SIZE - pos)
		size = SID_SIZE - pos;

	for (i = 0; i < size; i++)
		buf[i] = sunxi_sid_read_byte(sid_reg_base, pos + i);

	return size;
