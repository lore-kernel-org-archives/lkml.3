Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966679Ab3E2PMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:12:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966346Ab3E2PMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:12:41 -0400
Message-ID: <51A61ADD.8040707@redhat.com>
Date: Wed, 29 May 2013 17:12:29 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: megaraidlinux@lsi.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kashyap.desai@lsi.com, aradford@gmail.com,
        Li Zefan <lizefan@huawei.com>, Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH RESEND] scsi: megaraid: check kzalloc
References: <519ECEF1.9060804@huawei.com> <519F3592.4090207@huawei.com>
In-Reply-To: <519F3592.4090207@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 11:40 AM, Libo Chen wrote:
> we should check kzalloc, avoid to hit oops
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/scsi/megaraid.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> instead of checking scmd->device, sdev is more appropriate.
>
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 846f475..6b623cb 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -4161,6 +4161,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
>  	memset(scb, 0, sizeof(scb_t));
>
>  	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
> +	if (sdev) {
> +		scsi_free_command(GFP_KERNEL, scmd);

I think, that a mutex_unlock(&adapter->int_mtx); is also needed
Maybe just setting a rval = -ENOMEM and a jump to to some point below?

tomash

> +		return -ENOMEM;
> +	}
>  	scmd->device = sdev;
>
>  	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));

