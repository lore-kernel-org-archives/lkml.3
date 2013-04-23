Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab3DWWkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:40:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab3DWWkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 18:40:20 -0400
Date: Tue, 23 Apr 2013 15:40:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: tglx@linutronix.de, peterz@infradead.org, shli@fusionio.com,
        srivatsa.bhat@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
        fweisbec@gmail.com, sedat.dilek@gmail.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] smp: use '|=' for csd_lock
Message-Id: <20130423154019.4563d819760f5c5dd07ff4f6@linux-foundation.org>
In-Reply-To: <1366609643-17628-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1366609643-17628-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013 13:47:22 +0800 liguang <lig.fnst@cn.fujitsu.com> wrote:

> originally, 'data->flags = CSD_FLAG_LOCK',
> and we use 'data->flags &= ~CSD_FLAG_LOCK'
> for csd_unlock, they are not symmetrix operations
> so use '|=' instead of '='.
> though, now data->flags only hold CSD_FLAG_LOCK,
> it's not so meaningful to use '|=' to set 1 bit,
> and '&= ~' to clear 1 bit.
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  kernel/smp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 1818dc0..2d5deb4 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -109,7 +109,7 @@ static void csd_lock_wait(struct call_single_data *data)
>  static void csd_lock(struct call_single_data *data)
>  {
>  	csd_lock_wait(data);
> -	data->flags = CSD_FLAG_LOCK;
> +	data->flags |= CSD_FLAG_LOCK;
>  
>  	/*

call_single_data.flags is in fact presently a boolean - we only use one
bit in that word.  We could remove all the &=, |=, & and | operations
on call_single_data.flags and treat it as a boolean.  That would
probably result in faster and smaller code.

But leaving the other 31 bits alone and reserved-for-future-use is not
a bad thing.  But if we're going to do that we should do it consistently.

I rewrote your changelog ;)


From: liguang <lig.fnst@cn.fujitsu.com>
Subject: kernel/smp.c: use '|=' for csd_lock

csd_lock() uses assignment to data->flags rather than |=.  That is not
buggy at present because only one bit (CSD_FLAG_LOCK) is defined in
call_single_data.flags.

But it will become buggy if we later add another flag, so fix it now.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/smp.c~kernel-smpc-use-=-for-csd_lock kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-use-=-for-csd_lock
+++ a/kernel/smp.c
@@ -110,7 +110,7 @@ static void csd_lock_wait(struct call_si
 static void csd_lock(struct call_single_data *data)
 {
 	csd_lock_wait(data);
-	data->flags = CSD_FLAG_LOCK;
+	data->flags |= CSD_FLAG_LOCK;
 
 	/*
 	 * prevent CPU from reordering the above assignment
_

