Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaCMM5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:57:22 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39211 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaCMM5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:57:21 -0400
Date: Thu, 13 Mar 2014 23:57:11 +1100 (EST)
From: Austin Boyle <boyle.austin@gmail.com>
To: Gerlando Falauto <gerlando.falauto@keymile.com>
cc: Austin Boyle <boyle.austin@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Marek Vasut <marex@denx.de>, Angus Clark <angus.clark@st.com>
Subject: Re: [PATCH] mtd: m25p80: Flash protection support for STmicro
 chips
In-Reply-To: <531D80AB.5010209@keymile.com>
Message-ID: <alpine.DEB.2.02.1403132239490.4383@austin-Satellite-L510>
References: <1357257748.31023.12.camel@pc786-ubu.GNET.GLOBAL.VPN> <528D15B6.2030800@keymile.com> <530F4CDE.7010205@keymile.com> <20140305081008.GP13420@norris-Latitude-E6410> <20140305083153.GR13420@norris-Latitude-E6410> <CADnxWiqfaaRoaL+B_WQxx38-gpSDmdFQPLN-bs-moGRECXeJxg@mail.gmail.com>
 <531D80AB.5010209@keymile.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Gerlando,

On Mon, 10 Mar 2014, Gerlando Falauto wrote:
> What do you mean exactly by "it is optional"?
> I agree with you that an explicit ioctl(MEMLOCK) is order for locking to take 
> place. However, this seems to be the default action for the u-boot 
> environment userspace tools. They will issue a MEMUNLOCK/MEMLOCK pair when 
> trying to write some changes to the environment, without even checking the 
> return value. This would of course fail silently when the feature was not 
> implemented (as it was the case before the original patch was applied) and 
> everything was working as expected.
> Now linux supports this feature, and u-boot doesn't, so as soon as you write 
> something to the flash from userspace, it will be locked and u-boot won't 
> ever be able to write to it again.
>
OK I understand your point after checking the code for the u-boot tool.

> In my opinion, we're breaking something here (call it userspace API or 
> otherwise). My suggestion would then be to make it an optional feature to be 
> explicitly enabled on the device tree, like Heicho did for CFI flashes:
>
> http://lists.infradead.org/pipermail/linux-mtd/2013-January/045536.html
>
> Or I guess another way would be to implement the _is_locked() function, so to 
> have the userspace tools check the locking status before unlocking, and only 
> lock it again if was locked in the first place.
> It wouldn't fix my issue right away (as the userspace tools don't currenctly 
> perform this check), but at least it would provide some way out here without 
> breaking compatibility with the existing u-boot.
>
I prefer this suggestion of implementing _is_locked(). It is a simple 
change so may as well be done while fixing the lock/unlock code anyway. 
One could say it is counterintuitive for ioctl(MEMLOCK) not to work
without previous configuration, as in the first suggestion. If people are 
passionate about making the feature configurable it could be done 
separately once we've fixed the logic with _lock/_unlock and 
adding _is_locked.

I will submit a change to the u-boot env tool to check the locking state 
if supported and restore the same state after - obviously more 
correct, regardless of the decision made here.

Not ideal but in the meantime if someone needs to ensure the device is 
unlocked they can run the flash_unlock from mtd-utils after writing u-boot
environment variables from the userspace tool. (Call it a user space 
work around for a user space bug?)

> Uhm, I believe it should read like this (unprotected portion is of course "n 
> - protected portion"):
>
> SR BPs | Protected portion
> ---------------------------
>  0    | 0/n
>  1    | 1/n
>  2    | 2/n
>  3    | min(4,n)/n
>  4    | min(8,n)/n
>  5    | min(16,n)/n
>  6    | min(32,n)/n
>  7    | min(64,n)/n
>
Yes sorry that was a typo in the previous email, should have been powers 
of 2 as above and the patch. Also technically correct about the min macro, 
as you saw I was just terminating the loop before that condition was met.

>> A patch with this implementation follows. Let me know what you think. I
>> have a spreadsheet summarising the block protect bits for the STmicro
>> devices I can share if it will help.
>
> Could you please share this?
It sounds like you have already done your own research but here is what I 
have: 
https://docs.google.com/spreadsheet/ccc?key=0AhKBO-EQCLLkdGR1Q05qLUs2RURsMFA4V2s2X1llY3c&usp=sharing

Thanks for your comments on this issue and patch. I will resubmit 
another version addressing your points soon.

Cheers,
Austin.
