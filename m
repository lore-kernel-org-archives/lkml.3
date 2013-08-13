Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab3HMWNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:13:08 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35770 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3HMWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:13:05 -0400
Date: Tue, 13 Aug 2013 15:13:08 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] idr: Document ida tree sections
Message-ID: <20130813221308.GA11980@kmo-pixel>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-4-git-send-email-kmo@daterainc.com>
 <20130807202201.GA28039@mtj.dyndns.org>
 <20130807205117.GC11612@kmo-pixel>
 <20130809145756.GL20515@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809145756.GL20515@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 10:57:56AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 07, 2013 at 01:51:17PM -0700, Kent Overstreet wrote:
> > + * So if the max section size is 64k, that's ~4096 sections, with 8 byte
> > + * pointers that's a little over 32k for the pointers to sections.
> > + *
> > + * That means max size sections are order 4 page allocations.
> 
> Order 4 allocations for common data structure doesn't really sound
> like a good idea to me.  It's gonna work fine on relatively large
> machines but suck on mobile / small embedded devices, many of which
> are still struggling with 32bit address space and compaction may not
> be enabled.  It just doens't make sense to me to impose 64k
> allocations from low level library function like ida.

I have a hard time seeing how it could really be an issue in practice -
keep in mind, for every bit in the ida tree we're going to have some
struct allocated somewhere else that the id correspends to.

So for a 4k ida, that's... bare minimum around 128k memory that has to
be allocated somewhere else, and in a single subsystem, assuming 16 byte
structs - and typically it'll be many times that. 32k memory in the ida
-> 2 mb in the subsystem, absolute minimum.

If you're convinced this is a real issue though - how about
IDA_SECTION_SIZE conditional on CONFIG_COMPACTION, so we use order 2 or
3 allocations if CONFIG_COMPACTION=n?

Then the max size toplevel array of pointers to segments would be
bigger, but that's only an issue when we're allocating up to near
INT_MAX ids, so it's difficult to see how _that_ would be an issue on a
small/embedded system... and we could even use vmalloc for that
allocation when the size of that array is > IDA_SECTION_SIZE.
