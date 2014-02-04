Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaBDBxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 20:53:36 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59138 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaBDBxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 20:53:34 -0500
X-Original-SENDERIP: 10.177.222.146
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 4 Feb 2014 10:53:32 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, compaction: avoid isolating pinned pages fix
Message-ID: <20140204015332.GA14779@lge.com>
References: <alpine.DEB.2.02.1402012145510.2593@chino.kir.corp.google.com>
 <20140203095329.GH6732@suse.de>
 <alpine.DEB.2.02.1402030231590.31061@chino.kir.corp.google.com>
 <20140204000237.GA17331@lge.com>
 <alpine.DEB.2.02.1402031610090.10778@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402031610090.10778@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 05:20:46PM -0800, David Rientjes wrote:
> On Tue, 4 Feb 2014, Joonsoo Kim wrote:
> 
> > I think that you need more code to skip this type of page correctly.
> > Without page_mapped() check, this code makes migratable pages be skipped,
> > since if page_mapped() case, page_count() may be more than zero.
> > 
> > So I think that you need following change.
> > 
> > (!page_mapping(page) && !page_mapped(page) && page_count(page))
> > 
> 
> These pages returned by get_user_pages() will have a mapcount of 1 so this 
> wouldn't actually fix the massive lock contention.  page_mapping() is only 
> going to be NULL for pages off the lru like these are for 
> PAGE_MAPPING_ANON.

Okay. It can't fix your situation. Anyway, *normal* anon pages may be mapped
and have positive page_count(), so your code such as
'!page_mapping(page) && page_count(page)' makes compaction skip these *normal*
anon pages and this is incorrect behaviour.

Thanks.
