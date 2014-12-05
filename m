Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaLEI2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:28:20 -0500
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:47152 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752140AbaLEI2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:28:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3870:3871:4321:5007:6119:6261:6742:6743:10004:10044:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ghost02_d9262a2b1c5a
X-Filterd-Recvd-Size: 2586
Message-ID: <1417768091.2721.47.camel@perches.com>
Subject: Re: [PATCH] staging: lustre: fix sparse warning on LPROC_SEQ_FOPS
 macros
From: Joe Perches <joe@perches.com>
To: Tristan Lelong <tristan@lelong.xyz>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, askb23@gmail.com, john.hammond@intel.com,
        gdonald@gmail.com, anhlq2110@gmail.com, fabio.falzoi84@gmail.com,
        oort10@gmail.com, agimenez@sysvalve.es, rupran@einserver.de,
        surya.seetharaman9@gmail.com, Julia.Lawall@lip6.fr,
        a.terekhov@gmail.com, liang.zhen@intel.com, vthakkar1994@gmail.com,
        amk@cray.com, srikrishanmalik@gmail.com, rd@radekdostal.com,
        bergwolf@gmail.com, dan.carpenter@oracle.com,
        paul.gortmaker@windriver.com, tapaswenipathak@gmail.com,
        email@christophjaeger.info, uja.ornl@gmail.com, brilliantov@inbox.ru,
        dmitry.eremin@intel.com, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Dec 2014 00:28:11 -0800
In-Reply-To: <1417766627-5232-1-git-send-email-tristan@lelong.xyz>
References: <1417766627-5232-1-git-send-email-tristan@lelong.xyz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 00:03 -0800, Tristan Lelong wrote:
> This patch fix a sparse warning in lustre sources
> 
> warning: incorrect type in argument 1 (different address spaces)
>     expected void [noderef] <asn:1>*to
>     got char *<noident>
[]
> diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c b/drivers/staging/lustre/lustre/fld/lproc_fld.c
[]
> @@ -87,13 +87,21 @@ fld_proc_hash_seq_show(struct seq_file *m, void *unused)
>  }
>  
>  static ssize_t
> -fld_proc_hash_seq_write(struct file *file, const char *buffer,
> -			size_t count, loff_t *off)
> +fld_proc_hash_seq_write(struct file *file,
> +				const char __user *buffer,
> +				size_t count, loff_t *off)
>  {
>  	struct lu_client_fld *fld;
>  	struct lu_fld_hash *hash = NULL;
> +	char name[80];
>  	int i;
>  
> +	if (count > 80)
> +		return -ENAMETOOLONG;
> +
> +	if (copy_from_user(name, buffer, count) != 0)
> +		return -EFAULT;
> +
>  	fld = ((struct seq_file *)file->private_data)->private;
>  	LASSERT(fld != NULL);
>  

Why 80?  Is there no #define for this length?

