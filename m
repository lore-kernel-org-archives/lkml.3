Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaHMXcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 19:32:12 -0400
Received: from imap.thunk.org ([74.207.234.97]:59314 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbaHMXcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 19:32:10 -0400
Date: Wed, 13 Aug 2014 19:31:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Matt Fleming <matt@console-pimps.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] firmware: Do not use WARN_ON(!spin_is_locked())
Message-ID: <20140813233158.GB10808@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Matt Fleming <matt@console-pimps.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
References: <1407729253-31341-1-git-send-email-linux@roeck-us.net>
 <20140813141836.GQ15082@console-pimps.org>
 <53EB7831.4080306@roeck-us.net>
 <20140813150201.GT15082@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813150201.GT15082@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 04:02:01PM +0100, Matt Fleming wrote:
> On Wed, 13 Aug, at 07:37:37AM, Guenter Roeck wrote:
> > 
> > WARN_ON and WARN_ON_SMP are unconditional. lockdep_assert_held()
> > is only active if lockdep debugging is enabled. Not knowing the code,
> > nor the reason why the unconditional method was chosen, I prefer
> > to refrain from functional changes and limit myself to bug fixes.
>  
> As the author of that code, I feel confident telling you that the
> unconditional method was used because the author is a boob. The code
> isn't so important that we need to unconditionally check the locks, and
> indeed it's possible to run into all sorts of problems when you don't
> use the standard lock-checking functions - the non-SMP crash being a
> good example.

If you want to actually force a BUG_ON if the spinlock is not taken,
even for non-debug kernels, you can use assert_spin_locked().  This
translates to a BUG_ON(!raw_spin_is_locked(x)) on SMP kernels, and a
no-op on UP kernels.

If you're confident in your testing that any problems would be
discovered before you push your patches to linus (and you actually use
lockdep in your testing :-), then lockdep_assert_held() doesn't add
any overhead if !lockdep, and so it might be a better choice for you.

							- Ted
