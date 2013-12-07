Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3LGQpr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 11:45:47 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:35227 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab3LGQpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 11:45:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAJvTdKkQUKFhwswK64PDNgPOMxP4s2X1GYKzWLW0G6gWxhdWtA@mail.gmail.com>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
	<1386405590.5673.96.camel@marge.simpson.net>
	<CAJvTdKkQUKFhwswK64PDNgPOMxP4s2X1GYKzWLW0G6gWxhdWtA@mail.gmail.com>
Date: Sat, 7 Dec 2013 11:45:42 -0500
X-Google-Sender-Auth: yoI3tC3d0DeHha63NhfSsG63aSM
Message-ID: <CAJvTdK=9DVxY9xWCo=SSF-Rx3dFfZtkrubhtcgxxowj-rbi8LQ@mail.gmail.com>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Len Brown <lenb@kernel.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> It fixes that, except for my Q6600 box.  Too bad mwait_idle() went away,
>> beloved old box doesn't play hints game, so it continues to flog itself.


Thanks for pointing this out, Mike!

A Q6600 is a Kentsfield.  I dug one of those up.
Indeed, the only idle capabilities it has are  HALT
and old style MWAIT, and the latter is much more effective.
running 3.8 it idles at 75 watts.
running 3.8 with idle=nomwait it idles at 100 watts,
which is what it will do with 3.9 and later due to the patch below.

commit 69fb3676df3329a7142803bb3502fa59dc0db2e3
Author: Len Brown <len.brown@intel.com>
Date:   Sun Feb 10 01:38:39 2013 -0500

    x86 idle: remove mwait_idle() and "idle=mwait" cmdline param

Kentsfield proves that patch was based on a fault assumption.
Sweet box in its day, ECC memory and everything -- probably still
a fair number of them running...

Plus, I've found another machine that depends on having an idle=mwait
idle loop (A Sony Vaio BIOS SMM code apparently assumes we use it in
https://bugzilla.kernel.org/show_bug.cgi?id=60770)

So it looks like I need to (also) restore the simple idle=mwait idle loop
to make some machines happy.

thanks,
Len Brown, Intel Open Source Technology Center
