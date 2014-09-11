Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaIKPt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:49:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:34993 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaIKPt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:49:28 -0400
Date: Thu, 11 Sep 2014 12:49:22 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 13/14] tools lib fd array: Allow associating an integer
 cookie with each entry
Message-ID: <20140911154922.GK10158@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-14-git-send-email-acme@kernel.org>
 <20140911103319.GA13634@krava.brq.redhat.com>
 <20140911132911.GB10158@kernel.org>
 <20140911145945.GC32722@krava.brq.redhat.com>
 <20140911152330.GI10158@kernel.org>
 <20140911153527.GE32722@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911153527.GE32722@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 11, 2014 at 05:35:27PM +0200, Jiri Olsa escreveu:
> On Thu, Sep 11, 2014 at 12:23:30PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Sep 11, 2014 at 04:59:45PM +0200, Jiri Olsa escreveu:
> > > On Thu, Sep 11, 2014 at 10:29:11AM -0300, Arnaldo Carvalho de Melo wrote:
> > > > But then I had no use whatsoever for the ->ptr one at this point, so I
> > > > just nuked it, to keep _just_ what is used _right now_, and added the
> > > > comment to the changelog :-)

> > > if we are treeting tools/lib/api as 'external' lib, I think we should
> > > use 'void *' for priv and let the user retype it to whatever he wants

> > > but I dont care/insist here too much.. it just seems strange to me ;-)
> > 
> > Ok, so perhaps it should be:
> > 
> > 	struct fdarray {
> > 		...
> > 		union {
> > 			int idx;
> > 		} *priv;
> > 		...
> > }
> > 
> > And then perf's evlist will use:
> > 
> > 	fda->priv[fd].idx;
> > 
> > 	Then, when we get the need for a pointer, we can go there and
> > add it to the union.
> > 
> > 	This will make tools/lib/api/fd/ a little bit more friendly to
> > use outside the kernel sources, since then a new version will be source
> > code compatible (but not necessarily binary compatible).
> 
> you lost me ;-)
> 
> could you please make an example of the !compatibility you mentioned?

If I leave it as is now, when I add that void * pointer to each entry in
fdarray->priv[], I will have to change fdarray's users, i.e. right now I
will have to go and change evlist.h, i.e. every place that has:

	fda->priv[fd];

	will have to be changed to:

	fda->priv[fd].idx;

If I instead change it to:

 	struct fdarray {
 		...
 		union {
 			int idx;
 		} *priv;
 		...
	}

Then I will not have to change anything when I add that void * pointer
to the union.
 
> > 	If we commit to that we can't just go on and change all its
> > users as we can now do for things like 'struct sk_buff', 'struct sock'
> > and any other kernel data structures.
> > 	There are costs in making it 'external' in the sense you're
> > implying. I want to make it a bit less 'external' (in your sense), at
> > least while we initially implement new stuff like this one.
 
> and the costs?
 
> also I did not mean that union above, what I meant was:
 
> struct fdarray {
> 	...
> 	void *priv;
> 	...
> }

Yeah, that is what I am trying to avoid. This will make it use
sizeof(void *) for each entry, and I have no use for that right now. All
I need is sizeof(int) for each entry.

Remember, this is an array, so its not just a matter of changing:

	int *priv;

to:

	void *priv;

But since it is an array, it will use, in this case, double the space,
on 64-bit, for no gain _right now_.

- Arnaldo
