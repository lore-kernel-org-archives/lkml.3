Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab3GPQXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:23:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:16054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab3GPQXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:23:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,678,1367996400"; 
   d="scan'208";a="346522551"
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to
 moduledependency.
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-crypto <linux-crypto@vger.kernel.org>
In-Reply-To: <201307162249.JEA41532.FFOLHVQJFtOOMS@I-love.SAKURA.ne.jp>
References: <201307162053.GBC56724.MFVOJtSLQHFOOF@I-love.SAKURA.ne.jp>
	 <20130716115527.GA1034@gondor.apana.org.au>
	 <201307162249.JEA41532.FFOLHVQJFtOOMS@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Jul 2013 09:23:48 -0700
Message-ID: <1373991828.22432.274.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 22:49 +0900, Tetsuo Handa wrote:
> Herbert Xu wrote:
> > Looks like a bug in whatever is creating the initrd as it isn't
> > including modules necessary for the boot.
> 
> It turned out that it is already wrong as of creating modules.dep.
> 
>   # grep crc /lib/modules/3.11.0-rc1/modules.dep
>   kernel/crypto/crct10dif.ko:
>   kernel/drivers/scsi/sd_mod.ko: kernel/lib/crc-t10dif.ko
>   kernel/lib/crc-t10dif.ko:
> 
> modules.dep says
> 
>   (1) sd_mod.ko depends on crc-t10dif.ko
>   (2) crc-t10dif.ko does not depend on crct10dif.ko

Yes, the generator of modules.dep does not seem to pick up the right
dependency.  

> 
> but commit 2d31e518 made crc-t10dif.ko depend on crct10dif.ko , didn't it?
> 
> crct10dif.ko need to be loaded before crc-t10dif.ko is loaded, but doing
> 
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 35da513..53ee0fd 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -68,6 +68,7 @@ config CRC_T10DIF
>  	tristate "CRC calculation for the T10 Data Integrity Field"
>  	select CRYPTO
>  	select CRYPTO_CRCT10DIF
> +	depends on CRYPTO_CRCT10DIF

Herbert, seems like modules.dep generator wants explicit

- 	select CRYPTO_CRCT10DIF
+	depends on CRYPTO_CRCT10DIF

But it seems to me like it should have known CRC_T10DIF needs
CRYPTO_CRCT10DIF when we do 
	select CRYPTO_CRCT10DIF

Your thoughts?

Thanks.

Tim

>  	help
>  	  This option is only needed if a module that's not in the
>  	  kernel tree needs to calculate CRC checks for use with the
> 
> causes below warning.
> 
>   crypto/Kconfig:379:     symbol CRYPTO_CRCT10DIF is selected by CRC_T10DIF
>   warning: (BLK_DEV_SD && SCSI_LPFC && SCSI_DEBUG) selects CRC_T10DIF which has unmet direct dependencies (CRYPTO_CRCT10DIF)


