Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3KYWam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:30:42 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54836 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3KYWaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:30:39 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk
Subject: [PATCH] Make generic_make_request() handle arbitrary size bios
Date: Mon, 25 Nov 2013 14:30:28 -0800
Message-Id: <1385418633-9753-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This builds off of immutable biovecs; it's a small enough patch series that I'd
like to try to get it into 3.14 but it is a pretty significant change in
behaviour for the block layer so it should definitely be considered separately
from that series.

What the series does is pretty simple - like the title says, you can now pass
generic_make_request arbitrary size bios - you no longer have to care about
device limits, and we can start deleting a ton of code.

This is done by splitting bios as needed. The idea is to push the splitting
lower and lower over time, and in many cases we eventually won't have to
actually split the bios at all - it'll happen implicitly - for now though, we do
it the simple easy way, with a new function (blk_queue_split()) that mimics the
old behaviour of bio_add_page().

This series only starts with the obvious easy things - bio_add_page(), and the
stuff in blk-lib.c. There's a lot more coming - with the new bio_split() that
can split arbitrary size bios the various virtual block drivers (md, dm, drbd,
etc.) should all either be capable of handling arbitrary size bios now or mostly
need minor changes, so we can delete merge_bvec_fn.

This patch series doesn't with REQ_TYPE_BLOCK_PC bios - bio_add_pc_page() and
the blk_execute_rq() codepath are unchanged. I'd like to get rid of direct
request submission eventually, but that is a different patch series.

