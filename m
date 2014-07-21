Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaGUIcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:32:15 -0400
Received: from 8bytes.org ([81.169.241.247]:50680 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbaGUIcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:32:13 -0400
Date: Mon, 21 Jul 2014 10:32:11 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140721083211.GK30979@8bytes.org>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
 <20140719134904.GA2852@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140719134904.GA2852@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 03:49:04PM +0200, Pavel Machek wrote:
> Hi!
> 
> > These patches improve the data structure by adding a radix
> > tree to the linked list structure to improve random access
> > performance from O(n) to O(log_b(n)), where b depends on the
> > architecture (b=512 on amd64, 1024 in i386).
> 
> Are you sure? From your other mail, you said you are adding just a
> single page. I'd expect random access performance to go from
> 
> O(n) to O(n/1024) in such case?

No, for the 4GB case the additional page is used as an index page into
the block-bitmap pages. On AM64 a page can hold 512 references and a
single block-bitmap page is enough for 128MB of RAM. This means that for
systems with up to 64GB of RAM we can get the block-bitmap page directly
from the index page. For systems with more than 64GB of RAM we need
another level of index pages, and now we need two memory accesses to get
to the block-bitmap page (okay, with this implementation its actually 2
memory accesses per level, because the index-pages refer to a struct
rtree_node which itself contains the pointer to the index/data page).

A two-level radix tree would be enough for systems with up to 32TB of
RAM. After that we need 3 levels, but you can already see that this
doesn't scale linearly anymore but with log_512(n), where n is the
number of block-bitmap pages required.


	Joerg

