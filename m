Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaFNDG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 23:06:29 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63365 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaFNDG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 23:06:27 -0400
Message-ID: <1402715082.750.13.camel@debian>
Subject: Re: [PATCH v2] mm/vmscan.c: wrap five parameters into shrink_result
 for reducing the stack consumption
From: Chen Yucong <slaoub@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de, mhocko@suse.cz,
        riel@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Jun 2014 11:04:42 +0800
In-Reply-To: <20140613162807.GP2878@cmpxchg.org>
References: <1402634191-3442-1-git-send-email-slaoub@gmail.com>
	 <20140612214016.1beda952.akpm@linux-foundation.org>
	 <1402636875.1232.13.camel@debian> <20140613162807.GP2878@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 12:28 -0400, Johannes Weiner wrote:
> On Fri, Jun 13, 2014 at 01:21:15PM +0800, Chen Yucong wrote:
> > On Thu, 2014-06-12 at 21:40 -0700, Andrew Morton wrote:
> > > On Fri, 13 Jun 2014 12:36:31 +0800 Chen Yucong <slaoub@gmail.com> wrote:
> > > 
> > > > @@ -1148,7 +1146,8 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
> > > >  		.priority = DEF_PRIORITY,
> > > >  		.may_unmap = 1,
> > > >  	};
> > > > -	unsigned long ret, dummy1, dummy2, dummy3, dummy4, dummy5;
> > > > +	unsigned long ret;
> > > > +	struct shrink_result dummy = { };
> > > 
> > > You didn't like the idea of making this static?
> > Sorry! It's my negligence.
> > If we make dummy static, it can help us save more stack.
> > 
> > without change:  
> > 0xffffffff810aede8 reclaim_clean_pages_from_list []:	184
> > 0xffffffff810aeef8 reclaim_clean_pages_from_list []:	184
> > 
> > with change: struct shrink_result dummy = {};
> > 0xffffffff810aed6c reclaim_clean_pages_from_list []:	152
> > 0xffffffff810aee68 reclaim_clean_pages_from_list []:	152
> > 
> > with change: static struct shrink_result dummy ={};
> > 0xffffffff810aed69 reclaim_clean_pages_from_list []:	120
> > 0xffffffff810aee4d reclaim_clean_pages_from_list []:	120
> 
> FWIW, I copied bloat-o-meter and hacked up a quick comparison tool
> that you can feed two outputs of checkstack.pl for a whole vmlinux and
> it shows you the delta.
> 
> The output for your patch (with the static dummy) looks like this:
> 
> +0/-240 -240
> shrink_inactive_list                         136     112     -24
> shrink_page_list                             208     160     -48
> reclaim_clean_pages_from_list                168       -    -168
> 
> (The stack footprint for reclaim_clean_pages_from_list is actually 96
> after your patch, but checkstack.pl skips frames under 100)
> 
Thanks very much for your comparison tool. Its output is more concise.

thx!
cyc

gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.4, pie-0.5.5)
kernel version 3.15(stable)
Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz

The output for this patch (with the static dummy) is:

+0/-144 -144
shrink_inactive_list                         152     120     -32
shrink_page_list                             232     184     -48
reclaim_clean_pages_from_list                184     120     -64

-------
gcc version 4.7.2 (Debian 4.7.2-5)
kernel version 3.15(stable)
Intel(R) Core(TM) i5-2320 CPU @ 3.00GHz

The output for this patch (with the static dummy) is:

shrink_inactive_list                         136     120     -16
shrink_page_list                             216     168     -48
reclaim_clean_pages_from_list                184     120     -64


