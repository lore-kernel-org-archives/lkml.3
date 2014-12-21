Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaLUXaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 18:30:24 -0500
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:50205 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753399AbaLUXaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 18:30:23 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:966:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2196:2198:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3876:3877:4250:4321:4385:4605:5007:6114:6119:6261:6642:6742:8603:9149:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12740:13255:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: birds62_5a2dc4832a94e
X-Filterd-Recvd-Size: 3445
Message-ID: <1419204617.4200.13.camel@perches.com>
Subject: Re: [PATCH] staging: lustre: lustre: llite: llite_lib.c:  Removes
 unnecessary NULL check
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lai Siyao <laisiyao@whamcloud.com>, Peng Tao <bergwolf@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "John L. Hammond" <john.hammond@intel.com>,
        Brian Behlendorf <behlendorf1@llnl.gov>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sun, 21 Dec 2014 15:30:17 -0800
In-Reply-To: <1419199680-13390-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419199680-13390-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-21 at 23:08 +0100, Rickard Strandqvist wrote:
> Removes same unnecessary NULL check.

Depending on settings, these checks are necessary:

drivers/staging/lustre/lustre/include/obd_support.h:#define POISON(ptr, c, s) memset(ptr, c, s)
[]
drivers/staging/lustre/lustre/include/obd_support.h:#define OBD_FREE_PRE(ptr, size, name)                                  \
drivers/staging/lustre/lustre/include/obd_support.h-    LASSERT(ptr);                                              \
drivers/staging/lustre/lustre/include/obd_support.h-    obd_memory_sub(size);                                      \
drivers/staging/lustre/lustre/include/obd_support.h-    CDEBUG(D_MALLOC, name " '" #ptr "': %d at %p.\n",              \
drivers/staging/lustre/lustre/include/obd_support.h-           (int)(size), ptr);                                      \
drivers/staging/lustre/lustre/include/obd_support.h-    POISON(ptr, 0x5a, size)
[]
drivers/staging/lustre/lustre/include/obd_support.h:#define OBD_FREE(ptr, size)                                            \
drivers/staging/lustre/lustre/include/obd_support.h-do {                                                                          \
drivers/staging/lustre/lustre/include/obd_support.h-    OBD_FREE_PRE(ptr, size, "kfreed");                                  \
drivers/staging/lustre/lustre/include/obd_support.h-    kfree(ptr);                                                     \
drivers/staging/lustre/lustre/include/obd_support.h-    POISON_PTR(ptr);                                                      \
drivers/staging/lustre/lustre/include/obd_support.h-} while (0)

> diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
[]
> @@ -591,10 +591,8 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
>  		get_uuid2fsid(uuid->uuid, strlen(uuid->uuid), &sbi->ll_fsid);
>  	}
>  
> -	if (data != NULL)
> -		OBD_FREE_PTR(data);
> -	if (osfs != NULL)
> -		OBD_FREE_PTR(osfs);
> +	OBD_FREE_PTR(data);
> +	OBD_FREE_PTR(osfs);


