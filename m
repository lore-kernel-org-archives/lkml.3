Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaAWWb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:31:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaAWWby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:31:54 -0500
Date: Thu, 23 Jan 2014 17:31:36 -0500
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when
 seting kernel nodes to unhotpluggable.
Message-ID: <20140123223136.GA18468@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Tang Chen <tangchen@cn.fujitsu.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
	zhangyanfei@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
 <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com>
 <20140123061343.GB15206@redhat.com>
 <alpine.DEB.2.02.1401222214290.8088@chino.kir.corp.google.com>
 <20140123065824.GA17684@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123065824.GA17684@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 01:58:24AM -0500, Dave Jones wrote:

 > 128 bytes is a pretty small amount of stack though, so I'm just as confused
 > as to what the actual bug here is.
 > 
 > After trying the proposed fix, I got another oops in the early init code..
 > 
 > <trace>
 > nr_free_zone_pages
 > nr_free_pagecache_pages
 > build_all_zonelists
 > start_kernel
 > <rip> ffffffffbc164b1e next_zones_zonelist
 > <rsp> ffffffffbcc01f00

Ok, this is crashing here in next_zones_zonelist...

                while (zonelist_zone_idx(z) > highest_zoneidx)
  de:   3b 77 08                cmp    0x8(%rdi),%esi


I stuck this at the top of the function..

printk(KERN_ERR "z:%p nodes:%p highest:%d\n", z, nodes, highest_zoneidx);

and got

z: 1d08   nodes: (null)  highest:3


Some build tests show..

MAXSMP ( NODESHIFT=10 ) : Bug
NRCPUS=4 & NODESHIFT=10 : Bug
NRCPUS=4 & NODESHIFT=1 : no bug


The middle config test was accidental, I hadn't realised disabling MAXSMP
wouldn't reset NODESHIFT to something sane.

I'll start bisecting, as MAXSMP worked fine until a few days ago.

	Dave

