Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaIKN3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:29:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:51179 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaIKN3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:29:17 -0400
Date: Thu, 11 Sep 2014 10:29:11 -0300
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
Message-ID: <20140911132911.GB10158@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-14-git-send-email-acme@kernel.org>
 <20140911103319.GA13634@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911103319.GA13634@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 11, 2014 at 12:33:19PM +0200, Jiri Olsa escreveu:
> On Wed, Sep 10, 2014 at 11:08:48AM -0300, Arnaldo Carvalho de Melo wrote:
 
SNIP

> > @@ -80,11 +94,17 @@ int fdarray__filter(struct fdarray *fda, short revents)
> >  	for (fd = 0; fd < fda->nr; ++fd) {
> > -		if (fda->entries[fd].revents & revents)
> > +		if (fda->entries[fd].revents & revents) {
> > +			if (entry_destructor)
> > +				entry_destructor(fda, fd);
> 
> the desctructor callback could have the 'priv' as an argument
> so we dont need to touch fdarray internals in upper layer

I thought about that, but then I would have to pass as well the pollfd
entry, that is not in priv, i.e. the callback may want to know exactly
what were the POLL{RD,WR,HUP,ER) in fdarray->entryes[fd].revents.

Yeah, sometimes it is good to avoid users touching the internals, but
that doesn't need to be something set in stone, i.e. we can consider
fda->revents and priv->priv to "public" :-)

SNIP
 
> > +++ b/tools/lib/api/fd/array.h
> > @@ -10,6 +10,7 @@ struct fdarray {
> >  	struct pollfd *entries;
> > +	int	      *priv;
 
> I like the idea of private pointer for each fd, but I think it should
> be 'void*' to keep the library generic. The 'int*' is related only to
> the evlist usage of this.

Right, from the changelog comment for this patch:

------------------------------
    We may need to have further info associated with each fdarray entry,
in that case we'll make that int array a 'union fdarray_priv' one and
put a pointer there so that users can stash whatever they want there.
For now, an int is enough tho.
------------------------------

I had it as:

	struct fdarray {
	...
		union {
			int 	idx;
			void	*ptr;
		} priv;
	...
	}

But then I had no use whatsoever for the ->ptr one at this point, so I
just nuked it, to keep _just_ what is used _right now_, and added the
comment to the changelog :-)

Heck, even the comment mentions "union fdarray_priv", because at one
point I was passing that to the destructor, as you suggested, but then I
removed it to an unnamed union, because passing just the index would
allow access to ->priv[] and ->entries[].

- Arnaldo
