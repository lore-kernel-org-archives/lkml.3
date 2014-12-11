Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaLKMOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:14:09 -0500
Received: from exprod7og129.obsmtp.com ([64.18.2.122]:60447 "EHLO
	exprod7og129.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaLKMOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:14:06 -0500
MIME-Version: 1.0
In-Reply-To: <yq1wq5zcjmd.fsf@sermon.lab.mkp.net>
References: <1418131643-11568-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1wq5zcjmd.fsf@sermon.lab.mkp.net>
Date: Thu, 11 Dec 2014 17:44:03 +0530
Message-ID: <CAK=zhgrr=9+3dynE6fuTikNwnBFKe5x=jA+UTzPKqfNAyXt_ow@mail.gmail.com>
Subject: Re: [PATCH 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary
 restriction for the module parameter max_sgl_entries
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Sathya Prakash <Sathya.Prakash@avagotech.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2486,9 +2486,13 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
>
>         /* command line tunables  for max sgl entries */
>         if (max_sgl_entries != -1) {
> -               ioc->shost->sg_tablesize = (max_sgl_entries <
> -                   MPT2SAS_SG_DEPTH) ? max_sgl_entries :
> -                   MPT2SAS_SG_DEPTH;
> +               if (max_sgl_entries > MPT2SAS_SG_DEPTH)
> +                       printk(MPT2SAS_WARN_FMT
> +                        "setting max_sgl_entries(%d), overriding kernel"
> +                        " defined SCSI_MAX_SG_SEGMENTS(%d)\n", ioc->name,
> +                         max_sgl_entries, MPT2SAS_SG_DEPTH);
> +               ioc->shost->sg_tablesize =  min_t(unsigned short,
> +                            max_sgl_entries, SCSI_MAX_SG_CHAIN_SEGMENTS);
>         } else {
>                 ioc->shost->sg_tablesize = MPT2SAS_SG_DEPTH;
>         }
>
> Wouldn't it be better to print the new scatterlist limit after it has
> been clamped to reflect what it's actually being set to?

but Martin, I though to warn the user that the module parameter
max_sgl_entries value what they provided is greater than the kernel
defined SCSI_MAX_SG_SEGMENTS, whether if this module parameter value
is greater than or less than the SCSI_MAX_SG_CHAIN_SEGMENTS. Also I
thought, user may confuse if see observes SCSI_MAX_SG_CHAIN_SEGMENTS
value instead of max_sgl_entries value in the warning message.

Please let me known If my assumption is wrong. Then I will modify this
patch according to your suggestion i.e I will print the scatterlist
limit after it has been clamped.

Thanks,
Sreekanth
