Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3HFUhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:37:15 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:35593 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3HFUhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:37:13 -0400
X-AuditID: cbfec37d-b7f036d000004805-e3-52015e77b487
From: Shuah Khan <shuah.kh@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: sl811h_suspend() and PM_EVENT_PRETHAW state handling
Thread-topic: sl811h_suspend() and PM_EVENT_PRETHAW state handling
Thread-index: Ac6SyFcWUhE6FBeWT/iSf5cAZjp8ng==
Date: Tue, 06 Aug 2013 20:37:10 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6175A4F7@sisaex02sj>
References: <Pine.LNX.4.44L0.1308061433000.1154-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e+wn255HGOQwd9GM4vLu+awWdw9dZTN
	on9hL5PFhN8X2BxYPGbf/cHo8WhxC6PHitXf2T0+b5ILYInisklJzcksSy3St0vgypi4cDNj
	QYd4xY+HrewNjPeFuhg5OSQETCRenO1gg7DFJC7cWw9kc3EICSxjlGi+28cK4fQySVzfvhYq
	M59R4uDVRrAWNgF1ic+vd7CD2CICWhKbm14ygxQxCyxhlLh8bipYQljAUeLkst+sEEVOEg8P
	noZq0JN4PGsKC4jNIqAqcfbVGkYQm1fAXuLpzLXMILaQgI/Evs52sDgj0H3fT61hArGZBcQl
	mltvskDcLSCxZM95ZghbVOLl439AuziAbEWJ7autIMq1JNbvPA7Vqi3x5N0FVohVghI/Jt9j
	mcAoNgvJ1FlIWmYhaZmFpGUBI8sqRrHS4uSC4qT01AoTveLE3OLSvHS95PzcTYyQWKvdwXj/
	q80hRgEORiUe3gsSjEFCrIllxZW5hxglOJiVRHh9QEK8KYmVValF+fFFpTmpxYcYmTg4pRoY
	y5Td9KrUPPR3KUiei86qtnaTVjjCyBeyKEhUjLnbLi1je0XDees59+o7jI7v+a04uWtKctDc
	8kl7NsQYKVqc1F45v3UDq49rwmxbV1e3pqwTe97FJh4OrAq48e5Uwpe1nE/M/mi80ShJuls8
	v/q7aGv5r/yVzB9sTYJd2Lvuvn9inn5gZ4ASS3FGoqEWc1FxIgCvlVdskwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 12:39 PM, Alan Stern wrote:
> On Tue, 6 Aug 2013, Shuah Khan wrote:
>
>> sl811h_suspend() seems to be the odd routine in the way it handles the
>> PM_EVENT_PRETHAW state. It treats it same as PM_EVENT_SUSPEND and
>> PM_EVENT_HIBERNATE. All other uses I could find treat it same as
>> PM_EVENT_FREEZE and PM_EVENT_QUIESCE. Makes sense since PM_EVENT_PRETHAW
>> is PM_EVENT_QUIESCE.
>>
>> #define PM_EVENT_PRETHAW PM_EVENT_QUIESCE
>>
>> Reference: Commit 185849991d592497e43bcd264c6152af1261ffe2 introduced
>> PM_EVENT_PRETHAW state to sl811h_suspend().
>>
>> Couple of questions?
>>
>> - Why does sl811h_suspend() treat PM_EVENT_PRETHAW different from
>> PM_EVENT_FREEZE?
>
> Because with FREEZE, the driver wants to retain the current bus state.
> With PRETHAW, it doesn't care about retaining the bus state.
>
> At least, that's how it looks to me.  The original author of this
> driver died a couple of years ago.  I don't know if anyone is using it
> any more.
>
>> There is no problem with this code as such, since state is passed in.
>> However, this usage conflicts with the rest of the usages and the way
>> pm_op() routine maps PM_EVENT_PRETHAW/PM_EVENT_QUIESCE to freeze() pm_ops.
>>
>>           case PM_EVENT_FREEZE:
>>           case PM_EVENT_QUIESCE:
>>                   return ops->freeze;
>>
>> Assuming the handling PM_EVENT_PRETHAW is correct in this routine, what
>> would be the right mapping for this legacy handling to dev_pm_ops?
>
> It depends on the driver; there is no one answer.
>
> Alan Stern
>
>

With the dev_pm_ops model, drivers have to provide interfaces for each 
one of these states. In this case, there will be a conflict since 
pm_op() treats this state as freeze where as the driver wants to do 
treat it as a suspend/hibernate. In the case of legacy pm_ops, state is 
passed in as a parameter and driver could take special action if need 
be, based on the state, however in dev_pm_ops model, state is not passed 
in. Instead it is handled with state specific pm_ops interfaces.

For example, if this driver were to be converted to dev_pm_ops, it would 
require a freeze interface which will call sl811h_bus_suspend(). Once 
that is done, PM_EVENT_PRETHAW will be mapped to freeze() ops and 
sl811h_bus_suspend() will be called instead of port_power(sl811, 0);

What I am getting at is, there is no provision to handle the special 
case for PM_EVENT_PRETHAW like in the case of this driver when using 
dev_pm_ops.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
