Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab3BVXxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 18:53:18 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61690 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3BVXxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 18:53:16 -0500
Message-ID: <512804E9.1010408@linaro.org>
Date: Fri, 22 Feb 2013 15:53:13 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC patch 7/8] timekeeping: Implement a shadow timekeeper
References: <20130221220147.719832397@linutronix.de> <20130221224231.174700473@linutronix.de>
In-Reply-To: <20130221224231.174700473@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 02:51 PM, Thomas Gleixner wrote:
> Use the shadow timekeeper to do the update_wall_time() adjustments and
> then copy it over to the real timekeeper.
>
> Keep the shadow timekeeper in sync when updating stuff outside of
> update_wall_time().
>
> This allows us to limit the timekeeper_seq hold time to the update of
> the real timekeeper and the vsyscall data in the next patch.
>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> ---

So up to here it all looks ok to me (and not so different from my 
earlier attempts at the same).

The only gotcha here that I realized with my earlier patches, is that in 
order to do the shadow copy update properly, we are also going to need 
to merge the NTP state data into the timekeeper. Otherwise, we could run 
into odd cases where as we update the shadow copy, we change the NTP 
state which then would affect the non-shadow timekeeping state that is 
about to be updated. One example: A the leap second lands, and the tai 
offset gets bumped in the ntp state, while we do a similar counter 
adjustment to the shadow-copy. Then before the real/active timekeeper is 
updated, someone gets the tai offset and applies it to that pre-update 
timekeeper state, and gets an invalid tai time.

The down side is that the NTP state data is fairly large, and so adding 
it to the timekeeper will cause the memcopys to be a bit more painful.

I'm looking at the NTP code now to try to see if we can bound where the 
NTP state is accessed, so we can maybe thin out what ntp state is linked 
to timekeeper updates, and only move that data over to the timekeeper.

thanks
-john





