Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab3HABq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:46:29 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:34166 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3HABq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:46:28 -0400
From: Caizhiyong <caizhiyong@huawei.com>
To: Karel Zak <kzak@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Quyaxin <quyaxin@huawei.com>
Subject: RE: [PATCH] block: support embedded device command line partition
Thread-Topic: [PATCH] block: support embedded device command line partition
Thread-Index: Ac6K0RTEqYNaxbjoQ2ihDHJZj1d9uAC3UDQAACptZUA=
Date: Thu, 1 Aug 2013 01:46:17 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C061BEA@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C06195E@szxeml512-mbs.china.huawei.com>
 <20130731132514.GB1127@x2.net.home>
In-Reply-To: <20130731132514.GB1127@x2.net.home>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Karel Zak [mailto:kzak@redhat.com]
> Sent: Wednesday, July 31, 2013 9:25 PM
> To: Caizhiyong
> Cc: Andrew Morton; linux-kernel@vger.kernel.org; Wanglin (Albert); Quyaxin
> Subject: Re: [PATCH] block: support embedded device command line partition
> 
> On Sat, Jul 27, 2013 at 01:56:24PM +0000, Caizhiyong wrote:
> > +static int parse_partitions(struct parsed_partitions *state,
> > +			    struct cmdline_parts *parts)
> > +{
> > +	int slot;
> > +	uint64_t from = 0;
> > +	uint64_t disk_size;
> > +	char buf[BDEVNAME_SIZE];
> > +	struct cmdline_subpart *subpart;
> > +
> > +	bdevname(state->bdev, buf);
> > +
> > +	while (parts && strncmp(buf, parts->name, BDEVNAME_SIZE))
> > +		parts = parts->next_parts;
> > +
> > +	if (!parts)
> > +		return 0;
> > +
> > +	disk_size = (uint64_t) get_capacity(state->bdev->bd_disk) << 9;
> > +
> > +	for (slot = 1, subpart = parts->subpart;
> > +	     subpart && slot < state->limit;
> > +	     subpart = subpart->next_subpart, slot++) {
> > +
> > +		unsigned label_max;
> > +		struct partition_meta_info *info;
> > +
> > +		if (subpart->from == OFFSET_CONTINUOUS)
> > +			subpart->from = from;
> > +		else
> > +			from = subpart->from;
> > +
> > +		if (from >= disk_size)
> > +			break;
> > +
> > +		if (subpart->size > (disk_size - from))
> > +			subpart->size = disk_size - from;
> > +
> > +		from += subpart->size;
> > +
> > +		put_partition(state, slot, le64_to_cpu(subpart->from >> 9),
> > +			      le64_to_cpu(subpart->size >> 9));
> 
>  Why le64_to_cpu()?
> 
>  I guess that memparse() does not return explicitly LE and it also
>  seems that your code  on another places uses ->size and ->from
>  without any extra care.

Right. I will remove.

> 
>     Karel
> 
> --
>  Karel Zak  <kzak@redhat.com>
>  http://karelzak.blogspot.com
