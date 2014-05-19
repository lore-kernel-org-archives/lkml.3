Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaESNfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbaESNfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:35:02 -0400
Date: Mon, 19 May 2014 15:34:14 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/6] perf: Add dcacheline sort
Message-ID: <20140519133414.GD20810@krava.brq.redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
 <1399999697-65875-7-git-send-email-dzickus@redhat.com>
 <20140516114757.GD19475@krava.brq.redhat.com>
 <20140516133058.GN50500@redhat.com>
 <20140516140551.GF19475@krava.brq.redhat.com>
 <20140516143002.GU50500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516143002.GU50500@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 10:30:02AM -0400, Don Zickus wrote:
> On Fri, May 16, 2014 at 04:05:51PM +0200, Jiri Olsa wrote:
> > On Fri, May 16, 2014 at 09:30:58AM -0400, Don Zickus wrote:
> > > On Fri, May 16, 2014 at 01:47:57PM +0200, Jiri Olsa wrote:
> > > > On Tue, May 13, 2014 at 12:48:17PM -0400, Don Zickus wrote:
> > > > > In perf's 'mem-mode', one can get access to a whole bunch of details specific to a
> > > > > particular sample instruction.  A bunch of those details relate to the data
> > > > > address.
> > > > > 
> > > > > One interesting thing you can do with data addresses is to convert them into a unique
> > > > > cacheline they belong too.  Organizing these data cachelines into similar groups and sorting
> > > > > them can reveal cache contention.
> > > > > 
> > > > > This patch creates an alogorithm based on various sample details that can help group
> > > > > entries together into data cachelines and allows 'perf report' to sort on it.
> > > > > 
> > > > > The algorithm relies on having proper mmap2 support in the kernel to help determine
> > > > > if the memory map the data address belongs to is private to a pid or globally shared.
> > > > > 
> > > > > The alogortithm is as follows:
> > > > > 
> > > > > o group cpumodes together
> > > > > o group entries with discovered maps together
> > > > > o sort on major, minor, inode and inode generation numbers
> > > > > o if userspace anon, then sort on pid
> > > > > o sort on cachelines based on data addresses
> > > > 
> > > > needs some collumn width refresh or something..? ;-)
> > > 
> > > Not sure what you mean here.
> > > 
> > > > 
> > > > # Overhead  Data Cacheline         
> > > > # ........  .......................
> > 
> > header not being wide enough to cover the longest data
> 
> Ah. Ok.  So I am not sure the right way to fix that.  As the current
> header seems to be hardcoded with a bunch of spaces.  Is there a trick to
> dynamically space it correctly based on the data provided?

it should be enough to update function:
  void hists__calc_col_len(struct hists *hists, struct hist_entry *h)

with HISTC_MEM_DCACHELINE column update code, same as the rest

jirka
