Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab3APIOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:14:20 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43989 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3APIOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:14:18 -0500
Message-ID: <50F66120.50704@linux.vnet.ibm.com>
Date: Wed, 16 Jan 2013 13:43:20 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ivo Sieben <meltedpianoman@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tty: Only wakeup the line discipline idle queue when
 queue is active
References: <1355842130-15482-1-git-send-email-meltedpianoman@gmail.com> <50E3FDFA.4070203@suse.cz>	<20130102114311.66215bf5@pyramind.ukuu.org.uk> <CAMSQXEHmDb5rUQnT1JNcMCzdaN+gAr+1hR=PyPiDMu7vK5ykxA@mail.gmail.com> <50E4854E.8060801@suse.cz> <CAMSQXEGU2WmhmMqP7XMK2x39GN9iDDWpg-Wa7_cAauHWx5OWbQ@mail.gmail.com>
In-Reply-To: <CAMSQXEGU2WmhmMqP7XMK2x39GN9iDDWpg-Wa7_cAauHWx5OWbQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011608-8256-0000-0000-000005D85079
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivo,
Can you explain how this problem could create a scheduler overhead?
I am a little confused, because as far as i know,scheduler does not come
in the picture of the wake up path right? select_task_rq() in
try_to_wake_up() is where the scheduler comes in,and this is after the
task wakes up.

On 01/03/2013 03:19 PM, Ivo Sieben wrote:
> Oleg, Peter, Ingo, Andi & Preeti,
> 
> 2013/1/2 Jiri Slaby <jslaby@suse.cz>:
>> On 01/02/2013 04:21 PM, Ivo Sieben wrote:
>>> I don't understand your responses: do you suggest to implement this
>>> "if active" behavior in:
>>> * A new wake_up function called wake_up_if_active() that is part of
>>> the waitqueue layer?
>>
>> Sounds good.
>>
>> --
>> js
>> suse labs
> 
> I want to ask you 'scheduler' people for your opinion:
> 
> Maybe you remember my previous patch where I suggested an extra
> 'waitqueue empty' check before entering the critical section of the
> wakeup() function (If you do not remember see
> https://lkml.org/lkml/2012/10/25/159)
> 
> Finally Oleg responded that a lot of callers do
> 
> 	if (waitqueue_active(q))
> 		wake_up(...);
> 
> what made my patch pointless and adds a memory barrier. I then decided
> to also implement the 'waitqueue_active' approach for my problem.
> 
> But now I get a review comment by Jiri that he would like to hide this
> 'if active behavior' in a wake_up_if_active() kind of function. I
> think he is right that implementing this check in the wakeup function
> would clean things up, right?
> 
> I would like to have your opinion on the following two suggestions:
> - We still can do the original patch on the wake_up() that I
> suggested. I then can do an additional code cleanup patch that removes
> the double 'waitqueue_active' call (a quick grep found about 150 of
> these waitqueue active calls) on several places in the code.

I think this is a good move.

> - Or - as an alternative - I could add extra _if_active() versions of
> all wake_up() functions, that implement this extra test.

Why add 'extra' if_active versions? Why not optimize this within the
existing wake_up() functions?
> 
> Regards,
> Ivo

Regards
Preeti U Murthy
> 

