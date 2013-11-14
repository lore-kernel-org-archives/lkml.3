Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3KNCDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 21:03:41 -0500
Received: from imap.thunk.org ([74.207.234.97]:58329 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab3KNCDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 21:03:37 -0500
Date: Wed, 13 Nov 2013 21:03:32 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: /dev/random changes for 3.13
Message-ID: <20131114020332.GA10961@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6e4664525b1db28f8c4e1130957f70a94c19213e:

  Linux 3.11 (2013-09-02 13:46:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus

for you to fetch changes up to 392a546dc8368d1745f9891ef3f8f7c380de8650:

  random: add debugging code to detect early use of get_random_bytes() (2013-11-03 18:24:08 -0500)

----------------------------------------------------------------
The /dev/random changes for 3.13 including a number of improvements in
the following areas: performance, avoiding waste of entropy, better
tracking of entropy estimates, support for non-x86 platforms that have
a register which can't be used for fine-grained timekeeping, but which
might be good enough for the random driver.

Also add some printk's so that we can see how quickly /dev/urandom can
get initialized, and when programs try to use /dev/urandom before it
is fully initialized (since this could be a security issue).  This
shouldn't be an issue on x86 desktop/laptops --- a test on my Lenovo
T430s laptop shows that /dev/urandom is getting fully initialized
approximately two seconds before the root file system is mounted
read/write --- this may be an issue with ARM and MIPS embedded/mobile
systems, though.  These printk's will be a useful canary before
potentially adding a future change to start blocking processes which
try to read from /dev/urandom before it is initialized, which is
something FreeBSD does already for security reasons, and which
security folks have been agitating for Linux to also adopt.

----------------------------------------------------------------
H. Peter Anvin (3):
      random: statically compute poolbitshift, poolbytes, poolbits
      random: allow fractional bits to be tracked
      random: account for entropy loss due to overwrites

Theodore Ts'o (17):
      random: run random_int_secret_init() run after all late_initcalls
      random: allow architectures to optionally define random_get_entropy()
      random: mix in architectural randomness earlier in extract_buf()
      random: fix the tracepoint for get_random_bytes(_arch)
      random: optimize spinlock use in add_device_randomness()
      random: optimize the entropy_store structure
      random: cap the rate which the /dev/urandom pool gets reseeded
      random: speed up the fast_mix function by a factor of four
      random: adjust the generator polynomials in the mixing function slightly
      random: drop trickle mode
      random: push extra entropy to the output pools
      random: convert DEBUG_ENT to tracepoints
      random: make add_timer_randomness() fill the nonblocking pool first
      random: printk notifications for urandom pool initialization
      random: don't zap entropy count in rand_initialize()
      random: initialize the last_time field in struct timer_rand_state
      random: add debugging code to detect early use of get_random_bytes()

 drivers/char/random.c         | 652 ++++++++++++++++++++++++++++++++-------------------
 include/linux/random.h        |   1 +
 include/linux/timex.h         |  14 ++
 include/trace/events/random.h | 183 ++++++++++++++-
 init/main.c                   |   2 +
 5 files changed, 608 insertions(+), 244 deletions(-)
