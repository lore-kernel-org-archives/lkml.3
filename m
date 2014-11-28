Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaK1X6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 18:58:12 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:58540 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaK1X6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 18:58:10 -0500
MIME-Version: 1.0
In-Reply-To: <20141128163807.GN2361@bivouac.eciton.net>
References: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
 <1417110967-16284-3-git-send-email-leif.lindholm@linaro.org>
 <20141128004403.08D90C40A7F@trevor.secretlab.ca> <20141128113428.GM2361@bivouac.eciton.net>
 <20141128152512.2152EC40884@trevor.secretlab.ca> <20141128163807.GN2361@bivouac.eciton.net>
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 28 Nov 2014 23:57:49 +0000
X-Google-Sender-Auth: FMVsR6apZFb4aJMvpCHiSBmwmNo
Message-ID: <CACxGe6vsFOLSL+YXQNJcBZ_nEn9TxdWEe2JEjKw2-zBsEB4Rzw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] of: add optional options parameter to? of_find_node_by_path()
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ian Campbell <ijc@debian.org>, Andrew Lunn <andrew@lunn.ch>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 4:38 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> On Fri, Nov 28, 2014 at 03:25:12PM +0000, Grant Likely wrote:
>> On Fri, 28 Nov 2014 11:34:28 +0000
>> , Leif Lindholm <leif.lindholm@linaro.org>
>>  wrote:
>> > On Fri, Nov 28, 2014 at 12:44:03AM +0000, Grant Likely wrote:
>> > > > +       separator = strchr(path, ':');
>> > > > +       if (separator && opts)
>> > > > +               *opts = separator + 1;
>> > > > +
>> > >
>> > > What about when there are no opts? Do we require the caller to make sure
>> > > opts is NULL before calling the function (which sounds like a good
>> > > source of bugs) or do we clear it on successful return?
>> > >
>> > > I think if opts is passed in, but there are no options, then it should
>> > > set *opts = NULL.
>> >
>> > Yeah, oops.
>> >
>> > > There should be test cases for this also. Must set opts to NULL on
>> > > successful return, and (I think) should leave opts alone on an
>> > > unsuccessful search.
>> >
>> > I would actually argue for always nuking the opts - since that could
>> > (theoretically) prevent something working by accident in spite of
>> > error conditions.
>> >
>> > How about the below?
>>
>> Perfect, applied with one fixup below...
>
> Thanks!

Fixups merged. Thanks.

g.

>
> And since it's Friday... *cough*
>
> From 5c469dad81961164c444da7d6c4e1c5b1c097aab Mon Sep 17 00:00:00 2001
> From: Leif Lindholm <leif.lindholm@linaro.org>
> Date: Fri, 28 Nov 2014 16:27:25 +0000
> Subject: [PATCH] of: fix options clearing when path is "/"
>
> The addition of the optional options extraction on
> of_find_node_opts_by_path failed to clear incoming options pointer
> if the specified path was "/".
>
> Resolve this case, and add a test to detect it.
>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  drivers/of/base.c     |   11 ++++++-----
>  drivers/of/selftest.c |    5 +++++
>  2 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 5e16c6b..32664d1 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -743,15 +743,16 @@ struct device_node *of_find_node_opts_by_path(const char *path, const char **opt
>         struct device_node *np = NULL;
>         struct property *pp;
>         unsigned long flags;
> -       char *separator;
> +       char *separator = NULL;
> +
> +       if (opts) {
> +               separator = strchr(path, ':');
> +               *opts = separator ? separator + 1 : NULL;
> +       }
>
>         if (strcmp(path, "/") == 0)
>                 return of_node_get(of_allnodes);
>
> -       separator = strchr(path, ':');
> -       if (opts)
> -               *opts = separator ? separator + 1 : NULL;
> -
>         /* The path could begin with an alias */
>         if (*path != '/') {
>                 char *p = strchrnul(path, '/');
> diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
> index 721b2a4..914f0ae 100644
> --- a/drivers/of/selftest.c
> +++ b/drivers/of/selftest.c
> @@ -100,6 +100,11 @@ static void __init of_selftest_find_node_by_name(void)
>         np = of_find_node_opts_by_path("testcase-alias", &options);
>         selftest(np && !options, "option clearing test failed\n");
>         of_node_put(np);
> +
> +       options = "testoption";
> +       np = of_find_node_opts_by_path("/", &options);
> +       selftest(np && !options, "option clearing root node test failed\n");
> +       of_node_put(np);
>  }
>
>  static void __init of_selftest_dynamic(void)
> --
> 1.7.10.4
>
