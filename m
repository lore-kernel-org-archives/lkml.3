Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaLGXxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 18:53:16 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:65493 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaLGXxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 18:53:15 -0500
MIME-Version: 1.0
In-Reply-To: <54846B06.8050906@oracle.com>
References: <20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<20141202193252.GB17595@redhat.com>
	<547E4C14.6040509@oracle.com>
	<54813C03.8040009@oracle.com>
	<CA+55aFyZOo=HzB_n3gLqswFsN1FcMdumaKLBk+fbhDD3wrvXnA@mail.gmail.com>
	<5481C92E.6020805@oracle.com>
	<CA+55aFxnCxJcg7NgNeqn_P_TugpcHTUk+v21Td25Aw6+2Z8=YA@mail.gmail.com>
	<54846B06.8050906@oracle.com>
Date: Sun, 7 Dec 2014 15:53:14 -0800
X-Google-Sender-Auth: omCEIxRIZUfvcn0G0BFZP38X8-A
Message-ID: <CA+55aFxawNiRT6+0Qzpt3oqdW5fVKc+_kiW6K-1-ajZPFV5xSQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2014 at 6:58 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> Maybe the extra prints were just a catalyst?

So there's an interesting change in between 3.16..3.17 - a commit that
was already reverted once due to unrelated problems (it apparently hit
lockdep issues): commit 5874af2003b1 ("printk: enable interrupts
before calling console_trylock_for_printk()").

In particular, that commit means that interrupts get re-enabled in the
middle of the printk (if they were enabled before the printk), and
while I don't see why that would be wrong, it definitely might change
behavior. That code has often been fragile (the whole lockdep example
was just the latest case of that). For example, it ends up looping
over "goto again" with preemption disabled if new console messages
keep coming in.

So I don't think that "enable interrupts" commit itself is necessarily
buggy, but looking at all the printk changes in the relevant time
range, I can easily see that particular commit having some subtle
interaction under heavy printk activity. Before that commit, all the
queued printouts would be written with interrupts disabled all the
way. After that commit, interrupts get re-enabled before and in
between messages get actually pushed to the console.

Should it matter? No. But I don't think we figured out what went wrong
with the lockdep issue that an earlier version of that commit had
either, and that problem caused lockups at boot for some people.  The
whole "print to console" is just fragile, and the addition of serial
console migth just make it even worse.

I dunno. But especially since your RCU issues seem to solve themselves
when *not* having lots of printk's, maybe the lockup is somehow
related to this all. Maybe the lockdep recursion hang ends up being a
"RCU debugging" hang when the timer interrupt causes printk recursion
with the console lock held..

                       Linus
