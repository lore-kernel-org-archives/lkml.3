Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaCaMqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:46:39 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:56108 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaCaMqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:46:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC] Is wait_event_interruptible_timeout() broken ?
Date: Mon, 31 Mar 2014 14:48:38 +0200
Message-ID: <1651195.SHdSPrSxor@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While working on a driver for an I2C device I noticed that a call to 
wait_event_interruptible_timeout() would wait much longer than expected 
(2s-10s instead of 200ms). I've started by the obvious and checked the jiffies 
counter, which runs fine at the expected rate.

Further investigation showed that the schedule_timeout() call inside 
wait_event_interruptible_timeout() returns immediately. As the wait condition 
involves I2C access and thus takes significantly more time to run than 
schedule_timeout(), the probability of schedule_timeout() crossing a jiffies 
boundary is relatively small. The function thus returns the timeout value it 
received unchanged, and the jiffies boundary crossed by the condition check 
remains unnoticed. The actual timeout is thus much longer than requested.

I still need to investigate why schedule_timeout() returns immediately (help 
would be appreciated, I'm not familiar with the scheduler), but regardless of 
that I believe that wait_event_interruptible_timeout() should behave properly. 
Shouldn't it store the target jiffies before the loop and compare the current 
jiffies as part of the exit condition instead of relying on schedule_timeout() 
to update the timeout ?

I don't want to break the recent effort to consolidate all wait macros around 
___wait_event, so I'd appreciate both opinions on whether this should be 
considered as a wait_event_interruptible_timeout() bug, and hints regarding 
the preferred way to fix it.

-- 
Regards,

Laurent Pinchart

