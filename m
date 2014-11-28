Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaK1QBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:01:37 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:63784 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaK1QBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:01:36 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] lib: bitmap: Simplify bitmap_shift_{left,right}
Date: Fri, 28 Nov 2014 17:01:03 +0100
Message-Id: <1417190476-18066-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've previously changed the nbits parameter of most bitmap_* functions
to unsigned; now it is bitmap_shift_{left,right}'s turn. This alone
saves some .text, but while at it I found that there were a few other
things one could do. The end result of these seven patches is

$ scripts/bloat-o-meter /tmp/bitmap.o.{old,new}
add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-328 (-328)
function                                     old     new   delta
__bitmap_shift_right                         384     226    -158
__bitmap_shift_left                          306     136    -170

and less importantly also a smaller stack footprint

$ stack-o-meter.pl master bitmap
file                 function                       old  new  delta
lib/bitmap.o         __bitmap_shift_right             24    8  -16
lib/bitmap.o         __bitmap_shift_left              24    0  -24

For each pair of 0 <= shift <= nbits <= 256 I've tested the end result
with a few randomly filled src buffers (including garbage beyond
nbits), in each case verifying that the shift {left,right}-most bits
of dst are zero and the remaining nbits-shift bits correspond to src,
so I'm fairly confident I didn't screw up. That hasn't stopped me from
being wrong before, though.

Rasmus Villemoes (7):
  lib: bitmap: Change bitmap_shift_right to take unsigned parameters
  lib: bitmap: Eliminate branch in __bitmap_shift_right
  lib: bitmap: Remove redundant code from __bitmap_shift_right
  lib: bitmap: Yet another simplification in __bitmap_shift_right
  lib: bitmap: Change bitmap_shift_left to take unsigned parameters
  lib: bitmap: Eliminate branch in __bitmap_shift_left
  lib: bitmap: Remove redundant code from __bitmap_shift_left

 include/linux/bitmap.h | 24 ++++++++++++------------
 lib/bitmap.c           | 47 ++++++++++++++++++++---------------------------
 2 files changed, 32 insertions(+), 39 deletions(-)

-- 
2.0.4

