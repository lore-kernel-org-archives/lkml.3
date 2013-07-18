Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab3GRMkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:40:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab3GRMkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:40:14 -0400
Date: Thu, 18 Jul 2013 14:39:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 08/23] perf tools: Introduce perf data file version CHECK
 macro
Message-ID: <20130718123940.GA1092@krava.brq.redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
 <1374083403-14591-9-git-send-email-jolsa@redhat.com>
 <20130717194250.GB5127@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717194250.GB5127@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 04:42:50PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 17, 2013 at 07:49:48PM +0200, Jiri Olsa escreveu:
> > Introducing perf data file version CHECK macro, so the check
> > is easily extensible for new versions.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Cc: David Ahern <dsahern@gmail.com>
> > ---
> >  tools/perf/util/header.c | 27 ++++++++++++++++-----------
> >  1 file changed, 16 insertions(+), 11 deletions(-)
> > 
> > diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> > index f558f83..4ebe4a1 100644
> > --- a/tools/perf/util/header.c
> > +++ b/tools/perf/util/header.c
> > @@ -2493,18 +2493,23 @@ static int check_magic_endian(u64 magic, uint64_t hdr_sz,
> >  	 * - encode endianness of file
> >  	 */
> >  
> > -	/* check magic number with one endianness */
> > -	if (magic == __perf_magic2)
> > -		return 0;
> > -
> > -	/* check magic number with opposite endianness */
> > -	if (magic != __perf_magic2_sw)
> > -		return -1;
> > +#define CHECK(__m, __v)						\
> > +do {								\
> > +	/* check magic number with one endianness */		\
> > +	if (magic == __m)					\
> > +		goto v ## __v;					\
> > +	/* check magic number with opposite endianness */	\
> > +	if (magic != __m ## _sw)				\
> > +		break;						\
> > +	ph->needs_swap = true;					\
> > + v ## __v:							\
> > +	ph->version = __v;					\
> > +	return 0;						\
> > +} while (0)
> 
> Ouch, why not:
> 
> #define PERF_CHECK_VERSION(__m, __v)
> 	/* check magic number with one endianness */		\
> 	if (magic == __m) {					\
> 		ph->version = __v;				\
> 		return 0;					\
> 	/* check magic number with opposite endianness */	\
> 	} else if (magic == __m ## _sw) {			\
> 		ph->needs_swap = true;				\
> 	}

ok, will change

thanks,
jirka
