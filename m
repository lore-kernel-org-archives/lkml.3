Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934936Ab3GWWut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:50:49 -0400
Received: from relay2.sgi.com ([192.48.179.30]:39364 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934566Ab3GWWuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:50:44 -0400
Message-ID: <51EF08C3.7040609@sgi.com>
Date: Tue, 23 Jul 2013 17:50:43 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Holger Hans Peter Freyther <holger@freyther.de>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] timer_list: Correct the show function for timer_list
 by using iter->now
References: <20130720054300.GA29718@xiaoyu.lan> <1374527911-43084-1-git-send-email-nzimmer@sgi.com> <20130723071802.GA7966@xiaoyu.lan>
In-Reply-To: <20130723071802.GA7966@xiaoyu.lan>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.140]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 02:18 AM, Holger Hans Peter Freyther wrote:
> On Mon, Jul 22, 2013 at 04:18:31PM -0500, Nathan Zimmer wrote:
>> This patch corrects the issue with /proc/timer_list reported by Holger.
>> When reading from the proc file with a sufficently small buffer, 2k so not
>> really that small, there was one could get hung trying to read the file a
>> chunk at a time.
> I think it makes sense to always use iter->now but it does not solve
> the issue with dropbear/my test case. Or is this meant to be applied
> on top of the previous patch?
>
>
> holger
>
Ah sorry I networked booted the wrong kernel and got excited.


However after hitting my head against this for the better part of the 
day I found
the root cause of my issue.

In seq_read about halfway down when we flush the buffer to userland.
m->index is advanced without calling m->op->next().
My iterator doesn't take notice of that and thus fails to advance.

         /* if not empty - flush it first */
         if (m->count) {
                 n = min(m->count, size);
                 err = copy_to_user(buf, m->buf + m->from, n);
                 if (err)
                         goto Efault;
                 m->count -= n;
                 m->from += n;
                 size -= n;
                 buf += n;
                 copied += n;
                 if (!m->count)
                         m->index++;
....


I'll need to think about how to correct it.

For the moment probably the right thing would be to revert b3956a896ea5

