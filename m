Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaKZSuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:50:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27175 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaKZSuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:50:22 -0500
Message-ID: <547620E6.10306@oracle.com>
Date: Wed, 26 Nov 2014 13:50:14 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@kernel.org
Subject: Re: [RFC 1/2] compiler: use compiler to detect integer overflows
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com> <CA+55aFzyDC=o_Beg+8hjW8+TQXYWCgQo_yfjgHsTz0LRTiomWA@mail.gmail.com>
In-Reply-To: <CA+55aFzyDC=o_Beg+8hjW8+TQXYWCgQo_yfjgHsTz0LRTiomWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 12:55 PM, Linus Torvalds wrote:
> On Nov 26, 2014 6:00 AM, "Sasha Levin" <sasha.levin@oracle.com <mailto:sasha.levin@oracle.com>> wrote:
>>
>> We've used to detect integer overflows by causing an overflow and testing the
>> result. For example, to test for addition overflow we would:
>>
>>         if (a + b < a)
>>                 /* Overflow detected */
>>
>> While it works, this is actually an undefined behaviour and we're not
>> guaranteed to have integers overflowing this way.
> 
> Bullshit.
> 
> Integer overflow is completely well defined in unsigned types.
> 
> Don't make up things like this.

Yes, I messed up and picked case where both types are unsigned in my example
patch. Apologies.

The kernel still has it's share of *signed* integer overflows. Example? fadvise64_64():

	loff_t offset, len;
	[...]
	loff_t endbyte;
	[...]
        /* Careful about overflows. Len == 0 means "as much as possible" */
        endbyte = offset + len;
        if (!len || endbyte < len)
                endbyte = -1;
        else
                endbyte--;              /* inclusive */


In essence, it's checking (offset + len < len), all of which are signed.


Thanks,
Sasha
