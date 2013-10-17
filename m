Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab3JQRlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:41:06 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53516 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3JQRlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:41:03 -0400
Message-ID: <5260212D.2090905@lwfinger.net>
Date: Thu, 17 Oct 2013 12:41:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Christopher Li <sparse@chrisli.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sparse: possible false report of context imbalance
References: <525F584C.5010106@lwfinger.net> <20131017162551.GA4123@jtriplet-mobl1>
In-Reply-To: <20131017162551.GA4123@jtriplet-mobl1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 11:25 AM, Josh Triplett wrote:
> On Wed, Oct 16, 2013 at 10:23:56PM -0500, Larry Finger wrote:
>> Sparse reports the following:
>>
>>    CHECK   drivers/staging/rtl8188eu/core/rtw_mlme.c
>> drivers/staging/rtl8188eu/core/rtw_mlme.c:1003:9: warning: context
>> imbalance in 'rtw_free_assoc_resources' - different lock contexts
>> for basic block
>>
>> The code in question is as follows:
>>
>>          if (lock_scanned_queue)
>>                  spin_lock_bh(&(pmlmepriv->scanned_queue.lock));
>>
>>          pwlan = rtw_find_network(&pmlmepriv->scanned_queue,
>> tgt_network->network.MacAddress);
>>
>>          if (lock_scanned_queue)
>>                  spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
>>
>> As this fragment uses the identical test to unlock that is used to
>> lock, and the test variable is not touched, I think this is a false
>> indication. I am using version 0.4.4 of sparse.
>
> Sparse can't track conditional contexts like this; sparse intentionally
> complains here that you're running the same basic block (the
> rtw_find_network call) with and without a lock held.
>
> The following workaround works when this is legitimate, though it isn't
> ideal:
>
> if (condition) {
> 	lock
> 	do_thing
> 	unlock
> } else {
> 	do_thing
> }
>
> Ideally, Sparse should be able to track conditional contexts, but that
> would require some form of abstract evaluation, or as a simplistic hack,
> looking for identical side-effect-free conditional expressions.

Thanks for the answer, which is about what I expected. Sparse is a great tool, 
particularly for endian-related issues.

Larry

