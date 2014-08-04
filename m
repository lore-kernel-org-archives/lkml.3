Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaHDKsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:48:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaHDKsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:48:40 -0400
Date: Mon, 4 Aug 2014 11:48:26 +0100
From: Joe Thornber <thornber@redhat.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Anssi Hannula <anssi.hannula@iki.fi>, ejt@redhat.com, snitzer@redhat.com,
        LKML <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] dm cache: fix race affecting dirty block count
Message-ID: <20140804104826.GA494@debian>
Mail-Followup-To: Pranith Kumar <bobby.prani@gmail.com>,
	Anssi Hannula <anssi.hannula@iki.fi>, ejt@redhat.com,
	snitzer@redhat.com, LKML <linux-kernel@vger.kernel.org>,
	torvalds <torvalds@linux-foundation.org>
References: <53DD97B0.8040001@gmail.com>
 <CAJhHMCCFz5qpxocMbF1POBbFs6zPVaoM_j-52bw5vwpm1MV9aw@mail.gmail.com>
 <53DDAD9F.6010306@iki.fi>
 <CAJhHMCC8hDVzeYM1OL1VhTEw=+RrpVK_fQYCbKpnJvBUEP3LyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCC8hDVzeYM1OL1VhTEw=+RrpVK_fQYCbKpnJvBUEP3LyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2014 at 12:01:17AM -0400, Pranith Kumar wrote:
> Also dm_cblock_t is uint32_t, but atomic_t changes that to int. You
> should correct that to atomic64_t to preserve original semantics.

atomic_t used to have only 24 bits of range due to the Sparc
implementation holding a lock in one of the bytes.  I understand this
limitation was removed during 2.6 and the full 32 bits are now
available.

eg,

    https://github.com/jthornber/linux-2.6/commit/37682177af68478fa83429b735fa16913c2fbb2b

> These increments and decrements will still be lost if you do not use
> barriers in presence of concurrent accesses. Please see
> Documentation/memory-barriers.txt.

You do not need to use barriers for plain atomic_inc/dec().

    https://github.com/jthornber/linux-2.6/blob/thin-dev/Documentation/atomic_ops.txt#L187

You _do_ need to use a memory barrier for the ops that return a value
(such as atomic_dec_and_test()), But only if there's some other state
that needs synchronising.  See the nice example in atomic_ops.txt:

    https://github.com/jthornber/linux-2.6/blob/thin-dev/Documentation/atomic_ops.txt#L321

We just trigger a stateless event when the counter hits zero, so the
patch is fine.

- Joe
