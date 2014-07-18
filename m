Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbaGRBCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:02:33 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60881 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750928AbaGRBCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:02:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Brian W Hart <hartb@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Stratos Karafotis <stratosk@semaphore.gr>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] cpufreq: make table sentinal macros unsigned to match use
Date: Fri, 18 Jul 2014 03:20:49 +0200
Message-ID: <100420681.lrPIpDzhHV@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140711220630.GA5697@oc3347516403.ibm.com>
References: <20140627210939.GB24604@oc3347516403.ibm.com> <CAKohpo=qB3nB+ZNKE4Y94m6gPWZZ4YZEU_WOA=s5DB8apxUQGQ@mail.gmail.com> <20140711220630.GA5697@oc3347516403.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 11, 2014 05:06:30 PM Brian W Hart wrote:
> On Mon, Jun 30, 2014 at 10:25:20AM +0530, Viresh Kumar wrote:
> > On 28 June 2014 02:39, Brian W Hart <hartb@linux.vnet.ibm.com> wrote:
> > > Commit 5eeaf1f18973 (cpufreq: Fix build error on some platforms that
> > > use cpufreq_for_each_*) moved function cpufreq_next_valid() to a public
> > > header.  Warnings are now generated when objects including that header
> > > are built with -Wsign-compare (as an out-of-tree module might be):
> > >
> > > .../include/linux/cpufreq.h: In function ‘cpufreq_next_valid’:
> > > .../include/linux/cpufreq.h:519:27: warning: comparison between signed
> > > and unsigned integer expressions [-Wsign-compare]
> > >   while ((*pos)->frequency != CPUFREQ_TABLE_END)
> > >                            ^
> > > .../include/linux/cpufreq.h:520:25: warning: comparison between signed
> > > and unsigned integer expressions [-Wsign-compare]
> > >    if ((*pos)->frequency != CPUFREQ_ENTRY_INVALID)
> > >                          ^
> > >
> > > Constants CPUFREQ_ENTRY_INVALID and CPUFREQ_TABLE_END are signed, but
> > > are used with unsigned member 'frequency' of cpufreq_frequency_table.
> > > Update the macro definitions to be explicitly unsigned to match their
> > > use.
> > >
> > > This also corrects potentially wrong behavior of clk_rate_table_iter()
> > > if unsigned long is wider than usigned int.
> > >
> > > Signed-off-by: Brian W Hart <hartb@linux.vnet.ibm.com>
> > > ---
> > > These macros are fairly broadly used in the kernel so I was bit leery
> > > of changing them, but after inspection I think it's fine.  I found 102
> > > uses of the macros, of which:
> > >
> > > 99 are uses with cpufreq_frequency_table.frequency (95) or with local
> > >    variables of the same type as frequency (4).  These should be just
> > >    fine with this change--we're just making explicit a conversion that
> > >    was previously implicit.
> > >
> > >  2 are uses with a local variable of different type (unsigned long) than
> > >    'frequency' (in drivers/sh/clk/core.c).  One of these uses is safe;
> > >    the other (in clk_rate_table_iter()) is broken if unsigned long
> > >    is wider than unsigned int.  As a side-effect, this patch corrects
> > >    the potential misbehavior there.
> > >
> > >  1 is a use in macro cpufreq_for_each_entry() with what _should_ be the
> > >    frequency member of a cpufreq_frequency_table, provided the caller it
> > >    well-behaved.  There are 18 callers of this macro; all are well-behaved.
> > >    So these should also be safe.
> > 
> > I would have moved some of it to logs, they look good.
> > 
> > >  include/linux/cpufreq.h |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> > > index ec4112d..8f8ae95 100644
> > > --- a/include/linux/cpufreq.h
> > > +++ b/include/linux/cpufreq.h
> > > @@ -482,8 +482,8 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
> > >   *********************************************************************/
> > >
> > >  /* Special Values of .frequency field */
> > > -#define CPUFREQ_ENTRY_INVALID  ~0
> > > -#define CPUFREQ_TABLE_END      ~1
> > > +#define CPUFREQ_ENTRY_INVALID  ~0u
> > > +#define CPUFREQ_TABLE_END      ~1u
> > >  /* Special Values of .flags field */
> > >  #define CPUFREQ_BOOST_FREQ     (1 << 0)
> > 
> > Thanks.
> > 
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> I haven't seen this appear in the linux-pm tree yet. Is there anything
> further needed on my part--aside from patience?

Fell through the cracks, sorry.  I'll include this into the next PM pull request
for 3.16.  Thanks!

Rafael

