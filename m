Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3LBFR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:17:56 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:46154 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3LBFRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:17:53 -0500
Message-ID: <529C17FB.3040500@gtsys.com.hk>
Date: Mon, 02 Dec 2013 13:17:47 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11 ThunderBrowse/3.8
MIME-Version: 1.0
To: Peter Chen <Peter.Chen@freescale.com>
CC: "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 v3] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
References: <1385783513-22502-1-git-send-email-chris.ruehl@gtsys.com.hk> <F281D0F91ED19E4D8E63A7504E8A64980413B204@039-SN2MPN1-021.039d.mgd.msft.net> <529BE72C.9030805@gtsys.com.hk> <F281D0F91ED19E4D8E63A7504E8A64980413D5A8@039-SN2MPN1-021.039d.mgd.msft.net>
In-Reply-To: <F281D0F91ED19E4D8E63A7504E8A64980413D5A8@039-SN2MPN1-021.039d.mgd.msft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday, December 02, 2013 01:10 PM, Peter Chen wrote:
>
>>
>> If you have a look into the function hw_write() you will see that there
>> is no
>> effect if hw_write(...,sts) is called with sts=0/1, because the mask will
>> cut
>> off all bits beside BIT(29).
>
> Yes, it is my careless. I thought sts is PORTCS_STS.
>
>> I used BIT(29) rather then PORTCS_STS to make it more clear what going on.
>
> It is not a good coding style, you do need use MACRO to instead of raw number directly.
>
>> A write to PORTCS will always be "0" for the STS Register no matter if
>> sts is 1
>> or 0 within Patch v2. Patch v3 will take care of the registers bit
>> position and
>> set 1 or 0 to PORTCS_STS.
>>
>
> My suggestion like below:
>
> 	if (ci->hw_bank.lpm) {
>   		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
> -		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
> +		if (sts)
> +			hw_write(ci, OP_DEVLC, DEVLC_STS, DEVLC_STS);
>   	} else {
>   		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
> -		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
> +		if (sts)
> +			hw_write(ci, OP_PORTSC, PORTSC_STS, PORTSC_STS);
>   	}
>
>
> I think we just need to fix the original bug, and do not add any new fixes
> since we don't know which one is correct for every platform. My proposal is
> just set PORTSC_STS (DEVLC_STS is lpm) if it is serial PHY. For any other PHYS, just keep
> the reset value.
>
> Peter
>
>> I used the imx27 reference manual Capital 30.8.1.5.12 PORTSCx.
>>

I can follow your arguments, ACK.
I prepare a patch set with this solution if not other people have better
ideas.

Chris
