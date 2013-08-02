Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3HBK16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:27:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48030 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3HBK1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:27:55 -0400
Date: Fri, 2 Aug 2013 13:27:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] staging: ozwpan: Increase farewell report size.
Message-ID: <20130802102735.GB5051@mwanda>
References: <1375379102-18217-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375379102-18217-1-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 06:45:01PM +0100, Rupesh Gujare wrote:
> Farewell report size can be bigger than one byte, increase array
> size to accomodate maximum 32 bytes of farewell report.
> 

Gar...  No.  This is not right.

1) There is no check limiting the size to 32 and it could be up to
   253 bytes.

2) Use defines instead of magic numbers.

3) The oz_farewell struct is supposed to be a variable length struct
   but the variable part is put in the middle.  It doesn't make any
   sense to put the length of the variable size array after then end
   of the array because we can never find it again!  Put the
   variable size array at the end.  Make it a zero length array.
   u8 len;
   u8 report[0];

4) In oz_add_farewell() we do this:

	f = kmalloc(sizeof(struct oz_farewell) + len - 1, GFP_ATOMIC);

    The "- 1" refers to sizeof(f->report) but because it was a magic
    number then it was missed when the sizeof(f->report) changed.

5) In [patch 6/6] we set the ->len member.  But because it is at the
   end of a variable length array with no limit check the remote
   attacker can just rewrite it using the memcpy() on the next line.

regards,
dan carpenter
