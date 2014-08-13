Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaHMCEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 22:04:44 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:41861 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbaHMCEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 22:04:43 -0400
Date: Tue, 12 Aug 2014 22:04:53 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, kamal@canonical.com,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, ben@decadent.org.uk,
        m.szyprowski@samsung.com
Subject: Re: CONFIG_DMA_CMA causes ttm performance problems/hangs.
Message-ID: <20140813020452.GB3001@gmail.com>
References: <53E50C1B.9080507@gmail.com>
 <53E5B41B.3030009@vmware.com>
 <60bd3db2-4919-40c4-a4ff-1b7b043cadfc@email.android.com>
 <53E628FE.10808@vmware.com>
 <53E6E2CE.8070005@gmail.com>
 <53E75192.3070003@vmware.com>
 <53E7B39D.2060900@gmail.com>
 <53E896C9.5010501@vmware.com>
 <20140811151712.GA3541@gmail.com>
 <53EAC461.2060503@daenzer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53EAC461.2060503@daenzer.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:50:25AM +0900, Michel Dänzer wrote:
> On 12.08.2014 00:17, Jerome Glisse wrote:
> > On Mon, Aug 11, 2014 at 12:11:21PM +0200, Thomas Hellstrom wrote:
> >> On 08/10/2014 08:02 PM, Mario Kleiner wrote:
> >>> On 08/10/2014 01:03 PM, Thomas Hellstrom wrote:
> >>>> On 08/10/2014 05:11 AM, Mario Kleiner wrote:
> >>>>>
> >>>>> The other problem is that probably TTM does not reuse pages from the
> >>>>> DMA pool. If i trace the __ttm_dma_alloc_page
> >>>>> <https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/ident?i%3D__ttm_dma_alloc_page&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=7898522bba274e4dcc332735fbcf0c96e48918f60c2ee8e9a3e9c73ab3487bd0>
> >>>>> and
> >>>>> __ttm_dma_free_page
> >>>>> <https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/ident?i%3D__ttm_dma_alloc_page&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=7898522bba274e4dcc332735fbcf0c96e48918f60c2ee8e9a3e9c73ab3487bd0>
> >>>>> calls for
> >>>>> those single page allocs/frees, then over a 20 second interval of
> >>>>> tracing and switching tabs in firefox, scrolling things around etc. i
> >>>>> find about as many alloc's as i find free's, e.g., 1607 allocs vs.
> >>>>> 1648 frees.
> >>>> This is because historically the pools have been designed to keep only
> >>>> pages with nonstandard caching attributes since changing page caching
> >>>> attributes have been very slow but the kernel page allocators have been
> >>>> reasonably fast.
> >>>>
> >>>> /Thomas
> >>>
> >>> Ok. A bit more ftraceing showed my hang problem case goes through the
> >>> "if (is_cached)" paths, so the pool doesn't recycle anything and i see
> >>> it bouncing up and down by 4 pages all the time.
> >>>
> >>> But for the non-cached case, which i don't hit with my problem, could
> >>> one of you look at line 954...
> >>>
> >>> https://urldefense.proofpoint.com/v1/url?u=http://lxr.free-electrons.com/source/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c%23L954&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=l5Ago9ekmVFZ3c4M6eauqrJWGwjf6fTb%2BP3CxbBFkVM%3D%0A&m=QQSN6uVpEiw6RuWLAfK%2FKWBFV5HspJUfDh4Y2mUz%2FH4%3D%0A&s=e15c51805d429ee6d8960d6b88035e9811a1cdbfbf13168eec2fbb2214b99c60
> >>>
> >>>
> >>> ... and tell me why that unconditional npages = count; assignment
> >>> makes sense? It seems to essentially disable all recycling for the dma
> >>> pool whenever the pool isn't filled up to/beyond its maximum with free
> >>> pages? When the pool is filled up, lots of stuff is recycled, but when
> >>> it is already somewhat below capacity, it gets "punished" by not
> >>> getting refilled? I'd just like to understand the logic behind that line.
> >>>
> >>> thanks,
> >>> -mario
> >>
> >> I'll happily forward that question to Konrad who wrote the code (or it
> >> may even stem from the ordinary page pool code which IIRC has Dave
> >> Airlie / Jerome Glisse as authors)
> > 
> > This is effectively bogus code, i now wonder how it came to stay alive.
> > Attached patch will fix that.
> 
> I haven't tested Mario's scenario specifically, but it survived piglit
> and the UE4 Effects Cave Demo (for which 1GB of VRAM isn't enough, so
> some BOs ended up in GTT instead with write-combined CPU mappings) on
> radeonsi without any noticeable issues.
> 
> Tested-by: Michel Dänzer <michel.daenzer@amd.com>
> 

My patch does not fix the cma bug, cma should not allocate single page into
it reserved contiguous memory. But cma is a broken technology in the first
place and it should not be enabled on x86 who ever did that is a moron.

So i would definitly encourage opening a bug against cma.

None the less ttm code was buggy too and this patch will fix that but will
only allieviate or delay the symptoms reported by Mario.

Cheers,
Jérôme

> 
> -- 
> Earthling Michel Dänzer            |                  http://www.amd.com
> Libre software enthusiast          |                Mesa and X developer
