Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbbATJnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:43:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbbATJn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:43:29 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        Jason Wang <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 1/3] Drivers: hv: check vmbus_device_create() return value in vmbus_process_offer()
References: <1421686573-12771-1-git-send-email-vkuznets@redhat.com>
	<1421686573-12771-2-git-send-email-vkuznets@redhat.com>
	<20150119175857.GE6456@mwanda>
Date: Tue, 20 Jan 2015 10:43:19 +0100
In-Reply-To: <20150119175857.GE6456@mwanda> (Dan Carpenter's message of "Mon,
	19 Jan 2015 20:58:58 +0300")
Message-ID: <87bnltkcso.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> On Mon, Jan 19, 2015 at 05:56:11PM +0100, Vitaly Kuznetsov wrote:
>> vmbus_device_create() result is not being checked in vmbus_process_offer() and
>> it can fail if kzalloc() fails. Add the check and do minor cleanup to avoid
>> additional duplication of "free_channel(); return;" block.
>> 
>> Reported-by: Jason Wang <jasowang@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> "out" is always a bad name for a label.  It's too vague.  It implies
> that the code uses "One Err" style error handling which is bug prone and
> I've ranted about that in the past so I won't here.  This kind of coding
> is buggier than direct returns.  But recently I've been looking at bugs
> where we return zero where the code should return a negative error code
> and, wow, do I hate "out" labels!
>
> 	if (function_whatever(xxx))
> 		goto out;
>
> [ thousands of lines removed. ]
>
> out:
> 	return ret;
>
> Oh crap...  Did the coder mean to return success or not???
>
> If you use a direct return then the code looks like:
>
> 	if (function_whatever(xxx))
> 		return 0;
>
> In that case, you can immediately see that the coder typed "0"
> deliberately.  Direct returns are best.  I guess that's not directly
> related to this code.  But I didn't know that until I read to the bottom
> of the patch and I already had this rant prepared in my head ready to
> go...

Thank you for your rant, Dan! It contains an explanation _why_ and so is
useful. However ... :-)

1) vmbus_process_offer() returns void so we won't forget to set proper
return code.
2) this patch is a preparation for the PATCH 3/3 where the label is
being used to do some useful (non-trivial) work. "Direct returns"
approach would require us to duplicate the code or move it to a function
and call it from all return places. I consider adding "out" label being
less evil.

Anyway, I can rename it to something less provocative in PATCH 3/3,
e.g. init_rescind.

>
> "error" is a crap label name because it doesn't tell you what the code
> does.  A better name is "err_free_chan" or something which talks about
> freeing the channel.

And here I have to completely agree with you, I'll rename it in v3.

>
> regards,
> dan carpenter

-- 
  Vitaly
