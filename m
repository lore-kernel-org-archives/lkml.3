Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaFTQLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:11:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:43924 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbaFTQLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:11:41 -0400
Date: Fri, 20 Jun 2014 13:11:32 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] perf trace: add support for pagefault tracing
Message-ID: <20140620161132.GJ31524@kernel.org>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <1403261389-13423-3-git-send-email-stfomichev@yandex-team.ru>
 <20140620145955.GG31524@kernel.org>
 <20140620154901.GM15620@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620154901.GM15620@stfomichev-desktop.yandex.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 20, 2014 at 07:49:01PM +0400, Stanislav Fomichev escreveu:
> > > 1756272.905 ( 0.000 ms): curl/5937 majfault [0x7fa7261978b6] => /usr/lib/x86_64-linux-gnu/libkrb5.so.26.0.0+0x85288 (d.)
> > 
> > Things like the above may be better expressed using dso@symbol+offset,
> > even more when the symbol is not resolved within a DSO, due to
> > insufficient expressivity in the available symtab, i.e. perhaps the user
> > needs to install a debuginfo package.
> Currently, the format is:
> <header> <min|maj>fault [ip.symbol+ip.offset] => addr.dso+addr.offset (<mmap_type><addr.level>)
> 
> if no symbol found for IP, we have:
> <header> <min|maj>fault [ip.addr] => addr.dso+addr.offset (<mmap_type><addr.level>)
> 
> mmap_type is d - for data, x - for executable vmas.
> 
> I think we may try to print [ip.dso+ip.offset] if we can't resolve ip symbol,
> but I don't want dso@symbol+offset because if we have symbol, dso is
> probably (?) redundant (ok, at least for me).

Well, I don't think it is :-)

dso->short_name should disambiguate 99.9% of the cases tho. Perhaps we
can use --verbose, as in other places, to switch using dso->long_name,
for cases where multiple versions of a library are used, some in non
standard paths, which sometimes puzzles people looking at the tools
output.

> It also seems we don't need to resolve symbol of pagefault address

Well, in some cases if we can resolve to a variable, why not?

> because it's either some code or some address on the heap. Dso is enough.

> > > 1862866.036 ( 0.000 ms): wget/8460 majfault [__clear_user+0x3f] => 0x659cb4 (?k)

> > And here, where is this __clear_user symbol from? The kernel? Probaly
> > that 'k' there means that? If so, probably that deserves an entry in the
> > documentation.

> Yes, k or . describes symbol 'level'.
 
> > WRT documentation, please consider sending followup patches providing
> > examples in the documentation, talking about the possible need of
> > installing debuginfo packages as well.
> I didn't put much effort into documentation because I just wanted to get
> initial feedback. Will follow.

Ok, but I think its good practice, as much as it is seldom done because
it is boring, to do it exactly when doing the matching feature. Doing it
judiciously may even help the person implementing to think about what is
being done more thoroughly which sometimes leads to problems being
solved at an early stage 8-)
 
> > But its shaping up nicely, good work!
> Thanks.

- Arnaldo
