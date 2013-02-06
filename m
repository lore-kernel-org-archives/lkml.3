Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784Ab3BFVyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:54:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab3BFVyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:54:11 -0500
Date: Wed, 6 Feb 2013 13:54:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: jiang.liu@huawei.com, wujianguo@huawei.com, hpa@zytor.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] acpi, memory-hotplug: Support getting hotplug info
 from SRAT.
Message-Id: <20130206135409.3d8b37f7.akpm@linux-foundation.org>
In-Reply-To: <5111BE09.2030509@cn.fujitsu.com>
References: <1359106929-3034-1-git-send-email-tangchen@cn.fujitsu.com>
	<1359106929-3034-4-git-send-email-tangchen@cn.fujitsu.com>
	<20130204152651.2bca8dba.akpm@linux-foundation.org>
	<5111BE09.2030509@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2013 10:20:57 +0800
Tang Chen <tangchen@cn.fujitsu.com> wrote:

> >>
> >> +	if (!strncmp(p, "acpi", max(4, strlen(p))))
> >> +		movablemem_map.acpi = true;
> >
> > Generates a warning:
> >
> > mm/page_alloc.c: In function 'cmdline_parse_movablemem_map':
> > mm/page_alloc.c:5312: warning: comparison of distinct pointer types lacks a cast
> >
> > due to max(int, size_t).
> >
> > This is easily fixed, but the code looks rather pointless.  If the
> > incoming string is supposed to be exactly "acpi" then use strcmp().  If
> > the incoming string must start with "acpi" then use strncmp(p, "acpi", 4).
> >
> > IOW, the max is unneeded?
> 
> Hi Andrew,
> 
> I think I made another mistake here. I meant to use min(4, strlen(p)) in 
> case p is
> something like 'aaa' whose length is less then 4. But I mistook it with 
> max().
> 
> But after I dig into strcmp() in the kernel, I think it is OK to use 
> strcmp().
> min() or max() is not needed.

OK, I did that.

But the code still looks a bit more complex than we need.  Could we do

static int __init cmdline_parse_movablemem_map(char *p)
{
	char *oldp;
	u64 start_at, mem_size;

	if (!p)
		goto err;

	/*
	 * If user decide to use info from BIOS, all the other user specified
	 * ranges will be ingored.
	 */
	if (!strcmp(p, "acpi")) {
		movablemem_map.acpi = true;
		if (movablemem_map.nr_map) {
			memset(movablemem_map.map, 0,
				sizeof(struct movablemem_entry)
				* movablemem_map.nr_map);
			movablemem_map.nr_map = 0;
		}
		return 0;
	}

