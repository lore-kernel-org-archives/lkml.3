Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaJWPjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:39:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbaJWPjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:39:42 -0400
Date: Thu, 23 Oct 2014 17:39:32 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/powerpc: Cache the DWARF debug info
Message-ID: <20141023153932.GB25215@krava.brq.redhat.com>
References: <20141021185610.GA18366@us.ibm.com>
 <20141021190839.GA4160@kernel.org>
 <20141022000958.GB2228@us.ibm.com>
 <20141022081730.GB9860@krava.brq.redhat.com>
 <20141022174659.GA5119@us.ibm.com>
 <20141023133724.GE14687@kernel.org>
 <20141023141213.GA24079@krava.brq.redhat.com>
 <20141023142634.GF14687@kernel.org>
 <20141023151306.GA25215@krava.brq.redhat.com>
 <20141023153322.GH14687@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023153322.GH14687@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 12:33:22PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Oct 23, 2014 at 05:13:06PM +0200, Jiri Olsa escreveu:
> > On Thu, Oct 23, 2014 at 11:26:34AM -0300, Arnaldo Carvalho de Melo wrote:
> > > That is why I thought it would be a compromise to put what he did, it
> > > would not make the existing situation that much worse, work needs to be
> > > done in this area :-\
>  
> > I think we just need to put that libdw handle into dso object
> > as I suggested above
> 
> Isn't it there already?
> 
> The patch does:
> 
> +++ b/tools/perf/util/dso.h
> @@ -127,6 +127,7 @@ struct dso {
>         const char       *long_name;
>         u16              long_name_len;
>         u16              short_name_len;
> +       void            *dwfl;                  /* DWARF debug info */
> 
> 
> ----------
> 
> What you want, on top of that, at a minimum, we somehow limit the number
> of simultaneously dwfl_begin()'ed DSOs, right?

no, the patch is doing that.. as I wrote:

---
I think this can stay in 'struct dso' which is limited
by that code you show below (dso__data_open code)

I think we need just add generic functions that allocates/destroys
the dwfl handle and lazy allocate&store this handle whenever it's
needed and destroy it in dso__delete
---

so just:
  1) generic function to do the lazy allocation of dwlf handle
  2) store the handle within dso object
  3) destroy it in dso__delete

the limitation for opened dso objects number should cover
the dwlf limit

thanks,
jirka
