Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab3ELQ5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 12:57:04 -0400
Received: from canardo.mork.no ([148.122.252.1]:41224 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab3ELQ5D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 12:57:03 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Borislav Petkov <bp@alien8.de>
Cc: paulmck@linux.vnet.ibm.com, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time as with v3.9
Organization: m
References: <87r4hdjsu5.fsf@nemi.mork.no>
	<20130512113157.GG3648@linux.vnet.ibm.com>
	<87hai8kwgh.fsf@nemi.mork.no> <20130512162717.GA6305@pd.tnic>
Date: Sun, 12 May 2013 18:56:40 +0200
In-Reply-To: <20130512162717.GA6305@pd.tnic> (Borislav Petkov's message of
	"Sun, 12 May 2013 18:27:17 +0200")
Message-ID: <87ehdcuofr.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:

> On Sun, May 12, 2013 at 06:13:34PM +0200, Bjørn Mork wrote:
>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>> index 6934238..2dcbf84 100644
>> --- a/kernel/rcutree.c
>> +++ b/kernel/rcutree.c
>> @@ -3103,9 +3103,11 @@ static int rcu_pm_notify(struct notifier_block *self,
>>  {
>>  	switch (action) {
>>  	case PM_HIBERNATION_PREPARE:
>> +	case PM_SUSPEND_PREPARE:
>>  		rcu_expedited = 1;
>>  		break;
>> -	case PM_POST_RESTORE:
>> +	case PM_POST_HIBERNATION:
>> +	case PM_POST_SUSPEND:
>>  		rcu_expedited = 0;
>>  		break;
>>  	default:
>
> If I'm reading Documentation/power/notifiers.txt correctly, we only need
> PM_HIBERNATION_PREPARE when we go to sleep (whatever hibernation method
> we use) and PM_POST_HIBERNATION when we restore.

Well, that's not the way I read it. And testing also supports that.

Adding the above to your patch makes restore from suspend use < 3
seconds again.  Using only PM_HIBERNATION_PREPARE had no effect on the
restore from suspend time, still measured at around 15 seconds on my
laptop.

Note that I did not test hibernation at all.  But based on your patch I
assume the issue is exactly the same.

> I don't think it matters for expediting RCU grace periods whether
> we had an error during resume or not and I'd basically want to set
> rcu_expedited to 0 unconditionally when resuming..

Yes, and I believe that's what PM_POST_HIBERNATION will achieve if I
read the docs correctly.  But I guess this should be sanity checked via
Rafael or someone else knowing how these notifiers work.


Bjørn
