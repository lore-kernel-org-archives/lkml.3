Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab3LFPsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:48:38 -0500
Received: from imap.thunk.org ([74.207.234.97]:37324 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab3LFPsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:48:36 -0500
Date: Thu, 5 Dec 2013 20:13:47 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 9/9] random: simplify accounting code
Message-ID: <20131206011347.GD9010@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <cover.1384329436.git.price@mit.edu>
 <20131113080841.GW16018@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113080841.GW16018@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 03:08:41AM -0500, Greg Price wrote:
> +	entropy_count = max_t(int, 0,
> +			      entropy_count - (ibytes << (ENTROPY_SHIFT + 3)));
> +	if (ibytes && cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
> +		goto retry;

I wonder if we would be better dropping the test for ibytes here, so
the above condition reads:

	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
		goto retry;

It further simplifies the code, and it means that if we it turns out
that ibytes is zero (meaning there was no entropy available) but some
additional entropy comes in, we might acutally end up retrying and
successfully grabbing that entropy for the caller.

						- Ted
