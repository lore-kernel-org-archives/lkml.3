Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3JNJ2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:28:20 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:55977 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3JNJ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:28:19 -0400
Date: Mon, 14 Oct 2013 11:28:14 +0200
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] init: fix in-place parameter modification regression
Message-ID: <20131014092814.GA20882@shrek.podlesie.net>
References: <1381601100-5622-1-git-send-email-krzysiek@podlesie.net>
 <87eh7o8ft4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh7o8ft4.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 06:06:23PM +1030, Rusty Russell wrote:
> Krzysztof Mazur <krzysiek@podlesie.net> writes:
> > Before commit 026cee0086fe1df4cf74691cf273062cc769617d
> > ("params: <level>_initcall-like kernel parameters") the __setup
> > parameter parsing code could modify parameter in the
> > static_command_line buffer and such modifications were kept. After
> > that commit such modifications are destroyed during per-initcall level
> > parameter parsing because the same static_command_line buffer is used
> > and only parameters for appropriate initcall level are parsed.
> >
> > That change broke at least parsing "ubd" parameter in the ubd driver
> > when the COW file is used.
> >
> > Now the separate buffer is used for per-initcall parameter parsing,
> > like in parsing early params.
> 
> How about just removing "strcpy(static_command_line, saved_command_line);"
> from do_initcall_level altogether?  We already initialize it in
> setup_command_line().
> 

That does not work because the command line is always modified -
at least '\0' are added to split strings.

To be sure I tested that with:

diff --git a/kernel/params.c b/kernel/params.c
index c00d5b5..606058a 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -96,6 +96,7 @@ static int parse_one(char *param,
 	unsigned int i;
 	int err;
 
+	printk("param %d-%d: %s\n", min_level, max_level, param);
 	/* Find parameter */
 	for (i = 0; i < num_params; i++) {
 		if (parameq(param, params[i].name)) {


And without that strcpy() I get:

	[...]
	param 0-0: ubd0
	param 1-1: ubd0
	[...]

instead of:

	[...]
	param 0-0: ubd0
	param 0-0: ubd1
	param 0-0: raid
	param 0-0: hostfs
	param 0-0: root
	param 1-1: ubd0
	param 1-1: ubd1
	param 1-1: raid
	param 1-1: hostfs
	param 1-1: root
	[...]

I checked that also without udb parameters.

Thanks,
Krzysiek
