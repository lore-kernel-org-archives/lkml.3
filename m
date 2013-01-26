Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3AZJ7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 04:59:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55706 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3AZJ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 04:59:30 -0500
Date: Sat, 26 Jan 2013 09:59:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/19] regmap: avoid undefined return from
	regmap_read_debugfs
Message-ID: <20130126095916.GB23505@n2100.arm.linux.org.uk>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359123276-15833-12-git-send-email-arnd@arndb.de> <20130126044219.GA10580@opensource.wolfsonmicro.com> <201301260917.28028.arnd@arndb.de> <20130126094855.GI30594@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130126094855.GI30594@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 05:49:29PM +0800, Mark Brown wrote:
> Oh, ffs.  This is a false positive from the compiler - there is no case
> where it can actually do this as we will bail out before the walk if the
> list is empty so we'll always take at least one trip through our
> list_for_each_entry() and either return or set ret.  It should be smart
> enough to work out that the list_empty() means list_for_each_entry()
> will iterate over at least one entry or more conservative in what it
> warns about.

Why not code the function in a way that avoids the problem altogether?

	/*
	 * This should never happen; we return above if we fail to
	 * allocate and we should never be in this code if there are
	 * no registers at all.
	 */
-	if (list_empty(&map->debugfs_off_cache)) {
-		WARN_ON(list_empty(&map->debugfs_off_cache));
-		return base;
-	}
+	WARN_ON(list_empty(&map->debugfs_off_cache));
+	ret = base;

	/* Find the relevant block */
	list_for_each_entry(c, &map->debugfs_off_cache, list) {
		if (from >= c->min && from <= c->max) {
			*pos = c->min;
			return c->base_reg;
		}

		*pos = c->min;
		ret = c->base_reg;
	}

	return ret;
