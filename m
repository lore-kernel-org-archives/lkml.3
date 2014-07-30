Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaG3PTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:19:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:55414 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbaG3PTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:19:38 -0400
Date: Wed, 30 Jul 2014 12:19:32 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf tools: Ensure --symfs ends with '/'
Message-ID: <20140730151932.GS7831@kernel.org>
References: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
 <20140729050246.GC22707@bbox>
 <20140729123305.GO7831@kernel.org>
 <87ppgnhge3.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppgnhge3.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 30, 2014 at 08:52:36AM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Tue, 29 Jul 2014 09:33:05 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Jul 29, 2014 at 02:02:46PM +0900, Minchan Kim escreveu:
> >> On Fri, Jul 25, 2014 at 10:31:47AM +0900, Namhyung Kim wrote:
> >> > Minchan reported that perf failed to load vmlinux if --symfs argument
> >> > doesn't end with '/' character.  So make sure that the symfs always
> >> > ends with the '/'.

> >> Both patches work and are handy to me.
> >> Thanks Namhyung.

> > I haven't said it is not :-) Just that it should be fixed in a different
> > way.
 
> I also thought about that way first but changed my mind to the current
> approach because I don't want to change current behavior.

> I worried about the common case which has empty symfs.  By your patch,
> it makes a pathname absolute even with an empty symfs - I can see most
> filenames are already absolute paths but I'm not 100% sure it's always
> the case.

Yeah, after doing some research on the tools/perf/ 'git log' I got your point,
we can't add the / after symfs usages when it is "", i.e. we need something
like:

	("%s%s%s, symfs, symfs[0] ? "/" : "", dso_name)

I.e. the equivalent of this:

[acme@zoo linux]$ python
Python 2.7.5 (default, Jun 25 2014, 10:19:55) 
[GCC 4.8.2 20131212 (Red Hat 4.8.2-7)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import os
>>> symfs = ""
>>> os.path.join(symfs, "dso_path")
'dso_path'
>>> symfs = "/home/acme/embedded_device_dsos"
>>> os.path.join(symfs, "dso_path")
'/home/acme/embedded_device_dsos/dso_path'
>>> 

I'll try and get that in place.

- Arnaldo
