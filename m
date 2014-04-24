Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaDXGgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:36:38 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:39668 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaDXGgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:36:36 -0400
Date: Thu, 24 Apr 2014 08:36:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 0/4] perf/urgent fixes
Message-ID: <20140424063630.GC1104@gmail.com>
References: <1398252682-17185-1-git-send-email-jolsa@redhat.com>
 <20140423131433.GB23224@gmail.com>
 <20140423134910.GD11124@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423134910.GD11124@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Apr 23, 2014 at 03:14:33PM +0200, Ingo Molnar wrote:
> > 
> > (Just reporting two bugs I found today - unrelated to your the 
> > perf/urgent pull request.)
> > 
> > 1)
> > 
> > Even when the most modern unwind library is found, the autodetection 
> > is spammy:
> > 
> > 
> >  Auto-detecting system features:
> >  ...                         dwarf: [ on  ]
> >  ...                         glibc: [ on  ]
> >  ...                          gtk2: [ on  ]
> >  ...                      libaudit: [ on  ]
> >  ...                        libbfd: [ on  ]
> >  ...                        libelf: [ on  ]
> >  ...                       libnuma: [ on  ]
> >  ...                       libperl: [ on  ]
> >  ...                     libpython: [ on  ]
> >  ...                      libslang: [ on  ]
> >  ...                     libunwind: [ on  ]
> >  ...            libdw-dwarf-unwind: [ on  ]
> >  ...     DWARF post unwind library: libunwind
> > 
> > The 'DWARF post unwind library' line is somewhat superfluous. I 
> > realize that it prints out the library selected - but that's obvious 
> > from the 'libdw-dwarf-unwind' line above it already, right?
> 
> nope, the on/off output is only whats detected in system,
> you've got both libunwind and libdw-dwarf-unwind detected
> 
> libunwind is default unless you use NO_LIBUNWIND=1

Okay, so the problem is that we don't have a simple binary-state 
feature in this case, but three possible states: 'libunwind', or 
'libdw-dwarf-unwind', or 'OFF', right?

If so then the solution would be to replace those 3 last lines with 
just this line:

     ...        DWARF unwind library: [ libunwind ]

Where 'libunwind' is printed in green (like the 'on' lines are 
printed). If there's no suitable library available then output:

     ...        DWARF unwind library: [ OFF ]

Because the user looking at the output is really only interested in 
'is an unwind library available', and maybe in 'which one'.

Is there preference between library choices? I.e. is 'libunwind' 
preferred over 'libdw-dwarf-unwind', or the other way around? If yes 
then if we pick an inferior library we could print it in yellow color 
- and only use green if it's the 'best' choice.

That way the color codes also still keep working: red means problem, 
green means OK, yellow something inbetween.

But in any case we should try to keep the 'one feature, one line' 
fundamental output concept.

( Under V=1 we can output whatever details might be useful to
  developers, there's no restriction on what to output there. )

Thanks,

	Ingo
