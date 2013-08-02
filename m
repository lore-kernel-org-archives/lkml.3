Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab3HBLA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:00:56 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:43943 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab3HBLAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:00:54 -0400
Message-ID: <51FB915C.1050003@atmel.com>
Date: Fri, 2 Aug 2013 12:00:44 +0100
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@linuxdriverproject.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] staging: ozwpan: Increase farewell report size.
References: <1375379102-18217-1-git-send-email-rupesh.gujare@atmel.com> <20130802102735.GB5051@mwanda>
In-Reply-To: <20130802102735.GB5051@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/13 11:27, Dan Carpenter wrote:
> On Thu, Aug 01, 2013 at 06:45:01PM +0100, Rupesh Gujare wrote:
>> Farewell report size can be bigger than one byte, increase array
>> size to accomodate maximum 32 bytes of farewell report.
>>
> Gar...  No.  This is not right.
>
> 1) There is no check limiting the size to 32 and it could be up to
>     253 bytes.
>
> 2) Use defines instead of magic numbers.
>
> 3) The oz_farewell struct is supposed to be a variable length struct
>     but the variable part is put in the middle.  It doesn't make any
>     sense to put the length of the variable size array after then end
>     of the array because we can never find it again!  Put the
>     variable size array at the end.  Make it a zero length array.
>     u8 len;
>     u8 report[0];
>
> 4) In oz_add_farewell() we do this:
>
> 	f = kmalloc(sizeof(struct oz_farewell) + len - 1, GFP_ATOMIC);
>
>      The "- 1" refers to sizeof(f->report) but because it was a magic
>      number then it was missed when the sizeof(f->report) changed.
>
> 5) In [patch 6/6] we set the ->len member.  But because it is at the
>     end of a variable length array with no limit check the remote
>     attacker can just rewrite it using the memcpy() on the next line.
>
>
Thanks Dan.

A patch follows to fix above issues.

-- 
Regards,
Rupesh Gujare

