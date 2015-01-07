Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbbAGBEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:04:42 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50610 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbAGBEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:04:41 -0500
Date: Tue, 6 Jan 2015 17:04:33 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [RFC] mm:change meminfo cached calculation
In-Reply-To: <20150106164340.55e83f742d6f57c19e6500ff@linux-foundation.org>
Message-ID: <alpine.LSU.2.11.1501061654340.1497@eggly.anvils>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net> <CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com> <35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net> <20141205143134.37139da2208c654a0d3cd942@linux-foundation.org>
 <35FD53F367049845BC99AC72306C23D103E688B313F4@CNBJMBX05.corpusers.net> <20141208114601.GA28846@node.dhcp.inet.fi> <35FD53F367049845BC99AC72306C23D103E688B313FB@CNBJMBX05.corpusers.net> <CALYGNiMEytHuND37f+hNdMKqCPzN0k_uha6CaeL_fyzrj-obNQ@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E688B31408@CNBJMBX05.corpusers.net> <35FD53F367049845BC99AC72306C23D103EDAF89E14C@CNBJMBX05.corpusers.net> <35FD53F367049845BC99AC72306C23D103EDAF89E160@CNBJMBX05.corpusers.net>
 <20150106164340.55e83f742d6f57c19e6500ff@linux-foundation.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2015, Andrew Morton wrote:
> On Fri, 26 Dec 2014 19:56:49 +0800 "Wang, Yalin" <Yalin.Wang@sonymobile.com> wrote:
> 
> > This patch subtract sharedram from cached,
> > sharedram can only be swap into swap partitions,
> > they should be treated as swap pages, not as cached pages.
> > 
> > ...
> >
> > --- a/fs/proc/meminfo.c
> > +++ b/fs/proc/meminfo.c
> > @@ -45,7 +45,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
> >  	committed = percpu_counter_read_positive(&vm_committed_as);
> >  
> >  	cached = global_page_state(NR_FILE_PAGES) -
> > -			total_swapcache_pages() - i.bufferram;
> > +			total_swapcache_pages() - i.bufferram - i.sharedram;
> >  	if (cached < 0)
> >  		cached = 0;
> 
> Documentation/filesystems/proc.txt says
> 
> :      Cached: in-memory cache for files read from the disk (the
> :              pagecache).  Doesn't include SwapCached
> 
> So yes, I guess it should not include shmem.
> 
> And why not do this as well?
> 
> 
> --- a/Documentation/filesystems/proc.txt~mm-change-meminfo-cached-calculation-fix
> +++ a/Documentation/filesystems/proc.txt
> @@ -811,7 +811,7 @@ MemAvailable: An estimate of how much me
>       Buffers: Relatively temporary storage for raw disk blocks
>                shouldn't get tremendously large (20MB or so)
>        Cached: in-memory cache for files read from the disk (the
> -              pagecache).  Doesn't include SwapCached
> +              pagecache).  Doesn't include SwapCached or Shmem.
>    SwapCached: Memory that once was swapped out, is swapped back in but
>                still also is in the swapfile (if memory is needed it
>                doesn't need to be swapped out AGAIN because it is already

Whoa.  Changes of this kind would have made good sense about 14 years ago.
And there's plenty more which would benefit from having anon/shmem/file
properly distinguished.  But how can we make such a change now,
breaking everything that has made its own sense of these counts?

Hugh
