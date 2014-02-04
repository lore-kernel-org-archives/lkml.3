Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaBDAGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 19:06:54 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57733 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaBDAGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 19:06:53 -0500
Date: Mon, 3 Feb 2014 16:06:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Michal Hocko <mhocko@suse.cz>, Holger Kiehl <Holger.Kiehl@dwd.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org
Subject: Re: Need help in bug in isolate_migratepages_range
In-Reply-To: <52EFC93D.3030106@suse.cz>
Message-ID: <alpine.DEB.2.02.1402031602060.10778@chino.kir.corp.google.com>
References: <alpine.LRH.2.02.1401312037340.6630@diagnostix.dwd.de> <20140203122052.GC2495@dhcp22.suse.cz> <alpine.LRH.2.02.1402031426510.13382@diagnostix.dwd.de> <20140203162036.GJ2495@dhcp22.suse.cz> <52EFC93D.3030106@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Vlastimil Babka wrote:

> It seems to come from balloon_page_movable() and its test page_count(page) ==
> 1.
> 

Hmm, I think it might be because compound_head() == NULL here.  Holger, 
this looks like a race condition when allocating a compound page, did you 
only see it once or is it actually reproducible?

I think this happens when a new compound page is allocated and PageBuddy 
is cleared before prep_compound_page() and then we see PageTail(p) set but 
p->first_page is not yet initialized.  Is there any way to avoid memory 
barriers in compound_page()?
