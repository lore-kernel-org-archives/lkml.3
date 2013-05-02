Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763875Ab3ECW63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 18:58:29 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54673 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763861Ab3ECW61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 18:58:27 -0400
Date: Thu, 2 May 2013 10:08:57 -0700
From: Matt Helsley <matthltc@linux.vnet.ibm.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] pagemap: Introduce the /proc/PID/pagemap2 file
Message-ID: <20130502170857.GB24627@us.ibm.com>
References: <51669E5F.4000801@parallels.com>
 <51669EA5.20209@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51669EA5.20209@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050322-9360-0000-0000-00001205EAC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 03:29:41PM +0400, Pavel Emelyanov wrote:
> This file is the same as the pagemap one, but shows entries with bits
> 55-60 being zero (reserved for future use). Next patch will occupy one
> of them.

This approach doesn't scale as well as it could. As best I can see
CRIU would do:

for each vma in /proc/<pid>/smaps
	for each page in /proc/<pid>/pagemap2
		if soft dirty bit
			copy page

(possibly with pfn checks to avoid copying the same page mapped in
multiple locations..)

However, if soft dirty bit changes could be queued up (from say the
fault handler and page table ops that map/unmap pages) and accumulated
in something like an interval tree it could be something like:

for each range of changed pages
	for each page in range
		copy page

IOW something that scales with the number of changed pages rather
than the number of mapped pages.

So I wonder if CRIU would abandon pagemap2 in the future for something
like this.

Cheers,
	-Matt Helsley

