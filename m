Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3IPC6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 22:58:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:43381 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab3IPC6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 22:58:11 -0400
Message-ID: <1379300274.4098.77.camel@pasglop>
Subject: "memory" binding issues
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: devicetree@vger.kernel.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, m.szyprowski@samsung.com,
        swarren@nvidia.com, rob.herring@calxeda.com,
        Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 16 Sep 2013 12:57:54 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resent to the right list this time around]

Hi folks !

So I don't have the bandwidth to follow closely what's going on, but I
just today noticed the crackpot that went into 3.11 as part of commit:

9d8eab7af79cb4ce2de5de39f82c455b1f796963
drivers: of: add initialization code for dma reserved memory

Fist of all, do NOT add (or change) a binding as part of a patch
implementing code, it's gross.

Secondly, I don't know how much that binding was discussed on the list
(I assume it was and I just missed it) but it's gross.

It duplicates a binding that Jeremy Kerr had proposed a while ago for
a /reserved-ranges (and /reserved-names) pair of properties, possibly in
a better way but the fact is that the original binding received little
or no feedback and we went on and implemented support for it in powerpc
back in early 3.11 merge window.

Additionally, it has the following issues:

 - It describes the "memory" node as /memory, which is WRONG

It should be "/memory@unit-address, this is important because the Linux
kernel of_find_device_by_path() isn't smart enough to do partial
searches (unlike the real OFW one) and thus to ignore the unit address
for search purposes, and you *need* the unit address if you have
multiple memory nodes (which you typically do on NUMA machines).

 - To add to the above mistake, it defines "reserved memory" as a child
node of the "/memory" node. That is wrong or at least poorly thought
out. There can be several "memory" nodes, representing different areas
of memory, possibly even interleaved, having the reserved ranges as
children of a specific memory nodes thus doesn't work very well.
Breaking them up into regions based on what memory nodes they cover is
really nasty. Basically, the "reserved-memory" node should have been at
the root of the device-tree.

 - It provides no indication of what a given region is used for (or used
by). In the example, "display_region" is a label (thus information that
is lost) and unless it's referenced by another node there is no good way
to know what this region is about which is quite annoying.

 - The "memory-region" property is a phandle to a "reserved-memory"
region, this is not intuitive. If anything, the property should have
been called "reserved-memory-region".

 - The way the "compatible" property is documented breaks a basic
premise that the device-tree is a hardware description and not some
convenient way to pass linux specific kernel parameters accross. It is
*ok* to pass some linux specific stuff and to make compromise based on
what a driver generally might expect but the whole business of using
that to describe what to put in CMA is pushing it pretty far ...

 - The implementation of early_init_dt_scan_reserved_mem() will not work
on a setup whose /memory node has a unit address (typically /memory@0)

Now, I'd like to understand why not use the simpler binding originally
proposed by Jeremy, which had the advantage of proposing a unique name
per region in the traditional form "vendor,name", which then allows
drivers to pick up the region directly if they wish to query, remove or
update it in the tree for example (because they changed the framebuffer
address for example and want kexec to continue working).

I don't object to having a node per region, though it seemed unnecessary
at the time, but in any case, the current binding is crap and need to be
fixed urgently before its use spreads.

Ben.



