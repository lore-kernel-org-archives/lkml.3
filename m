Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3KGRiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:38:09 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:37169 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab3KGRiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:38:07 -0500
Date: Thu, 7 Nov 2013 13:37:43 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, daniel.kiper@oracle.com,
        linux-kernel@vger.kernel.org, Bob Liu <bob.liu@oracle.com>,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen/balloon: Set balloon's initial state to number of existing RAM pages
Message-ID: <20131107173742.GA26816@andromeda.dapyr.net>
References: <1383770260-15395-1-git-send-email-boris.ostrovsky@oracle.com> <527AE1CA.7030703@oracle.com> <7ae8615f-36f4-4c28-a147-c522335ba8f7@email.android.com> <20131107143832.GA27283@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107143832.GA27283@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 03:38:32PM +0100, Daniel Kiper wrote:
> On Wed, Nov 06, 2013 at 08:25:04PM -0500, Konrad Rzeszutek Wilk wrote:
> > Bob Liu <bob.liu@oracle.com> wrote:
> > >
> > >On 11/07/2013 04:37 AM, Boris Ostrovsky wrote:
> > >> Currently balloon's initial value is set to max_pfn which includes
> > >> non-RAM ranges such as MMIO hole. As result, initial memory target
> > >> (specified by guest's configuration file) will appear smaller than
> > >> what balloon driver perceives to be the current number of available
> > >> pages. Thus it will balloon down "extra" pages, decreasing amount of
> > >> available memory for no good reason.
> > >>
> > >
> > >This fix the strange behavior I mentioned yesterday, every time after
> > >guest started balloon driver will be triggered unreasonably.
> > >
> > >> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> > >> ---
> > >>  drivers/xen/balloon.c | 2 +-
> > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>
> > >> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> > >> index b232908..1b62304 100644
> > >> --- a/drivers/xen/balloon.c
> > >> +++ b/drivers/xen/balloon.c
> > >> @@ -641,7 +641,7 @@ static int __init balloon_init(void)
> > >>
> > >>  	balloon_stats.current_pages = xen_pv_domain()
> > >>  		? min(xen_start_info->nr_pages - xen_released_pages, max_pfn)
> > >> -		: max_pfn;
> > >> +		: get_num_physpages();
> > >
> > >By the way, should the other places using max_pfn also be changed with
> > >get_num_physpages()?
> >
> > No. In PV that calculation is correct as it gets the amount of RAM pages - which is a exactly what you need.
> 
> What about PCI passthrough case?

That is still valid. The nr_pages will have the amount of
RAM pages. If the user is using e820_host=1 option
the E820 in an PV guest looks like the host one - and
the Linux kernel ends up ballooning in/out to make the
P2M look like the E820. If not using the e820_host=1
you end up with a big giant E820_RAM - at which point
the 'max_pfn' is the end of the E820_RAM and
nr_pages - xen_relesed_pages is smaller, or equal.

The end result is that the nr_pages is the amount of
RAM pages that are right now available.
The max_pfn can be different - either bigger or the same.

I guess what you are thinking of is that we have:

	min(nr_pages - xen_released_pages, max_pfn).

And we could just get rid of the 'min' and just use
nr_pages - xen_released_page. And since the
'nr_pages - xen_released_page' should be equal to
'get_num_physpages()' so - why not do that.

But that sounds to me like a new patch - lets not
try to fix too many things at once.

> 
> Daniel
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
