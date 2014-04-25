Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaDYOE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:04:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaDYOEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:04:25 -0400
Date: Fri, 25 Apr 2014 16:04:21 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering
Message-ID: <20140425140421.GA7933@localhost>
References: <1398380677-8684-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398380677-8684-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 04:04:34PM -0700, John Stultz wrote:
> Continuing the sporadic work on improving the timekeeping
> frequency steering logic when NOHZ is enabled, I've made a number
> of changes to my re-implementation of Miroslav's patch (most
> recently posted here: https://lkml.org/lkml/2014/2/12/401 ),
> and I'm getting much closer results in the simulator.

Thanks, in my initial testing it seems to be working well. The results
from the simulator are much better than with the previous patch.

> Compared with Miroslav's patch, this avoids doing any extra
> divisions, and instead approximates the correction
> logarithmically.

Hm, doesn't that basically make the code a software implementation of
division? It seems it needs about 4-8 iterations to get to the final
result.

I didn't measure it, but I think with this change it now may be close
or possibly even slower than my patch. The extra division and
multiplication in my patch are used only when the tick length changes
(normally once per second), otherwise the update is very cheap.

> Miroslav's patch:
> -----------------
> $ ./test1.sh 
> 		freq10          freq100         dev             max
> nohz on	0.00601         0.00028         74.0            279.4
> nohz off	0.05867         0.00204         0.2             0.6

> This patchset:
> --------------
> $ ./test1.sh 
> 		freq10          freq100         dev             max
> nohz on	0.00748         0.00076         110.8           476.4
> nohz off	0.07173         0.03590         0.6             2.1

This looks pretty good to me. It's interesting that the performance
with nohz off got worse, but when I modify the test to use more points
I can see it does converge to the correct frequency and probably it's
not a big problem.

It seems it still doesn't always switch mult only between the two
closest values, which explains the slightly worse dev and max values.

Thanks,

-- 
Miroslav Lichvar
