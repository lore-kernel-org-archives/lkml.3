Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152AbaLLRfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:35:18 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39741 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbaLLRfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:35:16 -0500
Message-ID: <548B2752.7030607@lwfinger.net>
Date: Fri, 12 Dec 2014 11:35:14 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Krzysztof Konopko <kris@konagma.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com> <548A2E7A.4010303@lwfinger.net> <548AD2F1.3080200@konagma.com>
In-Reply-To: <548AD2F1.3080200@konagma.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 05:35 AM, Krzysztof Konopko wrote:
> On 12/12/14 00:53, Larry Finger wrote:
>>
>> This fix may make the sparse warnings go away, but I think it introduces
>> new bugs.
>
> Right, I see.  Nice try though, isn't it? ;)
>
>> In particular, did you test on big-endian hardware after you
>> made this change?
>
> Nope.  I don't have any big-endian hardware.  I don't even have the
> wireless card TBH.  But I'm happy to try to get one.  Is Rtl8723AE the
> right model?

No. The device numbers that end in E are PCIe and use a mac80211-based driver. 
As none of my BE hardware has PCIe, I cannot test those drivers on other than LE 
hardware. I do not have the hardware either for the RTL8723AU. For that reason, 
I am careful when modifying the driver - I let Jes do that.

>> I recently found that the driver for RTL8188EU needed
>> to have BA_para_set to unsigned short, and the endianess warnings needed
>> to be fixed in the code. Then it would work on my PowerBook G4 with a
>> PPC processor.
>>
>
> OK.  Does it still work with little endian?

Of course. Making changes between u16 and __le16 do not make any difference in 
the code for little endian. As Dan Carpenter pointed out, these changes cannot 
introduce any bugs. I should have said that the changes could obscure bugs for 
big-endian systems.

>> In RTL8188EU, both BA_starting_seqctrl and TXOP_limit are unsigned short.
>>
>
> That's not quite the case.  `TXOP_limit` is __le16 in RTL8188EU [1].
> It's __le16 even in your GitHub repo [2].  And that made me thinking
> that there's probably some inconsistency in the header.

All the USB drivers are a mess. The kernel version of rtl8188eu does not work on 
PPC; however, the git repo now does. I'm working on finding the differences and 
fixing the kernel version.

> I'm _far_ from being a wireless expert but doesn't data coming out of
> the wire/air have the endianess defined explicitly?  And both `AC_param`
> and `ADDBA_request` come out of air?

Yes, in the air the endianess is explicitly defined. I'm not sure how AC_param 
is populated, but the data in ADDBA_request are individually extracted/inserted 
from/to the on-air packets. They could be kept as little endian, but the 
calculations on BA_para_set are being done in CPU endianess. For consistency 
with the kernel headers you mention below, the structures should probably use LE 
and the calculations modified.

> I was hunting particularly for inconsistencies with `sparse` and came
> across this one.  But I dug a bit further and I wonder why the driver is
> not using standard stuff like the one in `include/linux/ieee80211.h`
> where any data wider than one byte is clearly declared as __le<nn>?

That is a good question. One possibility is that those definitions do not exist 
on some of the older kernels that Realtek supports. They generally work with 
2.6.18 and newer.

To be able to fix the kernel driver for RTL8188EU on PPC, I need to sort out 
these endian problems. Once I do, I will port them to the other drivers.

Larry

