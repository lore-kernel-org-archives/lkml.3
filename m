Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaCJJHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:07:08 -0400
Received: from mail-de.keymile.com ([195.8.104.250]:53159 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaCJJHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:07:05 -0400
Message-ID: <531D80AB.5010209@keymile.com>
Date: Mon, 10 Mar 2014 10:06:51 +0100
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Austin Boyle <boyle.austin@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Marek Vasut <marex@denx.de>, Angus Clark <angus.clark@st.com>
Subject: Re: [PATCH] mtd: m25p80: Flash protection support for STmicro chips
References: <1357257748.31023.12.camel@pc786-ubu.GNET.GLOBAL.VPN>	<528D15B6.2030800@keymile.com>	<530F4CDE.7010205@keymile.com>	<20140305081008.GP13420@norris-Latitude-E6410>	<20140305083153.GR13420@norris-Latitude-E6410> <CADnxWiqfaaRoaL+B_WQxx38-gpSDmdFQPLN-bs-moGRECXeJxg@mail.gmail.com>
In-Reply-To: <CADnxWiqfaaRoaL+B_WQxx38-gpSDmdFQPLN-bs-moGRECXeJxg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Austin, Brian,

thank you for taking care of this.

On 03/08/2014 04:03 PM, Austin Boyle wrote:
[...]
>
> I don't think there is an issue with some bootloaders not supporting
> this feature, it is already optional.

What do you mean exactly by "it is optional"?
I agree with you that an explicit ioctl(MEMLOCK) is order for locking to 
take place. However, this seems to be the default action for the u-boot 
environment userspace tools. They will issue a MEMUNLOCK/MEMLOCK pair 
when trying to write some changes to the environment, without even 
checking the return value. This would of course fail silently when the 
feature was not implemented (as it was the case before the original 
patch was applied) and everything was working as expected.
Now linux supports this feature, and u-boot doesn't, so as soon as you 
write something to the flash from userspace, it will be locked and 
u-boot won't ever be able to write to it again.

In my opinion, we're breaking something here (call it userspace API or 
otherwise). My suggestion would then be to make it an optional feature 
to be explicitly enabled on the device tree, like Heicho did for CFI 
flashes:

http://lists.infradead.org/pipermail/linux-mtd/2013-January/045536.html

Or I guess another way would be to implement the _is_locked() function, 
so to have the userspace tools check the locking status before 
unlocking, and only lock it again if was locked in the first place.
It wouldn't fix my issue right away (as the userspace tools don't 
currenctly perform this check), but at least it would provide some way 
out here without breaking compatibility with the existing u-boot.

> It is a good idea to add another flag for flash protection to be
> explicitly clear which devices support this. (I previously made the
> assumption that writing to those status bits when unused was harmless,
> from the datasheets I found they seem to be don't cares.)

Agreed.

> The following logic for calculating the block protect bits applies to
> the majority of the STmicro devices that support protection (m25p10,
> p20, p40, p80, p16, pe16, p32, p64, p128):
>
> SR_BPs| Protected (upper)| Unprotected (lower)
> =====================================================
> 0| 0/n| n - 0/n
> 1| 1/n| n - 1/n
> 2| 2/n| n - 2/n
> 3| 3/n| n - 4/n
> 4| 4/n| n - 8/n
> 5| 5/n| n - 16/n
> 6| 6/n| n - 32/n
> 7| 7/n| n - 64/n

Uhm, I believe it should read like this (unprotected portion is of 
course "n - protected portion"):

SR BPs | Protected portion
---------------------------
   0    | 0/n
   1    | 1/n
   2    | 2/n
   3    | min(4,n)/n
   4    | min(8,n)/n
   5    | min(16,n)/n
   6    | min(32,n)/n
   7    | min(64,n)/n

Or at least that was my understanding.

> Where n is number of sectors if less than 64.
>
> Some special cases:
> - m25p64 has 128 sectors but only supports protection to 64 sector
> resolution.
> - m25p05 uses SR=1/2 for protect Block Erase, and SR=3 for protect Block
> Erase, Page Program, Sector Erase.
> - m25px32 has an additional bit for locking the lower sections.
>
> A patch with this implementation follows. Let me know what you think. I
> have a spreadsheet summarising the block protect bits for the STmicro
> devices I can share if it will help.

Could you please share this?

Thank you,
Gerlando

>
> Thanks,
> Austin.

