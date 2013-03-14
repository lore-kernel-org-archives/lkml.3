Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483Ab3CNQLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:11:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28128 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933437Ab3CNQLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:11:38 -0400
MIME-Version: 1.0
Message-ID: <d02b5afd-bcb0-47df-9960-8e2122a04ad8@default>
Date: Thu, 14 Mar 2013 09:10:48 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH 4/4] zcache: add pageframes count once compress
 zero-filled pages twice
References: <1363158321-20790-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1363158321-20790-5-git-send-email-liwanp@linux.vnet.ibm.com>
 <634487ea-fbbd-4eb9-9a18-9206edc4e0d2@default>
 <20130314002056.GA10062@hacker.(null)>
In-Reply-To: <20130314002056.GA10062@hacker.(null)>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Wanpeng Li [mailto:liwanp@linux.vnet.ibm.com]
> Sent: Wednesday, March 13, 2013 6:21 PM
> To: Dan Magenheimer
> Cc: Andrew Morton; Greg Kroah-Hartman; Dan Magenheimer; Seth Jennings; Konrad Rzeszutek Wilk; Minchan
> Kim; linux-mm@kvack.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 4/4] zcache: add pageframes count once compress zero-filled pages twice
> 
> On Wed, Mar 13, 2013 at 09:42:16AM -0700, Dan Magenheimer wrote:
> >> From: Wanpeng Li [mailto:liwanp@linux.vnet.ibm.com]
> >> Sent: Wednesday, March 13, 2013 1:05 AM
> >> To: Andrew Morton
> >> Cc: Greg Kroah-Hartman; Dan Magenheimer; Seth Jennings; Konrad Rzeszutek Wilk; Minchan Kim; linux-
> >> mm@kvack.org; linux-kernel@vger.kernel.org; Wanpeng Li
> >> Subject: [PATCH 4/4] zcache: add pageframes count once compress zero-filled pages twice
> >
> >Hi Wanpeng --
> >
> >Thanks for taking on this task from the drivers/staging/zcache TODO list!
> >
> >> Since zbudpage consist of two zpages, two zero-filled pages compression
> >> contribute to one [eph|pers]pageframe count accumulated.
> >
> 
> Hi Dan,
> 
> >I'm not sure why this is necessary.  The [eph|pers]pageframe count
> >is supposed to be counting actual pageframes used by zcache.  Since
> >your patch eliminates the need to store zero pages, no pageframes
> >are needed at all to store zero pages, so it's not necessary
> >to increment zcache_[eph|pers]_pageframes when storing zero
> >pages.
> >
> 
> Great point! It seems that we also don't need to caculate
> zcache_[eph|pers]_zpages for zero-filled pages. I will fix
> it in next version. :-)

Hi Wanpeng --

I think we DO need to increment/decrement zcache_[eph|pers]_zpages
for zero-filled pages.

The main point of the counters for zpages and pageframes
is to be able to calculate density == zpages/pageframes.
A zero-filled page becomes a zpage that "compresses" to zero bytes
and, as a result, requires zero pageframes for storage.
So the zpages counter should be increased but the pageframes
counter should not.

If you are changing the patch anyway, I do like better the use
of "zero_filled_page" rather than just "zero" or "zero page".
So it might be good to change:

handle_zero_page -> handle_zero_filled_page
pages_zero -> zero_filled_pages
zcache_pages_zero -> zcache_zero_filled_pages

and maybe

page_zero_filled -> page_is_zero_filled

Thanks,
Dan
