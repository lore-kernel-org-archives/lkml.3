Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaIBHUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:20:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbaIBHUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:20:06 -0400
Message-ID: <54056F83.9010806@redhat.com>
Date: Tue, 02 Sep 2014 15:19:31 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com> <1408608310-13579-2-git-send-email-jasowang@redhat.com> <1408683665.5648.69.camel@marge.simpson.net> <20140901093159.GB27892@worktop.ger.corp.intel.com> <20140901095219.GD21269@redhat.com> <20140901100434.GD27892@worktop.ger.corp.intel.com> <54053BC0.6060700@redhat.com> <20140902061222.GE5806@worktop.ger.corp.intel.com>
In-Reply-To: <20140902061222.GE5806@worktop.ger.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 02:12 PM, Peter Zijlstra wrote:
> On Tue, Sep 02, 2014 at 11:38:40AM +0800, Jason Wang wrote:
>> > I see, how about just exporting a boolean helper like
>> > current_can_busy_loop() and take care all of the conditions (pending bhs
>> > and rcu callbacks, runnable processes) in scheduler code itself?
> How is that going to help the cases that are hurt by not spinning for a
> packet?

The patch does not help for this case. Spinning in the case only help
for a single process but hurt all others. Those other processes may not
use busy polling or even non network related. Spinning still may give
somewhat a high priority to the process who use busy polling or reading
which is unfair. And how much we can gain for only a single process by
spinning still when several other tasks could be done is still
questionable. It's quite possible that we could only get one or zero
packet after wasting lots of the cpu cycles when there are thousands or
more sockets.
