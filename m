Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3BADUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:20:40 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37412 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753156Ab3BADUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:20:37 -0500
Message-ID: <1359688835.15911.4.camel@joe-AO722>
Subject: Re: [PATCH] block: partition: optimize memory allocation in
 check_partition
From: Joe Perches <joe@perches.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@ti.com>,
        stable@vger.kernel.org
Date: Thu, 31 Jan 2013 19:20:35 -0800
In-Reply-To: <1359688060-12964-1-git-send-email-ming.lei@canonical.com>
References: <1359688060-12964-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-01 at 11:07 +0800, Ming Lei wrote:
> Currently, sizeof(struct parsed_partitions) may be 64KB in 32bit arch,
> so it is easy to trigger page allocation failure by check_partition,
[]
> This patch does below optimizations on the allocation of struct
> parsed_partitions to try to address the issue:
> 
> - make parsed_partitions.parts as pointer so that the pointed memory
> can fit in 32KB buffer, then approximate 32KB memory can be saved
> 
> - vmalloc the buffer pointed by parsed_partitions.parts because
> 32KB is still a bit big for kmalloc
[]
> diff --git a/block/partitions/check.h b/block/partitions/check.h
[]
> @@ -15,13 +15,15 @@ struct parsed_partitions {
>  		int flags;
>  		bool has_info;
>  		struct partition_meta_info info;
> -	} parts[DISK_MAX_PARTS];
> +	} *parts;

This is relatively unusual style.
Could you break out this struct instead?

struct partition_parts {
	...
};

and use

	struct partition_parts *parts;

