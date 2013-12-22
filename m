Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3LVCzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 21:55:38 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:60983 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3LVCzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 21:55:36 -0500
Message-ID: <1387680997.5567.91.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] drivers: target: target_core_mod: use div64_u64_rem()
 instead of operator '%' for u64
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: James Hogan <james.hogan@imgtec.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 21 Dec 2013 18:56:37 -0800
In-Reply-To: <52B4F837.1010403@gmail.com>
References: <52B4F837.1010403@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On Sat, 2013-12-21 at 10:08 +0800, Chen Gang wrote:
> In kernel, need use div64_u64_rem() instead of operator '%' for u64, or
> can not pass compiling (with allmodconfig under metag):
> 
>     MODPOST 2909 modules
>   ERROR: "__umoddi3" [drivers/target/target_core_mod.ko] undefined!
> 
> Also need u64 type cast for u32 variable multiply u32 variable, or will
> cause type overflow issue.
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/target/target_core_alua.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

FYI, this unsigned long long division in core_alua_state_lba_dependent()
was fixed for 32-bit in linux-next >= 12192013 code.

Regardless, thanks for your patch.

--nab

> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index dc0d399..ff2aadc 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -489,7 +489,8 @@ static inline int core_alua_state_lba_dependent(
>  			u64 first_lba = map->lba_map_first_lba;
>  
>  			if (segment_mult) {
> -				start_lba = lba % (segment_size * segment_mult);
> +				u64 tmp = (u64)segment_size * segment_mult;
> +				div64_u64_rem(lba, tmp, &start_lba);
>  				last_lba = first_lba + segment_size - 1;
>  				if (start_lba >= first_lba &&
>  				    start_lba <= last_lba) {


