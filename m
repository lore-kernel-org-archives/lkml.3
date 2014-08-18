Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaHRLc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:32:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbaHRLcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:32:25 -0400
Date: Mon, 18 Aug 2014 13:31:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 3/3] perf callchain: Prune misleading callchains for self
 entries
Message-ID: <20140818113147.GA5117@krava.redhat.com>
References: <1407996100-6359-1-git-send-email-namhyung@kernel.org>
 <1407996100-6359-4-git-send-email-namhyung@kernel.org>
 <20140814141056.GA7630@krava.brq.redhat.com>
 <1408067834.1679.15.camel@leonhard>
 <20140815195139.GA13425@krava.brq.redhat.com>
 <1408155991.1672.4.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408155991.1672.4.camel@leonhard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 11:26:31AM +0900, Namhyung Kim wrote:

SNIP

> > 
> > hum, where is it callee/caller mixed?  with following example:
> > 
> > ---
> > void c(void)
> > {
> > }
> > 
> > void b(void)
> > {
> >         c();
> > }
> > 
> > void a(void)
> > {
> >         b();
> > }
> > 
> > int main(void)
> > {
> >         while(1) {
> >                 a();
> >                 b();
> >                 c();
> >         }
> > }
> > ---
> > 
> > for 'c' the current code will display:
> > 
> > -   43.74%    43.74%  t        t                 [.] c                                                                                    ▒
> >    - __libc_start_main                                                                                                                    ▒
> >       - 86.33% main                                                                                                                       ▒
> >            67.08% c                                                                                                                       ▒
> >          - 32.91% a                                                                                                                       ▒
> >               99.44% c                                                                                                                    ▒
> >             - 0.56% b                                                                                                                     ▒
> >                  c                                                                                                                        ▒
> >         13.67% c                                                                                                                          ▒
> > 
> > and with this patch:
> > 
> > -   43.74%    43.74%  t        t                 [.] c                                                                                    ▒
> >      c                                                                                                                                    ▒
> > 
> > 
> > The 'c' callchain is still in caller order. IMO we should
> > keep whole callchain here.
> 
> The problem is not in pure self entry (that has self overhead = children
> overhead) and pure cumulative entry (self overhead = 0).  It's in mixed
> entries, please see last two examples in the description 0/3.

right, but it still affects pure entries as well
anyway, let's see the mixed entry

for 'a' the current code will display:
-   31.97%    17.16%  t        t                  [.] a                                                        ▒
   - __libc_start_main                                                                                         ◆
        81.08% a                                                                                               ▒
      - 18.92% main                                                                                            ▒
           a                                                                                                   ▒
   - a                                                                                                         ▒
        85.05% c                                                                                               ▒
      - 14.91% b                                                                                               ▒
           100.00% c                                                                                           ▒

and with this patch:
-   31.97%    17.16%  t        t                  [.] a                                                        ▒
   - a                                                                                                         ▒
        85.05% c                                                                                               ▒
      - 14.91% b                                                                                               ▒
           100.00% c                                                                                           ▒

so we'll miss the 'self' callchain of 'a' symbol

if we want to avoid the confusion about 2 different callchains, how
about marking them with 'self' and 'children' tags, instead of removing
one of them, like:

for 'a' the current code will display:
-   31.97%    17.16%  t        t                  [.] a                                                        ▒
   - [self]
     __libc_start_main                                                                                         ◆
        81.08% a                                                                                               ▒
      - 18.92% main                                                                                            ▒
           a                                                                                                   ▒
   - [children]
     a                                                                                                         ▒
        85.05% c                                                                                               ▒
      - 14.91% b                                                                                               ▒
           100.00% c                                                                                           ▒


jirka
