Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab3HMXyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:54:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54360 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3HMXyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:54:24 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-64-520ac72b4709
Date: Wed, 14 Aug 2013 08:54:25 +0900
From: Minchan Kim <minchan@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, guz.fnst@cn.fujitsu.com,
        Benjamin LaHaise <bcrl@kvack.org>, Dave Hansen <dave.hansen@intel.com>,
        lliubbo@gmail.com, aquini@redhat.com, Rik van Riel <riel@redhat.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC 0/3] Pin page control subsystem
Message-ID: <20130813235425.GA2271@bbox>
References: <1376377502-28207-1-git-send-email-minchan@kernel.org>
 <1376387202.31048.2.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376387202.31048.2.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On Tue, Aug 13, 2013 at 11:46:42AM +0200, Krzysztof Kozlowski wrote:
> Hi Minchan,
> 
> On wto, 2013-08-13 at 16:04 +0900, Minchan Kim wrote:
> > patch 2 introduce pinpage control
> > subsystem. So, subsystems want to control pinpage should implement own
> > pinpage_xxx functions because each subsystem would have other character
> > so what kinds of data structure for managing pinpage information depends
> > on them. Otherwise, they can use general functions defined in pinpage
> > subsystem. patch 3 hacks migration.c so that migration is
> > aware of pinpage now and migrate them with pinpage subsystem.
> 
> I wonder why don't we use page->mapping and a_ops? Is there any
> disadvantage of such mapping/a_ops?

Most concern of the approach is how to handle nested pin case.
For example, driver A and driver B pin same file-backed page
conincidently by get_user_pages.
For the migration, we needs following operations.

1. [buffer]'s migrate_page for the file-backed page
2. [driver A]'s migrate_page 
3. [driver B]'s migrate_page

But the page's mapping is only one. How can we handle it?

If we give up pinpage subsystem unifying userspace pages(ex, GUP)
and kernel space pages(ex, zswap, zram and zcache), we can go
address_space's migatepages but we might lost abstraction so that
all of users should implement own pinpage manager. It's not hard,
I guess but it's more error-prone and not maintainable for the future.

> 
> Best regards,
> Krzysztof
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
