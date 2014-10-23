Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaJWOM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:12:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbaJWOMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:12:24 -0400
Date: Thu, 23 Oct 2014 16:12:13 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/powerpc: Cache the DWARF debug info
Message-ID: <20141023141213.GA24079@krava.brq.redhat.com>
References: <20141021185610.GA18366@us.ibm.com>
 <20141021190839.GA4160@kernel.org>
 <20141022000958.GB2228@us.ibm.com>
 <20141022081730.GB9860@krava.brq.redhat.com>
 <20141022174659.GA5119@us.ibm.com>
 <20141023133724.GE14687@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023133724.GE14687@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:37:24AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 22, 2014 at 10:46:59AM -0700, Sukadev Bhattiprolu escreveu:
> > Jiri Olsa [jolsa@redhat.com] wrote:
> > | > +			goto out;
> > | > +		}
> > | > +		dso->dwfl = dwfl;
> > | 
> > | so by this we get powerpc arch code sharing dw handle via dso object,
> > | but we have lot of generic code too ;-)
> > 
> > Well, this applies to powerpc...
> > 
> > | 
> > | could you make this happen for unwind__get_entries.. probably
> > | both sharing same generic code I guess
> > 
> > and unwind_get_entries() applies only to x86 and arm right ? ;-)
> > Or at least thats what the config/Makefile says.
>  
> > I can take a look at unwind_get_entries(), but can you please merge
> > this fix for now, since the current performance is bad?
> 
> Right, I think the way it is now is a good compromise, i.e. you seem to
> be using the right place to cache this, this is restricted to powerpc,
> i.e. if leaks or excessive memory usage happens in workloads with lots
> of DSOs having dwfl handlers open at the same times happens, it doesn't
> affect users in other arches.
> 
> Jiri: do you agree?

well it's powerpc specific now.. anyway the code in the patch
to open the dwfl is generic and should be in in generic
place.. like in some extern function that the x86 would call
to get the dwfl handle

also the current patch leaks the dso->dwfl, which is never freed -> dwfl_end-ed,
dwfl_end should be called of in dso__delete I think

jirka
