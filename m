Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3C0RkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:40:18 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:64041 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3C0RkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:40:15 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de
Subject: Immutable biovecs
Date: Wed, 27 Mar 2013 10:39:30 -0700
Message-Id: <1364405992-28424-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements immutable biovecs, and converts drivers to
the new primitives.

This is done by pulling bi_sector, bi_size and bi_idx out of struct bio
into a new iterator; to that we add bi_bvec_done which indicates the
number of bytes done in the current bvec.

This means we can create a bio that points to an arbitrary byte range in
an existing biovec; if we have a preexisting biovec that points to 4
whole pages, we can create a bio that points to the first 512 bytes of
the second bvec.

This enables easy and efficient splitting of arbitrary size bios; future
patches on top of this are going to convert the existing bio_split() in
fs/bio.c and remove the single bvec restriction.

This patch series does the necessary driver conversions so that a)
they're not modifying the biovec anymore (except whey're they've
explicitly cloned it, as in mm/bounce.c) and b) they always respect the
values of bi_idx and bi_bvec_done when the bio was passed to them - i.e.
you can submit partially completed bios to generic_make_request().

The intention is to then use this to make generic_make_request() accept
arbitrary size bios, splitting them as needed by the underlying device.
This enables a whole host of cleanups; we can get rid of merge_bvec_fn
(that's over 1000 lines of code deleted right there), bio_add_page()
becomes trivial (a lot of code becomes simpler if it doesn't have to
deal with bio_add_page() failing) - and I've also got a rewrite of the
dio code that depends on this, and shrinks direct-io.c to 650 lines,
drastically simplifying it and making it quite a bit faster too.

