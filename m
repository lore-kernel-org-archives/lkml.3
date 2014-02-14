Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaBNHnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:43:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbaBNHnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:43:07 -0500
Date: Fri, 14 Feb 2014 08:43:05 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
Message-ID: <20140214074305.GF5160@quack.suse.cz>
References: <52F88C16.70204@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402100200420.30650@chino.kir.corp.google.com>
 <52F8C556.6090006@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402101333160.15624@chino.kir.corp.google.com>
 <52FC6F2A.30905@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402130003320.11689@chino.kir.corp.google.com>
 <52FC98A6.1000701@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402131416430.13899@chino.kir.corp.google.com>
 <20140214001438.GB1651@linux.vnet.ibm.com>
 <CA+55aFwH8BqyLSqyLL7g-08nOtnOrJ9vKj4ebiSqrxc5ooEjLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwH8BqyLSqyLL7g-08nOtnOrJ9vKj4ebiSqrxc5ooEjLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-02-14 16:37:53, Linus Torvalds wrote:
> Is this whole thread still just for the crazy and pointless
> "max_sane_readahead()"?
> 
> Or is there some *real* reason we should care?
> 
> Because if it really is just for max_sane_readahead(), then for the
> love of God, let us just do this
> 
>  unsigned long max_sane_readahead(unsigned long nr)
>  {
>         return min(nr, 128);
>  }
> 
> and bury this whole idiotic thread.
  max_sane_readahead() is also used for limiting amount of readahead for
[fm]advice(2) WILLNEED and that is used e.g. by a dynamic linker to preload
shared libraries into memory. So I'm convinced this usecase *will* notice
the change - effectively we limit preloading of shared libraries to the
first 512KB in the file but libraries get accessed in a rather random manner.

Maybe limits for WILLNEED and for standard readahead should be different.
It makes sence to me and people seem to keep forgetting that
max_sane_readahead() limits also WILLNEED preloading.

								Honza

> On Thu, Feb 13, 2014 at 4:14 PM, Nishanth Aravamudan
> <nacc@linux.vnet.ibm.com> wrote:
> >
> > I'm working on this latter bit now. I tried to mirror ia64, but it looks
> > like they have CONFIG_USER_PERCPU_NUMA_NODE_ID, which powerpc doesn't.
> > It seems like CONFIG_USER_PERCPU_NUMA_NODE_ID and
> > CONFIG_HAVE_MEMORYLESS_NODES should be tied together in Kconfig?
> >
> > I'll keep working, but would appreciate any further insight.
> >
> > -Nish
> >
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
