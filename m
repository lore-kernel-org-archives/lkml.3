Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbbASR7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:59:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39468 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbbASR7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:59:11 -0500
Date: Mon, 19 Jan 2015 20:58:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        Jason Wang <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 1/3] Drivers: hv: check vmbus_device_create() return
 value in vmbus_process_offer()
Message-ID: <20150119175857.GE6456@mwanda>
References: <1421686573-12771-1-git-send-email-vkuznets@redhat.com>
 <1421686573-12771-2-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421686573-12771-2-git-send-email-vkuznets@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 05:56:11PM +0100, Vitaly Kuznetsov wrote:
> vmbus_device_create() result is not being checked in vmbus_process_offer() and
> it can fail if kzalloc() fails. Add the check and do minor cleanup to avoid
> additional duplication of "free_channel(); return;" block.
> 
> Reported-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

"out" is always a bad name for a label.  It's too vague.  It implies
that the code uses "One Err" style error handling which is bug prone and
I've ranted about that in the past so I won't here.  This kind of coding
is buggier than direct returns.  But recently I've been looking at bugs
where we return zero where the code should return a negative error code
and, wow, do I hate "out" labels!

	if (function_whatever(xxx))
		goto out;

[ thousands of lines removed. ]

out:
	return ret;

Oh crap...  Did the coder mean to return success or not???

If you use a direct return then the code looks like:

	if (function_whatever(xxx))
		return 0;

In that case, you can immediately see that the coder typed "0"
deliberately.  Direct returns are best.  I guess that's not directly
related to this code.  But I didn't know that until I read to the bottom
of the patch and I already had this rant prepared in my head ready to
go...

"error" is a crap label name because it doesn't tell you what the code
does.  A better name is "err_free_chan" or something which talks about
freeing the channel.

regards,
dan carpenter

