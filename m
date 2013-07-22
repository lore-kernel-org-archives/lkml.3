Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab3GVNpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:45:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab3GVNpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:45:13 -0400
Date: Mon, 22 Jul 2013 15:44:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 10/23] perf tools: Introduce swap_header function
Message-ID: <20130722134434.GA3359@krava.brq.redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
 <1374083403-14591-11-git-send-email-jolsa@redhat.com>
 <87bo5ywzqm.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo5ywzqm.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 08:33:37PM +0900, Namhyung Kim wrote:
> On Wed, 17 Jul 2013 19:49:50 +0200, Jiri Olsa wrote:
> > Introducing swap_header function to make the swapping
> > code more clear and extensible.
> 
> [SNIP]
> >  
> > +static int swap_header(struct perf_file_header *header)
> > +{
> > +	mem_bswap_64(header, offsetof(struct perf_file_header, adds_features));
> > +
> > +	if (header->size != sizeof(*header)) {
> > +		/* Support the previous format */
> > +		if (header->size == offsetof(typeof(*header), adds_features))
> > +			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
> > +		else
> > +			return -1;
> > +	} else
> > +		swap_features(header->adds_features);
> > +
> > +	return 0;
> > +}
> > +
> >  int perf_file_header__read(struct perf_file_header *header,
> >  			   struct perf_header *ph, int fd)
> >  {
> > @@ -2562,19 +2578,8 @@ int perf_file_header__read(struct perf_file_header *header,
> >  		return -1;
> >  	}
> >  
> > -	if (ph->needs_swap) {
> > -		mem_bswap_64(header, offsetof(struct perf_file_header,
> > -			     adds_features));
> > -	}
> > -
> > -	if (header->size != sizeof(*header)) {
> > -		/* Support the previous format */
> > -		if (header->size == offsetof(typeof(*header), adds_features))
> > -			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
> > -		else
> > -			return -1;
> > -	} else if (ph->needs_swap)
> > -		swap_features(header->adds_features);
> > +	if (ph->needs_swap && swap_header(header))
> > +		return -1;
> 
> Doesn't it change existing behavior?  It looks like supporting previous
> format on a same endian machines will be removed by this patch.

I'll check and try to add v2 perf.data reading test for both endians

thanks,
jirka
