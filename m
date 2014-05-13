Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaEMAu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 20:50:58 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44586 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaEMAu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 20:50:56 -0400
Date: Mon, 12 May 2014 17:50:53 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mtd: Add sysfs attr to expose ECC stats
Message-ID: <20140513005053.GZ28907@ld-irv-0074>
References: <1395403064-28113-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1395403064-28113-2-git-send-email-ezequiel.garcia@free-electrons.com>
 <20980858CB6D3A4BAE95CA194937D5E73EAB91D7@DBDE04.ent.ti.com>
 <20140401111359.GA3324@arch.cereza>
 <20980858CB6D3A4BAE95CA194937D5E73EAC31AE@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EAC31AE@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Greg KH, LKML

For context:

http://thread.gmane.org/gmane.linux.drivers.mtd/52517/focus=52518

On Tue, Apr 15, 2014 at 11:13:52AM +0000, Pekon Gupta wrote:
> >From: Ezequiel Garcia
> >>On Mar 27, Gupta, Pekon wrote:
> >> >
> >> >+static ssize_t mtd_ecc_stats_show(struct device *dev,
> >> >+		struct device_attribute *attr, char *buf)
> >> >+{
> >> >+	struct mtd_info *mtd = dev_get_drvdata(dev);
> >> >+	struct mtd_ecc_stats *ecc_stats = &mtd->ecc_stats;
> >> >+
> >> >+	return snprintf(buf, PAGE_SIZE, "%8u %8u %8u %8u\n", ecc_stats->corrected,
> >> >+						ecc_stats->failed,
> >> >+						ecc_stats->badblocks,
> >> >+						ecc_stats->bbtblocks);
> >> Though I would have liked to see each field of ecc_stats as a separate sysfs entry
> >
> >I tried to match the ecc_stats structure exactly in the sysfs entry. Keep
> >in mind creating/keeping a sysfs file has its cost. Since it's trivial
> >to get one of the fields with any text parsing tool I didn't think having
> >a file per stat was worth it.

I'm not sure what kind of cost this has these days. I thought there was
some work to reduce the required kobject memory usage for each new sysfs
file.

> There are some guidelines about attributes in 'Documentation/filesystems/sysfs.txt'
> Though it's acceptable to put array of values of the "same type" in single sysfs file,
> But I'm still not confident on having all members of 'struct ecc_stats' being
> represented by single sysfs file
[...]

I agree, it looks like the sysfs policy would recommend against putting
distinct properties in the same file.

I'm not sure if /sys/block/<disk>/stat is a good example, as it does
violate this policy. It also seems to have some historical baggage.

But there is potentially one good reason for putting this distinct
information in a single file: if the information must be returned
atomically. For disk stats, it might be important to get a consistent
snapshot of the disk stats (or nearly so, with minimal locking
overhead), which might change significantly between file accesses if
we're doing half a dozen file queries instead.

This same reason may not apply to these ECC stats, since none of these
ECC stats are likely to be changing concurrently.

So I personally might lean toward "one file per attribute" here.

> >It won't impact as they are two completely different things. The ecc_stats
> >output is only "vaguely inspired" in block stats; but these are two completely
> >different stats. It's not about tool reusability, but about consistency.
> >
> >> Also, How about printing what these numbers mean ?

This sounds like an argument from the /proc days. Not sure if we want to
repeat that in /sys.

> >> I hope this will still keep it machine readable.
> >Well, this is not a debugfs entry, so I'm not sure we want to add such debug
> >information. Anyone can take a look at the code and see what ecc_stats mean.

The code or (as suggested by Pekon) the documentation
(Documentation/ABI/). Either way -- with a single 'ecc_stats' table, or
with 4 separate files -- they need to be documented.

Brian
