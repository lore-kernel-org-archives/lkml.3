Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbaEIP43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:56:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32788 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042AbaEIP41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:56:27 -0400
Message-ID: <536CFB79.7030602@oracle.com>
Date: Fri, 09 May 2014 11:59:53 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
        stefani@seibold.net, luto@amacapital.net, konrad.wilk@oracle.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] time: Cast tv_nsec to u64 for proper shifting in update_vsyscall()
References: <1399648287-15178-1-git-send-email-boris.ostrovsky@oracle.com> <536CF7B3.4040705@zytor.com>
In-Reply-To: <536CF7B3.4040705@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 11:43 AM, H. Peter Anvin wrote:
> On 05/09/2014 08:11 AM, Boris Ostrovsky wrote:
>> With tk->wall_to_monotonic.tv_nsec being a 32-bit value on 32-bit
>> systems, (tk->wall_to_monotonic.tv_nsec << tk->shift) in update_vsyscall()
>> may lose upper bits or, worse, add them since compiler will do this:
>> 	(u64)(tk->wall_to_monotonic.tv_nsec << tk->shift)
>> instead of
>> 	((u64)tk->wall_to_monotonic.tv_nsec << tk->shift)
>>
>> So if, for example, tv_nsec is 0x800000 and shift is 8 we will end up
>> with 0xffffffff80000000 instead of 0x80000000. And then we are stuck in
>> the subsequent 'while' loop.
>>
>> We need explicit cast.
>>
>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: stable@vger.kernel.org
> This is needed in stable only for v3.14, right?

I suspect anything that has commit 650ea024 needs to be fixed. I see 
this code, for example, in 3.12 (it used to be in vsyscall_64.c).

-boris
