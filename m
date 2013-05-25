Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3EYMEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 08:04:14 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63979 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab3EYMEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 08:04:13 -0400
Message-ID: <51A0A8B9.4070807@colorfullife.com>
Date: Sat, 25 May 2013 14:04:09 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 06/10] ipc: Don't allocate a copy larger than max
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

You wrote:
> When MSG_COPY is set, a duplicate message must be allocated for
> the copy before locking the queue. However, the copy could
> not be larger than was sent which is limited to msg_ctlmax.
>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>   ipc/msg.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/ipc/msg.c b/ipc/msg.c
> index 950572f..31cd1bf 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -820,15 +820,17 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
>   	struct msg_msg *copy = NULL;
>   	unsigned long copy_number = 0;
>   
> +	ns = current->nsproxy->ipc_ns;
> +
>   	if (msqid < 0 || (long) bufsz < 0)
>   		return -EINVAL;
>   	if (msgflg & MSG_COPY) {
> -		copy = prepare_copy(buf, bufsz, msgflg, &msgtyp, &copy_number);
> +		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax),
> +				    msgflg, &msgtyp, &copy_number);

What about:
- increase msg_ctlmax
- send message
- reduce msg_ctlmax

The side effects of the patch are odd:
- without MSG_COPY, a message can be read regardsless of the size.
   The user could check for E2BIG and increase the buffer size until
   msgrcv succeeds.
- with MSG_COPY, something else would happen.
   As far as I can see, it would oops: msg_ctlmax bytes are allocated,
   then the E2BIG test is against bufsz, and copy_msg() doesn't check
   the size of the target buffer.

I.e.: I would propose to revert the patch.

--
	Manfred
  


