Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaGULVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:21:06 -0400
Received: from ns.horizon.com ([71.41.210.147]:59318 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754504AbaGULVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:21:04 -0400
Date: 21 Jul 2014 07:21:02 -0400
Message-ID: <20140721112102.19300.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hannes@stressinduktion.org, linux@horizon.com
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu
In-Reply-To: <1405891964.9562.42.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't like partial reads/writes and think that a lot of people get
> them wrong, because they often only check for negative return values.

The v1 patch, which did it right IMHO, didn't do partial reads in the
case we're talking about:

+	if (count > 256)
+		return -EINVAL;

> In case of urandom extraction, I wouldn't actually limit the number of
> bytes. A lot of applications I have seen already extract more than 128
> out of urandom (not for seeding a prng but just to mess around with some
> memory). I don't see a reason why getrandom shouldn't be used for that.
> It just adds one more thing to look out for if using getrandom() in
> urandom mode, especially during porting an application over to this new
> interface.

Again, I disagree.  If it's "just messing around" code, use /dev/urandom.
It's more portable and you don't care about the fd exhaustion attacks.

If it's actual code to be used in anger, fix it to not abuse /dev/urandom.

You're right that a quick hack might be "broken on purpose", but without
exception, *all* code that I have seen which reads 64 or more bytes from
/dev/*random is broken, and highlighting the brokenness is a highly
desirable thing.

The sole and exclusive reason for this syscall to exist at all is to
solve a security problem.  Supporting broken security code does no favors
to anyone.
