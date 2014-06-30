Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaF3Id0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:33:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:30189 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbaF3IdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:33:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="562894285"
Message-ID: <1404117165.5102.3.camel@smile.fi.intel.com>
Subject: Re: [PATCH v2 2/2] lib.c: skip --param parameters
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Christopher Li <sparse@chrisli.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>
Date: Mon, 30 Jun 2014 11:32:45 +0300
In-Reply-To: <CANeU7QnLad1f4KkLpTGSWB8eD8_La-tACim6rR7DLQ=hggwhOQ@mail.gmail.com>
References: <1402996306-6811-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1402996306-6811-3-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CANeU7QnLad1f4KkLpTGSWB8eD8_La-tACim6rR7DLQ=hggwhOQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-28 at 09:59 -0700, Christopher Li wrote:
> Oops, I just click send before I type up the reply. Here we go again.
> 
> On Tue, Jun 17, 2014 at 2:11 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Very dumb patch to just skip --param allow-store-data-races=0 introduced in
> > newer GCC versions.
> >
> > +static char **handle_param(char *arg, char **next)
> > +{
> > +       const char *value = NULL;
> > +
> > +       /* For now just skip any '--param=*' or '--param *' */
> > +       value = split_value_from_arg(arg, value);
> > +       if (!value)
> > +               ++next;
> > +
> > +       return ++next;
> > +}
> 
> I think this is problematic.There are three possible input
> from args:
> 1) "--parm", you need to ++next skip to next arg, which is the value for parm.
> 2) "--parm=x",  you don't need to skip to next arg.
> 3) "--parm-with-crap", invalid argument. You don't need to skip next arg.
> 
> I think the patch is wrong on case 2) and case 3).
> In case 2), the patch skip two arguments and make next point
> points to out of bound memory.

Hmm... I'd just added test printf to the handle_param() and see if I
print *next, it is either --param or --param=*. So, using return (next +
2) helps, otherwise we end up with the same situation as before patch.

What did I miss?

> 
> The split_value_from_arg function is not a good abstraction for this job.
> Its return value can only indicate 2 possible out come.
> Also, returning the default value force the test against the input
> default value. That make the logic a bit complicate.
> 
> >  struct switches {
> >         const char *name;
> >         char **(*fn)(char *, char **);
> > @@ -686,13 +698,14 @@ struct switches {
> >  static char **handle_long_options(char *arg, char **next)
> >  {
> >         static struct switches cmd[] = {
> > +               { "param", handle_param },
> >                 { "version", handle_version },
> >                 { NULL, NULL }
> >         };
> >         struct switches *s = cmd;
> >
> >         while (s->name) {
> > -               if (!strcmp(s->name, arg))
> > +               if (!strncmp(arg, s->name, strlen(s->name)))
> 
> This will allow "--version-with-crap" as valid arguments.

Which was explicitly mentioned in the commit message.

> 
> I think we can have one extra member in "struct switch"
> to indicate this option is a prefix rather than a whole word.
> For "parm", it need to set that prefix member to non zero.

No objections about this approach.

> Please let me know if there is a V3 coming.

Apparently you did this on weekend.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

