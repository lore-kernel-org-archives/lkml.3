Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab3EZEcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 00:32:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab3EZEcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 00:32:16 -0400
From: Rafael Aquini <aquini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hughd@google.com,
        shli@kernel.org, kzak@redhat.com, jmoyer@redhat.com,
        kosaki.motohiro@gmail.com, riel@redhat.com, lwoodman@redhat.com,
        mgorman@suse.de
Subject: [PATCH 00/02] swap: allowing a more flexible DISCARD policy V2
Date: Sun, 26 May 2013 01:31:54 -0300
Message-Id: <cover.1369529143.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Considering the use cases where the swap device supports discard:
a) and can do it quickly;
b) but it's slow to do in small granularities (or concurrent with other
   I/O);
c) but the implementation is so horrendous that you don't even want to
   send one down;

And assuming that the sysadmin considers it useful to send the discards down
at all, we would (probably) want the following solutions:

  i. do the fine-grained discards for freed swap pages, if device is 
     capable of doing so optimally;
 ii. do single-time (batched) swap area discards, either at swapon 
     or via something like fstrim (not implemented yet);
iii. allow doing both single-time and fine-grained discards; or
 iv. turn it off completely (default behavior)


As implemented today, one can only enable/disable discards for swap, but 
one cannot select, for instance, solution (ii) on a swap device like (b)
even though the single-time discard is regarded to be interesting, or
necessary to the workload because it would imply (1), and the device
is not capable of performing it optimally.

This patchset addresses the scenario depicted above by introducing a
way to ensure the (probably) wanted solutions (i, ii, iii and iv) can
be flexibly flagged through swapon(8) to allow a sysadmin to select
the best suitable swap discard policy accordingly to system constraints.

Changeset from V1:
01 (kernel)       swap: discard while swapping only if SWAP_FLAG_DISCARD_PAGES
* ensure backwards compatibility with older swapon(8) releases;      (mkosaki)

02 (util-linux) swapon: allow a more flexible swap discard policy
* introduce discard policy selector as an optional argument of --discard option;
* rename user-visible discard policy names;           (mkosaki, karel, jmoyer) 
