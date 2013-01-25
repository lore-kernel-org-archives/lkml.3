Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab3AYP5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:57:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22766 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab3AYP53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:57:29 -0500
MIME-Version: 1.0
Message-ID: <b3ab2d2f-a0a1-44ff-ac8f-bb0ed73d8978@default>
Date: Fri, 25 Jan 2013 07:56:29 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCHv2 1/9] staging: zsmalloc: add gfp flags to zs_create_pool
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1357590280-31535-2-git-send-email-sjenning@linux.vnet.ibm.com>
 <CAEwNFnDWpyvmN-fU=MczXKtcay6vMMCOOHUM2M09+wx7zOVxDQ@mail.gmail.com>
 <51029FC3.4060402@linux.vnet.ibm.com>
In-Reply-To: <51029FC3.4060402@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCHv2 1/9] staging: zsmalloc: add gfp flags to zs_create_pool
> 
> On 01/24/2013 07:33 PM, Minchan Kim wrote:
> > Hi Seth, frontswap guys
> >
> > On Tue, Jan 8, 2013 at 5:24 AM, Seth Jennings
> > <sjenning@linux.vnet.ibm.com> wrote:
> >> zs_create_pool() currently takes a gfp flags argument
> >> that is used when growing the memory pool.  However
> >> it is not used in allocating the metadata for the pool
> >> itself.  That is currently hardcoded to GFP_KERNEL.
> >>
> >> zswap calls zs_create_pool() at swapon time which is done
> >> in atomic context, resulting in a "might sleep" warning.
> >
> > I didn't review this all series, really sorry but totday I saw Nitin
> > added Acked-by so I'm afraid Greg might get it under my radar. I'm not
> > strong against but I would like know why we should call frontswap_init
> > under swap_lock? Is there special reason?
> 
> The call stack is:
> 
> SYSCALL_DEFINE2(swapon.. <-- swapon_mutex taken here
> enable_swap_info() <-- swap_lock taken here
> frontswap_init()
> __frontswap_init()
> zswap_frontswap_init()
> zs_create_pool()
> 
> It isn't entirely clear to me why frontswap_init() is called under
> lock.  Then again, I'm not entirely sure what the swap_lock protects.
>  There are no comments near the swap_lock definition to tell me.
> 
> I would guess that the intent is to block any writes to the swap
> device until frontswap_init() has completed.
> 
> Dan care to weigh in?

I think frontswap's first appearance needs to be atomic, i.e.
the transition from (a) frontswap is not present and will fail
all calls, to (b) frontswap is fully functional... that transition
must be atomic.  And, once Konrad's module patches are in, the
opposite transition must be atomic also.  But there are most
likely other ways to do those transitions atomically that
don't need to hold swap_lock.

Honestly, I never really focused on the initialization code
so I am very open to improvements as long as they work for
all the various frontswap backends.

Dan
