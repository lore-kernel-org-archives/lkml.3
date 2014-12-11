Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbaLKBoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:44:17 -0500
Received: from ozlabs.org ([103.22.144.67]:33165 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbaLKBoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:44:16 -0500
In-Reply-To: <20141210222912.GA30869@us.ibm.com>
To: sukadev@linux.vnet.ibm.com, Michael Ellerman <mpe@ellerman.id.au>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, Jiri Olsa <jolsa@redhat.com>, dev@codyps.com,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [1/2] perf/powerpc/hv-24x7: Use per-cpu page buffer
Message-Id: <20141211014415.4168B1400B7@ozlabs.org>
Date: Thu, 11 Dec 2014 12:44:15 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-12 at 22:29:13 UTC, sukadev@linux.vnet.ibm.com wrote:
> Michael Ellerman [mpe@ellerman.id.au] wrote:
> | On Tue, 2014-12-09 at 23:06 -0800, Sukadev Bhattiprolu wrote:
> | > From 470c16c8955672103a9529c78dffbb239e9e27b8 Mon Sep 17 00:00:00 2001
> | > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> | > Date: Tue, 9 Dec 2014 22:17:46 -0500
> | > Subject: [PATCH 1/2] perf/poweprc/hv-24x7: Use per-cpu page buffer
> | > 
> | > diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
> | > index dba3408..18e1f49 100644
> | > --- a/arch/powerpc/perf/hv-24x7.c
> | > +++ b/arch/powerpc/perf/hv-24x7.c
> | > @@ -217,11 +217,14 @@ static bool is_physical_domain(int domain)
> | >  		domain == HV_24X7_PERF_DOMAIN_PHYSICAL_CORE;
> | >  }
> | >  
> | > +DEFINE_PER_CPU(char, hv_24x7_reqb[4096]);
> | > +DEFINE_PER_CPU(char, hv_24x7_resb[4096]);
> | 
> | Do we need it to be 4K aligned also? I would guess so.
> 
> Yes, fixed in the patch below.

OK.

> | 
> | Rather than declaring these as char arrays and then casting below, can you pull
> | the struct definitions up and then declare the per cpu variables with the
> | proper type.
> 
> Well, the structures, used for communication with HV, have variable length
> arrays, like:
> 
> 	struct hv_24x7_request_buffer {
> 		...
> 		struct hv_24x7_request requests[];
> 	};
> 
> i.e the buffer needs to be larger than reported by sizeof(). So we
> allocate a large buffer and cast it. Not sure if there is a trick to
> get DEFINE_PER_CPU() to do that.

So the array is variable length, but no larger than 4K - at least I hope
because you're using a 4K buffer :)

The neatest way to handle that is to make it a union, with the struct and a 4K
char buffer.

But we can do that as a cleanup later.

> | > +	memset(request_buffer, 0, 4096);
> | > +	memset(result_buffer, 0, 4096);
> | 
> | Do we have to memset them? That's not going to speed things up.
> 
> I agree about the speed, specially since we have a larger buffer. But we
> are reusing the buffer for independent events and some fields need to be 0
> (hence the zalloc in the current code).

Sure, so you could explicitly initialise those fields to zero.

But that also can be another cleanup.

I'll take this as it is.

cheers
