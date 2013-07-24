Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3GXXMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:12:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3GXXMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:12:24 -0400
Date: Wed, 24 Jul 2013 16:12:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        channing <chao.bi@intel.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: Re: [PATCH] ti-st: fix NULL dereference on protocol type check
Message-Id: <20130724161222.f87f698d991594f5c94e455f@linux-foundation.org>
In-Reply-To: <1374589774-450-1-git-send-email-gustavo@padovan.org>
References: <1374589774-450-1-git-send-email-gustavo@padovan.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013 15:29:31 +0100 Gustavo Padovan <gustavo@padovan.org> wrote:

> From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> 
> If the type we receive is greater than ST_MAX_CHANNELS we can't rely on
> type as vector index since we would be accessing unknown memory when we use the type
> as index.
> 
>  Unable to handle kernel NULL pointer dereference at virtual address 0000001b
>  pgd = c0004000
>  [0000001b] *pgd=00000000
>  Internal error: Oops: 17 [#1] PREEMPT SMP ARM
>  Modules linked in: btwilink wl12xx wlcore mac80211 cfg80211 rfcomm bnep bluo
>  CPU: 0    Tainted: G        W     (3.4.0+ #15)
>  PC is at st_int_recv+0x278/0x344
>  LR is at get_parent_ip+0x14/0x30
>  pc : [<c03b01a8>]    lr : [<c007273c>]    psr: 200f0193
>  sp : dc631ed0  ip : e3e21c24  fp : dc631f04
>  r10: 00000000  r9 : 600f0113  r8 : 0000003f
>  r7 : e3e21b14  r6 : 00000067  r5 : e2e49c1c  r4 : e3e21a80
>  r3 : 00000001  r2 : 00000001  r1 : 00000001  r0 : 600f0113
>  Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
>  Control: 10c5387d  Table: 9c50004a  DAC: 00000015
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
> ---
>  drivers/misc/ti-st/st_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
> index 0a14280..8e64eb1 100644
> --- a/drivers/misc/ti-st/st_core.c
> +++ b/drivers/misc/ti-st/st_core.c
> @@ -343,7 +343,7 @@ void st_int_recv(void *disc_data,
>  			/* Unknow packet? */
>  		default:
>  			type = *ptr;
> -			if (st_gdata->list[type] == NULL) {
> +			if (type >= ST_MAX_CHANNELS || st_gdata->list[type] == NULL) {
>  				pr_err("chip/interface misbehavior dropping"
>  					" frame starting with 0x%02x", type);
>  				goto done;

This would be a bug in the calling code, would it not?

How did this come about?
