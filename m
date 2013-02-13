Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3BMHUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:20:15 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39492 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab3BMHUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:20:13 -0500
X-Sasl-enc: 9oUYRhdzZZRKcAMrf+8VfodHgoEv402/vIXqnsxIOPoH 1360740011
Message-ID: <1360740008.2288.3.camel@perseus.themaw.net>
Subject: Re: [PATCH linux-next] autofs4: autofs4_catatonic_mode(): remove
 redundant null check on kfree()
From: Ian Kent <raven@themaw.net>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, autofs@vger.kernel.org
Date: Wed, 13 Feb 2013 15:20:08 +0800
In-Reply-To: <1360689138-59191-1-git-send-email-tim.gardner@canonical.com>
References: <1360689138-59191-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 10:12 -0700, Tim Gardner wrote:
> smatch analysis:
> 
> fs/autofs4/waitq.c:46 autofs4_catatonic_mode() info: redundant null
>  check on wq->name.name calling kfree()

I'm not sure about this change.

autofs4_catatonic_mode() could be called when there are remaining
entries in the wait queue, which is nulled, so autofs4_wait_release()
won't see the the discarded waits if it is called.

> 
> Cc: Ian Kent <raven@themaw.net>
> Cc: autofs@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  fs/autofs4/waitq.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
> index 03bc1d3..3db70da 100644
> --- a/fs/autofs4/waitq.c
> +++ b/fs/autofs4/waitq.c
> @@ -42,10 +42,8 @@ void autofs4_catatonic_mode(struct autofs_sb_info *sbi)
>  	while (wq) {
>  		nwq = wq->next;
>  		wq->status = -ENOENT; /* Magic is gone - report failure */
> -		if (wq->name.name) {
> -			kfree(wq->name.name);
> -			wq->name.name = NULL;
> -		}
> +		kfree(wq->name.name);
> +		wq->name.name = NULL;
>  		wq->wait_ctr--;
>  		wake_up_interruptible(&wq->queue);
>  		wq = nwq;


