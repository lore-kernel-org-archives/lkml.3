Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaFCIxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:53:33 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47184 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaFCIxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:53:30 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/base: Replace alias if it already exists
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <538CA125.7090906@gmail.com>
References: <1401624083-30796-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
	<20140602145959.7E669C426F6@trevor.secretlab.ca>
	<538CA125.7090906@gmail.com>
Date: Tue, 03 Jun 2014 09:53:25 +0100
Message-Id: <20140603085325.490A1C4096E@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2014 19:07:01 +0300, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> wrote:
> 
> 
> On  2.06.2014 17:59, Grant Likely wrote:
> > On Sun,  1 Jun 2014 15:01:23 +0300, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com> wrote:
> >> The current code unconditionally adds aliases without check if it already
> >> exists, so it is not possible to alter an alias, from board DT file for
> >> example. Fix that by replacing an alias if it already exists
> >>
> >
> > Can you describe a more detailed use-case for altering an alias?
> >
> > g.
> >
> 
> That one http://www.spinics.net/lists/linux-omap/msg107869.html

So, if I understand correctly, the .dtsi file sets up aliases like so:

aliases {
	i2c0 = &i2c1;
	i2c1 = &i2c2;
	i2c2 = &i2c3;
	i2c3 = &i2c4;
	i2c4 = &i2c5;
};

and the board file does this:


aliases {
	i2c1 = &i2c1;
	i2c2 = &i2c2;
	i2c3 = &i2c3;
	i2c4 = &i2c4;
	i2c5 = &i2c5;
};

Which results in a dtb that looks like this:

aliases {
	i2c0 = &i2c1;
	i2c1 = &i2c1;
	i2c2 = &i2c2;
	i2c3 = &i2c3;
	i2c4 = &i2c4;
	i2c5 = &i2c5;
};

Do I understand correctly?

The way aliases works, it is completely valid to have multiple aliases
pointing at the same node. There are also no ordering guarantees about
which comes first, so though this patch might work for you at the
moment, there is no guarantee that it will continue to do so. If the
i2c0 alias is invalid for that platform, then it must be removed.

Unfortunately, the overlays have no mechanism for removing properties at
this time. Can you try putting the following into your board dts file
and see if it works?

aliases {
	i2c0;		/* Deactivate the old alias by making it blank */
	i2c1 = &i2c1;
	i2c2 = &i2c2;
	i2c3 = &i2c3;
	i2c4 = &i2c4;
	i2c5 = &i2c5;
};

g.
