Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab3ENQut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:50:49 -0400
Received: from www.sr71.net ([198.145.64.142]:36816 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab3ENQuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:50:46 -0400
Message-ID: <51926B64.5040005@sr71.net>
Date: Tue, 14 May 2013 09:50:44 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tim.c.chen@linux.intel.com
Subject: Re: [RFC][PATCH 6/7] use __remove_mapping_batch() in shrink_page_list()
References: <20130507211954.9815F9D1@viggo.jf.intel.com> <20130507212002.219EDB7F@viggo.jf.intel.com> <20130514160541.GX11497@suse.de>
In-Reply-To: <20130514160541.GX11497@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 09:05 AM, Mel Gorman wrote:
> This helper seems overkill. Why not just have batch_mapping in
> shrink_page_list() that is set when the first page is added to the
> batch_for_mapping_removal and defer the decision to drain until after the
> page mapping has been looked up?
> 
> struct address_space *batch_mapping = NULL;
> 
> .....
> 
> mapping = page_mapping(page);
> if (!batch_mapping)
> 	batch_mapping = mapping;
> 
> if (!list_empty(&batch_for_mapping_removal) && mapping != batch_mapping) {
> 	nr_reclaimed += __remove_mapping_batch(....);
> 	batch_mapping = mapping;
> }

I was trying to avoid doing the batch drain while holding lock_page() on
an unrelated page.  But, now that I think about it, that was probably
unsafe anyway.  The page could have been truncated out of the mapping
since it *was* before lock_page().

I think I was also trying to save adding another local variable, but
you're right that it's overkill.  I'll fix it up.
