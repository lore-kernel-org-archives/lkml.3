Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaAOAxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:53:03 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:48428 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaAOAw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:52:59 -0500
Date: Tue, 14 Jan 2014 16:52:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Han Pingtian <hanpt@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
In-Reply-To: <20140114163533.ab191e118e82ca7b4d499551@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1401141643520.3375@chino.kir.corp.google.com>
References: <52C5AA61.8060701@intel.com> <20140103033303.GB4106@localhost.localdomain> <52C6FED2.7070700@intel.com> <20140105003501.GC4106@localhost.localdomain> <20140106164604.GC27602@dhcp22.suse.cz> <20140108101611.GD27937@dhcp22.suse.cz>
 <20140110081744.GC9437@dhcp22.suse.cz> <20140114200720.GM4106@localhost.localdomain> <20140114155241.7891fce1fb2b9dfdcde15a8c@linux-foundation.org> <alpine.DEB.2.02.1401141621560.3375@chino.kir.corp.google.com>
 <20140114163533.ab191e118e82ca7b4d499551@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Andrew Morton wrote:

> I've been waiting 10+ years for us to decide to delete that warning due
> to the false positives.  Hasn't happened yet, and the warning does
> find bugs/issues/misconfigurations/etc.
> 

I've found memory leaks from the meminfo that is emitted as part of page 
allocation failure warnings, that seems to be the only helpful part.  
Unfortunately, they typically emit ~80 lines to the kernel log and become 
quite verbose in succession.  If you have a lot of nodes, it just becomes 
longer.

I think we want to consider alternative values for the ratelimiter, in 
this case nopage_rs that Dave added.  Dave?

> > Would it be overkill to save the kernel default both with and without thp 
> > and then doing a WARN_ON_ONCE() if a user-written value is ever less?
> 
> Well, min_free_kbytes is a userspace thing, not a kernel thing - maybe
> THP shouldn't be dinking with it.  What effect is THP trying to achieve
> and can we achieve it by other/better means?
> 

It moved the preferred "hugeadm --set-recommended-min_free_kbytes" 
behavior into the kernel that gave better results (due to lower occurrence 
of fragmentation)  for thp hosts.  Previously, people were using hugeadm 
in initscripts and then it became the default kernel logic when thp was 
originally merged.  I think it's primarily targeted to adjust the high 
watermark so we could probably get the same behavior by special casing thp 
with some scalar to the watermarks, but changing min_free_kbytes was 
probably the easiest way to do it.
