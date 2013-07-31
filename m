Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab3GaNZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:25:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759424Ab3GaNZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:21 -0400
Date: Wed, 31 Jul 2013 15:25:14 +0200
From: Karel Zak <kzak@redhat.com>
To: Caizhiyong <caizhiyong@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Quyaxin <quyaxin@huawei.com>
Subject: Re: [PATCH] block: support embedded device command line partition
Message-ID: <20130731132514.GB1127@x2.net.home>
References: <C3050A4DBA34F345975765E43127F10F1C06195E@szxeml512-mbs.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C06195E@szxeml512-mbs.china.huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 01:56:24PM +0000, Caizhiyong wrote:
> +static int parse_partitions(struct parsed_partitions *state,
> +			    struct cmdline_parts *parts)
> +{
> +	int slot;
> +	uint64_t from = 0;
> +	uint64_t disk_size;
> +	char buf[BDEVNAME_SIZE];
> +	struct cmdline_subpart *subpart;
> +
> +	bdevname(state->bdev, buf);
> +
> +	while (parts && strncmp(buf, parts->name, BDEVNAME_SIZE))
> +		parts = parts->next_parts;
> +
> +	if (!parts)
> +		return 0;
> +
> +	disk_size = (uint64_t) get_capacity(state->bdev->bd_disk) << 9;
> +
> +	for (slot = 1, subpart = parts->subpart;
> +	     subpart && slot < state->limit;
> +	     subpart = subpart->next_subpart, slot++) {
> +
> +		unsigned label_max;
> +		struct partition_meta_info *info;
> +
> +		if (subpart->from == OFFSET_CONTINUOUS)
> +			subpart->from = from;
> +		else
> +			from = subpart->from;
> +
> +		if (from >= disk_size)
> +			break;
> +
> +		if (subpart->size > (disk_size - from))
> +			subpart->size = disk_size - from;
> +
> +		from += subpart->size;
> +
> +		put_partition(state, slot, le64_to_cpu(subpart->from >> 9),
> +			      le64_to_cpu(subpart->size >> 9));

 Why le64_to_cpu()?
 
 I guess that memparse() does not return explicitly LE and it also
 seems that your code  on another places uses ->size and ->from
 without any extra care.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
