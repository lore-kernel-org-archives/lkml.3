Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaIDMYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:24:24 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43796 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753179AbaIDMYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:24:22 -0400
Message-ID: <540859EC.5000407@hurleysoftware.com>
Date: Thu, 04 Sep 2014 08:24:12 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>, Mikael Pettersson <mikpelinux@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Henderson <rth@twiddle.net>, Oleg Nesterov <oleg@redhat.com>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org
Subject: Re: bit fields && data tearing
References: <20140712181328.GA8738@redhat.com> <54079B70.4050200@hurleysoftware.com> <1409785893.30640.118.camel@pasglop> <21512.10628.412205.873477@gargle.gargle.HOWL> <20140904090952.GW17454@tucnak.redhat.com>
In-Reply-To: <20140904090952.GW17454@tucnak.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 05:09 AM, Jakub Jelinek wrote:
> On Thu, Sep 04, 2014 at 10:57:40AM +0200, Mikael Pettersson wrote:
>> Benjamin Herrenschmidt writes:
>>  > On Wed, 2014-09-03 at 18:51 -0400, Peter Hurley wrote:
>>  > 
>>  > > Apologies for hijacking this thread but I need to extend this discussion
>>  > > somewhat regarding what a compiler might do with adjacent fields in a structure.
>>  > > 
>>  > > The tty subsystem defines a large aggregate structure, struct tty_struct.
>>  > > Importantly, several different locks apply to different fields within that
>>  > > structure; ie., a specific spinlock will be claimed before updating or accessing
>>  > > certain fields while a different spinlock will be claimed before updating or
>>  > > accessing certain _adjacent_ fields.
>>  > > 
>>  > > What is necessary and sufficient to prevent accidental false-sharing?
>>  > > The patch below was flagged as insufficient on ia64, and possibly ARM.
>>  > 
>>  > We expect native aligned scalar types to be accessed atomically (the
>>  > read/modify/write of a larger quantity that gcc does on some bitfield
>>  > cases has been flagged as a gcc bug, but shouldn't happen on normal
>>  > scalar types).
>>  > 
>>  > I am not 100% certain of "bool" here, I assume it's treated as a normal
>>  > scalar and thus atomic but if unsure, you can always use int.
>>
>> Please use an aligned int or long.  Some machines cannot do atomic
>> accesses on sub-int/long quantities, so 'bool' may cause unexpected
>> rmw cycles on adjacent fields.
> 
> Yeah, at least pre-EV56 Alpha performs rmw cycles on char/short accesses
> and thus those are not atomic.

Ok, thanks.

And I just confirmed with the Alpha cross-compiler that the fields are
not 'padded out' if volatile either.

Do any arches consider this an 'optimization'?  I ask because this kind of
accidental adjacency sharing may be common. Even RCU has a char field,
rcu_read_unlock_special, in the middle of the task_struct; luckily the
adjacent field is a list_head.

Besides updating the documentation, it may make sense to do something
arch-specific. Just bumping out storage on arches that don't need it
seems wasteful, as does generating bus locks on arches that don't need it.
Unfortunately, the code churn looks unavoidable.

Regards,
Peter Hurley
