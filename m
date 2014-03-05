Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbaCEX5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:57:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38377 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbaCEX5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:57:46 -0500
Message-ID: <5317B9B2.8070205@zytor.com>
Date: Wed, 05 Mar 2014 15:56:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Khalid Aziz <khalid.aziz@oracle.com>, David Lang <david@lang.hm>
CC: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@kernel.org>, peterz@infradead.org,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de> <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305145420.GA30173@redhat.com> <20140305155601.GF22728@two.firstfloor.org> <20140305163644.GA2824@redhat.com> <53175D54.1020804@oracle.com> <alpine.DEB.2.02.1403051506550.6682@nftneq.ynat.uz> <5317B7D5.2030403@oracle.com>
In-Reply-To: <5317B7D5.2030403@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 03:48 PM, Khalid Aziz wrote:
> 
> Cost is writing to a memory location since thread is using mmap, not
> insignificant but hardly expensive. Thread does not need to know how
> much time it has left in current timeslice. It always sets the flag to
> request pre-emption immunity before entering the critical section and
> clears the flag when it exits its critical section. If the thread comes
> up for pre-emption while the flag is set, it gets immunity. If it does
> not, flag will be cleared at the end of critical section any way.
> 

A little more than that.  The scheduler needs to set *another* flag
telling the process to yield upon leaving the critical section; if the
process doesn't, the scheduler needs to keep enough accounting to know
to penalize the process, or this method will not be usable for
unprivileged processes.

I have been thinking about how to deal with the fact that if this isn't
locked in memory, what happens if it is paged out.  If that can be
detected at reasonable cost, it probably makes most sense to simply say
that if the pointed-to memory is paged out, we're not in a critical section.
	
	-hpa

