Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab3FQLhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:37:46 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:51714 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932696Ab3FQLhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:37:45 -0400
Message-ID: <51BEF3D1.8050305@schinagl.nl>
Date: Mon, 17 Jun 2013 13:32:33 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, gregkh@linuxfoundation.org,
        Oliver Schinagl <oliver@schinagl.nl>, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        maxime.ripard@free-electrons.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
References: <1371251781-17167-1-git-send-email-oliver+list@schinagl.nl> <1371251781-17167-2-git-send-email-oliver+list@schinagl.nl> <2828921.i3T9JhMInt@flatron> <51BEE6BF.30401@schinagl.nl> <20130617112459.GD2718@n2100.arm.linux.org.uk>
In-Reply-To: <20130617112459.GD2718@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-06-13 13:25, Russell King - ARM Linux wrote:
> On Mon, Jun 17, 2013 at 12:36:47PM +0200, Oliver Schinagl wrote:
>> On 15-06-13 12:28, Tomasz Figa wrote:
>>> What is this version thingy?
>>>
>>> Is there a versioning scheme defined for this driver? Do you expect it to
>>> be changed every modification of this driver?
>>>
>>> I don't see any point of having such thing in a project with a version
>>> control system, where you have all change history.
>> Well we export something to userspace, while trivial there is the
>> possibility it changes over time. Say A40 which outputs 256 bits instead
>> of the current 128 bits. That would validate a bump in version number.
>> It's purely so the user can be aware of differences in the driver. So
>> maybe DRV_A[BP]I_VERSION would be better?
>
> What is better to do is to export such things as properties, or
> design the API in such a way that the length of the ID is reportable.
>
> However, it's actually quite easy to do if you only care about the
> number of bytes - you just arrange for the read() function to return
> the number of bytes read.  So in the case of 128 bits available, that's
> 16 bytes, so a read() of the sysfs attribute with a buffer of (say)
> 256 bytes should report only 16 bytes read.
>
> If it were to become 256 bytes later, then the read() would return
> 32 bytes read.  So there's no need for any new APIs to do this.
That makes sense for the sysfs bit and as the only user, I guess makes 
the version information obsolete for now.
>
> Also, this is over-complicated:
>
> +       for (i = 0; i < size; i++) {
> +               if ((pos + i) >= SID_SIZE || (pos < 0))
> +                       break;
> +               buf[i] = sunxi_sid_read_byte(sid_reg_base, pos + i);
> +       }
>
> Maybe:
> 	if (pos < 0 || pos >= SID_SIZE)
> 		return 0;
> 	if (size > SID_SIZE - pos)
> 		size = SID_SIZE - pos;
>
> 	for (i = 0; i < size; i++)
> 		buf[i] = sunxi_sid_read_byte(sid_reg_base, pos + i);
>
> 	return size;
>
I do like your approach, but takes a second to read ;) How is it less 
complicated though? It's more LOC i suppose. I do appreciate that we 
only perform the read function when our size is correct, thus making the 
for loop only execute the minimally required code. While in this driver 
is insignificant and not important, I am a proponent of it.
Consider it changed.

Will wait a bit for Thomaz to optionally reply and then send yet a 
nother version ;)

Thanks for your time,

Oliver
