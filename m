Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab3FZX24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:28:56 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34269 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3FZX2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:28:54 -0400
Message-ID: <51CB792D.6030504@redhat.com>
Date: Thu, 27 Jun 2013 01:28:45 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: NVMe: Add nvme-scsi.c (was Re: [PULL REQUEST] NVMe driver updates)
References: <20130509202015.GJ6057@linux.intel.com>
In-Reply-To: <20130509202015.GJ6057@linux.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/05/2013 22:20, Matthew Wilcox ha scritto:
>       NVMe: Add nvme-scsi.c

I couldn't find the original patch on LKML, so I'll just quote the
relevant piece of code.

> +int nvme_sg_io(struct nvme_ns *ns, struct sg_io_hdr __user *u_hdr)
> +{
> +	struct sg_io_hdr hdr;
> +	int retcode;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;

This should be EPERM, and also it should use the same checks as other
implementations of SG_IO, including:

- checking if it's operating on a partition, and requiring CAP_SYS_RAWIO
if so;

- allowing a limited number of commands even for !capable(CAP_SYS_RAWIO).

All this is done by scsi_cmd_blk_ioctl.

Paolo

> +	if (copy_from_user(&hdr, u_hdr, sizeof(hdr)))
> +		return -EFAULT;
> +	if (hdr.interface_id != 'S')
> +		return -EINVAL;
> +	if (hdr.cmd_len > BLK_MAX_CDB)
> +		return -EINVAL;
> +
> +	retcode = nvme_scsi_translate(ns, &hdr);
> +	if (retcode < 0)
> +		return retcode;
> +	if (retcode > 0)
> +		retcode = SNTI_TRANSLATION_SUCCESS;
> +	if (copy_to_user(__user u_hdr, &hdr, sizeof(sg_io_hdr_t)) > 0)
> +		return -EFAULT;
> +
> +	return retcode;
> +}


