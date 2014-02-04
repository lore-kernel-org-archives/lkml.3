Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaBDBUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 20:20:50 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57406 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaBDBUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 20:20:49 -0500
Date: Mon, 3 Feb 2014 17:20:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [patch] mm, compaction: avoid isolating pinned pages fix
In-Reply-To: <20140204000237.GA17331@lge.com>
Message-ID: <alpine.DEB.2.02.1402031610090.10778@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402012145510.2593@chino.kir.corp.google.com> <20140203095329.GH6732@suse.de> <alpine.DEB.2.02.1402030231590.31061@chino.kir.corp.google.com> <20140204000237.GA17331@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Joonsoo Kim wrote:

> I think that you need more code to skip this type of page correctly.
> Without page_mapped() check, this code makes migratable pages be skipped,
> since if page_mapped() case, page_count() may be more than zero.
> 
> So I think that you need following change.
> 
> (!page_mapping(page) && !page_mapped(page) && page_count(page))
> 

These pages returned by get_user_pages() will have a mapcount of 1 so this 
wouldn't actually fix the massive lock contention.  page_mapping() is only 
going to be NULL for pages off the lru like these are for 
PAGE_MAPPING_ANON.
