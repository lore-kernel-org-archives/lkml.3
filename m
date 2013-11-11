Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3KKTw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:52:29 -0500
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:55025 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754275Ab3KKTwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:52:21 -0500
X-AuditID: 12074425-b7fd96d000000c39-a1-528135742873
Date: Mon, 11 Nov 2013 14:52:17 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: random: locking vs. lockless accesses
Message-ID: <20131111195217.GV8043@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsUixCmqrFti2hhk8GW1ssXuOYtZLC7vmsPm
	wORxZsERdo/Pm+QCmKK4bFJSczLLUov07RK4MuY29bIUzGKvWHZpJVsD42vWLkZODgkBE4kp
	O/axQ9hiEhfurWfrYuTiEBKYzSSx4P0xFghnI6PEhxMTwTqEBH4xSkyZn9DFyMHBIqAqcWOL
	FkiYTUBB4sf8dcwgtoiAssSqmZuYQGxmAXuJ31Mngy0QFtCTuHd7FVgNr4CpxM9bt5ggbEGJ
	kzOfsEDUa0nc+PeSCWQ8s4C0xPJ/HCBhUQEViSknt7FNYOSfhaRjFpKOWQgdCxiZVzHKpuRW
	6eYmZuYUpybrFicn5uWlFula6OVmluilppRuYgQFIruL6g7GCYeUDjEKcDAq8fDu4GoMEmJN
	LCuuzD3EKMnBpCTKu9wIKMSXlJ9SmZFYnBFfVJqTWnyIUYKDWUmE140XKMebklhZlVqUD5OS
	5mBREue9xWEfJCSQnliSmp2aWpBaBJOV4eBQkuCVNAFqFCxKTU+tSMvMKUFIM3FwggznARru
	DFLDW1yQmFucmQ6RP8WoKCXOm2wMlBAASWSU5sH1whLFK0ZxoFeEeTlA2nmASQau+xXQYCag
	wQ6vakEGlyQipKQaGN036AQ1ZDoVhO98Z5kUZWkQIrma4fLzb7Ebu48e2FL/WFHjVcD6eR6X
	Nf7+ZTDxOXHs68b69+4zlqpX/fGc2v8vpejtXUPTI53J/xY2blqcttf2SOuyf5l9lnMeadSs
	0ouULU35v+ZYss/9hodHDJS87N9cf8xTt32pQNX9yGJf06VC2lzp3kosxRmJhlrMRcWJAEg4
	KEDvAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

After reading through the RNG code, I'm curious about one aspect and I
wonder if you can shed light on it.  Since v3.6-rc1~26^2~30 ("random:
use lockless techniques in the interrupt path"), we mix bytes into the
pool without taking the lock, when inside add_interrupt_randomness().
This means we may mix concurrently with mixing from other input
sources or with hashing the pool in extract_buf().  Nevertheless we
still take the lock in those other situations.

What do you think are the consequences of accessing the pool
concurrently?  If it's OK to do, should we be doing so everywhere?

By my reading, the only mutable data on a pool that we consistently
protect with the lock is ->last_data and ->last_data_init.  If
everything else were accessed without the lock, the only lock-taking
that would survive is what we do in extract_entropy when fips_enabled
is true.

Thanks, cheers,
Greg
