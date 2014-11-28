Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaK1PZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:25:23 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:53989 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaK1PZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:25:21 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 2/3] of: add optional options parameter
 =?iso-8859-1?Q?to=0D?= of_find_node_by_path()
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org, andrew@lunn.ch,
        s.hauer@pengutronix.de
In-Reply-To: <20141128113428.GM2361@bivouac.eciton.net>
References: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
	<1417110967-16284-3-git-send-email-leif.lindholm@linaro.org>
	<20141128004403.08D90C40A7F@trevor.secretlab.ca>
	<20141128113428.GM2361@bivouac.eciton.net>
Date: Fri, 28 Nov 2014 15:25:12 +0000
Message-Id: <20141128152512.2152EC40884@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014 11:34:28 +0000
, Leif Lindholm <leif.lindholm@linaro.org>
 wrote:
> On Fri, Nov 28, 2014 at 12:44:03AM +0000, Grant Likely wrote:
> > > +	separator = strchr(path, ':');
> > > +	if (separator && opts)
> > > +		*opts = separator + 1;
> > > +
> > 
> > What about when there are no opts? Do we require the caller to make sure
> > opts is NULL before calling the function (which sounds like a good
> > source of bugs) or do we clear it on successful return?
> > 
> > I think if opts is passed in, but there are no options, then it should
> > set *opts = NULL.
> 
> Yeah, oops.
> 
> > There should be test cases for this also. Must set opts to NULL on
> > successful return, and (I think) should leave opts alone on an
> > unsuccessful search.
> 
> I would actually argue for always nuking the opts - since that could
> (theoretically) prevent something working by accident in spite of
> error conditions.
> 
> How about the below?

Perfect, applied with one fixup below...

> 
> /
>     Leif
> 
> From 2e1a44e539967d96366d074ae158092900e0c822 Mon Sep 17 00:00:00 2001
> From: Leif Lindholm <leif.lindholm@linaro.org>
> Date: Thu, 27 Nov 2014 09:24:31 +0000
> Subject: [PATCH] of: add optional options parameter to of_find_node_by_path()
> 
> Update of_find_node_by_path():
> 1) Rename function to of_find_node_opts_by_path(), adding an optional
>    pointer argument. Provide a static inline wrapper version of
>    of_find_node_by_path() which calls the new function with NULL as
>    the optional argument.
> 2) Ignore any part of the path beyond and including the ':' separator.
> 3) Set the new provided pointer argument to the beginning of the string
>    following the ':' separator.
> 4: Add tests.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
> @@ -729,19 +737,24 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
>   *	Returns a node pointer with refcount incremented, use
>   *	of_node_put() on it when done.
>   */
> -struct device_node *of_find_node_by_path(const char *path)
> +struct device_node *of_find_node_opts_by_path(const char *path, const char **opts)
>  {
>  	struct device_node *np = NULL;
>  	struct property *pp;
>  	unsigned long flags;
> +	char *separator;

const char *separator.

Thanks,
g.
