Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaESH4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:56:40 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55774 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaESH4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:56:38 -0400
Message-ID: <1400486094.10554.3.camel@debian>
Subject: Re: [PATCH] x86/mce: Distirbute the clear operation of mces_seen to
 Per-CPU rather than only monarch CPU
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org
Date: Mon, 19 May 2014 15:54:54 +0800
In-Reply-To: <20140519072619.GA6311@pd.tnic>
References: <1400425504-8821-1-git-send-email-slaoub@gmail.com>
	 <20140518163508.GA8003@pd.tnic> <1400464540.9630.31.camel@debian>
	 <20140519072619.GA6311@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 09:26 +0200, Borislav Petkov wrote:
> On Mon, May 19, 2014 at 09:55:40AM +0800, Chen Yucong wrote:
> > But all other CPUs also have to wait monarch CPU to exit from mce_end.
> > What's the difference between monarch CPU and Per-CPU for clearing
> > mces_seen? In practice, there is no difference between them. If we use
> > monarch CPU to clear mces_seen, then Per-CPU variable can not play out
> > its advantage.
> 
> I'll let you stare at mce_reign() a little bit longer... Also, pay
> attention to its callsite, that might help.
> 
We can find the following code segment in mce_end:
-----
...
        if (order == 1) {
                /* CHECKME: Can this race with a parallel hotplug? */
                int cpus = num_online_cpus();

                /*
                 * Monarch: Wait for everyone to go through their
scanning
                 * loops.
                 */
                while (atomic_read(&mce_executing) <= cpus) {
                        if (mce_timed_out(&timeout))
                                goto reset;
                        ndelay(SPINUNIT);
                }

                mce_reign();
                barrier();
                ret = 0;
...
-----
If a timeout occurs in monarch CPU, what will happen for the above code
segment?
The monarch CPU will directly execute -goto reset-, so mce_reign will
not be invoked. That way, the clear operation of mces_seen will be
skipped, and the stale value of mces_seen will reappear on the next mce.

thx!
cyc


