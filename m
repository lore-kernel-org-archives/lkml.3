Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbaD1NQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:16:42 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60292 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaD1NQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:16:40 -0400
Subject: Re: [PATCH 2/3] perf tools: Cache dso data file descriptor
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>
In-Reply-To: <20140428100133.GE1109@krava.brq.redhat.com>
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
	 <1397756352-26694-3-git-send-email-jolsa@redhat.com>
	 <1398609395.1689.17.camel@leonhard>
	 <20140428100133.GE1109@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Apr 2014 22:16:34 +0900
Message-ID: <1398690994.1724.13.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-28 (월), 12:01 +0200, Jiri Olsa:
> On Sun, Apr 27, 2014 at 11:36:35PM +0900, Namhyung Kim wrote:
> > 2014-04-17 (목), 19:39 +0200, Jiri Olsa:
> > > Keeping the data file description open for the whole life
> > > of the dso object.
> > 
> > I suspect there might be an issue for reporting very large data file
> > with this approach - like open file limit?
> 
> I've got as high as ~200 openned file descriptors for
> ~2GB data of system wide monitoring
> 
> but right that could be an issue.. I wonder we could
> workaround this somehow, because the speed up is quite
> noticable
> 
> how about we monitor number of openned dso file descriptor
> and once we cross this we close some portion of them
> 
> or something along those lines ;-)

Yeah, we'll need some way to control those eventually.

> 
> > 
> > 
> > [SNIP]
> > > @@ -168,8 +174,8 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
> > >  	};
> > >  	int i = 0;
> > >  
> > > -	if (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND)
> > > -		return open_dso(dso, machine);
> > 
> > Why did you remove this line?
> 
> that code reopens already openned (and closed) file.. 
> instead I return (not closed) descriptor from previous open

But it'll overwrite the dso->binary_type then.  What about this?

	if (dso->data_fd >= 0)
		return dso->data_fd;

	if (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND) {
		dso->data_fd = open_dso(dso, machine);
		return dso->data_fd;
	}


Thanks,
Namhyung




