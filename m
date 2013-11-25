Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3KYPSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:18:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab3KYPSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:18:13 -0500
Date: Mon, 25 Nov 2013 16:17:35 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 19/22] perf tools: Add filename__read_str util function
Message-ID: <20131125151735.GI3161@krava.brq.redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
 <1385031680-9014-20-git-send-email-jolsa@redhat.com>
 <1385135039.1747.118.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385135039.1747.118.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 12:43:59AM +0900, Namhyung Kim wrote:
> 2013-11-21 (목), 12:01 +0100, Jiri Olsa:
> > Adding filename__read_str util function to read
> > text file and return it in the char array.
> > 
> > The interface is:
> >   int filename__read_str(const char *filename, char **buf, size_t *sizep)
> > 
> >   Returns 0/-1 if the read suceeded/fail respectively.
> > 
> >   buf  - place to store the data pointer
> >   size - place to store data size
> 
> [SNIP]
> > +int filename__read_str(const char *filename, char **buf, size_t *sizep)
> > +{
> > +	size_t size = 0, alloc_size = 0;
> > +	void *bf = NULL, *nbf;
> > +	int fd, n, err = 0;
> > +
> > +	fd = open(filename, O_RDONLY);
> > +	if (fd < 0)
> > +		return -errno;
> > +
> > +	do {
> > +		if (size == alloc_size) {
> > +			alloc_size += BUFSIZ;
> > +			nbf = realloc(bf, alloc_size);
> > +			if (!nbf) {
> > +				err = -ENOMEM;
> > +				break;
> > +			}
> > +
> > +			bf = nbf;
> > +		}
> > +
> > +		n = read(fd, bf + size, BUFSIZ);
> 
> Shouldn't it be "read(fd, bf + size, alloc_size - size)"?
> Otherwise there might be a problem if read() returned early for some
> reason with small size and then retry with a full BUFSIZ..
> 
> 
> > +		if (n < 0) {
> > +			err = 0;
> 
> I think it needs to check the size also since read() might fail at the
> first invocation.  What about this?
> 
> 		if (n < 0) {
> 			if (size)
> 				err = 0;
> 			else
> 				err = -errno;
> 

ok, added.. plus warning in the 'if (size)' leg,
because we're returning data even if we failed.

thanks,
jirka
