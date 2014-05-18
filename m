Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaERFxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 01:53:07 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:62991 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaERFxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 01:53:06 -0400
Message-ID: <53784ABD.8080209@colorfullife.com>
Date: Sun, 18 May 2014 07:53:01 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, akpm@linux-foundation.org
CC: aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ipc,msg: always respect MSG_NOERROR
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com> <1400012857-11733-4-git-send-email-davidlohr@hp.com>
In-Reply-To: <1400012857-11733-4-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 10:27 PM, Davidlohr Bueso wrote:
> When specifying the MSG_NOERROR flag, receivers can avoid returning
> error (E2BIG) and just truncate the message text, if it is too large.
>
> Currently, this logic is only respected when there are already pending
> messages in the queue.
Do you have a test case? The code should handle that
(See below)
>   Fix this for the case when there are only
> receivers waiting for a msg to be sent. In order for this to work, save
> the flags in the msg_receiver struct as it must be used later when
> doing the pipeline send.
No, it is sufficient to set the message size to infinity.

> Also do some pipeline_send() cleanups while at it.
No - please don't mix cleanups with bugfixes.

>   
>   long do_msgsnd(int msqid, long mtype, void __user *mtext,
> @@ -901,6 +907,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
>   		list_add_tail(&msr_d.r_list, &msq->q_receivers);
>   		msr_d.r_tsk = current;
>   		msr_d.r_msgtype = msgtyp;
> +		msr_d.r_msgflg = msgflg;
>   		msr_d.r_mode = mode;
>   		if (msgflg & MSG_NOERROR)
>   			msr_d.r_maxsize = INT_MAX;
    ^^^^^^
This code should handle MSG_NOERROR:
If MSG_NOERROR is set, then maxsize is set to INT_MAX, therefore -E2BIG 
should never be returned.

--
     Manfred
