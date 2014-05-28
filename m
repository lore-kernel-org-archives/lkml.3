Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaE1WhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:37:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaE1WhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:37:06 -0400
Date: Wed, 28 May 2014 15:37:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Ian Kent <raven@themaw.net>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: Re: [PATCH 2/2] fs: proc/stat: use usual seq_file ops rather than
 single_open
Message-Id: <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org>
In-Reply-To: <20140528090153.GC4219@osiris>
References: <20140521122521.GB7471@osiris>
	<20140521143229.GA32011@infradead.org>
	<20140528085841.GA4219@osiris>
	<20140528090153.GC4219@osiris>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014 11:01:53 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> Now, /proc/stat uses single_open() for showing information. This means
> the all data will be gathered and buffered once to a (big) buf.
> 
> Now, /proc/stat shows stats per cpu and stats per IRQs. To get information
> in once-shot, it allocates a big buffer (until KMALLOC_MAX_SIZE).
> 
> Eric Dumazet reported that the bufsize calculation doesn't take
> the numner of IRQ into account and the information cannot be
> got in one-shot. (By this, seq_read() will allocate buffer again
> and read the whole data gain...)
> 
> This patch changes /proc/stat to use seq_open() rather than single_open()
> and provides  ->start(), ->next(), ->stop(), ->show().
> 
> By this, /proc/stat will not need to take care of size of buffer.
> 
> [heiko.carstens@de.ibm.com]: This is the forward port of a patch
> from KAMEZAWA Hiroyuki (https://lkml.org/lkml/2012/1/23/41).
> I added a couple of simple changes like e.g. that the cpu iterator
> handles 32 cpus in a batch to avoid lots of iterations.
> 
> With this patch it should not happen anymore that reading /proc/stat
> fails because of a failing high order memory allocation.

So this deletes the problematic allocation which [1/2] kind-of fixed,
yes?

I agree with Ian - there's a hotplugging race.  And [1/2] doesn't do
anything to address the worst-case allocation size.  So I think we may
as well do this all in a single patch.

Without having looked closely at the code I worry a bit about the
effects.  /proc/pid/stat is a complex thing and its contents will vary
in strange ways as the things it is reporting on undergo concurrent
changes.  This patch will presumably replace one set of bizarre
behaviour with a new set of bizarre behaviour and there may be
unforseen consequences to established userspace.

So we're going to need a lot of testing and a lot of testing time to
identify issues and weed them out.

So..  can we take this up for 3.16-rc1?  See if we can get some careful
review done then and test it for a couple of months?

Meanwhile, the changelog looks a bit hastily thrown together - some
smoothing would be nice, and perhaps some work spent identifying
possible behavioural changes.  Timing changes, locking canges, effects
of concurrent fork/exit activity etc?

