Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3J2IEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:04:35 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:46865 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3J2IEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:04:30 -0400
MIME-Version: 1.0
In-Reply-To: <1382977811.30941.33.camel@joe-AO722>
References: <51F73A17.2090208@akamai.com>
	<1382974150-7392-1-git-send-email-changbin.du@gmail.com>
	<1382977811.30941.33.camel@joe-AO722>
Date: Tue, 29 Oct 2013 16:04:28 +0800
Message-ID: <CABgQ-Ti0aaxqVGF0R-huQur=EGCTyXM0w-gyz9TenC=msucJqA@mail.gmail.com>
Subject: Re: [PATCH v2] dynamic_debug: add wildcard support to filter files/functions/modules
From: Changbin Du <changbin.du@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@akamai.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Joe,

Thanks for your comments. I will update the patch. And now I am trying
to remove all the two goto statements. Agree with you, we can use a
while statement instead.

I will send you the new patch for you to review when it's done.


2013/10/29 Joe Perches <joe@perches.com>
>
> On Mon, 2013-10-28 at 23:29 +0800, Du, Changbin wrote:
> > From: "Du, Changbin" <changbin.du@gmail.com>
>
> trivial notes:
>
> > This patch add wildcard '*'(matches zero or more characters) and '?'
> > (matches one character) support when qurying debug flags.
>
> > diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> []
> > @@ -127,6 +127,41 @@ static void vpr_info_dq(const struct ddebug_query *query, const char *msg)
> >                query->first_lineno, query->last_lineno);
> >  }
> >
> > +/* check if the string matches given pattern which includes wildcards */
> > +static int match_pattern(const char *pattern, const char *string)
>
> bool match_pattern
>
> > +{
> > +     const char *s, *p;
> > +     int star = 0;
>
> bool star = false;
>
> > +
> > +loop:
> > +     for (s = string, p = pattern; *s; ++s, ++p) {
> > +             switch (*p) {
> > +             case '?':
> > +                     break;
> > +             case '*':
> > +                     star = 1;
> > +                     string = s;
> > +                     pattern = p;
> > +                     if (!*++pattern)
> > +                             return 1;
> > +                     goto loop;
> > +             default:
> > +                     if (*s != *p)
> > +                             goto star_check;
>
>                         star = false;
>
> > +                     break;
> > +             }
> > +     }
> > +     if (*p == '*')
> > +             ++p;
> > +     return (!*p);
>
> Don't need parentheses.
>
> > +
> > +star_check:
> > +     if (!star)
> > +             return 0;
> > +     string++;
> > +     goto loop;
> > +}
>
> The star_check: label block seems like it'd be
> better in the switch case as it's only used once.
>
> Maybe the thing would be more readable with a
> while loop
>
