Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaIWUMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:12:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbaIWUM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:12:29 -0400
Date: Tue, 23 Sep 2014 16:12:04 -0400
From: Dave Jones <davej@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] mm, debug: mm-introduce-vm_bug_on_mm-fix-fix.patch
Message-ID: <20140923201204.GB4252@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Michal Hocko <mhocko@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-next@vger.kernel.org, sfr@canb.auug.org.au,
	Sasha Levin <sasha.levin@oracle.com>
References: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
 <1411464279-20158-1-git-send-email-mhocko@suse.cz>
 <20140923112848.GA10046@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923112848.GA10046@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 01:28:48PM +0200, Michal Hocko wrote:
 > And there is another one hitting during randconfig. The patch makes my
 > eyes bleed but I don't know about other way without breaking out the
 > thing into separate parts sounds worse because we can mix with other
 > messages then.

how about something along the lines of..

 bufptr = buffer = kmalloc()

 #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
	bufptr += sprintf(bufptr, "tlb_flush_pending %d\n",
			mm->tlb_flush_pending);
 #endif

 #ifdef CONFIG_MMU
	bufptr += sprintf(bufptr, "...
 #endif

 ...

 printk(KERN_EMERG "%s", buffer);

 free(buffer);


Still ugly, but looks less like a trainwreck, and keeps the variables
with the associated text.

It does introduce an allocation though, which may be problematic
in this situation. Depending how big this gets, perhaps make it static
instead?

	Dave

