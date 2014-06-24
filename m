Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaFXMqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:46:33 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:41166 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbaFXMqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:46:31 -0400
X-Yandex-Uniq: f2218227-b348-45c9-b2c3-2c842100aa91
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 24 Jun 2014 16:46:20 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] perf trace: add support for pagefault tracing
Message-ID: <20140624124620.GB16950@stfomichev-desktop.yandex.net>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <1403261389-13423-3-git-send-email-stfomichev@yandex-team.ru>
 <20140620145955.GG31524@kernel.org>
 <20140620154901.GM15620@stfomichev-desktop.yandex.net>
 <20140620161132.GJ31524@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620161132.GJ31524@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think we may try to print [ip.dso+ip.offset] if we can't resolve ip symbol,
> > but I don't want dso@symbol+offset because if we have symbol, dso is
> > probably (?) redundant (ok, at least for me).
> 
> Well, I don't think it is :-)
> 
> dso->short_name should disambiguate 99.9% of the cases tho. Perhaps we
> can use --verbose, as in other places, to switch using dso->long_name,
> for cases where multiple versions of a library are used, some in non
> standard paths, which sometimes puzzles people looking at the tools
> output.
If we use --verbose it will result in noise besides short/long names
(like looking up debug symbols, etc).
But I'm still not convinced we need to always print dso of ip, we already have
target process and symbol (if we have dbg symbols), this should be
enough to understand what code path triggered fault.

> > It also seems we don't need to resolve symbol of pagefault address
> 
> Well, in some cases if we can resolve to a variable, why not?
If we fault into data map, we resolve to nothing, right? But if we
fault into some executable map, we can resolve some symbol. But is it
really useful to know (because for me it's much more interesting to know
which dso and offset we fault into, not the actual symbol)?

What I think makes sense it to have current (default) format:
[ip.sym+ip.offs] => [addr.dso.long+addr.offs]

And --verbose format, which will use dso.long@symbol+offset for addr and ip.
So by default we have somewhat readable and concise information, and if we
need to gather all possible details we may use --verbose. What do you
think?
